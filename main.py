# Android entry point for pyside6-android-deploy.
# The upstream desktop program is imported only after Android packaging
# has placed the source tree beside this file.

import runpy
from pathlib import Path

UPSTREAM = Path(__file__).resolve().parent / "upstream"
TARGET = UPSTREAM / "musicdownload.py"

if not TARGET.exists():
    raise FileNotFoundError(f"Upstream entry point not found: {TARGET}")

runpy.run_path(str(TARGET), run_name="__main__")
