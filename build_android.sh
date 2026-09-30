#!/usr/bin/env bash
set -euo pipefail

rm -rf upstream
git clone --depth 1 https://github.com/MrsEWE44/musicDownload.git upstream

python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel

# The upstream project declares its desktop dependencies here.
# Android-incompatible dependencies will be reported by the build.
if [ -f upstream/requirements.txt ]; then
  python -m pip install -r upstream/requirements.txt || true
fi

python -m pip install "PySide6>=6.8" buildozer cython

# Android deployment expects main.py in the project directory.
python -m pip install --upgrade pyside6

pyside6-android-deploy --init || true
pyside6-android-deploy --config-file pysidedeploy.spec -f
