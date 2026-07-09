#!/usr/bin/env bash
# ── 批量转录工具 — Mac 启动脚本 ──────────────────
# 用法：在终端中运行 bash transcribe.sh
# 或双击 transcribe.command
set -e

# 切换到项目根目录
cd "$(dirname "$0")/.."

echo "正在启动转录工具..."
python3 transcribe.py
