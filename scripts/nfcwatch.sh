#!/bin/bash
# Watch NFC tag detections on the phone and print them on the PC.
LOG=~/a71-oneui9/logs/nfc-$(date +%Y%m%d-%H%M%S).txt
mkdir -p "$(dirname "$LOG")"
cleanup() { echo; echo "stopping, NFC debug off"; adb shell "su -c 'setprop persist.nfc.debug_enabled false'" >/dev/null 2>&1; echo "log saved: $LOG"; exit 0; }
trap cleanup INT TERM
adb wait-for-device
adb shell "su -c 'setprop persist.nfc.debug_enabled true'" >/dev/null 2>&1
echo "NFC state: $(adb shell dumpsys nfc 2>/dev/null | grep -m1 -oE 'mState=[a-z_]+')"
echo "Watching... hold a card/tag to the back of the phone (Ctrl+C to stop). Log: $LOG"
adb logcat -c
FILTER='Nfc|NFC|nfc|NativeNfcTag|NfcTag|NfcDispatcher|libnfc|NxpTml|NxpHal|NfcAdaptation|IsoDep|Mifare|Ndef|HostEmulation|ApduService'
DETECT='[Tt]ag (detected|discovered)|onTagDiscovered|[Dd]ispatch(ing)? tag|tag=TAG|TAG: Tech|connectWithStatus|NFA_ACTIVATED_EVT|Tag:|techList|activated.*protocol|onRemoteFieldActivated|HCE|selectAid'
adb logcat -v time 2>/dev/null | grep --line-buffered -E "$FILTER" | tee -a "$LOG" | while IFS= read -r line; do
  if echo "$line" | grep -qE "$DETECT"; then
    echo; echo "==================== NFC EVENT $(date +%H:%M:%S) ===================="
    printf '%s\n' "$line" | cut -c1-220
    uid=$(echo "$line" | grep -oiE '(uid|id)[=: ]+\[?[0-9a-f]{2}([: ]?[0-9a-f]{2}){3,9}' | head -1); [ -n "$uid" ] && echo "  UID   : $uid"
    tech=$(echo "$line" | grep -oE 'android\.nfc\.tech\.[A-Za-z]+' | sort -u | sed 's/android.nfc.tech.//' | tr '\n' ' '); [ -n "$tech" ] && echo "  TECH  : $tech"
  else
    echo "$line" | grep -qiE 'ndef|record|mime|uri|text/|aid|iso|mifare|uid|sak|atqa|protocol|tech' && echo "  $(echo "$line" | cut -c20-220)"
  fi
done
