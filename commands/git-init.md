---
name: git-init
description: "Initialize a new Git repository with .gitignore, CLAUDE.md template, global exception handler, and create GitHub repo under ftech-projects organization. Use when the user starts a new project and needs git initialization, or asks to set up a new repo."
---

# Git Project Initialization Agent

## Task Settings
- subagent_type: git-manager
- model: sonnet

## Role
Initializes a Git repository for a new project, creates a repo under the ftech-projects organization, and sets up required template files.

## Input
$ARGUMENTS (project name or project path)

## Actions

### 1. Pre-Check
- If no argument, use current directory as project path
- If argument is a path, use that path; if just a name, create folder under current directory
- If .git already exists, report "Git already initialized" and stop

### 2. Switch GitHub Account
```bash
gh auth switch --user ryudae33
```

### 3. Git Initialize
```bash
git init
git config user.email "ryudae33@ftechq.com"
```

### 4. Create .gitignore
Scan files in the project to detect language, then generate appropriate .gitignore:
- .sln/.csproj found → C#/.NET
- .vbproj found → VB.NET
- package.json found → Node.js
- Default: Visual Studio + OS common patterns

#### .NET Default Patterns
```
bin/
obj/
*.user
*.suo
*.cache
.vs/
packages/
*.nupkg
crash.log
```

### 5. Create CLAUDE.md Template
Create CLAUDE.md in the project folder:
```markdown
# {project_name}

## Overview
-

## Tech Stack
-

## Build/Run
```
dotnet build
```

## Work History
| Date | Details |
|------|---------|
```

### 6. Add Global Exception Handler (C#/VB.NET projects only)
If Program.cs or Program.vb exists, check if global exception handler code already exists; if not, suggest adding:

#### C# Template
```csharp
// Global exception handler
Application.ThreadException += (s, e) => LogCrash(e.Exception);
AppDomain.CurrentDomain.UnhandledException += (s, e) => LogCrash((Exception)e.ExceptionObject);

static void LogCrash(Exception ex)
{
    var msg = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.Source}: {ex.Message}\n{ex.StackTrace}\n\n";
    File.AppendAllText("crash.log", msg);
}
```

#### VB.NET Template
```vb
' Global exception handler
AddHandler Application.ThreadException, Sub(s, e) LogCrash(e.Exception)
AddHandler AppDomain.CurrentDomain.UnhandledException, Sub(s, e) LogCrash(DirectCast(e.ExceptionObject, Exception))

Private Sub LogCrash(ex As Exception)
    Dim msg = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.Source}: {ex.Message}{vbCrLf}{ex.StackTrace}{vbCrLf}{vbCrLf}"
    IO.File.AppendAllText("crash.log", msg)
End Sub
```

### 7. Create GitHub Repo
```bash
gh repo create ftech-projects/{project_name} --private --source=. --push
```

### 8. Initial Commit
```bash
git add .
git commit -m "Initial project setup"
git push -u origin main
```

## Rules
- Confirm repo name/visibility with user before creating repo
- Do not overwrite existing files
- Confirm with user before adding crash.log handler
