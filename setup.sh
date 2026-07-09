#!/usr/bin/env bash
# ── 批量转录工具 — Mac 环境安装 ──────────────────
# 用法：在终端中运行 bash setup.sh
set -e

echo "================================================"
echo "  批量转录工具 — 环境安装 (macOS)"
echo "================================================"
echo ""

# ── 检查 Python ──────────────────────────────────
echo "[1/4] 检查 Python..."
if command -v python3 &>/dev/null; then
    python3 --version
    echo "  OK"
else
    echo "  [错误] 未找到 python3，macOS 通常自带 Python 3"
    echo "  如果缺失，请运行: xcode-select --install 或从 python.org 下载"
    exit 1
fi

# ── 检查 pip ─────────────────────────────────────
echo ""
echo "[2/4] 检查 pip..."
if python3 -m pip --version &>/dev/null; then
    python3 -m pip --version
    echo "  OK"
else
    echo "  正在安装 pip..."
    python3 -m ensurepip --user
fi

# ── 检查 ffmpeg ──────────────────────────────────
echo ""
echo "[3/4] 检查 ffmpeg..."
if command -v ffmpeg &>/dev/null; then
    ffmpeg -version | head -1
    echo "  OK"
else
    echo "  ffmpeg 未安装，正在通过 Homebrew 安装..."
    if command -v brew &>/dev/null; then
        brew install ffmpeg
    else
        echo "  [错误] 未找到 Homebrew，请先安装 Homebrew:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo "  安装完成后重新运行本脚本"
        exit 1
    fi
fi

# ── 安装 Python 依赖 ──────────────────────────────
echo ""
echo "[4/4] 安装 Python 依赖包..."
python3 -m pip install --user faster-whisper torch

# ── 检查 tkinter ─────────────────────────────────
echo ""
echo "检查 tkinter..."
if python3 -c "import tkinter" &>/dev/null; then
    echo "  tkinter OK"
else
    echo "  [提示] 缺少 tkinter，可能需要安装:"
    echo "    brew install python-tk"
    echo "  如果仅使用命令行模式可忽略此提示"
fi

# ── 检查模型文件 ─────────────────────────────────
echo ""
if [ -f "models/model.bin" ]; then
    echo "模型文件已就绪"
else
    echo "[!] 警告：模型文件尚未放入 models/ 目录"
    echo ""
    echo "请按以下步骤下载模型:"
    echo "  1. 浏览器打开 https://hf-mirror.com/Systran/faster-whisper-medium/tree/main"
    echo "  2. 下载所有文件（至少需要 config.json 和 model.bin）"
    echo "  3. 放入此目录下的 models/ 文件夹"
    echo "  4. 再次运行 bash transcribe.sh"
    echo ""
fi

echo ""
echo "================================================"
echo "  环境安装完成！"
echo "  终端运行 bash transcribe.sh 开始转录"
echo "================================================"
