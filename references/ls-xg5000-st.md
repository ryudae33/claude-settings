# LS Electric XG5000 ST (Structured Text) Reference

Authoritative reference for XG5000 ST programming. Based on XGI/XGR/XEC/XMC Instruction Manual V4.0 Ch.14 + real compilation experience (2026-03-16~17).

## 1. Code Structure Rules

- **NO `PROGRAM...END_PROGRAM`** in ST code — program defined in XG5000 project tree
- **NO `VAR...END_VAR`** in ST code — variables registered in XG5000 variable window
- ST code = pure logic only (assignments, IF, CASE, FOR, FB calls, comments)
- Comments: `(* block *)` or `// line`

## 2. CRITICAL: VAR_EXTERNAL Required

**ST programs MUST declare global variables as `VAR_EXTERNAL` in local variable window.**

Ladder programs can access globals directly, but ST CANNOT.
Without VAR_EXTERNAL → **E0153 error** on every global variable reference.

```
// In each program's local variable CSV:
VAR_EXTERNAL,g_SafetyStop,BOOL,,,,TRUE,,,,,,
VAR_EXTERNAL,g_FB_Org,APM_ORG,,,,TRUE,,,,,,
```

Every ST program CSV must include `VAR_EXTERNAL,<varname>,<type>` for each global variable used in that program.

## 3. RETURN Not Supported in PROGRAM

`RETURN` is only valid in FUNCTION/FUNCTION_BLOCK, NOT in PROGRAM blocks.
Using RETURN in PROGRAM → compile error.

**Use IF-ELSE structure instead:**
```st
// WRONG:
IF g_SafetyStop THEN
    (* emergency *)
    RETURN;
END_IF;
(* normal logic *)

// CORRECT:
IF g_SafetyStop THEN
    (* emergency *)
ELSE
    (* normal logic *)
END_IF;
```

## 4. Data Type Gotchas

### WORD is a Bit Type (ANY_BIT)
WORD/BYTE/DWORD/LWORD are **bit types**, NOT integer types.
Cannot use arithmetic operators (+, -, *, /) on WORD.

```st
// WRONG: g_ScanCount is WORD
g_ScanCount := g_ScanCount + 1;  // E0191 error

// CORRECT: use INT/UINT for arithmetic
g_ScanCount : INT;
g_ScanCount := g_ScanCount + 1;  // OK
```

### UINT OR Operation
UINT is integer type — cannot use bitwise OR directly.
Must convert to WORD first:

```st
// WRONG:
%MW414 := UINT_TO_WORD(wOrgStat OR wDstStat);  // OR on UINT = error

// CORRECT:
%MW414 := UINT_TO_WORD(wOrgStat) OR UINT_TO_WORD(wDstStat);  // convert then OR
```

### No Implicit Type Conversion
Must use explicit conversion functions:
`WORD_TO_DINT()`, `DINT_TO_UDINT()`, `UINT_TO_WORD()`, `DINT_TO_LREAL()`, etc.

### Integer Types
| Type | Size | Range |
|------|------|-------|
| SINT | 8-bit | -128~127 |
| INT | 16-bit | -32768~32767 |
| DINT | 32-bit | -2^31~2^31-1 |
| USINT | 8-bit | 0~255 |
| UINT | 16-bit | 0~65535 |
| UDINT | 32-bit | 0~2^32-1 |

### Bit Types (ANY_BIT — no arithmetic!)
| Type | Size |
|------|------|
| BOOL | 1-bit |
| BYTE | 8-bit |
| WORD | 16-bit |
| DWORD | 32-bit |
| LWORD | 64-bit |

## 5. Function Block Rules

### W0318: Duplicate FB Instance
Same FB instance must NOT be called from two places in one program.

```st
// WRONG: g_FB_Stp called in both SafetyStop block and normal stop block
IF g_SafetyStop THEN
    g_FB_Stp(REQ := TRUE, ...);  // call 1
ELSE
    g_FB_Stp(REQ := bStpReq, ...);  // call 2 — W0318!
END_IF;

// CORRECT: create separate instances
// g_FB_StpEmo for emergency, g_FB_Stp for normal
IF g_SafetyStop THEN
    g_FB_StpEmo(REQ := TRUE, ...);
ELSE
    g_FB_Stp(REQ := bStpReq, ...);
END_IF;
```

### FB Declaration
FB must be declared as instance variable in variable window (not in code).
Access FB output: `result := INST.Q;`

### FB Call Syntax
```st
// Formal (named params):
INST(IN := value, PT := T#1s, Q => output, ET => elapsed);

// Informal (positional):
INST(value, T#1s, output, elapsed);
```

## 6. APM (Positioning Module) FB Reference — FROM MANUAL

**These are XEC positioning FB, NOT PLCopen MC_xxx.**

### Common Parameters (ALL APM FBs)
| Param | Direction | Type | Description |
|-------|-----------|------|-------------|
| REQ | Input | BOOL | Rising edge trigger |
| BASE | Input | USINT | Base number (0) |
| SLOT | Input | USINT | Slot number |
| AXIS | Input | USINT | Axis number (0) |
| DONE | Output (=>) | BOOL | Completion flag |
| STAT | Output (=>) | UINT | Status/error code (0=OK) |

### APM_ORG (Origin/Home)
No additional params beyond common.
```st
g_FB_Org(REQ := bOrgReq, BASE := 0, SLOT := 9, AXIS := 0,
         DONE => bOrgDone, STAT => wOrgStat);
```

### APM_DST (Position Move)
| Param | Type | Description |
|-------|------|-------------|
| ADDR | DINT | Target position |
| SPEED | UDINT | Move speed |
| DWELL | UINT | Dwell time |
| MCODE | UINT | M-code |
| POS_SPD | BOOL | Position/speed mode |
| ABS_INC | BOOL | FALSE=absolute, TRUE=relative |
| TIME_SEL | USINT | Time selection |

```st
g_FB_Dst(REQ := bDstReq, BASE := 0, SLOT := 9, AXIS := 0,
         ADDR := dinTargetPos, SPEED := DINT_TO_UDINT(dinTargetVel),
         DWELL := 0, MCODE := 0,
         POS_SPD := FALSE, ABS_INC := bMoveRel,
         TIME_SEL := 0,
         DONE => bDstDone, STAT => wDstStat);
```

### APM_STP (Stop)
| Param | Type | Description |
|-------|------|-------------|
| DEC_TIME | UINT | Deceleration time |

```st
g_FB_Stp(REQ := bStpReq, BASE := 0, SLOT := 9, AXIS := 0,
         DEC_TIME := 0, DONE => bStpDone, STAT => wStpStat);
```

### APM_RST (Fault Reset)
| Param | Type | Description |
|-------|------|-------------|
| INH_OFF | BOOL | Inhibit off |

```st
g_FB_Rst(REQ := bRstReq, BASE := 0, SLOT := 9, AXIS := 0,
         INH_OFF := FALSE, DONE => bRstDone, STAT => wRstStat);
```

### NON-EXISTENT FBs (DO NOT USE)
- **APM_FLT** — does NOT exist. Use APM_RST for fault reset.
- **APM_EMG** — does NOT exist in standard library.
- **APM_PRS** — does NOT exist in standard library.

## 7. Direct Variable Addressing

### M Area (Internal Memory)
| Format | Example | Description |
|--------|---------|-------------|
| %MWn | %MW100 | Word (16-bit) |
| %MWn.b | %MW100.3 | Word bit access (PREFERRED) |
| %MXn | %MX1600 | Bit (absolute: 100×16=1600) |
| %MDn | %MD50 | Double word (32-bit) |

**Use `%MW n.bit` notation** for readability, not absolute %MX.

### I/O Variables
| Format | Example | Description |
|--------|---------|-------------|
| %IX b.s.n | %IX0.0.11 | Input: base.slot.bit |
| %QX b.s.n | %QX0.0.5 | Output: base.slot.bit |

Auto-generated names: `_00_IN00`, `_05_OUT12` — no declaration needed.

### U Area (Special Module Register)
| Format | Example | Description |
|--------|---------|-------------|
| %UW b.s.n | %UW0.9.0 | Special module word (positioning status) |
| %UW0.9.1 | | JOG control register |
| %UW0.9.2~5 | | Position/velocity readback |

## 8. Control Statements

```st
IF cond THEN ... ELSIF cond THEN ... ELSE ... END_IF;
CASE expr OF ... END_CASE;       // expr must be INT type only
FOR i := 1 TO 10 BY 1 DO ... END_FOR;  // counter: SINT/INT/DINT only
WHILE cond DO ... END_WHILE;
REPEAT ... UNTIL cond END_REPEAT;
EXIT;    // breaks innermost loop only
```

### NOT Supported in ST
- BREAK, CALL, END, JMP, NEXT, RET, SBRT
- ARRAY OF STRING
- Recursive function calls
- Operators as function names (OR, XOR, AND, MOD, NOT)

## 9. XG5000 Variable CSV Rules

### Encoding: EUC-KR (CP949) — NOT UTF-8
XG5000 cannot read UTF-8 CSV files. Claude's Write tool outputs UTF-8 → rejected.

### Line Endings: CRLF (0D 0A)
LF only (0A) will cause import failure.

### Correct Method: PowerShell Script
```powershell
# Copy existing working CSV as template, overwrite data via .ps1 script
# Read original file bytes to preserve EUC-KR header
# Append ASCII data rows with explicit 0x0D 0x0A
# Write via [System.IO.File]::WriteAllBytes()
# MUST run as .ps1 file (not inline -Command) — bash pipe corrupts encoding
```

### Header (12 columns — CRITICAL)
```
변수 종류,변수,타입,메모리 할당,초기값,리테인,사용 유무,EIP,OPC UA,HMI,모션,설명문
```
XG5000 exports 12 columns (includes `모션` before `설명문`). **11-column CSV will fail.**

### Variable Types in CSV
| Value | Meaning |
|-------|---------|
| VAR | Program-local variable |
| VAR_GLOBAL | Global variable |
| VAR_EXTERNAL | Reference to global (required in ST programs) |

### Notes
- FB types (R_TRIG, TON, APM_ORG, etc.) are allowed in CSV
- Initial values: leave empty (not "0" or "FALSE")
- 설명문 (description): leave empty

## 10. Identifier Rules

- Case-insensitive (internally all UPPERCASE)
- Korean characters allowed
- Must start with letter or underscore
- No spaces
- **Reserved prefixes**: M, D, T, K are direct address prefixes — prefix variable names with underscore (_M, _D, _T, _K)

## 11. Edge Detection (No R_TRIG in ST)

R_TRIG FB works in ST but manual edge detection is simpler:

```st
// Manual rising edge detection
bEdgeHome := bCmdHome AND NOT bPrevHome;
bPrevHome := bCmdHome;

// Use bEdgeHome to trigger one-shot actions
IF bEdgeHome THEN
    bOrgReq := TRUE;
END_IF;
```

## 12. Common Compile Errors

| Error | Cause | Fix |
|-------|-------|-----|
| E0153 | Undefined variable | Add VAR_EXTERNAL for globals, or declare in local var window |
| E0184 | Type mismatch | Use explicit conversion (WORD_TO_DINT, etc.) |
| E0191 | Invalid operation on type | WORD arithmetic → change to INT/UINT |
| W0318 | Duplicate FB instance | Create separate FB instances |
| W0305 | Type mismatch in expression | UINT OR → UINT_TO_WORD() first |
