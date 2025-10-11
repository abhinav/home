#!/bin/bash

# Read the JSON input from stdin.
input=$(cat)

added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

sections=()
if [[ "$added" -gt 0 ]]; then
	sections+=("\033[32m+${added}\033[0m")
fi
if [[ "$removed" -gt 0 ]]; then
	sections+=("\033[31m-${removed}\033[0m")
fi

echo -e "${sections[@]}"
