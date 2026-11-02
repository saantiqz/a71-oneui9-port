First release: One UI 9 (Android 17, based on the Galaxy S23) for the Galaxy A71 4G (SM-A715F).

What works:
- Boots with SELinux enforcing.
- File-based encryption, including unlocking with a PIN after a reboot.
- Wi-Fi and Bluetooth.
- Mobile data and calls, including the Access Point Names and Data roaming menus.
- Optical (under-display) fingerprint, with the included FOD Prime Kernel.
- Face unlock.
- Camera: photos, video with sound, mode switching, and night/HDR scenes.
- Video playback, including 4K.
- NFC and Samsung DeX.
- Speaker, microphone, vibration, flashlight, and charging.
- Sensors and auto-rotate.
- Eye comfort shield.
- A71 thermal profile (temperature and performance management).
- Now Brief (Galaxy AI).
- Personal Intelligence.
- Port information in Settings > About phone > Software information.

Fixes in this release:
- Fixed random soft reboots.
- Fixed the "System isn't responding" pop-up during setup.
- Fixed being stuck on "Phone is starting" after a reboot when a PIN is set.
- New fast TWRP installer that verifies every piece after writing it.

Known issues:
- Now Nudge is not available (it needs a Samsung component the A71 cannot run).
- Black areas can look slightly brown on some panels (seen on one device; unconfirmed on others).
- 5 GHz Wi-Fi may be slow to wake after being idle (reported on the 8.5 port; untested here).
- A kernel without the FOD patch breaks the fingerprint sensor. Use the included kernel.
- Coming from One UI 8.5 or another ROM requires Format Data (internal storage is erased).
