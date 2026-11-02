# A71 One UI 9 Utilities

Small utilities used during development and validation of the Galaxy A71 4G
One UI 9 port.

## Requirements

- Ubuntu or another Linux distribution
- Bash
- Android Platform Tools (`adb`)
- Python 3
- `sha256sum`
- Standard GNU utilities

## Scripts

### a71zipcheck.sh

Validates a built release ZIP.

Checks:
- ZIP structure and CRC
- Installer piece table and SHA-256 hashes
- Partition image contents against local build images
- Included FOD Prime Kernel ZIP

Usage:

    ./scripts/a71zipcheck.sh /path/to/release.zip

Without an argument, it searches `~/a71-oneui9/release/` for the newest ZIP.

Requires the original build images and kernel ZIP in the expected project
directories. This script reads files and does not flash or modify a device.

### nfcwatch.sh

Watches Android logcat for NFC activity.

Usage:

    ./scripts/nfcwatch.sh

Requires an authorized ADB connection and root access on the phone.
Enables persistent NFC debugging while running. Press Ctrl+C to stop.
The cleanup handler attempts to disable NFC debugging.

### watchboot.sh

Waits for an Android device to become available over ADB after a reboot,
then saves a logcat dump.

Usage:

    ./scripts/watchboot.sh
    ./scripts/watchboot.sh recovery-test

The optional argument names the output log directory.

### check_moneta.sh

Collects diagnostics related to Samsung Personal Intelligence and
Keystore/KeyMint.

Usage:

    ./scripts/check_moneta.sh

Requires an authorized ADB connection. Clears the current logcat buffer,
force-stops and restarts Samsung Smart Suggestions, waits 30 seconds,
then saves diagnostic output.

## Notes

These scripts were written around the author's local A71 port workspace.
Some paths assume `~/a71-oneui9` and its build directory structure.
Review scripts before running them on another setup.
