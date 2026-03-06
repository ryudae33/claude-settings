#!/bin/bash
# claude-config-sync.sh — Claude Code 설정을 Google Drive에 백업/복원
# 대상: G:/공유 드라이브/daehyun tmp/claude-settings/

DEST="G:/공유 드라이브/daehyun tmp/claude-settings"
SRC="$HOME/.claude"
VERSION_FILE=".sync-version.json"

check_gdrive() {
    if [ ! -d "G:/공유 드라이브/daehyun tmp" ]; then
        echo "오류: Google Drive (G:) 가 마운트되어 있지 않습니다."
        exit 1
    fi
}

# 백업 대상: ~/.claude/ 내 설정 파일 + 폴더
# (history, cache, projects, shell-snapshots 등 세션 데이터 제외)
SYNC_FILES=(
    CLAUDE.md INSTALL.md .claudeignore
    config.json settings.json settings.local.json
    mcp_servers.json claude.ico build-template.md
)
SYNC_GLOBS=("*.bat" "*.vbs" "*.sh")
SYNC_DIRS=(commands agents references memory bin)

# dotfiles (홈 디렉토리)
DOTFILES=(.bashrc .bash_profile .profile .gitconfig .vimrc)

# ~/bin 스크립트
SYNC_BIN=true

do_push() {
    check_gdrive
    echo "→ 백업: $SRC/ → $DEST/"
    local count=0

    # 개별 파일
    for f in "${SYNC_FILES[@]}"; do
        [ -f "$SRC/$f" ] && cp -u "$SRC/$f" "$DEST/$f" && echo "  ✓ $f" && ((count++))
    done

    # glob 패턴 (bat, vbs, sh)
    for g in "${SYNC_GLOBS[@]}"; do
        for f in "$SRC"/$g; do
            [ -f "$f" ] && cp -u "$f" "$DEST/$(basename "$f")" && echo "  ✓ $(basename "$f")" && ((count++))
        done
    done

    # 디렉토리 (하위 전체)
    for d in "${SYNC_DIRS[@]}"; do
        if [ -d "$SRC/$d" ]; then
            mkdir -p "$DEST/$d" 2>/dev/null
            for f in "$SRC/$d"/*; do
                [ -f "$f" ] && cp -u "$f" "$DEST/$d/$(basename "$f")" && echo "  ✓ $d/$(basename "$f")" && ((count++))
            done
        fi
    done

    # ~/bin 스크립트
    if [ "$SYNC_BIN" = true ] && [ -d "$HOME/bin" ]; then
        mkdir -p "$DEST/bin" 2>/dev/null
        for f in "$HOME"/bin/*; do
            [ -f "$f" ] && cp -u "$f" "$DEST/bin/$(basename "$f")" && echo "  ✓ bin/$(basename "$f")" && ((count++))
        done
    fi

    # dotfiles
    mkdir -p "$DEST/dotfiles" 2>/dev/null
    for f in "${DOTFILES[@]}"; do
        [ -f "$HOME/$f" ] && cp -u "$HOME/$f" "$DEST/dotfiles/$f" && echo "  ✓ dotfiles/$f" && ((count++))
    done

    # 버전 증가
    local cur_ver="0.0"
    if [ -f "$DEST/$VERSION_FILE" ]; then
        cur_ver=$(sed -n 's/.*"version":"\([^"]*\)".*/\1/p' "$DEST/$VERSION_FILE")
    fi
    local major="${cur_ver%%.*}"
    local minor="${cur_ver#*.}"
    if [ "$2" = "major" ]; then
        major=$((major + 1))
        minor=0
    else
        minor=$((minor + 1))
    fi
    local new_ver="${major}.${minor}"
    local ts=$(date '+%Y-%m-%d %H:%M:%S')
    local host=$(hostname)
    printf '{"version":"%s","date":"%s","host":"%s","files":%d}\n' "$new_ver" "$ts" "$host" "$count" > "$DEST/$VERSION_FILE"
    cp -f "$DEST/$VERSION_FILE" "$SRC/$VERSION_FILE"

    echo "완료: v$new_ver — $count개 파일 백업됨 ($host, $ts)"
}

do_pull() {
    check_gdrive
    if [ ! -d "$DEST" ]; then
        echo "Google Drive에 claude-settings 백업이 없습니다."
        exit 0
    fi
    echo "← 복원: $DEST/ → $SRC/"
    local count=0

    # 개별 파일
    for f in "${SYNC_FILES[@]}"; do
        [ -f "$DEST/$f" ] && cp -u "$DEST/$f" "$SRC/$f" && echo "  ✓ $f" && ((count++))
    done

    # glob 패턴
    for g in "${SYNC_GLOBS[@]}"; do
        for f in "$DEST"/$g; do
            [ -f "$f" ] && cp -u "$f" "$SRC/$(basename "$f")" && echo "  ✓ $(basename "$f")" && ((count++))
        done
    done

    # 디렉토리
    for d in "${SYNC_DIRS[@]}"; do
        if [ -d "$DEST/$d" ]; then
            mkdir -p "$SRC/$d" 2>/dev/null
            for f in "$DEST/$d"/*; do
                [ -f "$f" ] && cp -u "$f" "$SRC/$d/$(basename "$f")" && echo "  ✓ $d/$(basename "$f")" && ((count++))
            done
        fi
    done

    # ~/bin 스크립트
    if [ "$SYNC_BIN" = true ] && [ -d "$DEST/bin" ]; then
        mkdir -p "$HOME/bin" 2>/dev/null
        for f in "$DEST"/bin/*; do
            [ -f "$f" ] && cp -u "$f" "$HOME/bin/$(basename "$f")" && echo "  ✓ bin/$(basename "$f")" && ((count++))
        done
    fi

    # dotfiles
    if [ -d "$DEST/dotfiles" ]; then
        for f in "${DOTFILES[@]}"; do
            [ -f "$DEST/dotfiles/$f" ] && cp -u "$DEST/dotfiles/$f" "$HOME/$f" && echo "  ✓ dotfiles/$f" && ((count++))
        done
    fi

    # 버전 복사
    [ -f "$DEST/$VERSION_FILE" ] && cp -f "$DEST/$VERSION_FILE" "$SRC/$VERSION_FILE"

    echo "완료: $count개 파일 복원됨"
}

do_status() {
    check_gdrive
    local local_ver="(없음)" remote_ver="(없음)"
    local local_host="" remote_host=""
    local local_date="" remote_date=""

    if [ -f "$SRC/$VERSION_FILE" ]; then
        local_ver=$(sed -n 's/.*"version":"\([^"]*\)".*/\1/p' "$SRC/$VERSION_FILE")
        local_host=$(sed -n 's/.*"host":"\([^"]*\)".*/\1/p' "$SRC/$VERSION_FILE")
        local_date=$(sed -n 's/.*"date":"\([^"]*\)".*/\1/p' "$SRC/$VERSION_FILE")
    fi
    if [ -f "$DEST/$VERSION_FILE" ]; then
        remote_ver=$(sed -n 's/.*"version":"\([^"]*\)".*/\1/p' "$DEST/$VERSION_FILE")
        remote_host=$(sed -n 's/.*"host":"\([^"]*\)".*/\1/p' "$DEST/$VERSION_FILE")
        remote_date=$(sed -n 's/.*"date":"\([^"]*\)".*/\1/p' "$DEST/$VERSION_FILE")
    fi

    echo "로컬:  v$local_ver  $local_date  ($local_host)"
    echo "원격:  v$remote_ver  $remote_date  ($remote_host)"

    if [ "$local_ver" = "$remote_ver" ]; then
        echo "상태:  동기화됨"
    elif [ "$local_ver" = "(없음)" ]; then
        echo "상태:  로컬 없음 — load 필요"
    else
        echo "상태:  불일치 — backup 또는 load 필요"
    fi
}

case "$1" in
    push|backup) do_push "$@" ;;
    pull|load)   do_pull ;;
    status)      do_status ;;
    *)
        echo "사용법: claude-config-sync [push|pull|status]"
        echo "  push (backup)       — 설정 백업 (마이너 버전 +1)"
        echo "  push major          — 설정 백업 (메이저 버전 +1)"
        echo "  pull (load)         — Google Drive → 로컬 복원"
        echo "  status              — 버전 비교"
        ;;
esac
