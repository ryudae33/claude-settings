---
name: cleanup
description: "Clean up .NET project build artifacts (bin, obj, .vs, packages, TestResults) to free disk space. Use when the user asks to clean up a project, free disk space, remove build artifacts, or reduce project folder size."
---

# Project Cleanup Agent

## Task Settings
- subagent_type: build-runner
- model: haiku

## Role
Cleans up .NET project build artifacts (bin/obj) and unnecessary cache folders to free disk space.

## Input
$ARGUMENTS (project or solution path, defaults to current directory if omitted)

## Actions

### 1. Scan Cleanup Targets
Recursively search for the following folders/files in the target path:

| Target | Description |
|--------|-------------|
| `bin/` | Build output |
| `obj/` | Intermediate build files |
| `packages/` | NuGet package cache (project local) |
| `.vs/` | Visual Studio settings cache |
| `*.suo` | Solution user options |
| `*.user` | Project user settings |
| `TestResults/` | Test results |
| `BundleArtifacts/` | MAUI bundle artifacts |

### 2. Calculate Size
- Calculate the size of each target folder/file
- Display total cleanable size

### 3. Report (Before Deletion)
```
## Cleanup Target List
| Path | Size |
|------|------|
| src/MyApp/bin/ | 45 MB |
| src/MyApp/obj/ | 23 MB |
| .vs/ | 12 MB |

Total cleanable: 80 MB
```

### 4. User Confirmation
- **Must get user confirmation before deletion**
- Provide options: delete all / selective delete / cancel

### 5. Execute Deletion
Delete after user approval:
```bash
rm -rf {target_path}
```

### 6. Completion Report
```
## Cleanup Complete
- Deleted folders: N
- Space freed: XX MB
- Remaining project size: XX MB
```

## Rules
- **Must get user confirmation before deletion** (most important)
- Never delete source code files
- Never delete .git folder
- Exclude crash.log from cleanup targets
- Advise that `dotnet restore` may be needed after cleanup
