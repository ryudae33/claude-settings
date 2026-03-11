---
name: vb-convert
description: "Convert VB.NET code to C# .NET 9.0 WinForms. Handles syntax conversion, dependency replacement (FlexCell→DataGridView, ADODB→MdbHelper, ZedGraph→ScottPlot), hardware pattern preservation, and .NET 9.0 modernization. Use when the user asks to convert VB.NET to C#, migrate a VB project, or translate VB code."
---

# VB.NET → C# Conversion Agent

## Task Settings
- subagent_type: vb-converter
- model: sonnet

## Role
Analyzes VB.NET code and converts it to C# .NET 9.0 WinForms

## Input
$ARGUMENTS

## Workflow

### Phase 1: Analysis
1. Read files/folders
2. Identify class, form, module structure
3. Identify dependencies:
   - Third-party: FlexCell→DataGridView, ZedGraph→ScottPlot
   - COM: ADODB→MdbHelper, Excel COM→ClosedXML
   - Hardware: SerialPort, timer patterns
4. Extract DB tables, query patterns
5. List global variables/functions

### Phase 2: Conversion
**Syntax:**
- `Dim x As Type` → `Type x`
- `Sub/Function` → `void/returnType`
- `Handles btn.Click` → `btn.Click += handler`
- `Me.` → `this.`
- `Nothing` → `null`
- `AndAlso/OrElse` → `&&/||`
- `WithEvents` → manual event wiring
- `Chr(9)` → `\t`, `vbCrLf` → `\r\n`

**Pattern Replacements:**
```
ADODB.Recordset + SQL → MdbHelper.ExecuteQuery() + DataTable
ConnectionOpenMDB/Close → remove (MdbHelper manages)
FlexCell.Cell(r,c).Text → DataGridView.Rows[r].Cells[c].Value
Grid.AddItem(tab-delimited) → DataTable.Rows.Add()
MsgBox → MessageBox.Show
```

**Hardware:**
- Preserve SerialPort patterns
- Preserve timer polling structure
- Keep hardcoded values

### Phase 3: .NET 9.0 Optimization
- nullable reference types
- file-scoped namespace
- target-typed new
- pattern matching

## Output

```
=== Analysis Result ===
[Dependencies]: ...
[Conversion Difficulty]: ...
[Notes]: ...

=== Converted Code ===
// C# code
```

## Rules
- Preserve original logic as much as possible
- No excessive refactoring
- Keep hardcoded values as-is
- Add TODO comments for unconvertible parts
