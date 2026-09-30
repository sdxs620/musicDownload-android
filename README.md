# MusicDownload Android build

This build fixes the Android dependency/runtime issue in the previous scaffold.

Key changes:
- Removes desktop-only PyQt5 from the Android dependency set.
- Pins `musicdl` to 2.8.0 for the Android build.
- Includes `requests`, `charset-normalizer`, `click`, `prettytable`, and `pycryptodome`.
- Patches the PySide6 Android deployment-generated Buildozer requirements so these packages are actually packaged into the APK.
- The Android entry point now displays a startup exception instead of silently exiting.

The upstream project is:
https://github.com/MrsEWE44/musicDownload

The build uses PySide6 6.8.3 Android wheels for arm64-v8a and Python 3.11.
