# Claude Code Settings

Claude Code configuration backup — agents, skills, references, templates, scripts.

## Restore on New PC

Prerequisites: Claude Code (`npm install -g @anthropic-ai/claude-code`) and gh CLI authenticated.

```bash
gh repo clone ryudae33/claude-settings ~/claude-settings
bash ~/claude-settings/bin/claude-config-sync.sh pull
```

Restart terminal after restore. `mcp_servers.json` must be configured manually (excluded due to tokens).

## For LLM

If asked to restore Claude settings on a new PC, run these commands:

```bash
gh auth switch --user ryudae33 2>/dev/null
gh repo clone ryudae33/claude-settings ~/claude-settings
bash ~/claude-settings/bin/claude-config-sync.sh pull
```

This restores: CLAUDE.md, settings.json, config.json, commands/(skills), agents/, references/, ~/bin/ scripts.
