# Google Drive 동기화

전제: Google Drive for Desktop이 `G:` 드라이브로 마운트, `daehyun tmp` 공유 드라이브 사용
베이스 경로: `G:/공유 드라이브/daehyun tmp/github-ignore/`

## gdrive-sync (`~/bin/gdrive-sync.sh`)
Git 리포의 gitignore된 문서/DB → Google Drive 동기화 (cp 기반, rclone 불필요)
- `gdrive-sync push` — gitignore된 문서/DB → `github-ignore/리포명/`
- `gdrive-sync pull` — Google Drive → 로컬 (클론 후 실행)
- `gdrive-sync status` — 백업 파일 목록

### 백업 대상 확장자
pdf, docx, doc, xlsx, xls, pptx, ppt, hwp, hwpx, db, sqlite, sqlite3, mdb, accdb, csv, json, yaml, yml, ini, cfg, conf, bak, png, bin, cs

### git push 후 워크플로
```bash
git push && gdrive-sync push
```

## claude-config-sync (`~/bin/claude-config-sync.sh`)
Claude Code 설정 → GitHub `ryudae33/claude-settings` (private) 백업
- `claude-config-sync push` — `~/.claude/` + `~/bin/` + dotfiles → GitHub
- `claude-config-sync pull` — GitHub → 로컬 복원
- `claude-config-sync status` — 동기화 상태 (git log + diff)

### 백업 대상
- `~/.claude/` — CLAUDE.md, settings.json, config.json, .claudeignore, *.bat, *.vbs
- `~/.claude/commands/` — 사용자 스킬 (*.md)
- `~/.claude/agents/` — 에이전트 정의 (*.md)
- `~/.claude/references/` — 참조 문서 (*.md)
- `~/.claude/memory/` — 자동 메모리 (MEMORY.md)
- `~/bin/` — 스크립트 (*.sh)
- dotfiles — .bashrc, .bash_profile, .profile, .gitconfig, .vimrc
- **제외**: mcp_servers.json (토큰 포함), *.exe 바이너리

### 새 PC 세팅
```bash
gh repo clone ryudae33/claude-settings ~/claude-settings
bash ~/claude-settings/bin/claude-config-sync.sh pull
```
