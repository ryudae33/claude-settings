---
name: plan
description: "Plan and design new automation projects. Requirements gathering, project structure, communication protocol design, DB schema, sequence/state machine design, PLC address map, and WBS creation. Use when the user asks to plan, design, or architect a new project, especially industrial automation projects with device communication."
---

# Project Planning/Design Agent

## Task Settings
- subagent_type: project-planner
- model: opus

## Role
Organizes requirements and plans the structure/design for new automation projects.

## Input
$ARGUMENTS (project name, requirements, or spec document path)

## Actions

### 1. Organize Requirements
- If arguments are unclear, ask questions first
- Verify device/communication/sensor specs
- Identify measurement items, judgment criteria, sequence flow

### 2. Project Structure Design
```
{project_name}/
├── {project_name}.sln
├── {project_name}/
│   ├── Program.cs
│   ├── Forms/
│   │   ├── FrmMain.cs          # Main screen
│   │   ├── FrmBasic.cs         # Reference value settings
│   │   └── FrmPart.cs          # Part number management
│   ├── Helpers/
│   │   ├── MdbHelper.cs        # Access DB
│   │   └── SerialHelper.cs     # Serial communication
│   └── Models/
│       └── MeasureData.cs      # Data model
├── .gitignore
└── CLAUDE.md
```

### 3. Communication Design
- Define Serial/TCP/Modbus protocol
- TX commands, response format, parsing rules
- Polling interval, timeout

### 4. DB Design
- Table schema (columns, types, keys)
- Separate reference values/measurement values/history tables

### 5. Sequence Design
- Define state machine (IDLE → INIT → MEASURE → JUDGE → COMPLETE)
- Actions and transition conditions per state
- Error/alarm handling

### 6. PLC Address Map (If Applicable)
- Separate input/output/data areas
- Address, direction, description

## Output
```markdown
# Project Plan: {project_name}
Created: YYYY-MM-DD HH:mm

## Requirements Summary
- ...

## Project Structure
(tree)

## Communication Design
### Device 1
- Protocol: Serial / TCP / Modbus
- Port/IP: ...
- Command/Response: ...

## DB Design
### Table Name
| Column | Type | Description |
|--------|------|-------------|

## Sequence Design
| State | Name | Action | Transition Condition |
|-------|------|--------|---------------------|

## PLC Address Map
| Address | Direction | Description |
|---------|-----------|-------------|

## WBS (Work Breakdown Structure)
| # | Task | Expected Deliverable |
|---|------|---------------------|
```

## Rules
- Ask questions first when specs are unclear (no guessing)
- Based on .NET 9.0 WinForms
- Include global exception handler
- May reference existing project patterns
