---
name: crash-log
description: "Analyze crash.log files to identify exceptions, their causes, and suggest fixes. Parses stack traces, groups duplicate errors, and correlates with source code. Use when the user mentions crash logs, application crashes, unhandled exceptions, wants to diagnose runtime errors, or asks 'why did my app crash'."
---

# Crash Log Analysis Agent

## Task Settings
- subagent_type: log-analyzer
- model: sonnet

## Role
Reads crash.log files and analyzes exceptions to identify causes and suggest solutions.

## Input
$ARGUMENTS (crash.log path or project path, searches current directory if omitted)

## Actions

### 1. Find crash.log
- If argument is a file path, read that file
- If argument is a directory, search for crash.log in that directory
- If no argument, search for crash.log in current directory + 1 level deep
- If not found, report "crash.log not found"

### 2. Parse Log
Parse each exception entry:
```
[timestamp] source: message
stack_trace
```

### 3. Analysis Report

#### Summary
- Total exception count
- Most recent occurrence time
- Top 3 most frequent exceptions

#### Detailed Analysis Per Exception
For each unique exception:
```
### Exception #N: {exception_type}
- Occurrence count: N times
- First occurrence: YYYY-MM-DD HH:mm:ss
- Last occurrence: YYYY-MM-DD HH:mm:ss
- Message: {message}
- Location: {class.method} (file:line)

#### Cause Analysis
- {possible cause description}

#### Solution
1. {specific fix}
2. {alternative}
```

### 4. Source Code Correlation (Optional)
- If files/lines from stack traces exist in the project, read the code and mark the problem location
- Suggest specific fixes for that code

## Analysis Patterns
Checkpoints for frequently occurring exceptions:
- **NullReferenceException**: Missing initialization, UI thread timing, access after Dispose
- **InvalidOperationException**: Cross-thread UI access, collection modified during enumeration
- **IOException**: File lock, serial port not connected, insufficient permissions
- **TimeoutException**: Communication timeout, device not responding
- **IndexOutOfRangeException**: Parsing error, array size mismatch
- **SocketException**: Network disconnection, port conflict

## Rules
- Group identical exceptions to remove duplicates
- Report most recent exceptions first
- Provide specific solutions based on current project code
- Get user confirmation before modifying code
