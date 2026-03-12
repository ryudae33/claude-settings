# Device Protocol Reference

Quick-lookup for serial/TCP device communication specs used across projects.

## 1. LS PLC (Cnet Protocol)
- **Baud**: 9600, 8N1
- **Protocol**: ENQ(0x05)/ACK(0x06)/ETX(0x03) ASCII frame
- **Read**: `ENQ 00RSB07 {ADDR} {COUNT} EOT` → 4-digit hex values
- **Write**: `ENQ 00WSB07 {ADDR} {COUNT} {DATA} EOT`
- **Addresses**: IN0=%DW4000(32w), IN1=%DW4032(32w), OUT0=%DW5000(32w), OUT1=%DW5032(32w)
- **Timeout**: 1000ms, auto-reopen after 3 consecutive timeouts
- **Thread**: Read thread (blocking) + Work thread (state machine, 10ms polling)

## 2. ONOSOKKI RI-20W (Load Cell / LVDT Indicator)
- **Baud**: 9600 (standard) or 57600 (high-speed)
- **Query mode**: Send `ID{DeviceId:D2}P\r\n` → Response `ID,{ID},{VALUE}{UNIT}\r\n`
- **Stream mode**: F-40=000, F-42=0 → continuous `ST,NT,+01234.5\r\n` (16 bytes, ~100ms)
- **Zero**: `ID{ID}Z\r\n`
- **Parse**: comma-split, field[2] regex `([+-]?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)([A-Za-z%µ]*)`
- **Status**: "NT"=Normal, "ER"=Error

## 3. LVDT Sensor (4-Channel, Stream Mode)
- **Baud**: 9600
- **Frame**: `ST,NT,+01234.5\r\n` (continuous)
- **Parse**: Substring(6,8) → double, Math.Abs()
- **Ports**: COM_LVDT1~COM_LVDT4 (up to 4 independent channels)
- **Connection**: DataReceived event (ThreadPool)

## 4. Gauge / Load Cell (High-Speed)
- **Baud**: 115200
- **Parse**: comma-separated, `fields[2] / 1000.0`
- **Settings**: GlobalValues.LoadCellPort, GlobalValues.LvdtPort

## 5. Barcode Scanner
- **Baud**: 9600
- **Frame**: ASCII text, CR/LF terminated
- **Parse**: raw string, filter binary control chars (except CR/LF)
- **Connection**: DataReceived event (interrupt-driven)
- **Max**: 2 scanners (ScannerId 1~2)

## 6. SCPI Power Supply
- **Frame**: SCPI ASCII, CR terminated (`\r`)
- **Init**: `*ADR 1\r` (50ms delay after open)
- **Commands**: `MEAS:VOLT?\r`, `MEAS:CURR?\r`, `SOUR:VOLT {value:F3}\r`
- **State machine**: VOLT? → read → CURR? → read → set voltage (100ms cycle)
- **Timeout**: 2000ms
- **Default target**: 13.5V

## 7. Keyence Laser Sensor (RS-232)
- **Baud**: 9600
- **Command**: `MS\r\n` → response CSV `123.45,456.78\r\n`
- **Parse**: `double.TryParse(parts[0])` (first field = distance)

## 8. Servo Motor (via PLC Registers)
- **Not direct serial** — controlled through LS PLC Cnet write
- **Addresses**: Speed %MW5000~5010, Position %MW6000~6026
- **Conversion**: 1 pulse = 0.5mm (2000 pulses/mm)
- **Control**: PLC write-command pattern via Cnet protocol

## Communication Pattern Summary

| Pattern | Devices | Interval |
|---------|---------|----------|
| Event-driven (DataReceived) | Scanner, LVDT, Laser | Interrupt |
| Polling state machine | PLC, Power Supply | 10~100ms |
| Streaming (continuous) | RI-20W stream, LVDT | ~100ms auto |
| Request/Response | RI-20W query, Laser | On-demand |

## Port Config Storage
- **INI**: config.ini [System] — PlcPort, LvdtPort, LoadCellPort, GaugePort, ScannerPort
- **DB**: Table_System — COM_PLC, COM_LVDT1~4, COM_Laser + baud columns

## Error Recovery
- Port not found → log, return false
- Timeout → state reset, soft reopen, hard reopen after N failures
- Parse error → discard frame, continue
- Binary garbage → filter control chars, clear buffer, resync
