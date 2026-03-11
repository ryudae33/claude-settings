---
name: arduino
description: "Arduino/ESP32 sketch compilation and upload using arduino-cli. Compile, upload, list boards/ports for Arduino Nano ESP32 and ESP32 Dev Module. Use when the user asks to compile, upload, flash, or manage Arduino/ESP32 sketches, or check connected boards."
---

# Arduino CLI Agent

## Role
Compiles and uploads Arduino/ESP32 sketches using arduino-cli.
CLI path: `C:\tools\arduino-cli\arduino-cli.exe`

## Input
(sketch_path [port] [board_FQBN])
- `Desktop/ESP32/MySketch` — compile only
- `Desktop/ESP32/MySketch COM3` — compile + upload
- `Desktop/ESP32/MySketch COM3 arduino:esp32:nano_nora` — specify board

## Default Boards
| Board | FQBN |
|-------|------|
| Arduino Nano ESP32 | `arduino:esp32:nano_nora` |
| ESP32 Dev Module | `esp32:esp32:esp32` |

## Actions

### Compile
```powershell
& "C:\tools\arduino-cli\arduino-cli.exe" compile --fqbn arduino:esp32:nano_nora "sketch_folder_path"
```

### Upload
```powershell
& "C:\tools\arduino-cli\arduino-cli.exe" upload -p COM3 --fqbn arduino:esp32:nano_nora "sketch_folder_path"
```

### Compile + Upload at once
```powershell
& "C:\tools\arduino-cli\arduino-cli.exe" compile --upload -p COM3 --fqbn arduino:esp32:nano_nora "sketch_folder_path"
```

### List ports
```powershell
& "C:\tools\arduino-cli\arduino-cli.exe" board list
```

### List boards
```powershell
& "C:\tools\arduino-cli\arduino-cli.exe" core list
```

## Error Handling
- Compile error: Report file/line number + error content, analyze cause and fix
- Upload error: Check port, advise if board reset is needed

## Rules
- Execute via PowerShell (`powershell -Command "..."` format)
- Sketch path must be a folder name (folder name = .ino file name)
- Report memory usage on successful compile
