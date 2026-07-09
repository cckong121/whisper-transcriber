
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
