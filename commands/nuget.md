---
name: nuget
description: "Search, add, update, and remove NuGet packages for .NET projects. Use when the user asks to install, add, update, remove, search, or list NuGet packages, or check for outdated packages."
---

# NuGet Package Agent

## Task Settings
- subagent_type: build-runner
- model: sonnet

## Role
Searches, adds, updates, and removes NuGet packages.

## Input
$ARGUMENTS (task type + package name)
- `search ScottPlot` — search packages
- `add Newtonsoft.Json` — add package
- `update` — check all package updates
- `remove Serilog` — remove package
- `list` — list installed packages

## Actions

### 1. Project Discovery
- Search for `*.csproj` in current directory
- If multiple found, ask user to select

### 2. Search Packages
```bash
dotnet package search "{package_name}" --take 10
```
- Display name, latest version, download count

### 3. List Installed Packages
```bash
dotnet list "{project}" package
dotnet list "{project}" package --outdated  # updatable list
```

### 4. Add Package
```bash
# Latest version
dotnet add "{project}" package {package_name}

# Specific version
dotnet add "{project}" package {package_name} --version {version}

# Include prerelease
dotnet add "{project}" package {package_name} --prerelease
```

### 5. Update Package
```bash
# Check outdated
dotnet list "{project}" package --outdated

# Update individual (remove and add latest)
dotnet add "{project}" package {package_name}
```

### 6. Remove Package
```bash
dotnet remove "{project}" package {package_name}
```

### 7. Result Report
```
## NuGet Task Result
- Project: {name}
- Task: Add/Update/Remove
- Package: {name} {version}
- Status: Success/Failure
```

## Rules
- Suggest build verification after adding/removing packages
- Warn about breaking changes for major version updates
- Get user confirmation when adding to multiple projects simultaneously
