# CLI 유틸리티

## 파일 검색
- **Everything CLI** → `es` (PATH 등록, `C:\Users\Administrator\bin\es.exe` v1.1.0.27)
  - `es *.mdb` — 확장자 검색
  - `es ext:cs "C:\Projects"` — 경로 필터
  - `es -size -dm *.log` — 크기/수정일 포함
  - `es -n 20 검색어` — 결과 수 제한

## 압축
- **7-Zip** → `7z` (PATH 등록, `C:\Program Files\7-Zip\7z.exe`)
  - `7z a output.7z .\폴더\` — 압축
  - `7z x archive.zip -o.\출력\` — 해제
  - `7z l archive.zip` — 목록
  - `7z a -v100m output.7z .\폴더\` — 분할 압축

## 문서/뷰어
- **LibreOffice** → `soffice` (PATH 등록, `C:\Program Files\LibreOffice\program\`)
  - `soffice --headless --convert-to pdf 파일.docx`
  - `soffice --headless --convert-to xlsx 파일.csv`
- **SumatraPDF** → `SumatraPDF` (PATH 등록, `C:\Users\Administrator\AppData\Local\SumatraPDF\`)
  - `SumatraPDF -print-to-default 파일.pdf` — 기본 프린터 출력
- **Pandoc** → `pandoc` (PATH 등록, 설치됨)
  - `pandoc input.md -o output.docx` — Markdown → Word
  - `pandoc input.docx -o output.md` — Word → Markdown
  - `pandoc input.md --toc -o output.html` — 목차 포함 HTML

## 미디어
- **FFmpeg** → `ffmpeg` (PATH 등록, 설치됨)
  - `ffmpeg -i input.mp4 output.avi` — 형식 변환
  - `ffmpeg -i input.mp4 -vn output.mp3` — 오디오 추출
  - `ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 -c copy output.mp4` — 구간 자르기
  - `ffprobe -v quiet -print_format json -show_streams input.mp4` — 미디어 정보

## JSON 처리
- **jq** → `jq` (PATH 등록, 설치됨)
  - `curl -s https://api.example.com | jq '.'` — JSON 예쁘게 출력
  - `jq '.data[]' input.json` — 배열 순회
  - `jq '.name, .version' package.json` — 필드 추출
  - `jq '[.[] | select(.status == "active")]' data.json` — 필터링
  - `jq -r '.items[].name' data.json` — 원시 문자열 출력 (따옴표 없음)

## 컨테이너
- **Docker** → `docker` (PATH 등록, Docker Desktop 설치됨)
  - `docker ps` / `docker ps -a` — 컨테이너 목록
  - `docker run -d -p 80:80 nginx` — 컨테이너 실행
  - `docker compose up -d` — Compose 실행
  - `docker system prune -f` — 미사용 리소스 정리

## 동기화
- **rclone** → `rclone` (PATH 등록, v1.73.0)
  - `gdrive:` — 개인 Google Drive, `gdrive-tmp:` — 공유 daehyun tmp
  - 래퍼 스크립트: `gdrive-sync push/pull/status`

## 런타임
- **Python** → `python` (PATH 등록, `C:\Python314\python.exe` v3.14.3)
  - pip: `pip install 패키지`
  - 시리얼 테스트: `python -m serial.tools.miniterm COM1 9600`
- **Node.js** → `node` / `npm` / `npx` (PATH 등록, v24.13.1)
- **.NET** → `dotnet` (PATH 등록, v10.0.200-preview)
- **PowerShell 7+** → `pwsh` (PATH 등록, 설치됨)
  - 기존 `powershell` (v5.1)과 구분, 크로스플랫폼 지원

## 시스템 유틸
- **WSL** → `wsl -d Ubuntu -- bash -c "명령"` (PATH 등록)
- **curl** → `curl` (PATH 등록, `C:\Windows\System32\curl.exe`)
