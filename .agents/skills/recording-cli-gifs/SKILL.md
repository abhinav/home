---
name: recording-cli-gifs
description: >
  Use when creating, editing, validating, or rendering `.tape` files
  for CLI and TUI demo GIFs with VHS or Betamax,
  including terminal setup, Hide/Show sections, waits, sleeps,
  and reproducible demo artifacts.
---

# Recording CLI GIFs

## Scope

Use this skill for CLI and TUI demos recorded with Betamax or VHS.
Keep recordings local.
Do not publish recordings to hosted services.

## Required Operating Rules

Run tape renders with escalated privileges
using the render form in [Running Recorders](#running-recorders).
Betamax and VHS open PTY and recording resources while rendering,
and sandboxed execution can fail before the tape starts.

Do not request escalated privileges for informational or syntax-check commands
such as `vhs validate`, `vhs themes`, `vhs manual`,
`betamax validate`, or `betamax themes`.

Before rendering,
prefer the selected recorder's validate command
to catch syntax errors.
Validation does not replace rendering and visual inspection.

After rendering,
verify the artifact exists and is the expected file type.
Use `file`, `ls -lh`, or a visual check when the output is a GIF.

Before choosing commands, check whether `vhs` or `betamax` is installed.
Prefer `vhs` when it is available and works for the tape.
Use `betamax` only when `vhs` is unavailable or rendering does not work.

## Tape Design Workflow

Start from the viewer's task,
then design the whole demo around the viewer's experience:
what should the viewer notice,
what should the viewer be able to read,
what can the viewer infer from motion or terminal state,
and what should be clear before the GIF restarts?
Script the minimum terminal path that makes those points legible.

1. Choose the output path and terminal dimensions.
2. Put `Require`, `Output`, and `Set` commands at the top.
3. Decide which terminal states,
   commands,
   motion,
   and pauses should be visible to the viewer.
4. Use `Hide` for setup or cleanup
   that is not part of the visible demo.
5. Use a prepared fixture, existing example directory,
   temporary directory, or setup script according to the demo's needs.
6. Type and execute only the commands or TUI interactions
   the viewer needs to understand.
7. Use `Wait` for state-dependent output
   and `Sleep` for intentional viewer dwell time.
8. Add final dwell time only when the viewer needs time
   before the GIF restarts.

If setup takes more than a few simple commands,
put setup in a script and invoke the script from the hidden section.
This keeps the tape readable
and avoids making the recorder type a long setup transcript
into the fake terminal.

## Common CLI/TUI Pattern

Use this as a shape,
not as a literal template for every demo:

```tape
Output "demo.gif"
Require git
Require my-cli
Set Shell "bash"
Set FontSize 16
Set Width 900
Set Height 520
Set Padding 10

Hide
Type "/path/to/setup-demo-state.sh"
Enter
Type "clear"
Enter
Show

Sleep 500ms
Type "my-cli status"
Enter
Wait+Screen /Ready/
Sleep 1s

Type "my-cli choose"
Enter
Sleep 1s
Down
Sleep 300ms
Enter
Wait+Screen /Complete/
```

Use short sleeps after visible commands
when the viewer needs to perceive a transition.
Add a final sleep when the viewer needs time
to absorb the final visible state before the loop begins again.

## Writing Visible Interactions

Prefer visible commands that teach the user the workflow.
Avoid showing setup,
fixture generation,
dependency builds,
or cleanup unless those are the point of the demo.
Keep the demonstrated command representative of how a user would run it.
Do not prefix the render command or the demonstrated command with `TERM=...`
unless the demo is specifically about terminal-type behavior.
Let the recorder provide the terminal environment for the recording.

For TUI prompts,
script realistic key presses:
`Down`, `Up`, `Enter`, `Tab`, `Backspace`, `Ctrl+C`, and similar commands.
Add small sleeps between navigation keys
so the resulting GIF shows movement instead of a jump cut.

For terminal output that can vary in timing,
prefer `Wait`, `Wait+Screen`, or `Wait+Line`
over fixed sleeps.
Use fixed `Sleep` for pacing or animation capture.

## Hide And Show

`Hide` stops frame capture while commands still run in the fake terminal.
`Show` resumes capture.

The common setup sequence is:

```tape
Hide
Type "setup command or setup script"
Enter
Type "clear"
Enter
Show
```

The `clear` before `Show` matters.
It prevents hidden setup output from being visible
when recording resumes.

If hidden setup must type many commands,
prefer this shape:

```tape
Hide
Type "/absolute/path/to/setup-demo.sh"
Enter
Type "clear"
Enter
Show
```

Keep cleanup hidden as well when cleanup is needed for local hygiene.

## Running Recorders

Request escalation for tape rendering:

```bash
env -u NO_COLOR betamax run demo.tape
env -u NO_COLOR vhs demo.tape
```

Use the VHS form when `vhs` is available and works for the tape.
Use the Betamax form when `vhs` is unavailable
or when VHS rendering does not work.

Always remove `NO_COLOR` at the recorder process boundary.
This lets color-aware commands emit color inside the recording.
Do not set `TERM` on the recorder invocation for this purpose;
the recorder provides the terminal type inside the recording session.

Do not rationalize a normal sandboxed render as faster,
temporary,
or acceptable because a fallback is possible.
Escalation is the starting condition for rendering a tape,
not a retry strategy.

Run syntax and reference commands normally:

```bash
vhs validate demo.tape
vhs themes
vhs manual

betamax validate demo.tape
betamax themes
```

## References

Read [references/tape-reference.md](references/tape-reference.md)
when writing unfamiliar tape commands,
checking command ordering,
or deciding between `Wait`, `Sleep`, `Hide`, `Show`, and key commands.

Use `vhs manual` as the local source of truth
when installed VHS behavior may differ from the reference.

Use `betamax help` or command-specific Betamax help
as the local source of truth
when installed Betamax behavior may differ from the reference.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents
that have empty context windows.
