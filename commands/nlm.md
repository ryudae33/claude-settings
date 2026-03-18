---
name: nlm
description: "Analyze documents using Google NotebookLM via nlm CLI. Create notebooks, add sources (PDF/URL/text), query content, get summaries. Use when the user wants to analyze manuals, technical documents, or any files using NotebookLM AI."
---

# NotebookLM Manual Analyzer

## Task Settings
- subagent_type: general-purpose
- model: sonnet

## Environment
- nlm executable: `C:/Users/Administrator/AppData/Roaming/Python/Python314/Scripts/nlm.exe`
- MUST set PATH before every nlm command: `export PATH="$PATH:/c/Users/Administrator/AppData/Roaming/Python/Python314/Scripts"`
- All nlm commands must run via Bash tool with PATH set

## Input
$ARGUMENTS — command and parameters

## Usage Patterns

### Quick Analyze (most common)
```
/nlm analyze <file_or_url> "<question>"
/nlm analyze manual.pdf "통신 프로토콜 정리해줘"
/nlm analyze https://docs.example.com "API 사용법 요약"
```

### Individual Commands
```
/nlm login                          # 인증 (최초 1회)
/nlm list                           # 노트북 목록
/nlm create "<name>"                # 노트북 생성
/nlm add <notebook-id> <file/url>   # 소스 추가
/nlm query <notebook-id> "<question>"  # 질의
/nlm sources <notebook-id>          # 소스 목록
/nlm delete <notebook-id>           # 노트북 삭제
/nlm summary <notebook-id>          # 요약 생성
/nlm report <notebook-id>           # 리포트 생성
/nlm quiz <notebook-id>             # 퀴즈 생성
```

## Output Storage
- Analysis results saved to: `~/.claude/nlm-docs/<notebook-name>.md`
- Index file: `~/.claude/nlm-docs/INDEX.md` (filename + one-line description list)
- NOT in `references/` (avoids token consumption every conversation)
- When user needs past analysis, Read the file from `nlm-docs/` on demand

### INDEX.md format
```markdown
# NLM Analysis Index
| File | Description | Notebook ID | Date |
|------|-------------|-------------|------|
| servo-manual.md | Servo motor communication protocol summary | abc123 | 2026-03-18 |
```

## Process

### Mode 1: `analyze` (auto workflow)
Full pipeline: notebook create → add source → query → format result → save

1. **Auth check**: `nlm login --check` — if fails, run `nlm login` and stop
2. **Parse input**: separate file/URL from question
3. **Create notebook**: `nlm notebook create "<filename>-analysis"`
   - Parse notebook ID from output
4. **Add source**: `nlm source add <notebook-id> "<file_or_url>"`
   - PDF/docx/txt files: pass local file path (Windows path, double-quoted)
   - URL: pass as-is
   - Multiple sources: run `nlm source add` for each
5. **Wait**: `sleep 15` (NotebookLM processing time)
6. **Query**: `nlm chat query <notebook-id> "<question>"`
   - If no question provided, use: "이 문서의 핵심 내용을 구조적으로 정리해줘"
7. **Format result**: organize output as markdown for the user
8. **Save result**: Write to `~/.claude/nlm-docs/<notebook-name>.md` with frontmatter:
   ```markdown
   ---
   source: <original file/url>
   notebook_id: <id>
   date: <YYYY-MM-DD>
   question: <query used>
   ---
   <analysis content>
   ```
9. **Update INDEX.md**: append entry to `~/.claude/nlm-docs/INDEX.md`
10. **Report**: show notebook ID + saved file path to user

### Mode 2: Individual commands
Map user command to nlm CLI:

| User command | nlm CLI |
|---|---|
| `login` | `nlm login` |
| `login --check` | `nlm login --check` |
| `list` | `nlm notebook list` |
| `create "<name>"` | `nlm notebook create "<name>"` |
| `delete <id>` | `nlm notebook delete <id>` |
| `add <id> <source>` | `nlm source add <id> "<source>"` |
| `sources <id>` | `nlm source list <id>` |
| `query <id> "<q>"` | `nlm report create <id> --format "Create Your Own" --prompt "<q>" --language ko -y` |
| `summary <id>` | `nlm report create <id> --format "Briefing Doc" --language ko -y` |
| `report <id>` | `nlm report create <id>` |
| `quiz <id>` | `nlm quiz create <id>` |
| `audio <id>` | `nlm audio create <id>` |

## Command Reference (nlm CLI)

```bash
# Auth
nlm login                              # Browser auth
nlm login --check                      # Check auth status
nlm login --profile work               # Multiple Google accounts

# Notebook
nlm notebook list                      # List notebooks
nlm notebook create "name"             # Create (returns ID)
nlm notebook delete <id>               # Delete

# Source
nlm source add <id> <path_or_url>      # Add source (file or URL)
nlm source list <id>                   # List sources

# Chat/Query
nlm chat query <id> "question"         # Single query
nlm chat settings <id>                 # Chat settings

# Content generation
nlm audio create <id>                  # Podcast audio
nlm download audio <id> -o out.mp3     # Download audio
nlm report create <id>                 # Report
nlm quiz create <id>                   # Quiz
nlm flashcards create <id>            # Flashcards

# Share
nlm share set <id> --public            # Public share

# Batch/Pipeline
nlm batch <command> --all              # Run on all notebooks
nlm pipeline run <pipeline.yaml>       # Multi-step pipeline

# Alias (bookmark notebook IDs)
nlm alias set mymanual <id>            # Set alias
nlm alias list                         # List aliases
```

## Rules
- ALWAYS set PATH before nlm commands (see Environment section)
- Auth check first on any error → `nlm login --check`
- Double-quote file paths with Korean/spaces
- `analyze` mode default question: "이 문서의 핵심 내용을 구조적으로 정리해줘"
- Large manuals (100p+) handled by NotebookLM natively, no splitting needed
- Format results in Korean
- ALWAYS report notebook ID to user for follow-up queries
- On error, check auth status first with `nlm login --check`
- After manual analysis, suggest `/manual-import` for protocol extraction if applicable
- Use `--debug` flag for troubleshooting: `nlm --debug <command>`
