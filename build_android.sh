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

echo "=== Install Android deployment dependencies ==="
python -m pip install jinja2 pkginfo tqdm

echo "=== Install project requirements ==="
if [ -f requirements.txt ]; then
    python -m pip install -r requirements.txt || true
fi

echo "=== Install PySide6 ==="
python -m pip install PySide6

echo "=== Install build tools ==="
python -m pip install buildozer cython

echo "=== Check PySide6 Android deploy ==="
pyside6-android-deploy --help

echo "=== Build Android APK ==="
pyside6-android-deploy \
    --name musicDownload \
    --wheel-pyside PySide6 \
    --init \
    main.py

echo "=== APK files ==="
find . -type f -name "*.apk" -print
