# One UI 9 port for Galaxy A71 4G (SM-A715F)

Unofficial One UI 9 (Android 17) port based on the Galaxy S23 firmware, adapted for the Samsung Galaxy A71 4G.

Port by **saantiqz**.

**Latest: v1.0**, see [CHANGELOG.md](CHANGELOG.md).

This repository contains build scripts, verification tools and documentation. It does not contain the full ROM, Samsung firmware or proprietary Samsung applications.

## Features

- Android 17 with One UI 9.
- SELinux enforcing.
- File-based encryption with working PIN unlock after reboot.
- Wi-Fi and Bluetooth.
- Mobile data and calls.
- Access Point Names and Data Roaming menus.
- Optical under-display fingerprint sensor.
- Face unlock.
- Camera with photo, video, HDR and night modes.
- Video recording with sound.
- 4K video playback.
- NFC and Samsung DeX.
- Speaker, microphone and vibration.
- Sensors and auto-rotate.
- Flashlight and charging.
- Eye comfort shield.
- A71 thermal profile.
- Now Brief and Personal Intelligence fully working.
- Port information in Settings > About phone > Software information.

## Repository contents

- `scripts/`: build scripts, release tools, verification and maintenance utilities.
- `release/notes-v1.0.md`: v1.0 release notes.
- `CHANGELOG.md`: release history.
- `FEATURES.md`: supported features and known issues.

## Included tools

- `a71build.sh`: build management.
- `a71zipcheck.sh`: release ZIP verification.
- `a71release.sh`: release preparation.
- `a71noai.sh`: AI feature management.
- `a71gpumem.sh`: GPU memory patch management.
- `a71anrsys.sh`: system ANR-related patch management.
- `a71portinfo.sh`: port information management.

## Installation

Download the latest release:

[SourceForge Downloads](https://sourceforge.net/projects/PROJECT_NAME/files/)

Read the installation instructions included with the release before flashing.

**Important:** Coming from One UI 8.5 or another ROM requires Format Data. This erases internal storage. Back up your data before installation.

Use the included FOD Prime Kernel. A kernel without the required FOD patch breaks fingerprint functionality.

## Known issues

- Now Nudge is unavailable because it requires SSCO, which is unsupported on the A71.
- Black areas appear slightly brown on the current test device. Other panels remain untested.
- 5 GHz Wi-Fi idle wake behavior remains untested.
- Face unlock displays a harmless rotation warning.

## Credits

- Samsung, for One UI and the Galaxy S23 donor firmware.
- Paradigm Kernel and its developers.
- UN1CA, for reference and device-specific adaptations.
- Open-source developers whose tools contributed to this project.

## Disclaimer

This is an unofficial community port. It is not affiliated with, endorsed by or sponsored by Samsung or Google.

All trademarks belong to their respective owners.

Flash at your own risk.
