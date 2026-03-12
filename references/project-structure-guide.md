# Project Structure Guide

## Feature-Based Folder Structure
```
src/
  Features/
    Measurement/
      MeasurementService.cs    # business logic
      MeasurementConfig.cs     # settings/constants
      MeasurementForm.cs       # UI (thin, delegates to Service)
    ServoControl/
      ServoService.cs
      ServoConfig.cs
      ServoForm.cs
  Shared/
    Communication/             # serial/TCP/Modbus helpers
    Database/                  # DB access helpers
    Models/                    # shared DTOs/enums
  Program.cs                   # entry point + global exception handler
  config.json                  # all runtime settings (ports, speeds, thresholds)
```

## State Machine as Data
Define steps/sequences as enum + Dictionary, not giant switch-case:
```csharp
enum Step { Init, Move, Measure, Evaluate }
Dictionary<Step, StepConfig> Steps = new() {
    [Step.Init] = new("초기화", ServoAction.Home, nextStep: Step.Move),
    [Step.Move] = new("이동", ServoAction.MoveToPos, nextStep: Step.Measure),
};
```

## Interface-Based Devices
All devices implement common interface for easy extension:
```csharp
public interface IDevice { void Connect(); void Disconnect(); double Read(); }
```

## Project CLAUDE.md File Map Example
Every project root CLAUDE.md should include:
```markdown
## File Map
- Features/Measurement/ — load cell/LVDT/gauge measurement
- Features/ServoControl/ — servo control and positioning
- Shared/Communication/ — serial/TCP communication helpers
```
This eliminates exploratory file searches — biggest token saver.
