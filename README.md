<p align="center">
  <!-- <a href="README.md"><strong>English</strong></a> · -->
  <a href="README.zh-CN.md"><strong>简体中文</strong></a>
</p>


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
