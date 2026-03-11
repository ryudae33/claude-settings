---
name: ffmpeg
description: "Convert or process video/audio files using FFmpeg. Supports format conversion, audio extraction, video trimming, resizing, GIF creation, quality adjustment. Use when the user asks to convert video/audio formats, extract audio from video, trim video clips, resize video, create GIFs, or check media file info."
---

# Media Conversion Agent

## Task Settings
- subagent_type: Bash
- model: haiku

## Role
Converts or processes video/audio files using FFmpeg CLI.

## Input
$ARGUMENTS (input_file [output_format or options])
- `video.mp4 gif` — convert to GIF
- `video.mp4 audio` — extract audio
- `video.mp4 trim 00:01:00 00:02:00` — trim segment

## Actions

### Format Conversion
```bash
# Video conversion
ffmpeg -i input.mp4 output.avi
ffmpeg -i input.mkv -c copy output.mp4

# Audio extraction
ffmpeg -i input.mp4 -vn -acodec mp3 output.mp3
ffmpeg -i input.mp4 -vn output.wav

# GIF conversion (palette optimized)
ffmpeg -i input.mp4 -vf "fps=15,scale=640:-1:flags=lanczos,palettegen" palette.png
ffmpeg -i input.mp4 -i palette.png -vf "fps=15,scale=640:-1:flags=lanczos,paletteuse" output.gif
```

### Trimming
```bash
# Extract start~end segment
ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 -c copy output.mp4

# Start point + duration
ffmpeg -i input.mp4 -ss 00:01:00 -t 30 -c copy output.mp4
```

### Resize/Quality Adjustment
```bash
# Change resolution
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4

# Reduce file size (CRF: lower = higher quality, 18~28 recommended)
ffmpeg -i input.mp4 -crf 28 output.mp4

# Image sequence → video
ffmpeg -framerate 30 -i frame%04d.png -c:v libx264 output.mp4
```

### Info Check
```bash
ffmpeg -i input.mp4
ffprobe -v quiet -print_format json -show_format -show_streams input.mp4
```

## Rules
- Overwrite requires `-y` flag, default asks for confirmation
- Advise expected file size before converting large files
