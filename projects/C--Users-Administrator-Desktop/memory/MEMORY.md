# DSC India ST40 SP3 MECA
- [st40-sp3-meca-work.md](st40-sp3-meca-work.md) — IO module/ToolPos/INI features ported from S50

---

# Assemble 310 (Shinjin) Project Memory
- All details documented in project CLAUDE.md (`Assemble 310/CLAUDE.md`)
- Step structure details: [assemble310-steps.md](assemble310-steps.md)
- 2026-03-06 gauge work was never committed (code lost) — details in CLAUDE.md Work History

---

# GL3 NI COM Removal
- [gl3-ni-removal.md](gl3-ni-removal.md) — AxCWButton → Label conversion across 6 GL3 subprojects (2026-03-16)

---

# NoiseTest1 (Shinjin) Project Memory

## Project Overview
- Path: `C:\Users\Administrator\Desktop\SHINJIN\NoiseTest1\`
- vbproj: `LeakTestMachine_신진1.vbproj`
- Output: `TestSystemS_V1(20260306).exe`
- .NET Framework 4.8, VB.NET WinForms
- Detailed work log: [shinjin-noisetest1.md](shinjin-noisetest1.md)

## Current Status (2026-03-06)
- NI UI/FlexCell component removal complete → replaced with standard controls + ZedGraph
- Build success (0 errors, 6 warnings - unused variables)
- Runtime testing in progress — fixing graph/grid display issues

## Remaining Work
- Verify execution (after SetupGraphs added, GridCount Enabled removed)
- Possible LoadSetData/LoadBarcodeData/SaveDB errors if DB.mdb missing
- FirstPass column needed in Table_SET (currently defended with Try-Catch)

---

# Shinjin 1CELL XG5000 ST Upload
- [shinjin-1cell-xg5000.md](shinjin-1cell-xg5000.md) — XEC PLC ST code upload, variable naming, CSV import, XG5000 registration (2026-03-16)

# XG5000 ST Programming Rules
- [xg5000-st-rules.md](xg5000-st-rules.md) — VAR_EXTERNAL, RETURN restriction, WORD arithmetic, APM FB correct params

# Feedback
- [feedback_detail_oriented.md](feedback_detail_oriented.md) — User expects proactive edge case handling (overflow, sign, safety)
- [feedback_reset_safety.md](feedback_reset_safety.md) — Reset must retract 복동 SOL before clearing outputs
