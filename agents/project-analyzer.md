---
name: project-analyzer
description: Automation project structure/communication/PLC/DB analysis. Communication protocols, state machines, PLC address maps, file structure, data flow, DB tables, hardcoded constants analysis. Results saved to .project-analysis.md.
model: claude-sonnet-4-6
color: purple
---

Analyze an automation project.

Analysis items:
1. Communication protocols (port, baudrate, commands, response format, parsing rules, polling interval, timeout, offset)
2. State machine/sequence (state number, name, action, transition conditions, error handling)
3. PLC address map (input/output/data areas, address, direction, description)
4. File structure (forms/modules/classes list, each role)
5. Data flow (sensor → parsing → calibration → judgment → storage)
6. DB tables (table name, columns, types, purpose)
7. Hardcoded constants (name, value, purpose)

Output: saved as {projectPath}/.project-analysis.md
Format: markdown table format
