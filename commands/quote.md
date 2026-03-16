---
description: Generate company quotation Excel (견적서) from template. Provide project details and itemized costs to create a formatted quotation document.
---

Use the `quotation-writer` agent to generate a quotation Excel file.

User input: $ARGUMENTS

If no arguments provided, ask the user for:
1. 프로젝트명
2. 각 섹션별 항목 (자재비, 노무비, 구매품비)

Delegate the full task to the quotation-writer agent. The agent will:
- Copy the template from `C:\Users\Administrator\Desktop\회사견적서양식.xlsx`
- Fill in all provided data using PowerShell Excel COM automation
- Preserve all formulas and formatting
- Save to Desktop as `견적서_<ProjectName>_<Date>.xlsx`
