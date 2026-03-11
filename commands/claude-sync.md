---
name: claude-sync
description: "Backup or restore Claude Code settings (skills, agents, references, memory, dotfiles) to/from GitHub. Use when the user asks to sync, backup, push, pull, or restore their Claude configuration, or check sync status."
---

# Claude Settings Sync Agent

## Task Settings
- subagent_type: git-manager
- model: haiku

## Role
Backs up or restores Claude Code settings (skills/agents/references/memory/dotfiles) to/from GitHub.

## Input
$ARGUMENTS (task type)
- `backup` or `push` — Local → GitHub backup
- `load` or `pull` — GitHub → Local restore
- `status` — Check sync status

## Actions

### Backup (push/backup)
```bash
bash ~/bin/claude-config-sync.sh push
```

### Restore (load/pull)
```bash
bash ~/bin/claude-config-sync.sh pull
```

### Status Check
```bash
bash ~/bin/claude-config-sync.sh status
```

### Repository
`ryudae33/claude-settings` (private)

### New PC Initial Setup Steps
1. Install Claude Code + authenticate gh CLI
2. `gh repo clone ryudae33/claude-settings ~/claude-settings`
3. `bash ~/claude-settings/bin/claude-config-sync.sh pull`
4. Restart terminal
5. `mcp_servers.json` must be configured manually (excluded from git due to tokens)

## Rules
- Auto-clone if repo doesn't exist
- Skip commit if no changes
- mcp_servers.json is gitignored (contains tokens)
