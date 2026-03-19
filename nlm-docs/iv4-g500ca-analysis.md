---
source: AS_139399 (Installation Manual) + AS_159053 (User Manual)
notebook_id: 06eeac33-b20b-45eb-8b30-a86a2b1774d9
date: 2026-03-19
question: IV4-G500CA SW trigger, TCP/IP commands, FTP image transfer, HW specs
---

# Keyence IV4-G500CA Vision Sensor Reference

1cellAssembleMachine ST-12 (Spring 0.15) vision inspection use.
Current: electrical trigger (IN1) -> switching to software trigger (TCP/IP).

## 1. Hardware Specs

| Item | IV4-G500CA (Sensor Head) | IV4-G120 (Sensor Amp) |
|------|--------------------------|----------------------|
| Power | Supplied from amp | 24V DC +25%/-20% |
| Current (24V) | - | 1.7A (no AI light) / 3.2A (AI light) |
| Power consumption | 2.5W / 6.6W (AI light) | 9.5W (amp only) |
| Temp range | 0~50C | 0~50C |
| Protection | IP67 | - |
| Light source | White LED (Risk Group 1) | - |
| Case temp limit | 65C max | 65C max |

### I/O Terminal Block (18-pin)

| Pin | Name | Function |
|-----|------|----------|
| 1 | IN1 | External Trigger (FIXED - rising/falling selectable) |
| 2~8 | IN2~IN8 | User assignable: Program bit 0~6, Clear Error, Ext. Master Save |
| 9 | - | Unused |
| 10 | OUT1 | Total Status OK (default) |
| 11 | OUT2 | BUSY (default) |
| 12 | OUT3 | Error (default, N.C.) |
| 13~17 | OUT4~OUT8 | User assignable: OK/NG, RUN, SD error, tool results |
| 18 | OUT COM | Output common (NPN->0V, PNP->24V) |

## 2. TCP/IP Nonprocedural Communication

### Connection Specs

| Item | Value |
|------|-------|
| Port | **8500** (default, changeable 1024~65535) |
| Max connections | 2 |
| Encoding | ASCII |
| Delimiter | CR (0x0D) |
| Mode | Server (IV4) / Client (PC/PLC) |

### Setup Menu Path
`Program > Sensor Advanced > Utility tab > Communication Settings > Nonprocedural Communication Settings > Enable`

### Command Format
```
Command: aa,bb,...,cc[CR]    (aa=command, bb/cc=params, delimiter=comma)
Response: aa,bb,...,cc[CR]   (same command echoed + result params)
Error:    ER,aa,bb[CR]       (aa=command, bb=error code)
  Error codes: 02=no such command, 03=cannot execute, 22=param error
```

### Command List (Full)

#### Trigger / Result

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **T1** | `T1[CR]` | `T1[CR]` | Trigger only (immediate response, no wait) |
| **T2** | `T2[CR]` | `RT,...[CR]` | Trigger + wait + result (MAIN COMMAND) |
| **RT** | `RT[CR]` | `RT,result...[CR]` | Read last result (standard/detailed by OF) |
| **OE** | `OE,n[CR]` | `OE[CR]` | Auto result transmission (0=OFF, **1=ON**) |
| **OF** | `OF,nn[CR]` | `OF[CR]` | Result format (00=standard, 01=detailed, 02/03=with master#) |

#### Result Format (Standard, OF=00)
```
RT,aaaaa,bb,cc,dd,eeeeeee,...[CR]
  aaaaa  = result number (00000~32767, auto increment)
  bb     = total status (OK/NG/--)
  cc     = tool number (00=position adj, 01~64=tool)
  dd     = tool result (OK/NG/--)
  eeeeeee = matching rate (7 digits, e.g. 0000080 = 80%)
```
Example: `RT,01234,NG,01,OK,0000080,02,NG,0021500[CR]`

#### Result Format (Detailed, OF=01)
```
RT,aaaaa,bb,stuvwxyz,ddddd,eee,tool1,tool2,...[CR]
  stuvwxyz = logic 1~8 result (0=OFF, 1=ON)
  ddddd    = processing time [ms]
  eee      = program number (000~127)
```

#### Program Control

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **PR** | `PR[CR]` | `PR,nnn[CR]` | Read program number (000~127) |
| **PW** | `PW,nnn[CR]` | `PW[CR]` | Switch program |
| **PNR** | `PNR[CR]` | `PNR,name[CR]` | Read program name (UTF-8) |
| **PNW** | `PNW,name[CR]` | `PNW[CR]` | Write program name (max 16 chars) |

#### Status / Error

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **RM** | `RM[CR]` | `RM,n[CR]` | Operating status (0=Program, 1=Run) |
| **SR** | `SR[CR]` | `SR,a,b,c,d,e,f,g[CR]` | Sensor status (see below) |
| **RER** | `RER[CR]` | `RER,nnn[CR]` | Error number (000=no error) |
| **WR** | `WR[CR]` | `WR,nnn[CR]` | Warning number |
| **WC** | `WC[CR]` | `WC[CR]` | Clear warning |

SR response fields:
- a=BUSY(0/1), b=TriggerReady(0/1), c=Imaging(0/1), d=SD card(0/1)
- e=SD insufficient(0/1), f=Warning(0/1), g=Error(0/1)

#### Threshold

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **DR** | `DR,nn,a[CR]` | `DR,nn,a,bbbbbbb[CR]` | Read threshold (nn=tool, a=0:lower/1:upper) |
| **DW** | `DW,nn,a,bbbb[CR]` | `DW,nn[CR]` | Change threshold |

#### Image Data

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **BR** | `BR,m[CR]` | `BR,nnnn,ddddddd,<binary>[CR]` | **Read latest image** (m: 0=no compress, 1=1/2) |
| **BR,SD** | `BR,SD,m,/path/file.bmp[CR]` | `BR,nnnn[CR]` | Save image to SD card |

BR response: 24-bit BMP binary data, nnnn=total trigger count, ddddddd=image data length

#### FTP/SD File Name

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **FNR** | `FNR,n,m[CR]` | `FNR,n,m,ssss[CR]` | Read file name (n=condition 1~4, m=0:volatile/1:NV) |
| **FNW** | `FNW,n,m,ssss[CR]` | `FNW,n,m[CR]` | Change file name (max 64 chars) |
| **ITR** | `ITR,n[CR]` | `ITR,n,ssss[CR]` | Read nonprocedural ITW 1~8 |
| **ITW** | `ITW,n,ssss[CR]` | `ITW,n[CR]` | Write nonprocedural ITW 1~8 (volatile, lost on power off) |

#### Other

| Command | Format | Response | Description |
|---------|--------|----------|-------------|
| **MR** | `MR[CR]` | `MR[CR]` | Register current image as master |
| **VI** | `VI[CR]` | `VI,model,version[CR]` | Version (e.g. `VI,IV4-G500CA,R1.10.00`) |
| **SDR** | `SDR[CR]` | `SDR,nnnnn[CR]` | SD free space [MB] |
| **SDS** | `SDS[CR]` | `SDS[CR]` | SD card safe remove |
| **STR** | `STR[CR]` | `STR,max,min,avg,triggers,ok,ng,errors,...[CR]` | Statistics |
| **STC** | `STC[CR]` | `STC[CR]` | Reset statistics (STC,0=current prog, STC,1=all) |
| **TR** | `TR[CR]` | `TR,yy,mm,dd,hh,mm,ss[CR]` | Read unit time |
| **TC** | `TC,yy,mm,dd,hh,mm,ss[CR]` | `TC[CR]` | Set unit time |
| **TP** | `TP[CR]` | `TP,+nn.n[CR]` | Read sensor temperature |
| **CSR** | `CSR[CR]` | `CSR,aaaaa[CR]` | Settings checksum |
| **RFC** | `RFC[CR]` | `RFC,nnnnnnnnnn[CR]` | FTP/SD transfer completion count |

### Communication Flow (Recommended for ST-12)

```
[Method 1: T2 command — simple, blocking]
PC -> IV4: T2[CR]
IV4 -> PC: RT,00001,OK,01,OK,0000095[CR]    (waits until judgment complete)

[Method 2: OE auto transmission — non-blocking, recommended]
PC -> IV4: OE,1[CR]        (enable auto transmission, do once after connect)
IV4 -> PC: OE[CR]
...
PC -> IV4: T1[CR]          (trigger)
IV4 -> PC: T1[CR]          (immediate ack)
IV4 -> PC: RT,00001,OK,... (auto-sent when judgment done)

[Method 3: T1 + polling]
PC -> IV4: T1[CR]          (trigger)
IV4 -> PC: T1[CR]
PC -> IV4: SR[CR]          (check busy)
IV4 -> PC: SR,0,1,0,...    (BUSY=0 -> done)
PC -> IV4: RT[CR]          (read result)
IV4 -> PC: RT,...
```

### Image Retrieval via TCP/IP
```
PC -> IV4: BR,0[CR]        (read latest image, no compression)
IV4 -> PC: BR,0000000001,0921600,<921600 bytes of 24-bit BMP data>
```
- Image: 24-bit BMP (color or mono)
- Compression: 0=none, 1=half size
- Must have latest image (trigger must have been executed)

## 3. FTP/SFTP Image Auto-Transfer

### Setup Menu Path
`Program > Sensor Advanced > Utility tab > Image/Result Output > Output Destination: FTP`

### Connection Settings
- IP Address: FTP server IP
- Port: 21 (FTP default) / 22 (SFTP)
- User Name: max 48 chars
- Password: max 16 chars

### Global Settings
- **File Format**: IV4P, BMP, JPEG, IV4P/JPEG
- **Transfer Judgment Results**: Enable -> tab-delimited .txt with results
- **Add Result to Images**: Enable -> overlay OK/NG, matching rate on image
- **Image Size**: Full / Quarter

### Transfer Conditions (up to 4 independent)
- **Target Image**: All / Judgment Complete / Total Status / Tool 01~64 / Logic 1~8
- **Judgment Result**: OK / NG / NG+near threshold OK / near threshold OK
- **Subfolder**: No sorting / Subfolder only / Program / Date / Program+Date
- **Time Stamp**: YYYYMMDD_hhmmss appended to filename
- **File Name (Detail mode)**: Fixed String + Date + Time + Serial No. + Program + Total Status + Tool result + ITW 1~8

### File Name Format (Standard)
```
aaaa_bbbbb_ccc_ddd_YYYYMMDD_hhmmss.eee
  aaaa   = user filename
  bbbbb  = serial number (00000~99999)
  ccc    = program number (000~127)
  ddd    = OK/NG (or M00~M07 in sorting mode)
  eee    = extension (iv4p/bmp/jpeg)
```

### Image Size Reference (High-Speed Filter OFF, Full size)
- Full resolution: 1280x960, ~3600KB (BMP) / ~154KB (JPEG)
- Quarter: 640x480, ~900KB (BMP) / ~44KB (JPEG)

### Internal Buffer
- Up to 20 images buffered if FTP transfer is slow
- Transfer in FIFO order
- Buffer overflow -> transfer fails

## 4. Trigger Options

### Trigger Types
1. **External Trigger (IN1)**: Hardware signal, rising/falling edge selectable
2. **Internal Trigger**: Continuous cycle, configurable interval
3. **AI Trigger**: AI-based auto-trigger on scene change
4. **Software Trigger (TCP/IP)**: T1 or T2 command via Ethernet

### Switching to Software Trigger
Current: IN1 (external trigger via PLC output bit)
Target: TCP/IP T2 command from C# app

Steps:
1. Enable nonprocedural communication: `Sensor Advanced > Utility > Communication Settings > Nonprocedural > Enable`
2. Note sensor IP address (check/set in Network Settings)
3. C# app connects to sensor IP:8500 via TCP
4. Send `T2[CR]` to trigger + get result
5. Optionally enable OE for auto result push: `OE,1[CR]`
6. IN1 can remain connected as backup (both can coexist)

## 5. C# Implementation Plan (ST-12)

### Architecture
```
IV4Client.cs          -- TCP socket to IV4 (port 8500)
  Connect(ip, port)
  SendCommand(cmd) -> response
  TriggerAndRead()  -- T2 command, parse RT response
  ReadImage()       -- BR command, save BMP
  EnableAutoResult() -- OE,1
  Disconnect()
```

### Key Methods
```csharp
// Trigger + result
await Send("T2\r");
var response = await ReadLine();  // "RT,00001,OK,01,OK,0000080\r"
var parts = response.Split(',');
var totalResult = parts[2];       // "OK" or "NG"
var matchRate = int.Parse(parts[6]) / 10000.0; // 80.0%

// Image capture
await Send("BR,0\r");
// Read: "BR,nnnnnnnnnn,ddddddd," + binary image data
// Parse header, read ddddddd bytes of 24-bit BMP

// FTP file name dynamic change (for traceability)
await Send($"FNW,1,0,{serialNumber}\r");
```

### Integration with ST-12 Sequence
- Before vision step: `TriggerAndRead()` instead of PLC output bit toggle
- After judgment: parse OK/NG from RT response
- Image save: `ReadImage()` -> save to local folder with timestamp
- Sensor learning: keep as-is (sensor internal AI learning)

## 6. Current Wiring (ST-12)

PLC output -> IV4 IN1 (external trigger)
IV4 OUT1 (OK) -> PLC input _02_IN11 (104.11)
IV4 OUT2 (BUSY) -> PLC input _02_IN12 (104.12)
IV4 OUT3 (ERROR) -> PLC input _02_IN13 (104.13)

After SW trigger migration:
- IN1: can disconnect or keep as manual backup
- OUT1/2/3: can keep for PLC-side status monitoring
- Primary control: C# <-> IV4 TCP/IP (port 8500)
