---
name: VISION Project
description: VISION - LLM-based FA vision inspection tool at ~/.claude/tools/vision/. Camera + CV/AI pipeline + web viewer. Phase 1-2 done, syncs across PCs via claude-sync.
type: project
---

VISION project at `~/.claude/tools/vision/` — LLM-based FA vision inspection tool for personal use at factory sites. Stored in .claude for cross-PC sync via claude-sync.

**Why:** Automate vision inspection setup that traditionally depends on skilled engineer's experience. Not a product — a personal tool to speed up field work.

**How to apply:**
- Use `/vision` skill for all vision inspection tasks
- Max plan: Claude Code directly analyzes images (no API key)
- Web viewer at http://localhost:8470 for image/result viewing
- When results are uncertain, use `/gem` for Gemini 2nd opinion
- Classical CV first, AI model only when CV fails

**Status (2026-03-20):**
- Phase 1 done: project structure, camera (Basler pypylon), CLI (Typer), web live view (FastAPI + WebSocket)
- Phase 2 in progress: inspect analyze/build/run working with sample image (metal scratch detection, 3/3 detected, 14ms)
- Phase 3-5 not started: AI pipeline, export, skill integration

**Tech:** Python 3.13 / uv / Typer + FastAPI + WebSocket / pypylon / OpenCV / YOLO / ONNX RT
