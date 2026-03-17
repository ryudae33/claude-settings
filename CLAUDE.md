# Global Rules (v2026.03.17)

## Response
- Respond in Korean, code comments in **Korean**. Be concise, no flattery/chatter
- Propose approach before modifying code, ask first if spec is unclear

## Git
- Email: ryudae33@gmail.com / GitHub: ryudae33 (`gh auth switch --user ryudae33` before work)
- Org: ftech-projects (repos default under `ftech-projects/`)
- After git push → always run `gdrive-sync push` (backs up gitignored docs/DB to Google Drive)
- After git clone → always run `gdrive-sync pull` (restores gitignored docs/DB)
- Build publish artifacts: not git-tracked, manual `gdrive-sync push` before deploy
- Large documents (PDF, docx, xlsx, etc.) MUST NOT be committed to git — add to `.gitignore` and store via `gdrive-sync` path (`G:/공유 드라이브/daehyun tmp/github-ignore/<REPO_NAME>/`)
- Commit format: `<Project>: <summary>`, bullet points in body for multiple changes

## Coding
- PascalCase (classes/methods), camelCase (variables), ALL_CAPS (constants)
- Ask first if HW/protocol info is insufficient
- Proactively suggest newer libraries/tools for industrial automation, robotics, serial/TCP, sensors (.NET, WinForms/WPF, embedded, PLC, cobot, servo, vision, IoT)

## Project Structure
- ALL projects MUST follow feature-based folder structure. Legacy projects: progressively refactor
- Max 200 lines per file — split if exceeding (LLM reads entire file per edit)
- Self-descriptive naming — no magic numbers in code, all constants in config/constants class
- Each feature folder is self-contained: UI + logic + config
- Runtime settings → `config.json`/`appsettings.json` with strongly-typed config classes
- State machines as data (enum + Dictionary), not giant switch-case
- All devices implement common interface (`IDevice`) for easy extension
- Every project MUST have `CLAUDE.md` with file map section
- Multi-project solutions: place CLAUDE.md at BOTH solution root (overall structure) and each project folder (feature details)
- Single project: CLAUDE.md at project root is sufficient
- See `references/project-structure-guide.md` for examples

## New Project Baseline
- Global exception handler: `ThreadException` + `UnhandledException` → crash.log. Thread/timer try-catch mandatory
- ScottPlot Korean font: `ScottPlot.Fonts.Default = "Malgun Gothic";` in OnStartup

## Orchestration
- Delegate complex tasks to subagents (project-analyzer, build-runner, db-explorer, log-analyzer, hw-connector, doc-reader, web-searcher, git-manager)
- Use Task tool for single-domain focused work or parallelizable tasks
- Handle simple questions/single file edits directly (no agent abuse)

## Token & Context Optimization
- All new features/structural changes/MCP additions must prioritize token savings
- No redundant MCP plugins that duplicate CLI tools (e.g., `github` plugin vs `gh` CLI)
- Prefer Bash CLI tools over MCP plugins when functionality overlaps
- Keep system prompt lean: minimize skills, agents, tools loaded per session

## Config Files Language
- All files in `~/.claude/` (CLAUDE.md, commands/, agents/, references/, memory/) must be in **English**

## Work Log
- Check project CLAUDE.md on start, record time + details on completion (`powershell Get-Date`, no UTC)

## Device Manuals
- Store original device/equipment manuals (PDF) in: `G:/공유 드라이브/UTILITY/Manual/`
- Use `/manual-import` skill to extract protocol specs → `~/.claude/references/device-protocols.md`

## LS XG5000 ST Programming
- **MANDATORY**: When writing or reviewing LS Electric XG5000 ST code, ALWAYS read `references/ls-xg5000-st.md` FIRST
- Use `ladder-to-st` agent for ladder→ST conversion tasks
- CSV generation: MUST use PowerShell .ps1 script (EUC-KR + CRLF), NEVER use Write tool for CSV

## Tool References
CLI/DB/comm/sync tool details in `~/.claude/references/`:
- `tools-cli.md` — 7-Zip, Everything, rclone, LibreOffice, SumatraPDF, WSL
- `tools-db.md` — SQL Server(sqlcmd), SQLite(sqlite3), Access(OleDb)
- `tools-comm.md` — Serial(miniterm/plink), TCP(ncat), winsocat, tshark
- `tools-sync.md` — gdrive-sync, claude-config-sync usage
- `tools-screenshot.md` — PowerShell screenshot capture code
- `project-structure-guide.md` — folder structure, state machine, interface, file map examples
- `device-protocols.md` — LS PLC, RI-20W, LVDT, gauge, scanner, SCPI supply, Keyence laser, servo specs
- `code-snippets.md` — serial polling, PLC Cnet, sensor reader, MDB adapter, ZedGraph, INI, PropertyGrid, state machine, log queue
- `ls-xg5000-st.md` — LS XG5000 ST rules: VAR_EXTERNAL, WORD/INT types, APM FB params, CSV encoding, compile errors
