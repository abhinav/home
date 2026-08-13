#!/usr/bin/env bash

set -euo pipefail

codex_home=${CODEX_HOME:-"$HOME/.codex"}
hooks_file="$codex_home/hooks.json"
hook_command="$HOME/.agents/hooks/session-start.sh"

mkdir -p "$codex_home"

if [[ ! -e $hooks_file ]]; then
	printf '{}\n' >"$hooks_file"
	chmod 600 "$hooks_file"
fi

temporary_file=$(mktemp "$codex_home/.hooks.json.tmp.XXXXXX")
trap 'rm -f "$temporary_file"' EXIT

jq --arg command "$hook_command" '
  {
    "matcher": "startup",
    "hooks": [{
      "type": "command",
      "command": $command,
      "timeout": 5,
      "statusMessage": "Selecting session personality"
    }]
  } as $hook_group
  | .hooks //= {}
  | .hooks.SessionStart //= []
  | if any(
      .hooks.SessionStart[]?.hooks[]?;
      .command == $command
    ) then
      .hooks.SessionStart |= map(
        if any(.hooks[]?; .command == $command) then
          $hook_group
        else
          .
        end
      )
    else
      .hooks.SessionStart += [$hook_group]
    end
' "$hooks_file" >"$temporary_file"

chmod --reference="$hooks_file" "$temporary_file" 2>/dev/null ||
	chmod "$(stat -f '%Lp' "$hooks_file")" "$temporary_file"
mv "$temporary_file" "$hooks_file"
trap - EXIT

printf 'Installed SessionStart hook in %s\n' "$hooks_file"
