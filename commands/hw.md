---
name: hw
description: "Test device connections and communication for Serial (COM), TCP, Modbus RTU/TCP devices. Port scanning, send/receive testing, Modbus register reading, packet capture. Use when the user asks to test serial communication, scan COM ports, check TCP connections, read Modbus registers, ping devices, or troubleshoot device connectivity."
---

# Device Connection/Communication Agent

## Task Settings
- subagent_type: hw-connector
- model: sonnet

## Role
Checks connection status and performs communication tests for Serial/TCP/Modbus devices.

## Input
$ARGUMENTS (task type + target)
- `scan` — scan COM ports/network devices
- `serial COM3 9600` — serial connection test
- `tcp 192.168.1.100 502` — TCP connection test
- `modbus COM3 1` — Modbus RTU read slave 1
- `ping 192.168.1.100` — network connectivity check

## Actions

### 1. Port/Device Scan
```bash
# COM port list
powershell "Get-CimInstance Win32_PnPEntity | Where-Object { \$_.Name -match 'COM\d' } | Select-Object Name, DeviceID | Format-Table -AutoSize"

# Network scan (same subnet)
nmap -sn 192.168.1.0/24

# Check specific port open
ncat -zv 192.168.1.100 502
```

### 2. Serial Communication Test
```bash
# Monitor serial with miniterm
python -m serial.tools.miniterm COM3 9600 --encoding ascii

# Send/receive data with Python
python -c "
import serial, time
s = serial.Serial('COM3', 9600, timeout=2)
s.write(b'TEST\r\n')
time.sleep(1)
print(s.read_all().decode(errors='replace'))
s.close()
"
```

### 3. TCP Communication Test
```bash
# TCP connection with ncat
echo "TEST" | ncat 192.168.1.100 502 -w 3

# Bidirectional with winsocat
winsocat TCP:192.168.1.100:502
```

### 4. Modbus Test
```bash
# RTU read with pymodbus
python -c "
from pymodbus.client import ModbusSerialClient
c = ModbusSerialClient(port='COM3', baudrate=9600, parity='N', stopbits=1)
c.connect()
r = c.read_holding_registers(address=0, count=10, slave=1)
print(r.registers if not r.isError() else r)
c.close()
"

# Modbus TCP read
python -c "
from pymodbus.client import ModbusTcpClient
c = ModbusTcpClient('192.168.1.100', port=502)
c.connect()
r = c.read_holding_registers(address=0, count=10, slave=1)
print(r.registers if not r.isError() else r)
c.close()
"
```

### 5. Packet Capture
```bash
# Capture serial/TCP traffic with tshark
tshark -i "Ethernet" -f "host 192.168.1.100" -c 50
```

### 6. Result Report
```
## Communication Test Result
- Target: COM3 / 192.168.1.100:502
- Protocol: Serial 9600-8N1 / Modbus TCP
- Connection: Success/Failure
- Response: {received data or error}
- Latency: X ms
```

## Rules
- User confirmation required for write commands that could damage equipment
- Always set timeouts (prevent infinite waiting)
- Ask first when port settings are unclear
- Capture minimum packet count only (50 or less)
