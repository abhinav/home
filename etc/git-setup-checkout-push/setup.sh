#!/bin/bash
set -e

# From https://github.com/jcorbin/home/blob/main/.local/bin/git-setup-worktree-push

# shellcheck disable=2034
SUBDIRECTORY_OK=true
# shellcheck source=/dev/null
. "$(git --exec-path)"/git-sh-setup

[ "$(git rev-parse --is-bare-repository)" == "true" ] && \
	die "fatal: $0 cannot be used without a working tree"

cd "$(dirname "$0")"

cp ./post-receive \
	"$GIT_DIR/hooks/post-receive" \
	|| die "Cannot find githook-update-worktree-post-receive"

cp ./update \
	"$GIT_DIR/hooks/update" \
	|| die "Cannot find githook-update-worktree-update"

chmod +x "$GIT_DIR"/hooks/{update,post-receive}

git --git-dir="$GIT_DIR" config receive.denyCurrentBranch ignore
