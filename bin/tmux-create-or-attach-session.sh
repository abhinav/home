#!/bin/sh

ATTACH_ARGS=""
NEW_ARGS=""
if [ -n "$1" ]; then
	ATTACH_ARGS="$ATTACH_ARGS -t $1"
	NEW_ARGS="$NEW_ARGS -s $1"
fi

/usr/local/bin/tmux attach $ATTACH_ARGS || \
	/usr/local/bin/tmux new-session $NEW_ARGS
