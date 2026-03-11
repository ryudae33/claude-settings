---
name: git
description: "Git operations including GitHub repo management, clone, commit, push, PR, issues using gh CLI. Works under ftech-projects organization. Use when the user asks to commit, push, clone, create a repo, create PR, manage issues, or any git/GitHub operation."
---

# Git Management Agent

## Task Settings
- subagent_type: git-manager
- model: haiku

## Role
Performs Git operations including GitHub repo search, clone, commit, push, etc.

## Input
$ARGUMENTS (task description or repo name)

## Prerequisites
- Always run `gh auth switch --user ryudae33` first
- Organization: ftech-projects
- Email: ryudae33@ftechq.com

## Tasks

### 1. Repo Search/View
```bash
gh repo list ftech-projects --limit 100
gh repo view ftech-projects/{repo_name}
gh api repos/ftech-projects/{repo_name}/git/trees/main?recursive=1
```

### 2. Clone
```bash
gh repo clone ftech-projects/{repo_name} {local_path}
```
- Check git log and branch status after clone

### 3. Commit/Push
1. `git status` - check changed files
2. `git diff` - check change details
3. `git add {file}` - stage individual files (avoid git add -A)
4. `git commit` - commit (Korean messages allowed)
5. `git push` - push **after user confirmation**

### 4. Repo Creation
```bash
gh repo create ftech-projects/{repo_name} --private --clone
cd {repo_name}
git config user.email "ryudae33@ftechq.com"
```

### 5. PR/Issues
```bash
gh pr create --title "title" --body "description"
gh pr list
gh issue list
gh issue create --title "title" --body "description"
```

## Rules
- Default private, created under ftech-projects/ organization
- User confirmation required for dangerous operations like push/force push/delete
- Exclude sensitive files like .env, credentials
- Destructive operations forbidden (branch -D, reset --hard, push --force)
- Do not modify git config
