---
name: XG5000 ST programming critical rules
description: XG5000 ST language gotchas — VAR_EXTERNAL, RETURN restriction, WORD arithmetic, APM FB params
type: feedback
---

XG5000 ST programs require VAR_EXTERNAL to access global variables. Ladder doesn't need this but ST does.

**Why:** Without VAR_EXTERNAL, compiler throws E0153 on every global variable reference. Discovered during 1CELL Assemble Machine project — all g_xxx globals failed until VAR_EXTERNAL was added to each program's local variable CSV.

**How to apply:**
- Every ST program CSV must include `VAR_EXTERNAL,<varname>,<type>` for each global variable used
- RETURN is NOT supported in PROGRAM blocks — use IF-ELSE instead
- WORD is a bit type — cannot use arithmetic (+, -). Use INT/UINT for arithmetic
- Same FB instance must not be called from two places in one program (W0318) — create separate instances
- APM FB params (from manual): REQ, BASE, SLOT, AXIS, DONE=>, STAT=> — NOT ACTIVE/Q/ERR
- APM_STP needs DEC_TIME, APM_RST needs INH_OFF parameter
- APM_FLT does not exist — use APM_RST for fault reset
- ST_PROGRAMMING_RULES.md section 7 had wrong param names (ACTIVE/Q/BSY/ERR) — corrected to match manual
