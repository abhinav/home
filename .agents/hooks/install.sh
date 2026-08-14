#!/usr/bin/env bash

set -euo pipefail

hook_command="$HOME/.agents/hooks/session-start.sh"

install_hook() {
	local hooks_file=$1
	local settings_directory
	local temporary_file

	settings_directory=$(dirname "$hooks_file")
	mkdir -p "$settings_directory"

	if [[ ! -e $hooks_file ]]; then
		printf '{}\n' >"$hooks_file"
		chmod 600 "$hooks_file"
	fi

	temporary_file=$(mktemp "$settings_directory/.hooks.json.tmp.XXXXXX")
	trap 'rm -f "$temporary_file"' RETURN

	jq --arg command "$hook_command" '
		{
			"matcher": "startup|resume",
			"hooks": [{
				"type": "command",
				"command": $command,
				"timeout": 5,
				"statusMessage": "Selecting session personality"
			}]
		} as $hook_group
		| .hooks //= {}
		| .hooks.SessionStart //= []
		| .hooks.SessionStart |= (
			map(.hooks = [.hooks[]? | select(.command != $command)])
			| map(select(.hooks | length > 0))
			+ [$hook_group]
		)
	' "$hooks_file" >"$temporary_file"

	chmod --reference="$hooks_file" "$temporary_file" 2>/dev/null ||
		chmod "$(stat -f '%Lp' "$hooks_file")" "$temporary_file"
	mv "$temporary_file" "$hooks_file"
	trap - RETURN

	printf 'Installed SessionStart hook in %s\n' "$hooks_file"
}

codex_home=${CODEX_HOME:-"$HOME/.codex"}
claude_config_directory=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"}

install_hook "$codex_home/hooks.json"
install_hook "$claude_config_directory/settings.json"
