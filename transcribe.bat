@echo off
chcp 65001 >nul
title 批量视频/音频转文字

:: 设置 Python 路径
set PYTHON_PATH=C:\Users\Administrator\AppData\Local\Programs\Python\Python312
set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%

:: 设置 ffmpeg 路径 (EVCapture 附带)
set PATH=C:\Program Files\EVCapture;%PATH%

cd /d "%~dp0"
python transcribe.py
pause
