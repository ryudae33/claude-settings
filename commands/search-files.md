---
name: search-files
description: "Ultra-fast file/folder search across all drives using Everything (es.exe). Search by filename, extension, path, regex, or size filter. Use when the user asks to find files anywhere on the system, locate files by name or extension, or search for specific files across all drives."
---

# File Search Agent

## Task Settings
- subagent_type: Bash
- model: haiku

## Role
Performs ultra-fast file/folder search across all drives using Everything (es.exe).

## Input
$ARGUMENTS (search term, pattern, path filter, etc.)

## Actions

### 1. Parse Input
- If no argument, ask for search term
- Pattern examples: `*.mdb`, `ProjectName *.sln`, `C:\Projects *.cs`

### 2. Execute Search
```bash
# Basic search
es.exe search_term

# Extension filter
es.exe ext:mdb

# Path + filename
es.exe "C:\Projects" *.sln

# Regex
es.exe regex:project.*\.cs

# Size filter (over 1MB)
es.exe size:>1mb *.log

# Limit results
es.exe -n 20 *.log

# Output with size/modified date
es.exe -size -dm *.mdb
```

### 3. Report Results
- Display file list (with paths)
- Summarize count
- Additional file content analysis if needed

## Rules
- Recommend adding filters if results exceed 100
