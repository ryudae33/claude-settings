# CLI Utilities

## File Search
- **Everything CLI** → `es` (in PATH, `C:\Users\ryuda\bin\es.exe` v1.1.0.27)
  - `es *.mdb` — extension search
  - `es ext:cs "C:\Projects"` — path filter
  - `es -size -dm *.log` — include size/modified date
  - `es -n 20 keyword` — limit results

## Compression
- **7-Zip** → `7z` (in PATH, `C:\Program Files\7-Zip\7z.exe`)
  - `7z a output.7z .\folder\` — compress
  - `7z x archive.zip -o.\output\` — extract
  - `7z l archive.zip` — list
  - `7z a -v100m output.7z .\folder\` — split archive

## Documents/Viewer
- **LibreOffice** → `soffice` (in PATH, `C:\Program Files\LibreOffice\program\`)
  - `soffice --headless --convert-to pdf file.docx`
  - `soffice --headless --convert-to xlsx file.csv`
- **SumatraPDF** → `SumatraPDF` (in PATH, `C:\Users\ryuda\AppData\Local\SumatraPDF\`)
  - `SumatraPDF -print-to-default file.pdf` — print to default printer
- **Pandoc** → `pandoc` (in PATH, installed)
  - `pandoc input.md -o output.docx` — Markdown → Word
  - `pandoc input.docx -o output.md` — Word → Markdown
  - `pandoc input.md --toc -o output.html` — HTML with TOC

## Media
- **FFmpeg** → `ffmpeg` (in PATH, installed)
  - `ffmpeg -i input.mp4 output.avi` — format conversion
  - `ffmpeg -i input.mp4 -vn output.mp3` — extract audio
  - `ffmpeg -i input.mp4 -ss 00:01:00 -to 00:02:00 -c copy output.mp4` — trim segment
  - `ffprobe -v quiet -print_format json -show_streams input.mp4` — media info

## JSON Processing
- **jq** → `jq` (in PATH, installed)
  - `curl -s https://api.example.com | jq '.'` — pretty print JSON
  - `jq '.data[]' input.json` — iterate array
  - `jq '.name, .version' package.json` — extract fields
  - `jq '[.[] | select(.status == "active")]' data.json` — filter
  - `jq -r '.items[].name' data.json` — raw string output (no quotes)

## Containers
- **Docker** → `docker` (in PATH, Docker Desktop installed)
  - `docker ps` / `docker ps -a` — container list
  - `docker run -d -p 80:80 nginx` — run container
  - `docker compose up -d` — Compose up
  - `docker system prune -f` — cleanup unused resources

## Sync
- **rclone** → `rclone` (in PATH, v1.73.0)
  - `gdrive:` — personal Google Drive, `gdrive-tmp:` — shared daehyun tmp
  - Wrapper script: `gdrive-sync push/pull/status`

## Runtimes
- **Python** → `python` (in PATH, `C:\Users\ryuda\AppData\Local\Programs\Python\Python313\python.exe` v3.13.12)
  - pip: `pip install package`
  - Serial test: `python -m serial.tools.miniterm COM1 9600`
- **Node.js** → `node` / `npm` / `npx` (in PATH, v24.13.1)
- **.NET** → `dotnet` (in PATH, v10.0.200-preview)
- **PowerShell 7+** → `pwsh` (in PATH, installed)
  - Separate from `powershell` (v5.1), cross-platform support

## System Utils
- **WSL** → `wsl -d Ubuntu -- bash -c "command"` (in PATH)
- **curl** → `curl` (in PATH, `C:\Windows\System32\curl.exe`)
