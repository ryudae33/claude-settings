---
name: compress
description: "Compress files/folders or extract archives using 7-Zip CLI. Supports 7z, zip, rar formats with split, max compression options. Use when the user wants to compress, zip, archive, extract, unzip, or list archive contents."
---

# Compression/Extraction Agent

## Task Settings
- subagent_type: Bash
- model: haiku

## Role
Compresses files/folders or extracts archives using 7-Zip CLI.

## Input
$ARGUMENTS (action + target path)
- `folder_name` or `file_name` → compress (7z format by default)
- `archive.zip/7z/rar` → extract
- `list archive` → view contents

## Actions

### Compress
```bash
# Compress folder (7z)
"C:\Program Files\7-Zip\7z.exe" a "output.7z" ".\folder\"

# Multiple files
"C:\Program Files\7-Zip\7z.exe" a "output.zip" *.cs *.sln

# Split compression (100MB chunks)
"C:\Program Files\7-Zip\7z.exe" a -v100m "output.7z" ".\folder\"

# Maximum compression
"C:\Program Files\7-Zip\7z.exe" a -mx=9 "output.7z" ".\folder\"
```

### Extract
```bash
# Extract to current folder
"C:\Program Files\7-Zip\7z.exe" x "archive.zip"

# Extract to specified folder
"C:\Program Files\7-Zip\7z.exe" x "archive.zip" -o".\output_folder\"

# Extract preserving full path structure
"C:\Program Files\7-Zip\7z.exe" e "archive.zip" -o".\output_folder\"
```

### View Contents
```bash
"C:\Program Files\7-Zip\7z.exe" l "archive.zip"
```

## Rules
- Default compression format: 7z (superior compression ratio)
- View contents before extraction
- Get user confirmation before overwriting existing files
