@echo off
chcp 65001 >nul
title 安装转录工具依赖

echo ================================================
echo   批量转录工具 — 环境安装
echo ================================================
echo.

:: ── 检查 Python ──────────────────────────────────
echo [1/4] 检查 Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo   Python 未安装，正在通过 winget 安装...
    winget install Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo   [错误] 自动安装失败，请手动安装 Python:
        echo   https://www.python.org/downloads/
        echo   安装时务必勾选"Add Python to PATH"
        pause
        exit /b 1
    )
    echo   Python 安装完成，请重新打开此脚本
    pause
    exit /b 0
)
python --version
echo   OK

:: ── 检查 ffmpeg ──────────────────────────────────
echo.
echo [2/4] 检查 ffmpeg...
ffmpeg -version >nul 2>&1
if %errorlevel% neq 0 (
    echo   ffmpeg 未安装，正在通过 winget 安装...
    winget install Gyan.FFmpeg --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo   [备选] 尝试通过 Chocolatey 安装...
        choco install ffmpeg -y 2>nul
        if %errorlevel% neq 0 (
            echo   [错误] 自动安装失败，请手动安装 ffmpeg:
            echo   https://ffmpeg.org/download.html
            echo   下载后把 ffmpeg.exe 所在目录加入系统 PATH
            pause
            exit /b 1
        )
    )
    echo   ffmpeg 安装完成，请重新打开此脚本使 PATH 生效
    pause
    exit /b 0
)
ffmpeg -version | findstr /C:"ffmpeg version"
echo   OK

:: ── 安装 Python 依赖 ─────────────────────────────
echo.
echo [3/4] 安装 Python 依赖包...
echo   如果下载慢，将自动使用国内镜像...

:: 先尝试用镜像
pip install faster-whisper torch -i https://pypi.tuna.tsinghua.edu.cn/simple --quiet 2>nul
if %errorlevel% neq 0 (
    echo   镜像下载失败，改用默认源...
    pip install faster-whisper torch --quiet
    if %errorlevel% neq 0 (
        echo   [错误] 安装失败，请检查网络连接后重试
        pause
        exit /b 1
    )
)
echo   OK

:: ── 检查模型文件 ─────────────────────────────────
echo.
echo [4/4] 检查模型文件...

if not exist "%~dp0models\model.bin" (
    echo   [!] 警告：模型文件尚未放入 models\ 目录
    echo.
    echo   请按以下步骤下载模型:
    echo     1. 浏览器打开 https://hf-mirror.com/Systran/faster-whisper-medium/tree/main
    echo     2. 下载所有文件（至少需要 config.json 和 model.bin）
    echo     3. 放入此目录下的 models\ 文件夹
    echo     4. 再次运行 transcribe.bat
    echo.
) else (
    echo   模型文件已就绪
    echo   OK
)

echo.
echo ================================================
echo   环境安装完成!
echo   可以双击 transcribe.bat 开始转录
echo ================================================
pause
