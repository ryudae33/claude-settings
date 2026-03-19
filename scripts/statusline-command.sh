#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Progress bar (10 chars)
FILLED=$((PCT * 10 / 100))
EMPTY=$((10 - FILLED))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done

# Warning at 70%
WARN=""
if [ "$PCT" -ge 70 ]; then
  WARN=" ⚠ COMPACT recommended"
fi

echo "[$MODEL] $BAR ${PCT}%${WARN}"
