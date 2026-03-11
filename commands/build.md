---
name: build
description: ".NET project build/publish agent. Runs dotnet build, dotnet publish, MSBuild, and analyzes/fixes build errors. Use this skill whenever the user asks to build, publish, clean build, rebuild, fix build errors, self-contained deploy, or any build-related request. Supports .NET Framework (MSBuild), .NET Core/5+/6+/8+/9+ (dotnet CLI), and MAUI Android."
---

# Build/Publish Agent

## Task Settings
- subagent_type: build-runner
- model: sonnet

## Role
Agent that performs .NET project build and publish, and analyzes/fixes errors when they occur.

## Input
$ARGUMENTS (task type + target path, defaults to current directory if omitted)
- `build` — build only
- `publish` — Release publish
- `publish win-x64` — publish with specific RID
- `clean build` — clean build
- `rebuild` — rebuild (clean + build)
- Path: `build C:\path\to\project`

## Actions

### 1. Project Discovery
- Search for `*.sln`, `*.csproj`, `*.vbproj` in specified or current directory
- If multiple found, ask user to select
- Check project SDK type (WinForms/WPF/Console/MAUI/Library, etc.)
- **Build system detection**: Check TargetFramework
  - `net9.0`, `net8.0`, `net6.0`, etc. → `dotnet` CLI
  - `v4.8`, `v4.7.2`, etc. .NET Framework → `MSBuild`

### 2. Build Execution

#### dotnet CLI (.NET Core/5+)
```bash
# Default build
dotnet build "{project_path}" -c Release

# Clean build
dotnet clean "{project_path}" && dotnet build "{project_path}" -c Release

# MAUI Android
dotnet build -c Release -f net9.0-android -p:AndroidSdkDirectory=C:/android-sdk
```

#### MSBuild (.NET Framework)
```bash
# Find MSBuild path via vswhere
$msbuild = & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.Component.MSBuild -find "MSBuild\**\Bin\MSBuild.exe" | Select-Object -First 1

# Default build
& $msbuild "{project_path}" /p:Configuration=Release /restore

# Clean build
& $msbuild "{project_path}" /t:Clean,Build /p:Configuration=Release /restore
```

### 3. Publish Execution
```bash
# Default publish
dotnet publish "{project_path}" -c Release

# Self-contained (no .NET runtime needed on target)
dotnet publish "{project_path}" -c Release -r win-x64 --self-contained

# Single file
dotnet publish "{project_path}" -c Release -r win-x64 --self-contained -p:PublishSingleFile=true

# Trimmed (remove unused assemblies, reduce size)
dotnet publish "{project_path}" -c Release -r win-x64 --self-contained -p:PublishSingleFile=true -p:PublishTrimmed=true
```

### 4. Error Analysis & Fix
On build failure:
1. Classify error messages:
   - **CS codes** (CS0246, CS1061, etc.): Compile errors — missing references, type errors
   - **MSB codes** (MSB3073, MSB4019, etc.): Build system errors — SDK/tool issues
   - **NU codes** (NU1101, NU1605, etc.): NuGet package errors — package restore failures
   - **NETSDK codes**: SDK installation/version issues
2. Identify cause and suggest fix
3. **Fix code only after user confirmation** (no auto-fix)
4. Rebuild after fix

### 5. Result Report
```
## Build Result
- Status: Success/Failure
- Project: {name}
- Build Tool: dotnet CLI / MSBuild
- Configuration: Release | {RID}
- Output: {output path}
- Warnings: N
- Duration: X seconds
```

## Rules
- User confirmation required before fixing build errors
- Report warnings but do not auto-fix
- Automatically add AndroidSdkDirectory property for MAUI Android builds
- Clearly indicate publish output path
- Try `dotnet restore` first on NuGet restore failures
- Auto-detect MSBuild path via vswhere for .NET Framework projects
