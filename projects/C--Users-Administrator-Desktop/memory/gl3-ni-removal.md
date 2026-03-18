---
name: GL3 NI COM Control Removal
description: AxCWButton → Label conversion across 6 GL3 subprojects (2026-03-16)
type: project
---

GL3 all subprojects: NI COM AxCWButton controls removed, replaced with System.Windows.Forms.Label.

**Why:** NI CWUIControlsLib COM dependency prevents build on machines without NI runtime installed.

**How to apply:** Same conversion pattern can be applied to any remaining VB.NET projects using AxCWButton.

## Work Done (2026-03-16 13:20)

### Conversion Rules
- Designer.vb: `New AxCWUIControlsLib.AxCWButton()` → `New System.Windows.Forms.Label()`
- Designer.vb: `.OcxState` → `.BackColor=Black, .ForeColor=White, .TextAlign=MiddleCenter`
- Designer.vb: Remove `ISupportInitialize.BeginInit/EndInit` for AxCWButton controls
- Code.vb: `.OffText` → `.Text`, `.OffColor` → `.BackColor`
- Code.vb: `.Value = True` → `.BackColor = Color.Lime`, `.Value = False` → `.BackColor = Color.Black`
- Code.vb: `ValueChanged` event → `Click` event
- vbproj: Remove COMReference blocks (AxCWUIControlsLib, CWUIControlsLib, stdole)

### Build Results

| # | Project | Path | Result |
|---|---------|------|--------|
| 1 | 1차 MNL | `GL3\1차 MNL\OP 10 MNL.vbproj` | ✅ `GL3 MNL 1.exe` |
| 2 | 2차 PWR | `GL3\2차 PWR\OP 20.vbproj` | ✅ `GL3 OP 20(20230810).exe` |
| 3 | 품번선택1 | `GL3\품번선택1\CHOICE.vbproj` | ✅ `GL3 ASSEMBLE.exe` |
| 4 | 5차 | `GL3\5차\END PWR.vbproj` | ✅ `GL3 END(20221124).exe` (4 warnings) |
| 5 | 5차(B) | `GL3\5차(B)\END PWR(B).vbproj` | ✅ `GL3 END(20241223)(B).exe` (4 warnings) |
| 6 | NOISE TEST | `GL3\NOISE TEST\NOISE TEST.vbproj` | ❌ Pre-existing Automation.BDaq resx error (not conversion-related) |

### Notes
- 1차 (`GL3\1차\`) was already converted in a prior session
- NOISE TEST: AxCWButton conversion done, DAQmx/WaveformGraph preserved. Build fails due to missing Advantech BDaq DLL on this PC (pre-existing issue)
- 5차/5차(B): Designer files were accidentally overwritten from 1차 during encoding fix — missing controls (Panel_S1~S3, Tmr_Feeder, ToolStripStatusLabel, etc.) were added back as declarations. UI layout may differ from original — verify visually
- Warnings in 5차/5차(B): unused local variables (SAB_TMP, BArcode_STring, i, tmp) — pre-existing
