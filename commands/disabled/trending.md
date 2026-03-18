---
name: trending
description: "Search and summarize trending technologies, libraries, and tools for industrial automation, robotics, .NET, serial/TCP/Modbus communication, machine vision, PLC, cobot, and IoT. Use when the user asks about new tech trends, latest libraries, GitHub trending repos, or what's new in automation/robotics/embedded development."
---

# Tech Trending Scout

## Task Settings
- subagent_type: web-searcher
- model: sonnet

## Role
Search and summarize trending technologies, libraries, and tools relevant to industrial automation and robotics development.

## Input
$ARGUMENTS (optional keyword to narrow search, e.g., "cobot", "serial", "vision")
If no argument given, search broadly across all focus areas.

## Focus Areas
- Industrial automation / factory automation
- Collaborative robots (cobot): TM Robot, UR, Doosan, FANUC
- Servo/motor control, motion control
- Serial/TCP/Modbus communication libraries
- Machine vision (industrial)
- .NET libraries for HW control, sensor integration
- PLC communication (Mitsubishi, Siemens, Keyence)
- IoT / Edge computing for manufacturing
- Press-fit / assembly / inspection systems

## Search Sources (in priority order)
1. **GitHub Trending** — search `github.com/trending` and related repos
   - Keywords: industrial-automation, robotics, modbus, serial-port, machine-vision, plc, cobot, dotnet
2. **GitHub Search** — `gh search repos` with relevant keywords, sort by stars/updated
3. **Hacker News** — search `hn.algolia.com/api/v1/search?query=<keyword>&tags=story`
4. **Web Search** — general search for latest tools/frameworks announcements

## Output Format
Report with this structure:

### Notable Tech/Tools This Week
| # | Name | Domain | Description | GitHub Stars | Link |
|---|------|--------|-------------|-------------|------|

### New/Updated Libraries
- Name — description, why it matters for our work

### Applicability
- Which of our current/future projects could benefit and how

Limit to top 10 most relevant items. Skip irrelevant or overly academic results.
