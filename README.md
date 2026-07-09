# Whisper Transcriber

Batch video/audio to text transcription tool powered by [faster-whisper](https://github.com/SYSTRAN/faster-whisper). Works on **Windows** and **macOS**.

## Features

- 🎬 Transcribe video and audio files in batch
- 🖥️ Cross-platform: Windows & macOS
- 🚀 GPU acceleration (NVIDIA CUDA, auto-detected)
- 🇨🇳 Chinese-optimized defaults (configurable)
- ⏭️ Auto-skip already transcribed files
- 📝 Timestamped output (`[hh:mm:ss --> hh:mm:ss] text`)

## Supported Formats

Video: MP4, MOV, M4V, AVI, MKV
Audio: M4A, MP3, WAV, FLAC, OGG, WMA

## Quick Start

### 1. Download Model Files

Download the [faster-whisper-medium](https://hf-mirror.com/Systran/faster-whisper-medium/tree/main) model files and place them in the `models/` directory:

```
models/
  ├── config.json      (required)
  ├── model.bin        (required, ~1.5 GB)
  ├── tokenizer.json   (required)
  └── vocabulary.txt   (required)
```

> **Note:** `model.bin` is ~1.5 GB. Download from [HuggingFace](https://huggingface.co/Systran/faster-whisper-medium) or [HF Mirror](https://hf-mirror.com/Systran/faster-whisper-medium) (China-friendly).

### 2. Install Dependencies

**Windows:**
```
Double-click setup.bat
```

**macOS:**
```bash
bash setup.sh
```

Or manually:
```bash
pip install -r requirements.txt
# Also requires ffmpeg — install via your package manager
```

### 3. Run

**Windows:** Double-click `transcribe.bat`

**macOS:**
```bash
bash transcribe.sh
# or: python3 transcribe.py
```

A dialog will prompt you to select a folder (batch process) or individual files. Output `.txt` files are saved alongside the source files.

## Directory Structure

```
whisper-transcriber/
  ├── models/            # Model files (download separately)
  │   ├── config.json
  │   ├── model.bin      # Excluded from git (too large)
  │   ├── tokenizer.json
  │   └── vocabulary.txt
  ├── transcribe.py      # Core transcription script
  ├── setup.bat / .sh    # Environment setup (Windows / macOS)
  ├── transcribe.bat / .sh  # Launcher (Windows / macOS)
  ├── requirements.txt   # Python dependencies
  └── 使用说明.txt        # Chinese manual
```

## Performance

| Hardware | 10-min video |
|----------|-------------|
| NVIDIA GPU (CUDA) | < 30 sec |
| CPU (Intel/Apple Silicon) | 1–2 min |

## Changing the Language

Edit `transcribe.py` line 93, change `language="zh"` to your target language code (e.g. `"en"` for English, `"ja"` for Japanese).

## License

MIT License — see [LICENSE](LICENSE) for details.

The [faster-whisper](https://github.com/SYSTRAN/faster-whisper) library and model are under their respective licenses.

---

# 中文说明

## 批量视频/音频转文字工具

基于 [faster-whisper](https://github.com/SYSTRAN/faster-whisper)，支持 Windows 和 macOS。

### 功能特性

- 🎬 批量转录视频和音频文件
- 🖥️ 跨平台：Windows / macOS 均可使用
- 🚀 自动检测 NVIDIA 显卡并启用 GPU 加速
- 🇨🇳 默认中文识别（可修改）
- ⏭️ 已有同名 .txt 自动跳过，不重复转录
- 📝 带时间戳的输出格式：`[时:分:秒 --> 时:分:秒] 文本`

### 使用方法

**第一步：下载模型**

从 [hf-mirror.com](https://hf-mirror.com/Systran/faster-whisper-medium/tree/main) 下载所有文件放入 `models/` 目录。至少需要 `config.json` 和 `model.bin`（约 1.5 GB）。

**第二步：安装环境**

- Windows：双击 `setup.bat`
- Mac：终端运行 `bash setup.sh`

**第三步：启动转录**

- Windows：双击 `transcribe.bat`
- Mac：终端运行 `bash transcribe.sh`

弹窗选择文件夹（处理整个文件夹）或手动多选文件，结果保存为同目录下同名 .txt。

### 常见问题

- **提示未找到 ffmpeg**：运行 setup 脚本自动安装，或手动从 [ffmpeg.org](https://ffmpeg.org) 下载
- **模型文件缺失**：检查 `models/` 下是否有 `model.bin` 和 `config.json`
- **想换模型**：替换 `models/` 下的文件即可，支持 small / medium / large-v3
- **Mac 上无法双击 .sh**：在终端中 `cd` 到目录后运行 `bash setup.sh` 或 `bash transcribe.sh`

### 许可

MIT License — 详见 [LICENSE](LICENSE)。
