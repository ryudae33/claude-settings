# 환경 설치 에이전트

## Task 설정
- subagent_type: build-runner
- model: sonnet

## 역할
새 PC에 Claude Code 작업 환경(CLI 도구/라이브러리/포터블 바이너리)을 자동 설치한다.

## 입력
$ARGUMENTS (없으면 전체 설치)
- (빈값) — 전체 설치
- `status` — 설치 현황 확인
- `update` — 설치된 도구 업데이트

## 동작

### 전체 설치
```bash
bash ~/claude-settings/setup.sh
```

### 설치 현황 확인
설치 여부를 확인만 한다 (설치하지 않음):
```bash
echo "=== 설치 현황 ===" && \
for cmd in git gh pwsh python node dotnet sqlite3 jq 7z es ffmpeg pandoc ncat tshark docker; do \
  command -v $cmd &>/dev/null && echo "  ✓ $cmd" || echo "  ✗ $cmd"; \
done && \
pip show pyserial httpx click pymodbus 2>/dev/null | grep -E "^Name:" | sed 's/Name: /  ✓ /' && \
echo "포터블:" && \
for f in es.exe winsocat.exe; do \
  [ -f "$HOME/bin/$f" ] && echo "  ✓ $f" || echo "  ✗ $f"; \
done
```

### 도구 업데이트
```bash
winget upgrade --all --accept-package-agreements --accept-source-agreements
pip install --upgrade pyserial httpx click pymodbus
```

### 설치 대상
| 분류 | 도구 | 방식 |
|------|------|------|
| 개발 | Git, gh, PowerShell 7, Python, Node.js, .NET SDK | winget |
| DB | SQLite, jq | winget |
| 문서 | LibreOffice, Pandoc, SumatraPDF | winget |
| 유틸 | 7-Zip, Everything, Rclone | winget |
| 미디어 | FFmpeg | winget |
| 네트워크 | PuTTY, Nmap, Wireshark | winget |
| 컨테이너 | Docker Desktop | winget |
| Python | pyserial, httpx, click, pymodbus | pip |
| 포터블 | es.exe, winsocat.exe | Google Drive 복사 |

### 포터블 바이너리 경로
`G:/공유 드라이브/daehyun tmp/claude-settings/bin/`

## 규칙
- 이미 설치된 도구는 스킵
- 설치 실패 시 다음 도구로 계속 진행
- 한글로 응답
