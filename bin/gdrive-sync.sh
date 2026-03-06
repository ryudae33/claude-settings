#!/bin/bash
# gdrive-sync.sh — gitignore된 문서/DB 파일을 Google Drive에 동기화
# 대상: G:\공유 드라이브\daehyun tmp\github-ignore
# 경로: BASE_PATH/리포명/

BASE_PATH="/g/공유 드라이브/daehyun tmp/github-ignore"
DOC_EXT='\.(pdf|docx|doc|xlsx|xls|pptx|ppt|hwp|hwpx|db|sqlite|sqlite3|mdb|accdb|csv|json|yaml|yml|ini|cfg|conf|bak|png|bin|cs)$'

get_repo_name() {
    git rev-parse --show-toplevel 2>/dev/null | xargs basename
}

get_repo_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

case "$1" in
    push)
        REPO=$(get_repo_name) || { echo "오류: Git 리포가 아닙니다."; exit 1; }
        ROOT=$(get_repo_root)
        DEST="$BASE_PATH/$REPO"
        echo "→ Google Drive: $DEST/ 으로 업로드 중..."

        # gitignore된 파일 중 문서/DB 확장자만 업로드 (빌드 산출물 폴더 제외)
        cd "$ROOT"
        git -c core.quotepath=false ls-files --others --ignored --exclude-standard \
            | grep -Ei "$DOC_EXT" \
            | grep -Ev '^(bin|obj|\.vs|node_modules|\.gradle|build|dist|__pycache__)/' \
            | grep -Ev '/(bin|obj|\.vs|node_modules|\.gradle|build|dist|__pycache__)/' \
            | while read -r f; do
            DIR=$(dirname "$f")
            if [ "$DIR" = "." ]; then
                rclone copy "$f" "$DEST/" --progress 2>&1
            else
                rclone copy "$f" "$DEST/$DIR/" --progress 2>&1
            fi
        done
        echo "완료: $DEST/"
        ;;

    pull)
        REPO=$(get_repo_name) || { echo "오류: Git 리포가 아닙니다."; exit 1; }
        ROOT=$(get_repo_root)
        DEST="$BASE_PATH/$REPO"
        echo "← Google Drive: $DEST/ 에서 다운로드 중..."
        rclone copy "$DEST/" "$ROOT/" --progress
        echo "완료"
        ;;

    status)
        REPO=$(get_repo_name) || { echo "오류: Git 리포가 아닙니다."; exit 1; }
        DEST="$BASE_PATH/$REPO"
        echo "[ $DEST/ ]"
        rclone ls "$DEST/" 2>/dev/null || echo "(비어 있음)"
        ;;

    *)
        echo "사용법: gdrive-sync [push|pull|status]"
        echo "  push   — gitignore된 문서/DB → Google Drive (github-ignore/리포명/)"
        echo "  pull   — Google Drive → 로컬 (클론 후 복원)"
        echo "  status — Google Drive에 저장된 파일 목록"
        ;;
esac
