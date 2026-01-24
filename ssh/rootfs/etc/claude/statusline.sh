#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
model=$(echo "$input" | jq -r '.model.display_name')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
LAVENDER='\033[38;2;178;185;244m'
RESET='\033[0m'

# Get relative path from project root (empty for root dir)
if [[ "$current_dir" == "$project_dir" ]]; then
  rel_dir=""
elif [[ "$current_dir" == "$project_dir"/* ]]; then
  rel_dir="${current_dir#$project_dir/}"
else
  rel_dir="$current_dir"
fi

# Get Home Assistant version
ha_version=$(ha core info --raw-json 2>/dev/null | jq -r '.data.version // empty')
if [ -z "$ha_version" ]; then
  ha_version=""
fi

# Calculate context window percentage and build progress bar
usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
  current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  size=$(echo "$input" | jq '.context_window.context_window_size')
  pct=$((current * 100 / size))
else
  pct=0
fi

# Build ASCII progress bar (10 chars wide)
bar_width=10
filled=$((pct * bar_width / 100))
empty=$((bar_width - filled))
bar=$(printf '%*s' "$filled" '' | tr ' ' '█')$(printf '%*s' "$empty" '' | tr ' ' '░')
context_info="${LAVENDER}${bar}${RESET} ${pct}%"

# Build status line
status=""

if [ -n "$rel_dir" ]; then
  status="${CYAN}${rel_dir}${RESET}"
fi

if [ -n "$ha_version" ]; then
  if [ -n "$status" ]; then
    status="$status ${GREEN}HA ${ha_version}${RESET}"
  else
    status="${GREEN}HA ${ha_version}${RESET}"
  fi
fi

if [ -n "$status" ]; then
  status="$status | "
fi

status="${status}${YELLOW}${model}${RESET} | ${context_info}"

printf '%b' "$status"
