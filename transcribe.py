"""
批量视频/音频转文字工具 — Windows / macOS 跨平台版
依赖：faster-whisper + ffmpeg
用法：
  Windows：双击 transcribe.bat
  macOS：  终端运行 bash transcribe.sh，或直接 python3 transcribe.py
"""
import os
import sys
import subprocess
import tempfile
import tkinter as tk
from tkinter import filedialog, messagebox
from pathlib import Path

# ── 配置 ──────────────────────────────────────────
SCRIPT_DIR = Path(__file__).resolve().parent
MODEL_DIR = SCRIPT_DIR / "models"
SUPPORTED_EXTS = {".mp4", ".mov", ".m4v", ".avi", ".mkv",
                  ".m4a", ".mp3", ".wav", ".flac", ".ogg", ".wma"}

# ── 检查环境 ──────────────────────────────────────
def check_ffmpeg():
    try:
        result = subprocess.run(["ffmpeg", "-version"], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"ffmpeg 已就绪: {result.stdout.split(chr(10))[0]}")
            return True
    except FileNotFoundError:
        pass
    print("[WARN] 未找到ffmpeg，请运行 setup.bat 安装")
    return False

def check_model():
    required = ["config.json", "model.bin"]
    missing = [f for f in required if not (MODEL_DIR / f).exists()]
    if missing:
        print(f"[WARN] 模型文件缺失: {missing}")
        print(f"       请将模型文件放入: {MODEL_DIR}")
        return False
    return True

# ── 转录核心 ──────────────────────────────────────
def transcribe_file(src_path, out_txt):
    """对单个文件提取音频并转录。src_path和out_txt都是Path对象。"""
    src_path = Path(src_path)
    out_txt = Path(out_txt)
    tmp_wav = Path(tempfile.gettempdir()) / f"whisper_tmp_{os.getpid()}.wav"

    # 提取音频
    ext = src_path.suffix.lower()
    is_audio = ext in {".mp3", ".wav", ".m4a", ".flac", ".ogg", ".wma"}

    if is_audio:
        # 音频文件：直接转成16kHz单声道wav
        cmd = ["ffmpeg", "-y", "-i", str(src_path),
               "-acodec", "pcm_s16le", "-ar", "16000", "-ac", "1",
               "-loglevel", "error", str(tmp_wav)]
    else:
        # 视频文件：丢掉视频轨
        cmd = ["ffmpeg", "-y", "-i", str(src_path),
               "-vn", "-acodec", "pcm_s16le", "-ar", "16000", "-ac", "1",
               "-loglevel", "error", str(tmp_wav)]

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0 or not tmp_wav.exists():
        print(f"  [错误] 音频提取失败")
        return False

    # 加载模型
    from faster_whisper import WhisperModel

    # 判断是否有NVIDIA GPU
    try:
        import torch
        device = "cuda" if torch.cuda.is_available() else "cpu"
    except ImportError:
        device = "cpu"

    compute_type = "float16" if device == "cuda" else "int8"
    try:
        model = WhisperModel(str(MODEL_DIR), device=device, compute_type=compute_type)
    except Exception as e:
        print(f"  [错误] 加载模型失败: {e}")
        tmp_wav.unlink(missing_ok=True)
        return False

    # 识别
    try:
        segments, info = model.transcribe(
            str(tmp_wav),
            language="zh",
            beam_size=5,
            vad_filter=True,
        )
        detected_lang = info.language
        print(f"  检测语言: {detected_lang}, 概率: {info.language_probability:.2f}")

        with open(out_txt, "w", encoding="utf-8") as f:
            for seg in segments:
                line = f"[{seg.start:06.2f} --> {seg.end:06.2f}] {seg.text.strip()}"
                f.write(line + "\n")
        return True
    except Exception as e:
        print(f"  [错误] 识别失败: {e}")
        return False
    finally:
        tmp_wav.unlink(missing_ok=True)


# ── 主流程 ────────────────────────────────────────
def main():
    print("=" * 56)
    print("  批量视频/音频转文字工具")
    print("  powered by faster-whisper")
    print("=" * 56)

    # 环境检查
    if not check_ffmpeg():
        input("按回车键退出...")
        sys.exit(1)
    if not check_model():
        input("按回车键退出...")
        sys.exit(1)
    print()

    # 弹窗选择
    root = tk.Tk()
    root.withdraw()

    choice = messagebox.askyesno(
        "批量转录 — 选择方式",
        "选「是」= 处理整个文件夹\n选「否」= 手动选择多个文件"
    )

    FILES = []

    if choice:
        # 选文件夹
        folder = filedialog.askdirectory(title="选择包含视频/音频文件的文件夹")
        if not folder:
            print("已取消")
            return
        folder_path = Path(folder)
        for f in sorted(folder_path.iterdir()):
            if f.is_file() and f.suffix.lower() in SUPPORTED_EXTS:
                FILES.append(f)
    else:
        # 选多个文件
        filetypes = [
            ("视频/音频文件", "*.mp4 *.mov *.m4v *.avi *.mkv *.m4a *.mp3 *.wav *.flac *.ogg *.wma"),
            ("所有文件", "*.*"),
        ]
        selected = filedialog.askopenfilenames(
            title="选择要转录的视频/音频文件",
            filetypes=filetypes,
        )
        FILES = [Path(f) for f in selected]

    root.destroy()

    if not FILES:
        print("没有找到符合条件的文件")
        return

    print(f"\n共 {len(FILES)} 个文件待转录\n")

    success = 0
    skipped = 0
    failed = 0

    for i, src in enumerate(FILES, 1):
        name = src.stem
        out_txt = src.parent / f"{name}.txt"

        if out_txt.exists():
            print(f"[{i}/{len(FILES)}] 跳过: {src.name} (转写结果已存在)")
            skipped += 1
            continue

        print(f"[{i}/{len(FILES)}] 处理: {src.name}", end="", flush=True)
        if transcribe_file(src, out_txt):
            print(f"\r[{i}/{len(FILES)}] 完成: {src.name}")
            success += 1
        else:
            print(f"\r[{i}/{len(FILES)}] 失败: {src.name}")
            failed += 1

    print(f"\n{'=' * 56}")
    print(f"处理完成: 成功 {success}, 跳过 {skipped}, 失败 {failed}")
    print(f"转写结果保存在视频同目录下，同名 .txt 文件")
    input("\n按回车键退出...")


if __name__ == "__main__":
    main()
