---
name: analyze-project
description: "Analyze existing .NET automation project architecture: communication protocols, state machines, PLC address maps, file structure, data flow, DB schemas, hardcoded constants. Use when user asks to analyze, understand, or reverse-engineer a project — especially industrial automation with serial/TCP/Modbus. Also triggers on '프로젝트 분석', 'analyze project', 'what does this project do'."
---

# Automated Project Analysis Agent

## Task Settings
- subagent_type: project-analyzer
- model: sonnet

## Role
Analyzes the entire automation project and saves the results to the project folder.

## Input
$ARGUMENTS (project path)

## Analysis Items

### 1. Communication Protocol
```
[Device Name]
- Port: COM?, Baud rate
- TX commands: "MS\r\n", "P\r\n", etc.
- Response format: CSV, fixed-length, delimiter
- Parsing rules: Split(n) → meaning
- Polling interval: n ms
- Timeout: n ms
- Offset/calibration: LASER_TOL, etc.
```

### 2. State Machine / Sequence
```
[Main Sequence]
State 0: IDLE - Waiting
  → Condition: Start signal ON
State 1: INIT - Initialization
  → Condition: Initialization complete
State 2: MEASURE_FWD - Forward measurement
  → Condition: Measurement value received
State 3: MEASURE_BWD - Backward measurement
  ...
State N: COMPLETE - Complete
  → Return to IDLE

[Error Handling]
ALARM trigger conditions: ...
RESET conditions: ...
```

### 3. PLC Address Map
```
[Input - Read]
D100: Start signal
D101: Reset signal
M100: Door sensor

[Output - Write]
D200: Measurement complete
D201: OK/NG result
M200: Alarm output

[Data]
D300~D310: Measurement value storage
```

### 4. File Structure
```
[Forms]
- FrmMain.vb: Main screen, measurement sequence
- FrmBasic.vb: Reference value settings
- FrmPart.vb: Part number management

[Modules]
- Module1.vb: Global variables, DB connection

[Classes]
- None or list
```

### 5. Data Flow
```
Sensor → Serial receive → Parse → Apply calibration → Judgment → Display/Save
         ↓
      LaserDataManager (cache)
         ↓
      FrmAngle (interpolation table → angle conversion)
```

### 6. DB Tables
```
[Table_Basic]
- Type: Part number type
- Angle Min/Max, DIFF Min/Max, Lever settings...

[Table_Part]
- PartNo, PartName, WorkID...

[Table_Angle_LH_FWD]
- LaserDistance, ConvertAngle (interpolation table)
```

### 7. Hardcoded Values
```
LASER_TOL_1 = 300 (Laser1/BWD)
LASER_TOL_2 = 900 (Laser2/FWD)
LASER_TOL_3 = 900 (Laser3/3RD)
Polling interval = 50ms (original 200ms)
```

## Output
Save analysis results to the project folder:
```
{project_path}/.project-analysis.md
```

## Output Format

```markdown
# Project Analysis: {project_name}
Analysis date: YYYY-MM-DD HH:mm

## Communication Protocol
### Laser1 (BWD/Backward)
- Port: Loaded from COM settings
- Baud rate: 9600
- Command: MS\r\n
- Response: 7-value CSV
- Parsing: Split(6)→[2], Split(4)→[1], Split(2)→[0]
- Calibration: LASER_TOL=300 - value + BwdTol

### Laser2 (FWD/Forward)
...

## State Machine
### Main Sequence
| State | Name | Action | Transition Condition |
|-------|------|--------|---------------------|
| 0 | IDLE | Wait | Start signal |
| 1 | MEASURE | Measure | Complete |
...

## PLC Address Map
| Address | Direction | Description |
|---------|-----------|-------------|
| D100 | R | Start signal |
...

## DB Schema
### Table_Basic
| Column | Type | Description |
|--------|------|-------------|
...

## File Structure
| File | Role | Conversion Status |
|------|------|-------------------|
| FrmMain | Main screen | Complete |
| FrmPart | Part management | Incomplete |
...

## Hardcoded Constants
| Name | Value | Purpose |
|------|-------|---------|
| LASER_TOL_1 | 300 | BWD reference distance |
...
```

## Rules
- Scan all source code before saving
- Reference this file first for subsequent work
- Update when changes occur
