---
name: convert-doc
description: "Convert office documents between formats using LibreOffice CLI (headless mode). Supports docx, xlsx, pptx, csv, hwp to PDF and other format conversions. Use when the user wants to convert Word/Excel/PowerPoint/HWP files to PDF or other formats. For Markdown/HTML/LaTeX conversions, use /pandoc instead."
---

# Document Conversion Agent

## Task Settings
- subagent_type: Bash
- model: haiku

## Role
Converts documents to other formats using LibreOffice CLI.

## Input
$ARGUMENTS (file path [output format])
- `file.docx` → PDF conversion (default)
- `file.xlsx pdf` → PDF conversion
- `file.csv xlsx` → Excel conversion

## Actions

### Execute Conversion
```bash
# → PDF conversion (default)
soffice --headless --convert-to pdf "file_path"

# → Excel (.xlsx)
soffice --headless --convert-to xlsx "file_path"

# → CSV
soffice --headless --convert-to csv "file_path"

# Specify output folder
soffice --headless --convert-to pdf --outdir "C:\output\" "file_path"

# Batch convert multiple files
soffice --headless --convert-to pdf *.docx
```

### Supported Formats
| Input | Possible Output |
|-------|----------------|
| .docx/.doc | pdf, odt, txt |
| .xlsx/.xls | pdf, csv, ods |
| .pptx/.ppt | pdf, odp |
| .csv | xlsx, ods |
| .hwp (Korean Hangul) | pdf (LibreOffice Hangul filter required) |

## Rules
- Output file is created in the same folder as input file (unless otherwise specified)
- Report output file path after conversion
