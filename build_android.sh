#!/usr/bin/env bash
set -euo pipefail

echo "=== Download Qt Android SDK/NDK ==="

if [ ! -d "$HOME/.pyside6_android_deploy" ]; then
    git clone --depth 1 --branch 6.8 https://code.qt.io/pyside/pyside-setup.git "$HOME/pyside-setup"
    python -m pip install -r "$HOME/pyside-setup/requirements.txt"
    python -m pip install -r "$HOME/pyside-setup/tools/cross_compile_android/requirements.txt"
    python "$HOME/pyside-setup/tools/cross_compile_android/main.py" \
        --download-only \
        --skip-update \
        --auto-accept-license
fi

echo "=== Clone upstream project ==="

rm -rf musicDownload-upstream
git clone --depth 1 https://github.com/MrsEWE44/musicDownload.git musicDownload-upstream

cd musicDownload-upstream

echo "=== Replace desktop-only requirements with Android-compatible requirements ==="
cp ../requirements-android.txt ./requirements.txt

echo "=== Install host-side application dependencies ==="
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r requirements.txt
python -m pip install jinja2 pkginfo tqdm buildozer cython

echo "=== Install PySide6 host package ==="
python -m pip install "PySide6==6.8.3"

echo "=== Install Android entry point ==="
cp ../main.py ./main.py

echo "=== Patch PySide6 Android deployment requirements ==="
python - <<'PY'
from pathlib import Path
import PySide6

base = Path(PySide6.__file__).resolve().parent
candidates = [
    base / "scripts" / "deploy_lib" / "android" / "buildozer.py",
    base / "scripts" / "deploy_lib" / "android" / "buildozer.pyc",
]

path = next((p for p in candidates if p.exists() and p.suffix == ".py"), None)
if path is None:
    # Fallback: locate the file in the installed package.
    matches = list(base.rglob("buildozer.py"))
    path = matches[0] if matches else None

if path is None:
    raise SystemExit("Could not locate PySide6 Android buildozer.py")

text = path.read_text(encoding="utf-8")

old = 'self.set_value("app", "requirements", "python3,shiboken6,PySide6")'
new = (
    'self.set_value("app", "requirements", '
    '"python3,shiboken6,PySide6,requests==2.32.3,charset-normalizer==2.1.1,'
    'musicdl==2.8.0,click,prettytable,pycryptodome")'
)

if old in text:
    text = text.replace(old, new)
elif "musicdl==2.8.0" not in text:
    # Handle small source variations between 6.8.x builds.
    needle = 'self.set_value("app", "requirements",'
    lines = text.splitlines()
    replaced = False
    for i, line in enumerate(lines):
        if needle in line:
            indent = line[:len(line)-len(line.lstrip())]
            lines[i] = indent + new
            replaced = True
            break
    if not replaced:
        raise SystemExit("Could not patch Android requirements in buildozer.py")
    text = "\n".join(lines) + "\n"

path.write_text(text, encoding="utf-8")
print("Patched:", path)
PY

echo "=== Download official Qt Android wheels ==="

mkdir -p ../android-wheels
cd ../android-wheels

wget -q --show-progress \
  https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl

wget -q --show-progress \
  https://download.qt.io/official_releases/QtForPython/shiboken6/shiboken6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl

PYSIDE_WHEEL="$PWD/PySide6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl"
SHIBOKEN_WHEEL="$PWD/shiboken6-6.8.3-6.8.3-cp311-cp311-android_aarch64.whl"

cd ../musicDownload-upstream

echo "=== Build Android APK ==="

pyside6-android-deploy \
    --name "musicDownload" \
    --wheel-pyside "$PYSIDE_WHEEL" \
    --wheel-shiboken "$SHIBOKEN_WHEEL" \
    --force

echo "=== Locate APK ==="
find . -type f \( -name "*.apk" -o -name "*.aab" \) -print
