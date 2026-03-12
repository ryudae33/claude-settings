# Global Rules

## Response
- Respond in Korean, code comments in **English**. Be concise, no flattery/chatter
- Propose approach before modifying code, ask first if spec is unclear

## Git
- Email: ryudae33@gmail.com / GitHub: ryudae33 (run `gh auth switch --user ryudae33` before work)
- Org: ftech-projects (repos default under `ftech-projects/`)
- **After git push, always run `gdrive-sync push`** — backs up gitignored docs/DB files to Google Drive `Sourcr ryudae/repo-name/`
- **Build publish artifacts**: not tracked by git. Manual `gdrive-sync push` before deploy is project-specific (build-runner does not auto-sync)
- **After git clone, always run `gdrive-sync pull`** — restores gitignored docs/DB files from Google Drive
- **Commit messages must include clear change summary**: format `<Project>: <summary>`, use bullet points in body for multiple changes

## Coding
- PascalCase (classes/methods), camelCase (variables), ALL_CAPS (constants)
- Ask first if HW/protocol info is insufficient
- **Tech suggestions**: When writing code related to industrial automation, robotics, serial/TCP communication, or sensor integration, proactively suggest newer/better libraries, tools, or approaches if available (e.g., newer NuGet packages, GitHub trending repos, better protocols). Focus areas: .NET, WinForms/WPF, embedded, PLC, cobot, servo/motor control, vision, IoT

## Project Structure (LLM-Optimized)
ALL projects (new and existing) MUST follow this structure. When modifying legacy projects, progressively refactor toward this structure — split large files, extract features, separate config.

### File Rules
- **Max 200 lines per file** — split if exceeding. LLM reads entire file per edit; large files waste tokens
- **Self-descriptive naming** — `MoveServoToPosition(int servoIndex, double targetMm)` not `DoWork(int m, double v)`
- **No magic numbers in code** — all constants in config or dedicated constants class

### Feature-Based Folder Structure (not layered MVC)
```
src/
  Features/
    Measurement/
      MeasurementService.cs    # business logic
      MeasurementConfig.cs     # settings/constants
      MeasurementForm.cs       # UI (thin, delegates to Service)
    ServoControl/
      ServoService.cs
      ServoConfig.cs
      ServoForm.cs
  Shared/
    Communication/             # serial/TCP/Modbus helpers
    Database/                  # DB access helpers
    Models/                    # shared DTOs/enums
  Program.cs                   # entry point + global exception handler
  config.json                  # all runtime settings (ports, speeds, thresholds)
```
- Each feature folder is self-contained: UI + logic + config
- LLM finds target file by feature name without Glob/Grep → saves search tokens

### Config Separation
- Runtime settings (ports, speeds, thresholds) → `config.json` or `appsettings.json`
- Changing a value = editing JSON, not parsing 1000-line code file
- Use strongly-typed config classes to deserialize

### State Machine as Data
- Define steps/sequences as enum + Dictionary or data structure, not giant switch-case
- Step additions/changes become data edits, not logic refactoring
```csharp
enum Step { Init, Move, Measure, Evaluate }
Dictionary<Step, StepConfig> Steps = new() {
    [Step.Init] = new("초기화", ServoAction.Home, nextStep: Step.Move),
    [Step.Move] = new("이동", ServoAction.MoveToPos, nextStep: Step.Measure),
};
```

### Interface-Based Devices
- All devices implement common interface → LLM can add new device without reading existing implementations
```csharp
public interface IDevice { void Connect(); void Disconnect(); double Read(); }
```

### Project CLAUDE.md File Map
- Every new project MUST have a `CLAUDE.md` in project root with a file map section:
```markdown
## File Map
- Features/Measurement/ — load cell/LVDT/gauge measurement
- Features/ServoControl/ — servo control and positioning
- Shared/Communication/ — serial/TCP communication helpers
```
- This eliminates exploratory file searches → biggest token saver

## New Project Baseline
- **Global exception handler**: `ThreadException` + `UnhandledException` → crash.log (time/source/message/stack). Thread/timer try-catch mandatory
- **ScottPlot Korean font**: `ScottPlot.Fonts.Default = "Malgun Gothic";` set globally in OnStartup

## Orchestration
- Delegate complex tasks (analysis/build/DB/comm/docs) to specialized subagents
- Criteria: use Task tool for single-domain focused work or parallelizable tasks
- Key agents: project-analyzer, build-runner, db-explorer, log-analyzer, hw-connector, doc-reader, web-searcher, git-manager
- Handle simple questions/single file edits directly (no agent abuse)

## Token & Context Optimization
- **All new features, structural changes, and plugin/MCP additions must prioritize token savings and context optimization**
- Avoid redundant plugins/MCP servers that duplicate existing CLI tool capabilities (e.g., `github` plugin when `gh` CLI already works)
- MCP tool schemas load into context every message — only install plugins that provide genuinely new capabilities
- Prefer Bash CLI tools over MCP plugins when functionality overlaps
- Keep system prompt lean: minimize skills, agents, and tools loaded per session

## Config Files Language
- All config/memory/reference files (`~/.claude/` including CLAUDE.md, commands/, agents/, references/, memory/) must be written in **English** to minimize token consumption

## Work Log
- Check project CLAUDE.md on start, record time + details on completion (`powershell Get-Date`, no UTC)

## Tool References
CLI/DB/comm/sync tool details in `~/.claude/references/`:
- `tools-cli.md` — 7-Zip, Everything, rclone, LibreOffice, SumatraPDF, WSL
- `tools-db.md` — SQL Server(sqlcmd), SQLite(sqlite3), Access(OleDb)
- `tools-comm.md` — Serial(miniterm/plink), TCP(ncat), winsocat, tshark
- `tools-sync.md` — gdrive-sync, claude-config-sync usage
- `tools-screenshot.md` — PowerShell screenshot capture code
