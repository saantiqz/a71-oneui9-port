#!/bin/bash
# Polls adb every 10 s after a reboot. Saves logcat as soon as the phone answers.
N=${1:-boot}
OUT=~/a71-oneui9/logs/$N-$(date +%H%M%S)
START=$(date +%s)
echo "Watching for the phone. Ctrl+C to stop. Logs will go to $OUT"
while true; do
  T=$(( $(date +%s)-START ))
  STATE=$(adb devices | awk 'NR>1 && $2 {print $2}' | head -1)
  printf '\r[%02d:%02d] adb: %-14s' $((T/60)) $((T%60)) "${STATE:-no device}"
  if [ "$STATE" = "device" ]; then
    echo; echo "Phone is up in Android. Saving logcat..."
    mkdir -p "$OUT"
    adb logcat -b all -d > "$OUT/logcat.txt"
    BC=$(adb shell getprop sys.boot_completed | tr -d '\r')
    echo "boot_completed = ${BC:-0}"
    echo "== crashes / fatal"
    grep -aE 'F DEBUG.*(Cmdline|Abort message)|abortOnMismatch|FATAL EXCEPTION' "$OUT/logcat.txt" | sort | uniq -c | head -20
    echo "Saved: $OUT/logcat.txt"
    break
  fi
  if [ "$STATE" = "recovery" ]; then
    echo; echo "Phone is in TWRP (it rebooted to recovery, or you forced it)."
    break
  fi
  sleep 10
done
