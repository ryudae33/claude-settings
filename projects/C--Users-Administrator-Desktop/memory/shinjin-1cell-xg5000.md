---
name: Shinjin 1CELL XG5000 ST Upload
description: XEC PLC ST code upload progress - variable naming, CSV import, XG5000 registration
type: project
---

## Project
- Path: `C:\Users\Administrator\Desktop\SHINJIN\1 CELL 조립 장비\`
- PLC: LS Electric XEC-DR64H (XG5000)
- Original: XBC ladder → ST conversion (25 files)

## Completed Work (2026-03-16)
1. ST conversion: 17 ST programs + 5 GVL + 3 docs
2. Timer PT values ×100 correction
3. GVL missing variables ~1,476 added
4. Servo logic fixes (8 cases)
5. Spring logic fixes (10 cases × 2 files)
6. U09 variable name cleanup (bJogCW/bJogCCW)
7. P-address → XG5000 auto-generated names (1,041 replacements)
8. **M/D/T/K → _M/_D/_T/_K rename** (13,713 replacements in ST, 2,663 in CSV)
   - XG5000 reserves M/D/T/K as direct address prefixes
   - All variable names prefixed with underscore
9. GVL → XG5000 CSV import file generation (EUC-KR, comma-separated)
   - VAR_GVL_import.csv: 2,039 vars (M/D/T/K only)
   - VAR_ALL_import.csv: 2,381 vars (I/O + M/D/T/K)
10. Global variables successfully imported into XG5000

## XG5000 Project Status
- I/O parameters: slots 1-8 (input/output) configured
- Slots 9-10 (XBF-PD02A, XBF-AD04A): removed for now (modules not physically present)
- Global/direct variables: imported via CSV
- Programs: NewProgram1 exists, ST_01_MAIN.st to be pasted next
- Remaining: 17 ST programs need to be registered one by one

## Key XG5000 Findings
- "파일로부터 항목 읽기" requires right-clicking on correct node
- Export format: comma-separated CSV, EUC-KR encoding
- Header: 변수 종류,변수,타입,메모리 할당,초기값,리테인,사용 유무,EIP,OPC UA,HMI,모션,설명문
- Task must exist before program can be added
- PLC write works with empty program (`;` only)

## File Locations
- ST code: `PLC RAW/ST_XEC/` (all renamed to _M/_D/_T/_K)
- CSV import: `PLC RAW/VAR_GVL_import.csv`, `PLC RAW/VAR_ALL_import.csv`
- Original VAR: `PLC RAW/VAR.txt` (I/O only, original format)
- Scripts: `PLC RAW/convert_gvl_to_csv.py`, `PLC RAW/fix_varnames.py`, `rename_vars.py`

## Next Steps
- Paste ST_01_MAIN.st into NewProgram1 and build (F7)
- Fix compile errors if any
- Add remaining 16 ST programs
- Re-add slots 9/10 when hardware is available
- HMI communication setup
