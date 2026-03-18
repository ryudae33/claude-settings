---
name: ST40 SP3 MECA IO/ToolPos feature addition
description: ST40 project (SP3 MECA LH RH) - added Serial Module IO, LED display, FrmToolPos, INI IO conditions from S50 (KY FRT CUSH)
type: project
---

## ST40 SP3 MECA Feature Addition (2026-03-16)

**Path:** `C:\Users\Administrator\Desktop\DSC_INDIA_1\SP3 MECA LH RH\SP2i MECA_SP3 추가\ST40\`
**Project:** ST50.vbproj (RootNamespace: S50, AssemblyName: SP3_LINE1_OP50)
**Framework:** .NET Framework 4.8, VB.NET WinForms

### Work Done (2026-03-16 11:34)
Ported features from S50 (KY FRT CUSH) project to ST40:

1. **Serial_Module IO** — 115200bps, ThreadTask4_Module for D_Value read (S...E protocol)
2. **LED display** — P_IN0~15 + P_OUT0~7 PictureBoxes created programmatically in Control_2_Arry()
3. **FrmToolPos** — Image + coordinate editor, 8 spec combinations (HGT/NHGT × LH/RH × KY/QY), INI save/load
4. **INI IO conditions** — LoadIOConditionsFromINI(), CheckIOCondition(), toolstep logic in wStep=5/6
5. **pos1~5 labels** — IO condition display in Panel5 (dynamic creation)
6. **FrmPort Module port** — ComboBox5 for Module serial port
7. **DB auto-migration** — ALTER TABLE Table_SerialPort ADD Module (on startup)
8. **LED resources** — 32 PNG files copied, Resources.resx + Designer.vb updated

**Why:** DSC India factory line standardization — same IO module/tool position features across stations
**How to apply:** Same pattern can be applied to other stations (S10, S20, S30, etc.) in KY FRT CUSH or SP3 MECA solutions
