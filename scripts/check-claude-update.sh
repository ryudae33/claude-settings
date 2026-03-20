#!/bin/bash
# Claude Code 업데이트 체크 스크립트
# SessionStart hook에서 호출됨

VERSION_FILE="$HOME/.claude/.claude-code-last-version"
CURRENT_VERSION=$(claude --version 2>/dev/null | head -1 | awk '{print $1}')

# gh CLI로 최신 릴리즈 정보 가져오기
LATEST_INFO=$(gh api repos/anthropics/claude-code/releases/latest --jq '.tag_name + "|" + .name + "|" + .published_at + "|" + .html_url' 2>/dev/null)

if [ -z "$LATEST_INFO" ]; then
  exit 0
fi

LATEST_TAG=$(echo "$LATEST_INFO" | cut -d'|' -f1)
LATEST_NAME=$(echo "$LATEST_INFO" | cut -d'|' -f2)
LATEST_DATE=$(echo "$LATEST_INFO" | cut -d'|' -f3)
LATEST_URL=$(echo "$LATEST_INFO" | cut -d'|' -f4)
LATEST_VERSION="${LATEST_TAG#v}"

# 마지막 확인 버전 읽기
LAST_SEEN=""
if [ -f "$VERSION_FILE" ]; then
  LAST_SEEN=$(cat "$VERSION_FILE")
fi

# 새 릴리즈가 있으면 알림
if [ "$LATEST_VERSION" != "$LAST_SEEN" ]; then
  # 현재 버전과 비교
  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    STATUS="(현재 사용 중)"
  else
    STATUS="(현재: $CURRENT_VERSION → 업데이트 필요)"
  fi

  # 릴리즈 노트 요약 (첫 500자)
  RELEASE_BODY=$(gh api repos/anthropics/claude-code/releases/latest --jq '.body' 2>/dev/null | head -20)

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🆕 Claude Code 최신 릴리즈: $LATEST_TAG $STATUS"
  echo "   $LATEST_NAME"
  echo "   릴리즈 날짜: $LATEST_DATE"
  echo "   $LATEST_URL"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -n "$RELEASE_BODY" ]; then
    echo ""
    echo "$RELEASE_BODY"
    echo ""
  fi

  # 확인 버전 업데이트
  echo "$LATEST_VERSION" > "$VERSION_FILE"
fi
