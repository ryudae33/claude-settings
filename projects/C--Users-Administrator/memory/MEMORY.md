# Memory

## Agent System

### Task Subagents (Built-in)
| Agent | Model | Purpose |
|-------|-------|---------|
| project-planner | **sonnet** | New project planning/design |
| project-analyzer | **sonnet** | Project structure/comm/PLC/DB analysis |
| vb-converter | **sonnet** | VB.NET → C# conversion |
| ui-builder | **sonnet** | WinForms Designer.cs generation |
| db-explorer | **sonnet** | DB exploration (SQL Server/Access/SQLite/MySQL/PostgreSQL/dBASE/Excel) |
| doc-reader | **sonnet** | Read/analyze PDF/Excel/Word/CSV docs |
| log-analyzer | **sonnet** | Log analysis (comm/app/event logs) |
| hw-connector | **sonnet** | Device connection/verification (Serial/TCP/USB/Modbus) |
| web-searcher | **sonnet** | Web search/technical research |
| build-runner | **sonnet** | dotnet build/publish, MSBuild, build error analysis |
| git-manager | **haiku** | GitHub repo management (gh CLI) |
| screenshot-viewer | **haiku** | Latest screenshot check/analysis |
| tm-robot | **sonnet** | TM cobot (TMflow/TMscript/Modbus/vision/coords/I-O) |
| db-schema-designer | **opus** | DB schema design (requirements→normalization→DDL, ERD) |

### User Skills (commands/*.md)
| Skill | Purpose |
|-------|---------|
| /analyze-project | Full automation project analysis → .project-analysis.md |
| /vb-convert | VB.NET → C# .NET 9.0 conversion |
| /winforms-ui | WinForms Designer.cs UI authoring |
| /sc | Latest screenshot check/analysis |
| /crash-log | crash.log exception analysis |
| /arduino | Arduino CLI compile/upload (C:\tools\arduino-cli\arduino-cli.exe) |

### User Subagents (agents/*.md)
| Agent | Purpose |
|-------|---------|
| arduino-builder | Arduino/ESP32 compile/upload, error analysis/fix |
| /git-init | Git init + GitHub repo creation |
| /cleanup | Build artifact cleanup (bin/obj/.vs) |
| /search-files | Drive-wide file search via Everything |
| /compress | 7-Zip compress/decompress |
| /convert-doc | LibreOffice doc conversion (→ PDF/xlsx/csv etc.) |
| /pandoc | Pandoc doc conversion (Markdown↔Word/HTML/PDF) |
| /ffmpeg | FFmpeg media conversion/editing |
| /docker | Docker container/image/Compose management |

## Config Structure
- `~/.claude/CLAUDE.md` — Core rules
- `~/.claude/references/` — 5 tool reference files (tools-cli/db/comm/sync/screenshot.md)
- Tool versions/paths delegated to reference files

## Build Environment
- Android SDK path: `C:/android-sdk` (MSBuild property `-p:AndroidSdkDirectory=C:/android-sdk` required)
- JDK: Microsoft OpenJDK 17 (installed via winget)
- MAUI workload: `dotnet workload install maui-android`
- aapt2 build may fail in OneDrive Korean path → copy to English path before build

## Win7 (192.168.0.218) Driver Signing Issue
- bcdedit testsigning/nointegritychecks ignored (suspected patched winload.exe)
- PEAK driver cross-cert expired 2021 → catalog signature invalid
- **Solution**: `bcdedit /set {globalsettings} advancedoptions true` → select "Disable Driver Signature Enforcement" on each boot
- Remote shell: `PEAK_DRV/remote.ps1` (PS 2.0 compatible TCP 4444, multi-connection)
- Korean paths break in Win7 PS → use English folder names

## MCP Servers
- **pcan**: `C:\Users\Administrator\mcp-servers\pcan\server.py` — PCAN-USB CAN comm (PCANBasic.dll ctypes)
  - Tools: can_open/close, can_send/recv, can_monitor, uds_request, ign_start/stop, tp_start/stop, heater_status
  - Config: registered in `~/.claude/settings.local.json` mcpServers section

## Active Projects
- **JX1 Huseok Seat ECU Test**: see `Desktop/JX1/CLAUDE.md`
  - PCAN-USB + RLPSU ECU, CAN 500K, UDS $2F F016 heater control
  - BCM_02 (0x3E0) = IGN ON, 0x732/0x73A = UDS diagnostics

## Installed Tool Versions
- 7-Zip 26.00, Everything 1.4.1 + es.exe 1.1.0.27, rclone 1.73.0, LibreOffice 25.8
- SumatraPDF 3.5.2, PuTTY 0.83, nmap 7.80, WinSocat 0.1.3, Wireshark 4.6.3
- sqlite3 3.51.2, SSMS 20.2.1, Access Database Engine 2016
- Python 3.14.3 (pyserial 3.5, httpx 0.28, click 8.3), Node.js 24.13.1, .NET 10.0-preview
- ffmpeg 8.0.1, jq 1.8.1, pandoc 3.9, pwsh 7.5.4, Docker Desktop 29.2.0
- D2Coding font: Windows Terminal default font
