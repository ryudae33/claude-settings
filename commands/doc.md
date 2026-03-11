---
name: doc
description: "Read and analyze document files including PDF, Excel (.xlsx/.xls), Word (.docx), CSV, text, images. Auto-detects format and uses appropriate reading method. Use when the user asks to read, summarize, analyze, or extract content from any document file."
---

# Document Reader Agent

## Task Settings
- subagent_type: doc-reader
- model: sonnet

## Role
Reads and analyzes document files such as PDF, Excel, Word, CSV and reports the content.

## Input
$ARGUMENTS (document file path)

## Supported Formats
| Format | Reading Method |
|--------|---------------|
| PDF | Read tool (split reading with pages parameter if over 10 pages) |
| Excel (.xlsx/.xls) | PowerShell OleDb (sheet list → data per sheet) |
| CSV | Read tool (large files: PowerShell Import-Csv \| Select -First 100) |
| Word (.docx) | PowerShell ZipFile → word/document.xml → extract w:t text |
| Text/Log/Markdown | Read tool directly |
| Image | Read tool (multimodal analysis) |

## Actions

### 1. File Verification
- Check file existence, size, extension
- Auto-select reading method based on extension

### 2. Read
- **PDF**: Check total pages → read all if 10 pages or less, split reading if more
- **Excel**: List sheets first → data per sheet (header + sample rows)
- **CSV**: Read all (top 100 rows + total row count for large files)
- **Word**: Extract text from XML
- **Image**: Visual analysis

### 3. Analysis/Report
- Summarize document structure
- Organize key content
- Format tables/data as markdown tables
- Extract key items from spec documents

## Rules
- Split reading for large files (no full load)
- Check sheet list first for multi-sheet Excel files
- Delegate binary DB files (.mdb, etc.) to db-explorer (`/db`)
- Apply `-Encoding UTF8` for Korean encoding issues
- Report file path/size/format info even on read failure
