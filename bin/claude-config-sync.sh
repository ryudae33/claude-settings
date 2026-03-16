#!/bin/bash
# claude-config-sync: Sync Claude Code settings with GitHub
# Usage:
#   claude-config-sync push   - Local settings → GitHub push
#   claude-config-sync pull   - GitHub → Local settings restore
#   claude-config-sync status - Check sync status

REPO="ryudae33/claude-settings"
LOCAL_REPO="$HOME/claude-settings"
CLAUDE_DIR="$HOME/.claude"

# Ensure gh auth
gh auth switch --user ryudae33 2>/dev/null

# Clone repo if not exists
ensure_repo() {
    if [ ! -d "$LOCAL_REPO/.git" ]; then
        echo "[Claude Config] Cloning repo..."
        gh repo clone "$REPO" "$LOCAL_REPO"
        cd "$LOCAL_REPO" && git config user.email "ryudae33@gmail.com"
    fi
}

case "${1}" in
    push)
        ensure_repo
        echo "[Claude Config] Local → GitHub push..."

        # Auto-update CLAUDE.md version (date-based)
        VERSION="v$(date '+%Y.%m.%d')"
        sed -i "s/^# Global Rules (v[0-9.]*)/# Global Rules ($VERSION)/" "$CLAUDE_DIR/CLAUDE.md"

        # Copy settings to repo
        cp "$CLAUDE_DIR/CLAUDE.md" "$LOCAL_REPO/" 2>/dev/null
        cp "$CLAUDE_DIR/config.json" "$LOCAL_REPO/" 2>/dev/null
        cp "$CLAUDE_DIR/settings.json" "$LOCAL_REPO/" 2>/dev/null
        cp "$CLAUDE_DIR/.claudeignore" "$LOCAL_REPO/" 2>/dev/null
        cp "$CLAUDE_DIR/build-template.md" "$LOCAL_REPO/" 2>/dev/null

        # Commands (skills)
        mkdir -p "$LOCAL_REPO/commands"
        cp "$CLAUDE_DIR/commands/"*.md "$LOCAL_REPO/commands/" 2>/dev/null

        # Agents
        if [ -d "$CLAUDE_DIR/agents" ]; then
            mkdir -p "$LOCAL_REPO/agents"
            cp "$CLAUDE_DIR/agents/"*.md "$LOCAL_REPO/agents/" 2>/dev/null
        fi

        # References
        if [ -d "$CLAUDE_DIR/references" ]; then
            mkdir -p "$LOCAL_REPO/references"
            cp "$CLAUDE_DIR/references/"*.md "$LOCAL_REPO/references/" 2>/dev/null
        fi

        # Bin scripts
        mkdir -p "$LOCAL_REPO/bin"
        cp "$HOME/bin/"*.sh "$LOCAL_REPO/bin/" 2>/dev/null

        # Commit and push
        cd "$LOCAL_REPO"
        git add -A
        if git diff --cached --quiet; then
            echo "No changes to push."
        else
            git commit -m "[sync] $(date '+%Y-%m-%d %H:%M:%S')"
            git push
            echo "Push complete."
        fi
        ;;
    pull)
        ensure_repo
        echo "[Claude Config] GitHub → Local restore..."
        cd "$LOCAL_REPO" && git pull

        # Restore settings
        cp "$LOCAL_REPO/CLAUDE.md" "$CLAUDE_DIR/" 2>/dev/null
        cp "$LOCAL_REPO/config.json" "$CLAUDE_DIR/" 2>/dev/null
        cp "$LOCAL_REPO/settings.json" "$CLAUDE_DIR/" 2>/dev/null
        cp "$LOCAL_REPO/.claudeignore" "$CLAUDE_DIR/" 2>/dev/null
        cp "$LOCAL_REPO/build-template.md" "$CLAUDE_DIR/" 2>/dev/null

        # Commands
        mkdir -p "$CLAUDE_DIR/commands"
        cp "$LOCAL_REPO/commands/"*.md "$CLAUDE_DIR/commands/" 2>/dev/null

        # Agents
        if [ -d "$LOCAL_REPO/agents" ]; then
            mkdir -p "$CLAUDE_DIR/agents"
            cp "$LOCAL_REPO/agents/"*.md "$CLAUDE_DIR/agents/" 2>/dev/null
        fi

        # References
        if [ -d "$LOCAL_REPO/references" ]; then
            mkdir -p "$CLAUDE_DIR/references"
            cp "$LOCAL_REPO/references/"*.md "$CLAUDE_DIR/references/" 2>/dev/null
        fi

        # Bin scripts
        mkdir -p "$HOME/bin"
        cp "$LOCAL_REPO/bin/"*.sh "$HOME/bin/" 2>/dev/null

        echo "Restore complete. Restart Claude Code."
        ;;
    status)
        ensure_repo
        echo "[Claude Config] Sync status:"
        cd "$LOCAL_REPO"
        git fetch
        git status
        echo ""
        echo "Last commit:"
        git log --oneline -3
        ;;
    *)
        echo "Usage: claude-config-sync {push|pull|status}"
        echo ""
        echo "  push   - Local Claude settings → GitHub backup"
        echo "  pull   - GitHub → Local Claude settings restore"
        echo "  status - Check sync status"
        echo ""
        echo "Restore on new PC:"
        echo "  1. npm install -g @anthropic-ai/claude-code"
        echo "  2. gh auth login"
        echo "  3. gh repo clone $REPO ~/claude-settings"
        echo "  4. bash ~/claude-settings/bin/claude-config-sync.sh pull"
        echo "  5. claude"
        exit 1
        ;;
esac
