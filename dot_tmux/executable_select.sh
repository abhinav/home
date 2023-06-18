#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

MATCH_TEXT="$1"
PANE_ID="$FASTCOPY_TARGET_PANE_ID"

tmux \
	copy-mode -t "$PANE_ID" ';' \
	send-keys -t "$PANE_ID" -X search-backward-text "$MATCH_TEXT" ';' \
	send-keys -t "$PANE_ID" -X begin-selection ';' \
	send-keys -t "$PANE_ID" -X -N "$((${#MATCH_TEXT} - 1))" cursor-right ';' \
	send-keys -t "$PANE_ID" -X end-selection
