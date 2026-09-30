# musicDownload Android build

This is an Android build scaffold for the upstream project:
https://github.com/MrsEWE44/musicDownload

## What it does
- Downloads the upstream source during GitHub Actions.
- Creates `main.py` as the Android entry point expected by `pyside6-android-deploy`.
- Installs the upstream Python requirements.
- Attempts an Android debug APK build for `aarch64`.

## Important
This is a build scaffold, not a verified APK. The upstream project was designed for desktop PySide6 and some of its dependencies may not have Android-compatible wheels/recipes. If the workflow fails, the failure log identifies the dependency that needs an Android-specific replacement or recipe.

## Build
1. Create a GitHub repository and upload these files.
2. Push to `main`.
3. Open Actions -> `Build Android APK`.
4. Download the `musicDownload-debug.apk` artifact if the build succeeds.
