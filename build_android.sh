#!/usr/bin/env bash
set -e

echo "=== Clone upstream project ==="

if [ ! -d "musicDownload-upstream" ]; then
    git clone https://github.com/MrsEWE44/musicDownload.git musicDownload-upstream
fi

cd musicDownload-upstream

echo "=== Create Python environment ==="

python -m venv ../.venv
source ../.venv/bin/activate

echo "=== Upgrade pip ==="

python -m pip install --upgrade pip setuptools wheel

echo "=== Install deployment dependencies ==="

python -m pip install \
    jinja2 \
    pkginfo \
    tqdm \
    buildozer \
    cython

echo "=== Install PySide6 ==="

python -m pip install "PySide6==6.8.3"

echo "=== Download PySide6 Android wheels ==="

qtpip download PySide6 --android --arch aarch64

echo "=== Find Android wheels ==="

PYSIDE_WHEEL=$(find . -maxdepth 2 -type f -name "PySide6-*-android_*.whl" | head -n 1)

SHIBOKEN_WHEEL=$(find . -maxdepth 2 -type f -name "shiboken6-*-android_*.whl" | head -n 1)

echo "PySide6 wheel:"
echo "$PYSIDE_WHEEL"

echo "Shiboken6 wheel:"
echo "$SHIBOKEN_WHEEL"

if [ -z "$PYSIDE_WHEEL" ]; then
    echo "ERROR: PySide6 Android wheel not found"
    exit 1
fi

if [ -z "$SHIBOKEN_WHEEL" ]; then
    echo "ERROR: Shiboken6 Android wheel not found"
    exit 1
fi

echo "=== Build Android APK ==="

pyside6-android-deploy \
    --name "musicDownload" \
    --wheel-pyside "$PYSIDE_WHEEL" \
    --wheel-shiboken "$SHIBOKEN_WHEEL" \
    --arch aarch64 \
    --force

echo "=== Locate APK ==="

find . -type f -name "*.apk" -print
