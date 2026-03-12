# Manual Import — Device Protocol Extractor

## Task Settings
- subagent_type: doc-reader
- model: sonnet

## Input
$ARGUMENTS — PDF/document file path and device name
Format: `<file_path> --device "<device_name>"` or just `<file_path>`

## Role
Read device/equipment manual and extract communication protocol specs into `~/.claude/references/device-protocols.md`.

## Process

### Step 1: Read Document
- Use Read tool or appropriate method for the file type (PDF, Word, Excel, image)
- If device name not provided, infer from document title/content

### Step 2: Extract Protocol Information
Find and extract ALL of these fields (leave blank if not found):

- **Device name & model**
- **Communication type**: Serial / TCP / Modbus RTU / Modbus TCP / USB / EtherNet/IP / other
- **Serial settings**: baud rate, data bits, parity, stop bits
- **Network settings**: port number, IP config
- **Protocol/frame format**: ASCII / binary / Modbus registers
- **Commands**: request format, response format (with concrete examples)
- **Data parsing**: delimiter, field positions, data types, unit conversion
- **Register map**: address, data type, description (for Modbus devices)
- **Status/error codes**
- **Timing**: response timeout, polling interval, startup delay
- **Special init sequence**: handshake, address setting, mode configuration

### Step 3: Format as Reference Entry
Format the extracted info as a new section matching the existing style in `~/.claude/references/device-protocols.md`:

```markdown
## N. Device Name (Model)
- **Baud**: 9600, 8N1
- **Protocol**: ASCII / binary / Modbus
- **Commands**: `CMD\r\n` → `RESPONSE\r\n`
- **Parse**: description of data extraction
- **Timeout**: Nms
```

### Step 4: Append to device-protocols.md
- Read current `~/.claude/references/device-protocols.md`
- Check if device already exists (update if so, append if new)
- Add the new section before the "Communication Pattern Summary" table
- Update the summary table if applicable

### Step 5: Report
Show the user:
1. Device name and model identified
2. Communication specs extracted
3. What was added/updated in device-protocols.md

## Rules
- Keep entries concise — protocol quick-reference, not full manual reproduction
- Include concrete command/response examples with actual byte/string values
- If manual is unclear about a spec, note it with `(verify)` marker
- If manual contains register maps, include key registers (not all 500+)
- All content in English
