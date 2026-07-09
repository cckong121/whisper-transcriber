@echo off
chcp 65001 >nul
title 批量视频/音频转文字

cd /d "%~dp0"
python transcribe.py
pause
