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

echo "=== Download official Qt Android wheels ==="

mkdir -p ../android-wheels
cd ../android-wheels

wget -q --show-progress \
    https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl

wget -q --show-progress \
    https://download.qt.io/official_releases/QtForPython/shiboken6/shiboken6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl

PYSIDE_WHEEL="$PWD/PySide6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl"

SHIBOKEN_WHEEL="$PWD/shiboken6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl"

echo "PySide6 Android wheel:"
echo "$PYSIDE_WHEEL"

echo "Shiboken6 Android wheel:"
echo "$SHIBOKEN_WHEEL"

cd ../musicDownload-upstream

echo "=== Build Android APK ==="

pyside6-android-deploy \
    --name "musicDownload" \
    --wheel-pyside "$PYSIDE_WHEEL" \
    --wheel-shiboken "$SHIBOKEN_WHEEL" \
    --arch aarch64 \
    --force

echo "=== Locate APK ==="

find . -type f -name "*.apk" -print
