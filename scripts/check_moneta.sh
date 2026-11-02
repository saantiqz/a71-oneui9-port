
#!/usr/bin/env bash

OUT="$HOME/a71-oneui9"
LOG="$OUT/moneta-post-patch.txt"

mkdir -p "$OUT"

echo "======================================"
echo " A71 ONE UI 9 - MONETA DIAGNOSTICS"
echo "======================================"

echo "[1/5] Checking ADB connection..."
adb get-state || exit 1

echo "[2/5] Clearing previous logs..."
adb logcat -c

echo "[3/5] Restarting Personal Intelligence..."
adb shell am force-stop com.samsung.android.smartsuggestions
adb shell monkey -p com.samsung.android.smartsuggestions 1 >/dev/null 2>&1

echo "[4/5] Waiting 30 seconds for initialization..."
sleep 30

echo "[5/5] Collecting logs..."
adb logcat -d -b all > "$LOG"

echo
echo "======================================"
echo " MONETA ERRORS"
echo "======================================"

grep -iE 'moneta|securestorage|smartsuggestions' "$LOG" |
grep -iE 'error|fail|exception|denied|crash|unavailable' |
tail -60

echo
echo "======================================"
echo " KEYSTORE / KEYMINT ERRORS"
echo "======================================"

grep -iE 'keystore2|keymint|keymaster|strongbox|HARDWARE_TYPE_UNAVAILABLE' "$LOG" |
tail -60

echo
echo "======================================"
echo " FATAL EXCEPTIONS"
echo "======================================"

grep -A25 'FATAL EXCEPTION' "$LOG" | tail -100

echo
echo "======================================"
echo " RESULTS"
echo "======================================"

echo "Total log lines: $(wc -l < "$LOG")"
echo "Full log: $LOG"

echo "======================================"
echo " DIAGNOSTICS COMPLETE"
echo "======================================"

