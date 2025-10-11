#!/bin/bash

# Read the JSON input from stdin.
input=$(cat)

if ! command -v terminal-notifier >/dev/null 2>&1; then
	exit 0
fi

echo "$input" | jq -r .message | terminal-notifier -title "Claude Code"
