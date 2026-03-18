---
name: search
description: "Web search for error resolution, API docs, library usage, device specs/manuals, protocol documentation. Use when the user asks to search the web, look up errors, find documentation, or research technical topics."
---

# Web Search (Direct — no subagent)

Search the web for: `$ARGUMENTS`

Do NOT spawn a subagent. Use WebSearch and WebFetch tools directly.

## Steps

1. **WebSearch** with the query from $ARGUMENTS
   - Use concise, targeted search terms
   - If Korean query, try both Korean and English search terms
2. **Review results** — pick the 2-3 most relevant links
3. **WebFetch** the top results to get detailed content
4. **Summarize** findings concisely:
   - Direct answer to the question
   - Code examples if applicable
   - Source URLs for reference

## Rules
- Max 3 WebFetch calls — don't crawl endlessly
- Prefer official docs, GitHub repos, Stack Overflow
- For error messages: search the exact error string in quotes
- For device/protocol specs: include manufacturer name + model number
- Present results in Korean with original English terms preserved
