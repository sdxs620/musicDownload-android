[app]
title = MusicDownload
project_dir = .
input_file = main.py
exec_directory = .

[python]
python_path = .
android_packages = buildozer,cython

[qt]
modules = Core,Gui,Widgets,Network

[android]
arch = aarch64

[buildozer]
mode = debug
sdk_path = /home/runner/.pyside6_android_deploy/android-sdk
ndk_path = /home/runner/.pyside6_android_deploy/android-ndk/android-ndk-r26b
