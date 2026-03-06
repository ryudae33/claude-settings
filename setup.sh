#!/bin/bash
# setup.sh — 새 PC Claude Code 환경 자동 설치
# 사용: bash ~/claude-settings/setup.sh
#
# 전제: winget 사용 가능, Google Drive (G:) 마운트됨
# 포터블 바이너리: G:/공유 드라이브/daehyun tmp/claude-settings/bin/

GDRIVE_BIN="G:/공유 드라이브/daehyun tmp/claude-settings/bin"

echo "=== Claude Code 환경 설치 ==="
echo ""

# ── 1. winget 패키지 ──
declare -A PKGS=(
    # 개발 기본
    ["Git.Git"]="Git"
    ["GitHub.cli"]="GitHub CLI"
    ["Microsoft.PowerShell"]="PowerShell 7"
    ["Python.Python.3.13"]="Python 3.13"
    ["OpenJS.NodeJS.LTS"]="Node.js LTS"
    ["SQLite.SQLite"]="SQLite"
    ["jqlang.jq"]="jq"

    # .NET
    ["Microsoft.DotNet.SDK.10"]="dotnet SDK 10"

    # 편집/문서
    ["TheDocumentFoundation.LibreOffice"]="LibreOffice"
    ["JohnMacFarlane.Pandoc"]="Pandoc"
    ["SumatraPDF.SumatraPDF"]="SumatraPDF"

    # 압축/검색/동기화
    ["7zip.7zip"]="7-Zip"
    ["voidtools.Everything"]="Everything"
    ["Rclone.Rclone"]="Rclone"

    # 미디어
    ["Gyan.FFmpeg"]="FFmpeg"

    # 네트워크/통신
    ["PuTTY.PuTTY"]="PuTTY"
    ["Insecure.Nmap"]="Nmap"
    ["WiresharkFoundation.Wireshark"]="Wireshark"

    # 컨테이너
    ["Docker.DockerDesktop"]="Docker Desktop"
)

# 설치 순서 고정
INSTALL_ORDER=(
    "Git.Git" "GitHub.cli" "Microsoft.PowerShell"
    "Python.Python.3.13" "OpenJS.NodeJS.LTS"
    "Microsoft.DotNet.SDK.10"
    "SQLite.SQLite" "jqlang.jq"
    "7zip.7zip" "voidtools.Everything" "Rclone.Rclone"
    "TheDocumentFoundation.LibreOffice" "JohnMacFarlane.Pandoc" "SumatraPDF.SumatraPDF"
    "Gyan.FFmpeg"
    "PuTTY.PuTTY" "Insecure.Nmap" "WiresharkFoundation.Wireshark"
    "Docker.DockerDesktop"
)

echo "[1/3] winget 패키지 설치 중..."
for id in "${INSTALL_ORDER[@]}"; do
    name="${PKGS[$id]}"
    if winget list --id "$id" --accept-source-agreements 2>/dev/null | grep -q "$id"; then
        echo "  ✓ $name"
    else
        echo "  → $name 설치 중..."
        winget install --id "$id" --accept-package-agreements --accept-source-agreements -h 2>/dev/null \
            && echo "  ✓ $name" || echo "  ✗ $name (실패)"
    fi
done

# ── 2. pip 패키지 ──
PIP_PKGS=(pyserial httpx click pymodbus)

echo ""
echo "[2/3] pip 패키지 설치 중..."
for pkg in "${PIP_PKGS[@]}"; do
    if pip show "$pkg" &>/dev/null; then
        echo "  ✓ $pkg"
    else
        pip install -q "$pkg" 2>/dev/null && echo "  ✓ $pkg" || echo "  ✗ $pkg"
    fi
done

# ── 3. 포터블 바이너리 (Google Drive → ~/bin/) ──
echo ""
echo "[3/3] 포터블 바이너리 복사..."
mkdir -p "$HOME/bin"

if [ -d "$GDRIVE_BIN" ]; then
    for f in "$GDRIVE_BIN"/*.exe; do
        [ -f "$f" ] || continue
        name=$(basename "$f")
        if [ -f "$HOME/bin/$name" ]; then
            echo "  ✓ $name (이미 있음)"
        else
            cp "$f" "$HOME/bin/$name" && echo "  ✓ $name 복사됨" || echo "  ✗ $name 복사 실패"
        fi
    done
else
    echo "  ⚠ Google Drive 경로 없음: $GDRIVE_BIN"
    echo "    es.exe, winsocat.exe 수동 설치 필요"
fi

# ── 결과 ──
echo ""
echo "=== 설치 완료 ==="
echo ""
echo "다음 단계:"
echo "  1. 터미널 재시작 (PATH 적용)"
echo "  2. gh auth login (GitHub 인증)"
echo "  3. bash ~/claude-settings/bin/claude-config-sync.sh pull (설정 복원)"
echo "  4. ~/.claude/mcp_servers.json 수동 설정 (토큰 포함)"
echo "  5. Google Drive for Desktop 설치 → G: 드라이브 마운트"
