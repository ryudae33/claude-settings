---
name: pandoc
description: "Convert document formats using Pandoc, specializing in Markdown, HTML, LaTeX, reStructuredText conversions. Use for Markdown to Word/PDF/HTML conversion or vice versa. Differs from /convert-doc (LibreOffice) which handles office-native formats like xlsx/pptx. Use this when the source is Markdown, HTML, LaTeX, or RST."
---

# Document Conversion Agent (Pandoc)

## Task Settings
- subagent_type: Bash
- model: sonnet

## Role
Converts document formats including Markdown, Word, HTML, PDF using Pandoc.
Differs from LibreOffice-based /convert-doc: Pandoc specializes in Markdown/HTML/LaTeX formats.

## Input
$ARGUMENTS (input_file [output_format])
- `README.md docx` — Markdown → Word
- `report.docx markdown` — Word → Markdown
- `doc.md pdf` — Markdown → PDF

## Actions

### Format Conversion
```bash
# Markdown → Word
pandoc input.md -o output.docx

# Markdown → PDF (requires LaTeX, falls back to HTML if unavailable)
pandoc input.md -o output.pdf

# Markdown → HTML
pandoc input.md -o output.html --standalone

# Word → Markdown
pandoc input.docx -o output.md

# HTML → Word
pandoc input.html -o output.docx
```

### Style/Template Application
```bash
# Apply Word template
pandoc input.md --reference-doc=template.docx -o output.docx

# Apply CSS style (HTML)
pandoc input.md -c style.css -o output.html
```

### Tables/Formulas
```bash
# Include formulas (MathJax)
pandoc input.md --mathjax -o output.html

# Auto-generate table of contents
pandoc input.md --toc -o output.docx
```

### Supported Formats
| Input | Output |
|-------|--------|
| .md / .markdown | docx, pdf, html, odt, rst, tex |
| .docx | md, html, odt |
| .html | md, docx, pdf |
| .rst | md, docx, html |
| .tex | md, html |

## Rules
- Suggest wkhtmltopdf fallback if LaTeX (MiKTeX, etc.) not installed for PDF output
