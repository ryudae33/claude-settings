# Google Drive Sync

Prerequisite: Google Drive for Desktop mounted as `G:` drive, using `daehyun tmp` shared drive
Base path: `G:/공유 드라이브/daehyun tmp/github-ignore/`

## gdrive-sync (`~/bin/gdrive-sync.sh`)
Syncs gitignored docs/DB from Git repo → Google Drive (cp-based, no rclone needed)
- `gdrive-sync push` — gitignored docs/DB → `github-ignore/repo-name/`
- `gdrive-sync pull` — Google Drive → local (run after clone)
- `gdrive-sync status` — backup file list

### Backup Target Extensions
pdf, docx, doc, xlsx, xls, pptx, ppt, hwp, hwpx, db, sqlite, sqlite3, mdb, accdb, csv, json, yaml, yml, ini, cfg, conf, bak, png, bin, cs

### Post git-push Workflow
```bash
git push && gdrive-sync push
```

## claude-config-sync (`~/bin/claude-config-sync.sh`)
Claude Code config → GitHub `ryudae33/claude-settings` (private) backup
- `claude-config-sync push` — `~/.claude/` + `~/bin/` + dotfiles → GitHub
- `claude-config-sync pull` — GitHub → local restore
- `claude-config-sync status` — sync status (git log + diff)

### Backup Targets
- `~/.claude/` — CLAUDE.md, settings.json, config.json, .claudeignore, *.bat, *.vbs
- `~/.claude/commands/` — User skills (*.md)
- `~/.claude/agents/` — Agent definitions (*.md)
- `~/.claude/references/` — Reference docs (*.md)
- `~/.claude/memory/` — Auto memory (MEMORY.md)
- `~/bin/` — Scripts (*.sh)
- dotfiles — .bashrc, .bash_profile, .profile, .gitconfig, .vimrc
- **Excluded**: mcp_servers.json (contains tokens), *.exe binaries

### New PC Setup
```bash
gh repo clone ryudae33/claude-settings ~/claude-settings
bash ~/claude-settings/bin/claude-config-sync.sh pull
```
