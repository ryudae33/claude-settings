# Assemble 310 - tmrLotorAssembleTimer_Tick Step Structure

## File: _FrmMain.cs (line 266~926)

### Overall Flow
- case 0: Product detect sensor (PlcValueBit[0,6]) → case 1
- case 1: Bolt1 LVDT measurement (ToolStep 0→1→1.1→2), OK → case 2
- case 2: Sensor (PlcValueBit[0,5]) → case 3
- case 3: Bolt2 LVDT measurement (ToolStep 0→1→1.1→2), OK → case 4, MES bolt record
- **case 4**: Product detect (PlcValueBit[0,4]) → init, case 5 (press-fit inspection start)
- case 5: Load cell < 0.1 check → start position3 move, case 5.1
- case 5.1: PlcValueBit[14,2] arrived → position3 OFF, case 5.2
- case 5.2: 0.5s wait → case 5.3
- case 5.3: Start position2 move → case 6
- **case 6**: Time-based graph (LoadCell realtime), load detection, >13 → NG→6.1, after servo arrival 0.5s → case 6.5
- **case 6.5**: Time→13mm scaling, redraw graph, guidelines, judgment (OK/NG), MES record → case 7
- case 6.1: NG manual home return → case 6.2
- case 7: After 0.5s position1 move → case 8
- case 8: Position1 arrived → case 8.1
- case 8.1: If NG wait PlcValueBit[0,0] → case 4 re-inspect, if OK → case 9
- case 9: Product removed (PlcValueBit[0,4]==false), OK → case 10, NG → case 0
- case 10: Count increment, save → case 0

### Master Measurement (case 99~115)
- case 99: Product detect → case 100
- case 100: Position4 move → case 101
- case 101: Position4 arrived → case 102
- case 102: Switch to manual mode → case 103
- case 103: Manual mode confirmed → case 104
- case 104: FlagServoSet=true, jog speed 200 → case 105
- case 105: Timer start → case 105.1
- case 105.1: After 1s FlagServoSet=false, start jog forward → case 106
- case 106: LoadCell > 5 → jog stop → case 107
- case 107: FlagServoSet=true → case 108
- case 108: After 1s log current torque/position → case 109
- case 109: Save master coordinates (Pos3=current, Pos2=current), save INI → case 110
- case 110: Restore jog speed, reload INI, MES record → case 111
- case 111: Alarm check → case 112
- case 112: Switch to auto → case 113
- case 113: Position1 move → case 114
- case 114: Position1 arrived → case 115
- case 115: Master removal check → case 0

### PLC Bit Map
- PlcValueBit[0,0]: Start signal
- PlcValueBit[0,2]: Reset/Stop
- PlcValueBit[0,4]: Assembly product detect
- PlcValueBit[0,5]: Bolt2 sensor
- PlcValueBit[0,6]: Bolt1 sensor
- PlcValueBit[0,8]: Tool detect
- PlcValueBit[8,1]/[10,1]: Alarm
- PlcValueBit[8,3]/[10,3]: Manual OFF
- PlcValueBit[8,4]/[10,4]: Manual ON
- PlcValueBit[14,0]: Axis1 position1 arrived
- PlcValueBit[14,1]: Axis1 position2 arrived
- PlcValueBit[14,2]: Axis1 position3 arrived
- PlcValueBit[14,3]: Axis1 position4 arrived
- SetPlcBit(9,1): Axis1 jog forward
- SetPlcBit(9,5): Axis1 auto
- SetPlcBit(9,6): Axis1 manual
- SetPlcBit(9,8): NG signal
- SetPlcBit(11,5): Axis2 auto
- SetPlcBit(11,6): Axis2 manual
- SetPlcBit(12,0): Axis1 move to position1
- SetPlcBit(12,1): Axis1 move to position2
- SetPlcBit(12,2): Axis1 move to position3
- SetPlcBit(12,3): Axis1 move to position4

### Key Variables
- LotorAssembleStep: Main step
- ToolStep: Bolt measurement sub-step
- ValueLoadCell: Load cell value
- ValueLvdt: LVDT value
- LvdtMax: LVDT max value
- tmpMax: Load cell max value
- maxLoadInPassRange: Max load cell within pass range
- timeList/valueList: Graph data
- FlagServoMoveCompleted: Servo move complete flag
- loadStarted/loadStartTime: Load start detection
- measureStartTime: Measurement start time
- tmrStopWatch/LoadStopWatch: Stopwatch
