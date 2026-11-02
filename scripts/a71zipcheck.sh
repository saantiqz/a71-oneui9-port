#!/bin/bash
# a71zipcheck.sh - check a built release zip on the PC (read-only, ~2-3 min)
#   a71zipcheck.sh [zip]   (default: newest zip in ~/a71-oneui9/release)
# 1. zip structure + CRC of every entry (what TWRP's unzip relies on)
# 2. the installer's piece table: offsets inside the zip and sha256 of each piece = what TWRP will verify
# 3. INDEPENDENT check: each piece compared with the real partition images (system/vendor/product/odm),
#    using the partition table stored in the zip's own first piece -> proves the phone gets exactly the images
# 4. kernel inside = kernel/PrimeKernel-a71-fod.zip, sha256 file matches
set -u
R=~/a71-oneui9; B=$R/out/build
Z=${1:-$(ls -t $R/release/*.zip 2>/dev/null | head -1)}
[ -f "$Z" ] || { echo "no zip"; exit 1; }
ODM=$R/work/odm-release.img; case "$Z" in *_debug.zip) ODM=$R/work/odm-debug.img;; esac
echo "zip: $Z ($(du -h "$Z" | cut -f1))"
python3 -I - "$Z" $B/system.img $B/vendor.img $B/product.img "$ODM" $R/kernel/PrimeKernel-a71-fod.zip <<'PYEOF'
import sys, zipfile, struct, hashlib, re, os
Z, SYS, VEN, PRO, ODM, KZ = sys.argv[1:7]
MB = 1 << 20; ok = True
def res(name, good, extra=''):
    global ok; ok &= good; print(("  OK   " if good else "  FAIL ") + name + (("  " + extra) if extra else ''), flush=True)
z = zipfile.ZipFile(Z)
names = z.namelist()
res("installer present", 'META-INF/com/google/android/update-binary' in names)
ub = z.read('META-INF/com/google/android/update-binary').decode()
res("installer: no here-doc piece list", "<<'EOF'" not in ub)
m = re.search(r'CHUNKS="([^"]*)"', ub); rows = [l.split() for l in m.group(1).strip().splitlines()] if m else []
res("piece table", len(rows) > 0, "%d pieces" % len(rows))
km = re.search(r'KERNEL="([^"]*)"', ub).group(1).split()
print("  ... CRC of all entries (reads the whole zip)", flush=True)
bad = z.testzip(); res("zip CRCs", bad is None, bad or '')
f = open(Z, 'rb')
def zread(off, n): f.seek(off); return f.read(n)
# 2. piece table vs zip bytes
pieces = []; nbad = 0
for zo, so, cnt, sh in rows:
    zo, so, cnt = int(zo) * MB, int(so) * MB, int(cnt) * MB
    h = hashlib.sha256(); p = 0
    while p < cnt: b = zread(zo + p, min(64 * MB, cnt - p)); h.update(b); p += len(b)
    pieces.append((zo, so, cnt))
    if h.hexdigest() != sh: nbad += 1; res("piece at super %d MiB: zip bytes = table hash" % (so // MB), False)
res("piece hashes match the installer table", nbad == 0, "%d/%d" % (len(rows) - nbad, len(rows)))
# 3. independent: partition table from piece 0 (super offset 0), extents -> compare with images
p0 = [p for p in pieces if p[1] == 0]
if not p0: res("piece with the partition table", False)
else:
    zo0 = p0[0][0]; buf = zread(zo0, min(p0[0][2], 12288 + 65536 * 4)); M = 12288
    hm, _, _, hsz = struct.unpack('<IHHI', buf[M:M + 12]); res("LP metadata in piece 0", hm == 0x414C5030)
    def desc(o): return struct.unpack('<III', buf[M + o:M + o + 12])
    T = M + hsz; po, pn, ps = desc(80); eo, en, es = desc(92)
    ext = [struct.unpack('<QIQI', buf[T + eo + i * es:T + eo + i * es + 24]) for i in range(en)]
    imgs = {'system': SYS, 'vendor': VEN, 'product': PRO, 'odm': ODM}
    def super_read(off, n):          # read super bytes via the pieces in the zip
        out = bytearray(n)
        for zo, so, cnt in pieces:
            a = max(off, so); e = min(off + n, so + cnt)
            if a < e: out[a - off:e - off] = zread(zo + a - so, e - a)
        return bytes(out)
    for i in range(pn):
        e = buf[T + po + i * ps:T + po + (i + 1) * ps]
        pname = e[:36].split(b'\0')[0].decode(); fi, ne = struct.unpack('<II', e[40:48])
        if pname not in imgs or ne == 0: continue
        if not os.path.exists(imgs[pname]): res(pname + " image on PC", False, imgs[pname]); continue
        fimg = open(imgs[pname], 'rb'); isz = os.path.getsize(imgs[pname]); lo = 0; same = True
        for x in ext[fi:fi + ne]:
            n = x[0] * 512; so = x[2] * 512; p = 0
            while p < n and same:
                k = min(64 * MB, n - p); fimg.seek(lo + p); want = fimg.read(k); want += bytes(k - len(want))
                same = super_read(so + p, k) == want; p += k
            lo += n
        res("%-8s in zip == %s" % (pname, os.path.basename(imgs[pname])), same, "%d MiB" % (isz // MB))
# 4. kernel
kzo, kcnt, klen, ksha = int(km[0]) * MB, int(km[1]) * MB, int(km[2]), km[3]
kb = zread(kzo, kcnt)
res("kernel piece hash", hashlib.sha256(kb).hexdigest() == ksha)
res("kernel == PrimeKernel-a71-fod.zip", kb[:klen] == open(KZ, 'rb').read() if os.path.exists(KZ) else False)
print("RESULT:", "ALL OK" if ok else "PROBLEMS FOUND")
sys.exit(0 if ok else 1)
PYEOF
r=$?
[ -f "$Z.sha256" ] && (cd "$(dirname "$Z")" && sha256sum -c "$(basename "$Z").sha256") || echo "  (no .sha256 file)"
exit $r
