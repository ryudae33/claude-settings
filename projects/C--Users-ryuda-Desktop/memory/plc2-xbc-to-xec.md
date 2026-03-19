---
name: PLC2 XBC→XEC IL-to-ST Converter
description: LS PLC XBC-DN64H (MK IL/Ladder) → XEC-DN64H (IEC 61131-3 ST) conversion project at Desktop/plc2
type: project
---

## Project: PLC2 XBC→XEC Converter
Location: `Desktop/plc2/`
Target: LS XG5000 v4.81, XEC-DN64H

**Why:** Customer migrating from legacy XBC-DN64H (MK series, IL/Ladder) to XEC-DN64H (IEC 61131-3 ST). 17 programs total extracted from PDF as IL text.

### Status (2026-03-17)
- MAIN_01: **compiled 0 errors** in XG5000 (manually verified)
- All 17 programs: converted via Python converter → `output_final/`
- Remaining: user needs to compile each program in XG5000 and report errors

### Key Technical Rules (verified by compilation)
- **D device** → `%MW` (NOT %DW — %DW is invalid in XEC)
- **U device** → `%UW` (word) / `%UX` (bit) direct access (NOT GET/PUT FBs, NOT %IW/%QW)
- **U addressing**: U0A (slot 0x0A=10) → `%UW0.10.x`, bit offset = word_decimal * 16 + bit
- **P device** → XEC global variable name via P→%IX/%QX→varname lookup
- **TIME functions**: Only `TIME_TO_UDINT` / `UDINT_TO_TIME` exist (NO TIME_TO_DINT/DINT_TO_TIME)
- **WORD↔UDINT**: `WORD_TO_UDINT` / `UDINT_TO_WORD` for %MW ↔ UDINT conversion
- **FMOV/GMOV**: expand to individual %MW assignments (GMOV in reverse order)
- **GET** → `dest := %UW0.slot.reg;` direct read
- **PUTP** → `%UW0.slot.reg := value;` direct write
- **XG5000 ST**: body-only code (no PROGRAM/VAR/END_PROGRAM wrapper)
- **R_TRIG/F_TRIG**: declare as VAR, call with CLK at program start, use .Q inline
- **Cross-program timers**: MK T devices are global, XEC TON is local → use global BOOL `__Txxxx_Q`

### File Structure
```
converter/
  parser.py       — IL text parser
  instructions.py — IL instruction definitions + operand counts
  mapping.py      — address conversion (P/M/K/F/D/U/T → IEC notation)
  converter.py    — STConverter class (IL → ST code generation)
  postprocess.py  — cross-program timer reference resolution
  main.py         — batch conversion entry point
output_final/     — final ST + vars CSV for all 17 programs
  _GLOBAL_TIMER_VARS.csv — 8 global BOOL vars for shared timers
```

### Known Issues
- `__T0555_Q`: no TON definition found in any program (possibly missing in original)
- `DECO()`: used as function call — needs XG5000 ST compatibility check
- Global timer vars (`__Txxxx_Q`) must be registered in XEC global variable table

**How to apply:** When user reports compilation errors from remaining programs, check these rules first. Cross-program timer references and DECO are the most likely error sources.
