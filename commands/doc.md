---
name: doc
description: "Read and analyze document files including PDF, Excel (.xlsx/.xls), Word (.docx), CSV, text, images. Auto-detects format and uses appropriate reading method. Use when the user asks to read, summarize, analyze, or extract content from any document file."
---

# Document Reader (Direct — no subagent)

Read the file at `$ARGUMENTS` directly using the tools below. Do NOT spawn a subagent.

## Reading Method by Extension

### PDF (.pdf)
- Use `Read` tool with `pages` parameter
- 10 pages or less → read all at once
- Over 10 pages → split into chunks of 15 pages max

### Excel (.xlsx / .xls)
```powershell
# List sheets
$conn = New-Object System.Data.OleDb.OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source='FILE';Extended Properties='Excel 12.0 Xml;HDR=YES;IMEX=1'")
$conn.Open(); $conn.GetSchema("Tables") | Select TABLE_NAME; $conn.Close()
# Read sheet data
$cmd = $conn.CreateCommand(); $cmd.CommandText = "SELECT TOP 100 * FROM [Sheet1$]"
$reader = $cmd.ExecuteReader(); # ... process rows
```

### Word (.docx)
```powershell
Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead("FILE")
$entry = $zip.Entries | Where { $_.FullName -eq "word/document.xml" }
$sr = New-Object IO.StreamReader($entry.Open())
$xml = [xml]$sr.ReadToEnd(); $sr.Close(); $zip.Dispose()
$xml.GetElementsByTagName("w:t") | ForEach { $_.InnerText }
```

### CSV
- Use `Read` tool directly
- Large files (>500 lines): `powershell Import-Csv 'FILE' -Encoding UTF8 | Select -First 100`

### Text / Log / Markdown
- Use `Read` tool directly

### Image (.png / .jpg / .bmp)
- Use `Read` tool (multimodal visual analysis)

## Rules
- Split reading for large files — never load entire large file at once
- For Excel, list sheets first, then read data per sheet
- Binary DB files (.mdb, .accdb) → tell user to use `/db` instead
- Use `-Encoding UTF8` for Korean content in PowerShell
- Always report: file path, size, format, then content summary
