#!/usr/bin/env bash
# ── 批量转录工具 — Mac 环境安装 ──────────────────
# 用法：在终端中运行 bash setup.sh
set -e

echo "================================================"
echo "  批量转录工具 — 环境安装 (macOS)"
echo "================================================"
echo ""

# ── 检查 Python ──────────────────────────────────
echo "[1/3] 检查 Python..."
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
echo "[2/3] 检查 pip..."
if python3 -m pip --version &>/dev/null; then
    python3 -m pip --version
    echo "  OK"
else
    echo "  正在安装 pip..."
    python3 -m ensurepip --user
fi

# ── 检查 ffmpeg ──────────────────────────────────
echo ""
echo "[3/3] 检查 ffmpeg..."
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
echo "正在安装 Python 依赖包..."
python3 -m pip install --user faster-whisper torch

# ── 检查 tkinter ─────────────────────────────────
echo ""
echo "检查 tkinter..."
if python3 -c "import tkinter" &>/dev/null; then
    echo "  tkinter OK"
else
    echo "  [提示] 缺少 tkinter，Mac 上可能需要:"
    echo "    brew install python-tk@3.12 (或与你 python3 版本对应)"
    echo "  如果仅使用命令行模式可忽略此提示"
fi

echo ""
echo "================================================"
echo "  环境安装完成！"
echo "  双击 transcribe.command 或在终端运行:"
echo "    bash transcribe.sh"
echo "================================================"
