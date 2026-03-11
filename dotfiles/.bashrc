
# gdrive-sync: Git repo docs/DB files Google Drive sync
alias gdrive-sync='bash /c/Users/Administrator/bin/gdrive-sync.sh'

# claude-config-sync alias
alias claude-config-sync='bash ~/bin/claude-config-sync.sh'

# Auto-sync Claude settings on terminal startup
(
  CLAUDE_REPO="$HOME/claude-settings"
  if [ -d "$CLAUDE_REPO/.git" ]; then
    cd "$CLAUDE_REPO"
    git fetch origin main --quiet 2>/dev/null
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/main 2>/dev/null)
    if [ "$LOCAL" != "$REMOTE" ]; then
      echo "[Claude Config] New settings found, updating..."
      git pull --quiet 2>/dev/null
      bash "$CLAUDE_REPO/bin/claude-config-sync.sh" pull 2>/dev/null
    fi
  fi
) &
