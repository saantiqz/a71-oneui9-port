# Changelog

All notable releases of the One UI 9 Galaxy A71 port are documented here.

## v1.0 - 2026-11-02

First public release of One UI 9 (Android 17) for the Samsung Galaxy A71 4G (SM-A715F).

### Major Fixes

- Fixed PIN unlock after reboot.
  - Fixed the Vold authentication token rejection affecting Gatekeeper-based devices.
  - PIN-protected encryption now unlocks successfully after reboot.
- Fixed random soft reboots related to GPU memory reporting.
- Fixed the "System isn't responding" popup during setup.
- Added a faster TWRP installer.
- Added verification after writing installer components.

### Features

- One UI 9 based on Galaxy S23 firmware.
- Android 17.
- SELinux enforcing.
- File-based encryption enabled.
- Working PIN unlock after reboot.
- Personal Intelligence fully working.
- Now Brief working.
- Samsung DeX.
- NFC.
- Optical fingerprint with FOD Prime Kernel.
- Face unlock.
- A71 thermal profile.
- Camera and 4K video playback.
- Port information in Settings.

### Installer and Build Tools

- Updated `a71build.sh`.
- Added `a71zipcheck.sh`.
- Added `a71release.sh`.
- Added `a71noai.sh`.
- Added `a71gpumem.sh`.
- Added `a71anrsys.sh`.

### Known Issues

- Now Nudge unavailable.
- Brown-looking black levels reported on one device.
- 5 GHz Wi-Fi idle wake behavior remains untested.
- Face unlock rotation warning.

### Release Information

Device: Galaxy A71 4G (SM-A715F)

Android: 17

One UI: 9

Release status: v1.0
