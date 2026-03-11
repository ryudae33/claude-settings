---
name: deploy
description: "Deploy .NET publish output to target PC or network path. Copies build artifacts with backup and verification. Use when the user asks to deploy an application, copy build output to a server or shared folder, or distribute a built application to a target machine."
---

# Deploy Agent

## Task Settings
- subagent_type: build-runner
- model: sonnet

## Role
Copies publish output to target PC/path for deployment.

## Input
$ARGUMENTS (deploy target or task)
- `\\192.168.1.10\share` — deploy to network path
- `D:\Deploy\MyApp` — deploy to local path
- `status` — check recent deploy status

## Actions

### 1. Find Build Output
- Search for `bin/Release/**/publish/` folder in current project
- If multiple found, select by latest timestamp or ask user
- If no publish folder exists, advise that build/publish is needed first

### 2. Pre-Deploy Confirmation
```
## Deploy Plan
- Source: {publish path}
- Target: {deploy path}
- File count: N files
- Total size: XX MB
- Existing files at target: Yes/No (will be overwritten)
```
- **Must get user confirmation before proceeding**

### 3. Verify Target Path Access
```bash
# Check network path access
ls "\\\\192.168.1.10\\share" 2>/dev/null || echo "Access denied"

# Check local path exists
ls "{target_path}" 2>/dev/null || mkdir -p "{target_path}"
```

### 4. Backup Existing (Optional)
If existing files at target path:
```bash
# Backup existing files
mv "{target_path}" "{target_path}_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "{target_path}"
```

### 5. Execute Deploy
```bash
# Copy with robocopy (optimal for Windows)
robocopy "{source}" "{target}" /MIR /NJH /NJS /NDL /NC /NS /NP

# Or copy with cp
cp -r "{source}/"* "{target}/"
```

### 6. Verify Deploy
```bash
# Compare file count/size
echo "Source:"
find "{source}" -type f | wc -l
echo "Target:"
find "{target}" -type f | wc -l
```

### 7. Result Report
```
## Deploy Result
- Source: {publish path}
- Target: {deploy path}
- Files copied: N
- Total size: XX MB
- Backup: {backup path or none}
- Status: Success/Failure
- Time: {completion time}
```

## Rules
- **Must get user confirmation before deploy** (most important)
- Confirm backup preference when overwriting existing files
- Advise on cause when network path is inaccessible (permissions/firewall/share settings)
- Report executable file path after deploy
