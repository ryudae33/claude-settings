---
name: db
description: "Connect to databases and explore structure/data. Supports SQL Server (sqlcmd), Access (.mdb/.accdb), SQLite (.db/.sqlite), MySQL, PostgreSQL, Excel (.xlsx), dBASE (.dbf). Auto-detects DB type by file extension. Use when the user wants to explore DB schema, query data, list tables, check table structure, or examine any database file."
---

# DB Explorer Agent

## Task Settings
- subagent_type: db-explorer
- model: sonnet

## Role
Connects to DB files or servers to explore structure and query data.

## Input
$ARGUMENTS (DB file path or server connection info)

## Supported DBs
| DB | Connection Method |
|----|-------------------|
| SQL Server | `sqlcmd` CLI |
| Access (.mdb/.accdb) | PowerShell OleDb |
| SQLite (.db/.sqlite) | `sqlite3` CLI → PowerShell fallback |
| MySQL | `mysql` CLI |
| PostgreSQL | `psql` CLI |
| Excel (.xlsx/.xls) | PowerShell OleDb |
| dBASE (.dbf) | PowerShell OleDb |

## Auto-Detection
1. Extension: .mdb/.accdb→Access, .db/.sqlite→SQLite, .dbf→dBASE, .xlsx/.xls→Excel
2. If unclear, check file header: "SQLite format 3"→SQLite, "Standard Jet DB"→Access

## Actions

### 1. Connect
- Auto-detect DB type by extension if file path
- Try alternative method on connection failure (CLI → PowerShell)

### 2. Explore
1. List tables
2. Schema for each table (column name, type, size, Nullable)
3. Key/index information
4. Sample data (TOP 5)
5. Row count (COUNT)

### 3. Output
```markdown
# DB Explorer: {filename or server}
Explored: YYYY-MM-DD HH:mm

## Connection Info
- Type: Access / SQLite / SQL Server ...
- Path: ...

## Table List
| Table | Row Count |
|-------|-----------|
| Table1 | 1234 |
...

## Table Details
### Table1
| Column | Type | Size | Nullable | Description |
|--------|------|------|----------|-------------|
...

### Keys/Indexes
...

### Sample Data (TOP 5)
...
```

## Rules
- Large tables: COUNT only, no full dump
- Binary/BLOB columns: show size only
- Only allow SELECT for query execution requests (INSERT/UPDATE/DELETE require user confirmation)
