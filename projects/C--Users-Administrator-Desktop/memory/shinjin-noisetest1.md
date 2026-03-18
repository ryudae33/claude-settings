# NoiseTest1 (Shinjin) Detailed Work Log

## Completed Work (2026-03-06)

### Phase 1: Project Reference Cleanup
- Removed FlexCell, NI UI (Common kept, UI, UI.WindowsForms, DAQmx.ComponentModel) References from vbproj
- Removed COMReference: AxCWUIControlsLib, CWUIControlsLib
- Removed Imports: NationalInstruments, NationalInstruments.UI
- Added ZedGraph 5.2.0 NuGet (packages.config + HintPath: `..\packages\ZedGraph.5.2.0\lib\net35-Client\ZedGraph.dll`)
- Kept NI Common reference (needed for DAQmx AnalogWaveform type)
- Cleared licenses.licx, removed OcxState from all .resx files

### Phase 2: ClassZedGraph.vb
- Copied from converttp folder and modified
- Title font: Arial Bold 16pt
- Methods: InitGraph, DrawGraph, ClearGraph, PlotXY, SetXAxisRange, SetYAxisRange

### Phase 3: FrmMain.Designer.vb (~1900 lines)
- AxCWButton → Button/Label/Panel (by purpose)
- ScatterGraph (12) → ZedGraphControl
- Removed ScatterPlot/XAxis/YAxis/XYCursor declarations
- FlexCell GridCount → DataGridView
- Removed OcxState/BeginInit/EndInit
- Label text: extracted from CP949 binary
- All Labels: BorderStyle = FixedSingle

### Phase 4: FrmMain.vb (~2700 lines)
- .OffText → .Text, .OffColor → .ForeColor
- .ClearData() → ClassZedGraph.ClearGraph()
- PlotXYAppend → ClassZedGraph.DrawGraph
- ClickEvent → Click (Handles clause)
- PortOpen: AxCWButton→Panel, .Value→.BackColor
- DecideControl: AxCWButton→Label
- MeasureLabel/MeasureGraph type changes
- GridCount: FlexCell→DataGridView API (→later changed to INI file)
- Added SetupGraphs(): 12 graphs ClassZedGraph.InitGraph calls
- InitGraphs(): ClearGraph only (no curve reset)

### Phase 5: Other Forms
- FrmPart: FlexCell→DataGridView, AxCWButton→Button
- FrmSearch/FrmSearch2: FlexCell→DataGridView, AxCWButton→Button
- FrmPassWord: AxCWButton→Button
- FrmTest: NumericEdit→NumericUpDown, AxCWButton→Button
- FrmSeq: FlexCell→DataGridView
- FrmSet: AxCWButton→Button (designer modified by user)
- FrmSIgnal: AxCWButton→Button

### Phase 6: Feature Additions
- **First Pass Check (CheckFirstPass)**
  - Module1: `_FirstPassEnabled` global variable, Try-Catch for FirstPass field read/write in LoadSetData/SaveSetData
  - FrmSet: `CheckFirstPass.Checked` ↔ `_FirstPassEnabled`
  - FrmMain: at wStep=10, if `_FirstPassEnabled`, skip first inspection (Flow1→wStep=75, Flow2→wStep=100)
  - Note: FrmSet.Designer.vb control name is `CheckFirstPass` (not CheckAmp)

- **OK/NG Result Color Change**
  - Text: always White
  - OK/PASS: BackColor = Blue
  - NG: BackColor = Red
  - Init: BackColor = SystemColors.Control
  - Applied at: DecideControl(), wStep=73 direct judgment (2 places), PASS (2 places), InitGraphs() init

- **GridCount INI File Conversion**
  - Removed DB (Table_Count) access → `Count.ini` text file (part-no TAB count)
  - LoadGrid: read file to DataGridView, empty grid if file missing
  - AddCount: search part-no in grid → +1 or new → SaveCountFile
  - ResetGrid: clear grid + delete file

### Phase 7: Bug Fixes
- GridCount DataGridView: added AllowUserToAddRows=False, ReadOnly=True, RowHeadersVisible=False
- Removed GridCount Enabled=False (caused X display in DataGridView)
- Missing SetupGraphs() — added ClassZedGraph.InitGraph calls (caused red X on graphs)

## Build
- MSBuild path: `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe`
- Build command: `MSBuild.exe "LeakTestMachine_신진1.vbproj" -t:Build -p:Configuration=Debug`
- Current: 0 errors, 6 warnings (unused variables)

## Preserved Items
- NI DAQmx code (DaqStart, DaqEnd, SetVoltage, AnalogInCallback, dataToDataTable)
- Serial comm, IO control, DB logic (except Count)

## Known Issues
- DB.mdb file missing → possible LoadSetData/LoadBarcodeData/SaveDB errors
- FirstPass bit column not added to Table_SET (defended with Try-Catch)
- SetupGraphs Y-axis range temp values (Amp:0-1, Noise:0-100, Flow:0-30) — needs adjustment for actual operation
