---
description: "Generate company quotation Excel (견적서) from template. Fills project info, itemized costs (materials, labor, purchased items) with auto-calculated subtotals, admin fees, and profit margins. Use when the user asks to create a quotation, make 견적서, generate a cost estimate, or prepare a project quote document."
---

# Quotation Generator (견적서)

## Task Settings
- subagent_type: quotation-writer
- model: sonnet

## Input
$ARGUMENTS (project name, items, or "help" for format guide)

## Required Information
If not provided, ask the user for:
1. **프로젝트명** — project name
2. **고객 정보** — customer name, contact (optional)
3. **자재비 항목** — material items (name, spec, qty, unit, unit price)
4. **노무비 항목** — labor items (description, man-days, daily rate)
5. **구매품비 항목** — purchased items (name, qty, unit price, vendor)
6. **납기** — delivery period (optional)

## Process
1. Gather all item data from user
2. Delegate to quotation-writer agent
3. Agent copies template → fills data via PowerShell Excel COM → saves result
4. Output: `C:\Users\Administrator\Desktop\견적서_<ProjectName>_<Date>.xlsx`

## Rules
- Template: `C:\Users\Administrator\Desktop\회사견적서양식.xlsx`
- Preserve all formulas (SUM, cross-sheet refs) — never overwrite formula cells
- Admin fee default: 5%, profit margin default: 10%
- Quote number format: FT-SR-YYYY-MMDD-NNNN
