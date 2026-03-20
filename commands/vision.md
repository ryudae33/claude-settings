---
name: vision
description: "FA vision inspection: camera management, defect detection (scratch/dent/stain), CV/AI pipeline auto-generation, inspection execution, web result viewer. Use when user asks about vision inspection, camera setup, image defect analysis, quality inspection, or building inspection pipelines. Also triggers on '비전 검사', '외관 검사', 'defect detection', '카메라'."
---

# VISION - FA Vision Inspection Tool

## Project Path
`~/.claude/tools/vision/`

## Prerequisites
- Working directory: `cd ~/.claude/tools/vision`
- Python venv: `.venv/Scripts/python`
- Run CLI: `.venv/Scripts/python -m vision {command}`

## Input
$ARGUMENTS (task description or command)

## Core Workflow
```
[1] Camera scan/connect → [2] Web live view → [3] Capture samples
→ [4] Claude analyzes image (directly, not via API) → [5] Generate pipeline code
→ [6] Test inspection → [7] If uncertain, ask Gemini via /gem → [8] Export
```

## Actions

### 1. Camera Management
```bash
cd ~/.claude/tools/vision
.venv/Scripts/python -m vision camera scan          # find cameras
.venv/Scripts/python -m vision camera connect {serial}
.venv/Scripts/python -m vision camera capture --output data/raw/{project}/ --count 5
.venv/Scripts/python -m vision camera status
```

### 2. Web Server (live view + results)
```bash
.venv/Scripts/python -m vision web start             # http://localhost:8470
# Pages:
#   /camera/preview     — live camera stream
#   /inspect/results    — inspection results with images
```

### 3. Image Analysis (Claude directly — NO API key needed)
When the user provides sample images for analysis:
1. Read the image file using the Read tool (Claude Code can see images)
2. Analyze: material, surface, defect types, lighting condition
3. Decide: classical_cv or ai_model
4. Generate analysis JSON and save to `data/projects/{name}/analysis.json`

Analysis JSON format:
```json
{
    "image_quality": {"inspectable": true, "brightness": "", "focus": "", "uniformity": ""},
    "target_analysis": {"material": "", "surface": "", "defect_types": [], "background_complexity": ""},
    "strategy": {
        "recommended": "classical_cv or ai_model",
        "reason": "",
        "algorithms": [{"step": "", "params": {}, "purpose": ""}]
    },
    "lighting_advice": {"current": "", "recommendation": "", "workaround": ""},
    "confidence": 0.0,
    "summary": ""
}
```

### 4. Pipeline Generation
After analysis, generate a Python pipeline file:
- File: `data/projects/{name}/{name}_pipeline.py`
- Must inherit `InspectionPipeline` from `vision.inspect.pipeline_base`
- Must return `InspectionResult` from `vision.inspect.result`
- Include defect overlay on result image (red bounding boxes)

### 5. Inspection Execution
```bash
# Single image
.venv/Scripts/python -m vision inspect run {name} {image_path}

# Batch (entire folder)
.venv/Scripts/python -m vision inspect batch {name} {image_dir}

# View results in web
# http://localhost:8470/inspect/results
```

### 6. Gemini Review (when results are uncertain)
When inspection results are ambiguous or accuracy is poor:
1. Use /gem skill to send the result image + analysis to Gemini
2. Ask for 2nd opinion on: algorithm choice, parameter tuning, false NG issues
3. Apply Gemini feedback to adjust pipeline parameters

### 7. Project Management
```bash
.venv/Scripts/python -m vision inspect create {name} --type classical_cv --desc "description"
.venv/Scripts/python -m vision inspect list
```

### 8. Export (Phase 4 — not yet implemented)
```bash
.venv/Scripts/python -m vision export script {name}   # Python script
.venv/Scripts/python -m vision export dll {name}       # C# DLL
```

## Project Structure Reference
Read `~/.claude/tools/vision/CLAUDE.md` for full file map.

Key directories:
- `src/vision/cli/` — CLI commands (Typer)
- `src/vision/web/` — Web server (FastAPI + WebSocket)
- `src/vision/camera/` — Camera interface + Basler implementation
- `src/vision/inspect/` — Inspection engine (analyzer, pipeline, result)
- `data/projects/` — Inspection projects (pipeline code + config)
- `data/raw/` — Captured images
- `data/results/` — Inspection result images

## Important Rules
- **Max plan**: No API key. Claude Code directly analyzes images and generates code.
- **200-line rule**: Each file max 200 lines
- **Classical CV first**: Only use AI model when CV is insufficient
- **Web viewer**: Always remind user to check results at http://localhost:8470/inspect/results
- **Gemini 2nd opinion**: Use /gem when inspection results are uncertain
