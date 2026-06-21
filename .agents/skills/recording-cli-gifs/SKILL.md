---
name: recording-cli-gifs
description: >
  Use when creating, editing, validating, rendering, or debugging
  local CLI and TUI demo GIFs with asciinema+agg, VHS, or Betamax,
  including recorder selection, scripted terminal recordings,
  `.tape` files, Hide/Show sections, waits, sleeps,
  and reproducible demo artifacts.
---

# Recording CLI GIFs

## Scope

Use this skill for local CLI and TUI demo GIFs recorded with
asciinema+agg, VHS, or Betamax.
Keep recordings local.
Do not publish recordings to hosted services.

## Required Operating Rules

Choose the recorder from the demo's interaction model
before writing commands.
Use asciinema+agg for scripted,
non-interactive recordings.
Use VHS or Betamax when the demo needs typed input,
TUI navigation,
recorder-observed waits,
or other tape choreography.

Run recorder commands with escalated privileges
using the forms in [Running Recorders](#running-recorders).
Recorders open PTY,
terminal capture,
or rendering resources,
and sandboxed execution can fail before the recording starts.

Do not request escalated privileges for informational,
syntax-check,
or inspection commands such as `vhs validate`,
`vhs themes`, `vhs manual`, `betamax validate`, `betamax themes`,
`asciinema --help`, or `agg --help`.

Before rendering,
use the selected recorder's syntax checks when they exist.
For tapes,
prefer `vhs validate` or `betamax validate`.
For asciinema+agg,
inspect the script or command that asciinema will run.
Validation does not replace recording,
rendering,
and visual inspection.

After rendering,
verify the artifact exists and is the expected file type.
Use `file`, `ls -lh`, or a visual check when the output is a GIF.

Before choosing tape commands,
check whether `vhs` or `betamax` is installed.
Prefer `vhs` for ordinary tapes when it is available and works.
Use `betamax` when VHS is unavailable,
VHS rendering does not work,
or the demo needs Betamax-specific behavior or styling.

## Recorder Selection

Use asciinema+agg when the whole recording can be driven by one finite
command,
script,
or child shell.
The asciinema recorder command should usually use the `env -u NO_COLOR`
wrapper shown in [Running Recorders](#running-recorders).
For asciinema+agg recordings,
set `TERM=xterm-256color` at the recorder process boundary
so child commands that inspect terminal capabilities emit ANSI color.
Good fits include showing a command running,
printing staged messages for the viewer,
running a shell script that sleeps between visible states,
capturing real command output,
or recording terminal animation produced by a script.

Use VHS or Betamax when the recording needs interactive input
after the recorder starts.
Good fits include visible typing,
arrow-key navigation,
interactive prompts,
TUI selection movement,
recorder-observed waits,
screenshots,
or precise tape-controlled pacing.
If the recorder must deliver keys to the program,
choose VHS or Betamax.

For asciinema+agg,
do not start an interactive `asciinema record <file>` session.
Use the escalated recorder form with a finite command or script:
`env -u NO_COLOR TERM=xterm-256color asciinema record --headless --return --command ...`.
The command may start a child shell,
such as `bash demo.sh` or `bash -lc '...'`,
as long as that shell exits by itself.
Do not treat "the keys are known" as enough reason to use asciinema
when the recorder would still need to send those keys.
Use asciinema+agg only if the program or script drives that behavior
and exits by itself.

If either recorder family could work,
prefer asciinema+agg for a naturally scripted command demo
and prefer VHS/Betamax for a viewer-facing interaction demo.

## Demo Design Workflow

Start from the viewer's task,
then design the whole demo around the viewer's experience:
what should the viewer notice,
what should the viewer be able to read,
what can the viewer infer from motion or terminal state,
and what should be clear before the GIF restarts?
Script the minimum terminal path that makes those points legible.

1. Choose the output path and terminal dimensions.
2. Decide which terminal states,
   commands,
   motion,
   and pauses should be visible to the viewer.
3. Keep setup or cleanup out of the visible demo.
   For VHS or Betamax,
   use `Hide`,
   `clear`,
   and `Show`.
   For asciinema+agg,
   run setup before the first visible output in the child command.
4. Use a prepared fixture, existing example directory,
   temporary directory, or setup script according to the demo's needs.
5. Show only the commands,
   output,
   or TUI interactions
   the viewer needs to understand.
6. Use recorder-observed waits for tape-controlled terminal state.
   Use script-side waits for asciinema+agg.
   Use fixed sleeps for viewer pacing or animation capture.
7. Add final dwell time only when the viewer needs time
   before the GIF restarts.

For VHS or Betamax,
put `Require`,
`Output`,
and most `Set` commands at the top of the tape.
Use `Hide`,
setup commands or a setup script,
`clear`,
and `Show`
for setup that should not appear in the GIF.
Read [references/tape-reference.md](references/tape-reference.md)
for tape command details.

For asciinema+agg,
put setup and visible motion in the finite command or script.
The script can print messages,
sleep between states,
clear or redraw the terminal,
run the demonstrated command,
and leave a readable final state before exiting.
Read [references/asciinema-agg-reference.md](references/asciinema-agg-reference.md)
for scripted recording details.

## Writing Visible Interactions

Prefer visible commands that teach the user the workflow.
Avoid showing setup,
fixture generation,
dependency builds,
or cleanup unless those are the point of the demo.
Keep the demonstrated command representative of how a user would run it.
Do not prefix the demonstrated command with `TERM=...`
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

For asciinema+agg recordings,
the visible interaction is the output produced by the child command.
Make the child command representative of how the user would run it,
or use a small demo script when the recording needs staged narration,
delays,
or terminal redrawing.
Do not rely on sending input after asciinema starts.

## Running Recorders

Request escalation for recorder commands.
By default,
remove `NO_COLOR` at the recorder process boundary.
This lets color-aware commands emit color inside the recording.
Keep `NO_COLOR` only when colorless output or `NO_COLOR` behavior
is the subject of the demo.
For asciinema recordings,
also set `TERM=xterm-256color` at the recorder process boundary by default.

For asciinema recording,
request escalation for the `asciinema record` command:

```bash
env -u NO_COLOR TERM=xterm-256color \
  asciinema record --headless --overwrite --return \
  --window-size 80x24 \
  --command "bash demo.sh" \
  demo.cast
```

Run `agg` normally after the cast exists,
unless sandboxing blocks conversion:

```bash
agg --theme github-dark --font-size 16 --idle-time-limit 1 \
  demo.cast demo.gif
```

For tape rendering:

```bash
env -u NO_COLOR betamax run demo.tape
env -u NO_COLOR vhs demo.tape
```

Use the VHS form when `vhs` is available and works for the tape.
Use the Betamax form when VHS is unavailable,
VHS rendering does not work,
or the demo needs Betamax-specific behavior or styling.

Do not add `TERM=...` to tape recorder invocations or visible demo commands
for ordinary color stability.
Use `TERM=xterm-256color` only on the asciinema recorder invocation.

Do not rationalize a normal sandboxed recorder run as faster,
temporary,
or acceptable because a fallback is possible.
Escalation is the starting condition for recording,
not a retry strategy.

Run syntax and reference commands normally:

```bash
vhs validate demo.tape
vhs themes
vhs manual

betamax validate demo.tape
betamax themes
asciinema --help
asciinema record --help
agg --help
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

Read [references/asciinema-agg-reference.md](references/asciinema-agg-reference.md)
when choosing asciinema+agg,
writing a scripted recording,
debugging cast output,
or deciding whether the demo needs tape-controlled interactivity.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents
that have empty context windows.
