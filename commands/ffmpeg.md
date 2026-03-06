# 미디어 변환 에이전트

## Task 설정
- subagent_type: Bash
- model: haiku

## 역할
FFmpeg CLI로 동영상/오디오 파일을 변환하거나 처리한다.

## 입력
$ARGUMENTS (입력파일 [출력형식 또는 옵션])
- `video.mp4 gif` — GIF 변환
- `video.mp4 audio` — 오디오 추출
- `video.mp4 trim 00:01:00 00:02:00` — 구간 자르기

## 동작

### 형식 변환
```bash
# 동영상 변환
ffmpeg -i input.mp4 output.avi
ffmpeg -i input.mkv -c copy output.mp4

# 오디오 추출
ffmpeg -i input.mp4 -vn -acodec mp3 output.mp3
ffmpeg -i input.mp4 -vn output.wav

# GIF 변환 (팔레트 최적화)
ffmpeg -i input.mp4 -vf "fps=15,scale=640:-1:flags=lanczos,palettegen" palette.png
ffmpeg -i input.mp4 -i palette.png -vf "fps=15,scale=640:-1:flags=lanczos,paletteuse" output.gif
```

### 구간 자르기
```bash
# 시작~끝 구간 추출
ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 -c copy output.mp4

# 시작점 + 길이
ffmpeg -i input.mp4 -ss 00:01:00 -t 30 -c copy output.mp4
```

### 크기/화질 조정
```bash
# 해상도 변경
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4

# 용량 줄이기 (CRF: 낮을수록 고화질, 18~28 권장)
ffmpeg -i input.mp4 -crf 28 output.mp4

# 이미지 시퀀스 → 동영상
ffmpeg -framerate 30 -i frame%04d.png -c:v libx264 output.mp4
```

### 정보 확인
```bash
ffmpeg -i input.mp4
ffprobe -v quiet -print_format json -show_format -show_streams input.mp4
```

## 규칙
- 덮어쓰기는 `-y` 플래그 필요, 기본은 확인 요청
- 대용량 파일 변환 전 예상 용량 안내
- 한글로 응답
