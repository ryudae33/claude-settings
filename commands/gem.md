---
name: gem
description: "Send code to Gemini for review and apply feedback after user approval. Gets a second opinion from Google's Gemini model on code quality, bugs, security, and performance. Use when the user asks for a Gemini code review, wants a second AI opinion on code, or asks for external code review."
---

# Gemini Code Reviewer

## Role
Sends files worked on in the current conversation to Gemini for review, and applies feedback after user approval.
Opens a notepad window to display the Gemini review results, then closes it after approval.

## Execution Steps

### Step 1: Identify Review Targets
- Identify the list of recently Read/Edit/Written files from the current conversation context
- If no files found, advise "Please specify files to review" and stop
- If user specified particular files, prioritize those

### Step 2: Write Review Request File
Write to `C:/tmp/gem_request.txt` with the following content:
```
Review the code below. Respond in English.

Review points:
- Bugs or potential errors
- Improvable code quality/readability
- Performance issues
- Security vulnerabilities

[Filename: actual_filename]
[Full file content]
```
Include all files if multiple. Create `C:/tmp/` folder first if it doesn't exist.

### Step 3: Run Gemini Headless
Announce "Requesting Gemini review..." before execution.
Pass file content inline directly (`@filepath` method unavailable due to workspace restrictions):
```bash
gemini -m gemini-2.5-flash -p "$(cat C:/tmp/gem_request.txt)" > C:/tmp/gem_output.txt 2>&1
```

### Step 4: Display Results in Notepad
Open notepad to show results:
```bash
taskkill /IM notepad.exe /F 2>/dev/null; start "" notepad "C:/tmp/gem_output.txt"
```

### Step 5: Report Feedback + Request Approval
- Read `C:/tmp/gem_output.txt` and summarize key feedback for the user
- Confirm approval via AskUserQuestion:
  - "Approve" — apply feedback and modify files
  - "Reject" — end without modifications

### Step 6: Apply Feedback (If Approved)
- Modify files using Edit tool based on Gemini feedback
- Report summary of changes after completion

### Step 7: Notepad Window
User closes it manually. No additional handling needed.

## Rules
- Temp files: `C:/tmp/gem_request.txt`, `C:/tmp/gem_output.txt`
- **Absolutely no file modifications before approval**
- Show error content and stop if gemini execution fails
- Summarize feedback as numbered key items only (do not show full original text)
