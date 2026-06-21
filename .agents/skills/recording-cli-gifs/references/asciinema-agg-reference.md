# Asciinema And Agg Reference

Use this reference for scripted,
non-interactive CLI and TUI GIF recordings with `asciinema` and `agg`.

## Command-Line Commands

`asciinema record` records a terminal session to an asciicast file.
The command starts either the default shell
or the command passed with `--command`.
For automated skill use,
always pass a finite command or script with `--command`.

`agg` converts an asciicast file or URL to a GIF.
For local skill use,
use a local asciicast file.
Do not use remote upload or hosted recording paths.

## Basic Pipeline

Request escalation for `asciinema record`
because the recorder opens terminal capture resources.
Remove `NO_COLOR` at the recorder boundary
so color-aware commands can emit color inside the recording.
Keep `NO_COLOR` only when colorless output or `NO_COLOR` behavior
is the subject of the demo.
For asciinema recordings,
set `TERM=xterm-256color` at the same recorder boundary.

```bash
env -u NO_COLOR TERM=xterm-256color \
  asciinema record --headless --overwrite --return \
  --window-size 80x24 \
  --command "bash demo.sh" \
  demo.cast
```

Run `agg` normally after the cast exists,
unless sandboxing blocks conversion.

```bash
agg --theme github-dark --font-size 16 --idle-time-limit 1 \
  --last-frame-duration 2 \
  demo.cast demo.gif
```

## Script Shape

The recorded command or script can set up state,
print narration,
sleep for viewer pacing,
run the demonstrated command,
redraw the screen,
and leave a readable final state before exiting.

## Headless Recording

Always use `--headless` for Codex-run asciinema recordings.
With `--headless`,
asciinema runs the child command and records its output
without using the current terminal for live input or output.
This is not for background execution:
the `asciinema record` command still runs in the foreground
and exits when the child command exits.

## Child Shells And Scripts

`--command` may launch a child shell,
as long as the child shell exits by itself.
These are valid shapes:

```bash
env -u NO_COLOR TERM=xterm-256color \
  asciinema record --headless --overwrite --return \
  --window-size 80x24 \
  --command "bash demo.sh" \
  demo.cast

env -u NO_COLOR TERM=xterm-256color \
  asciinema record --headless --overwrite --return \
  --window-size 80x24 \
  --command "bash -lc 'make demo && ./demo'" \
  demo.cast
```

Prefer a script file over a heavily quoted `bash -lc` command
when the demo has staged output,
sleeps,
redraws,
or setup.
Script files are easier to inspect before recording
and reduce shell-quoting failures.

Asciinema sets `ASCIINEMA_SESSION` inside the recorded session.
That can be useful when diagnosing whether a command is running
inside the recorder.

## Useful Agg Options

Common `agg` controls:

- `--theme <name>` chooses a named theme.
- `--font-size <px>` controls text size.
- `--line-height <n>` controls line spacing.
- `--speed <n>` adjusts playback speed.
- `--idle-time-limit <secs>` caps pauses.
- `--fps-cap <n>` limits frame rate.
- `--last-frame-duration <secs>` controls final dwell.
- `--cols <n>` and `--rows <n>` override terminal dimensions.
- `--select <selector>` renders a time,
  marker,
  percent,
  or event subset.

Use local `agg --help` as the source of truth
when installed behavior may differ from this reference.

## Inspecting Casts

Asciicast v3 files are line-oriented.
The first line is JSON metadata.
Later lines are event records.
For example:

```json
{"version":3,"term":{"cols":80,"rows":10},"timestamp":1782065682,"command":"bash demo.sh","env":{"SHELL":"/bin/zsh"}}
[0.013, "o", "visible output\r\n"]
[0.000, "x", "0"]
```

Useful event types include:

- `"o"` for terminal output;
- `"x"` for exit status.

Inspect the cast directly when debugging TUI output,
ANSI escape sequences,
screen redraws,
unexpected colors,
or missing final output.
Use `head`,
`sed`,
or a structured JSON tool for the raw events.
