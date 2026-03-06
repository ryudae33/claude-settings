#!/bin/bash
# claude-config-sync.sh — Claude Code 설정을 GitHub로 백업/복원
# 리포: ryudae33/claude-settings (private)

REPO_DIR="$HOME/claude-settings"
SRC="$HOME/.claude"

# 동기화 대상
SYNC_FILES=(CLAUDE.md INSTALL.md .claudeignore config.json settings.json settings.local.json claude.ico build-template.md)
SYNC_GLOBS=("*.bat" "*.vbs" "*.sh")
SYNC_DIRS=(commands agents references memory)
DOTFILES=(.bashrc .bash_profile .profile .gitconfig .vimrc)

check_repo() {
    if [ ! -d "$REPO_DIR/.git" ]; then
        echo "리포 없음. 클론 중..."
        gh repo clone ryudae33/claude-settings "$REPO_DIR" 2>/dev/null
        if [ ! -d "$REPO_DIR/.git" ]; then
            echo "오류: 리포 클론 실패"
            exit 1
        fi
    fi
}

# ~/.claude → 리포로 파일 복사
copy_to_repo() {
    # 개별 파일
    for f in "${SYNC_FILES[@]}"; do
        [ -f "$SRC/$f" ] && cp "$SRC/$f" "$REPO_DIR/$f"
    done
    # glob
    for g in "${SYNC_GLOBS[@]}"; do
        for f in "$SRC"/$g; do
            [ -f "$f" ] && cp "$f" "$REPO_DIR/$(basename "$f")"
        done
    done
    # 디렉토리
    for d in "${SYNC_DIRS[@]}"; do
        if [ -d "$SRC/$d" ]; then
            mkdir -p "$REPO_DIR/$d"
            cp "$SRC/$d"/*.md "$REPO_DIR/$d/" 2>/dev/null
        fi
    done
    # ~/bin 스크립트
    mkdir -p "$REPO_DIR/bin"
    for f in "$HOME"/bin/*.sh; do
        [ -f "$f" ] && cp "$f" "$REPO_DIR/bin/"
    done
    # dotfiles
    mkdir -p "$REPO_DIR/dotfiles"
    for f in "${DOTFILES[@]}"; do
        [ -f "$HOME/$f" ] && cp "$HOME/$f" "$REPO_DIR/dotfiles/$f"
    done
}

# 리포 → ~/.claude로 파일 복사
copy_from_repo() {
    # 개별 파일
    for f in "${SYNC_FILES[@]}"; do
        [ -f "$REPO_DIR/$f" ] && cp "$REPO_DIR/$f" "$SRC/$f"
    done
    # glob
    for g in "${SYNC_GLOBS[@]}"; do
        for f in "$REPO_DIR"/$g; do
            [ -f "$f" ] && cp "$f" "$SRC/$(basename "$f")"
        done
    done
    # 디렉토리
    for d in "${SYNC_DIRS[@]}"; do
        if [ -d "$REPO_DIR/$d" ]; then
            mkdir -p "$SRC/$d"
            cp "$REPO_DIR/$d"/*.md "$SRC/$d/" 2>/dev/null
        fi
    done
    # ~/bin 스크립트
    mkdir -p "$HOME/bin"
    for f in "$REPO_DIR"/bin/*.sh; do
        [ -f "$f" ] && cp "$f" "$HOME/bin/"
    done
    # dotfiles
    if [ -d "$REPO_DIR/dotfiles" ]; then
        for f in "${DOTFILES[@]}"; do
            [ -f "$REPO_DIR/dotfiles/$f" ] && cp "$REPO_DIR/dotfiles/$f" "$HOME/$f"
        done
    fi
}

do_push() {
    check_repo
    echo "→ 설정 백업 중..."
    copy_to_repo

    cd "$REPO_DIR" || exit 1
    git add -A

    # 변경 없으면 스킵
    if git diff --cached --quiet; then
        echo "변경 없음 — 이미 최신"
        return
    fi

    local host=$(hostname)
    local ts=$(date '+%Y-%m-%d %H:%M:%S')
    local changed=$(git diff --cached --stat | tail -1)
    git commit -m "$(cat <<EOF
[$host] $ts

$changed
EOF
)"
    git push 2>&1
    echo "완료: 백업됨 ($host, $ts)"
}

do_pull() {
    check_repo
    echo "← 설정 복원 중..."

    cd "$REPO_DIR" || exit 1
    git pull --ff-only 2>&1

    copy_from_repo
    echo "완료: 복원됨"
}

do_status() {
    check_repo
    cd "$REPO_DIR" || exit 1

    # 최신 커밋 정보
    echo "최근 백업:"
    git log --oneline -5 --format="  %h  %s"
    echo ""

    # 로컬 변경 확인 (임시 복사 후 diff)
    copy_to_repo
    if git diff --quiet && git diff --cached --quiet; then
        echo "상태: 동기화됨"
    else
        echo "상태: 로컬 변경 있음 — backup 필요"
        git diff --stat
    fi
    # 복사한 변경 되돌리기
    git checkout -- . 2>/dev/null
}

case "$1" in
    push|backup) do_push ;;
    pull|load)   do_pull ;;
    status)      do_status ;;
    *)
        echo "사용법: claude-config-sync [push|pull|status]"
        echo "  push (backup) — 설정 → GitHub 백업"
        echo "  pull (load)   — GitHub → 로컬 복원"
        echo "  status        — 동기화 상태 확인"
        ;;
esac
