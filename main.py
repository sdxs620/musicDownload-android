import runpy
import sys
import traceback
from pathlib import Path

BASE = Path(__file__).resolve().parent
TARGET = BASE / "musicdownload.py"

def show_error(message: str):
    try:
        from PySide6.QtWidgets import QApplication, QMessageBox
        app = QApplication.instance() or QApplication(sys.argv)
        box = QMessageBox()
        box.setWindowTitle("MusicDownload 启动失败")
        box.setText(message)
        box.setDetailedText(traceback.format_exc())
        box.exec()
    except Exception:
        pass

if not TARGET.exists():
    show_error(f"找不到主程序文件：{TARGET}")
    raise FileNotFoundError(TARGET)

try:
    runpy.run_path(str(TARGET), run_name="__main__")
except Exception as exc:
    text = f"程序启动失败：{type(exc).__name__}: {exc}\n\n请查看详细错误信息。"
    show_error(text)
    raise
