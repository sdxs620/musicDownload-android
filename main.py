import runpy
from pathlib import Path

BASE = Path(__file__).resolve().parent

# pyside6-android-deploy 会把这个 main.py 放在
# 原项目目录中，因此原始程序就在当前目录。
TARGET = BASE / "musicdownload.py"

if not TARGET.exists():
    raise FileNotFoundError(
        f"找不到主程序文件: {TARGET}"
    )

runpy.run_path(str(TARGET), run_name="__main__")
