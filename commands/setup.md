---
name: setup
description: "Install Claude Code work environment tools on a new PC. Installs CLI tools, libraries, and portable binaries via winget/pip. Use when setting up a new development machine, checking installed tool status, or updating all installed tools."
---

# Environment Setup Agent

## Task Settings
- subagent_type: build-runner
- model: sonnet

## Role
Automatically installs Claude Code work environment (CLI tools/libraries/portable binaries) on a new PC.

## Input
$ARGUMENTS (empty for full install)
- (empty) — full install
- `status` — check installation status
- `update` — update installed tools

## Actions

### Full Install
```bash
bash ~/claude-settings/setup.sh
```

### Check Installation Status
Check only (does not install):
```bash
echo "=== Installation Status ===" && \
for cmd in git gh pwsh python node dotnet sqlite3 jq 7z es ffmpeg pandoc ncat tshark docker; do \
  command -v $cmd &>/dev/null && echo "  ✓ $cmd" || echo "  ✗ $cmd"; \
done && \
pip show pyserial httpx click pymodbus 2>/dev/null | grep -E "^Name:" | sed 's/Name: /  ✓ /' && \
echo "Portable:" && \
for f in es.exe winsocat.exe; do \
  [ -f "$HOME/bin/$f" ] && echo "  ✓ $f" || echo "  ✗ $f"; \
done
```

### Update Tools
```bash
winget upgrade --all --accept-package-agreements --accept-source-agreements
pip install --upgrade pyserial httpx click pymodbus
```

### Installation Targets
| Category | Tool | Method |
|----------|------|--------|
| Development | Git, gh, PowerShell 7, Python, Node.js, .NET SDK | winget |
| DB | SQLite, jq | winget |
| Documents | LibreOffice, Pandoc, SumatraPDF | winget |
| Utilities | 7-Zip, Everything, Rclone | winget |
| Media | FFmpeg | winget |
| Network | PuTTY, Nmap, Wireshark | winget |
| Container | Docker Desktop | winget |
| Python | pyserial, httpx, click, pymodbus | pip |
| Portable | es.exe, winsocat.exe | Google Drive copy |

### Portable Binary Path
`G:/Shared drives/daehyun tmp/claude-settings/bin/`

## Rules
- Skip already installed tools
- Continue to next tool on installation failure
