# Asciinema and agg reference

Use this reference for scripted,
non-interactive CLI and TUI GIF recordings with `asciinema` and `agg`.

## Record a finite command

`asciinema record` writes an asciicast, running the default shell
or the command passed with `--command`.
For automated skill use, always supply a finite command or script with `--command`.
Always use `--headless` for Codex-run recordings: the child runs and its output is recorded
without live input or output through the current terminal.
The recorder still runs in the foreground and exits with the child;
headless does not mean background execution.

For every concrete plan or recording, show or use the complete command below
as one contract so omissions are visible before recording starts.
Request escalation because `asciinema record` opens terminal capture resources.
At the recorder boundary, set `TERM=xterm-256color`.
Remove `NO_COLOR` there so color-aware commands can emit color,
unless colorless output or `NO_COLOR` behavior is the demo's subject.

```bash
env -u NO_COLOR TERM=xterm-256color \
  asciinema record --headless --overwrite --return \
  --window-size 80x24 \
  --command "bash demo.sh" \
  demo.cast
```

`agg` converts an asciicast file or URL to GIF.
For local skill use, use only a local cast; do not use remote upload
or hosted recording paths.
Run `agg` normally after the cast exists, unless sandboxing blocks conversion.

```bash
agg --theme github-dark --font-size 16 --idle-time-limit 1 \
  --last-frame-duration 2 \
  demo.cast demo.gif
```

## Scripts and child shells

The command or script can set up state, print narration,
sleep for viewer pacing, run the demonstrated command, redraw the screen,
and leave a readable final state before exiting.
A child shell is valid if it exits by itself; another valid command is:

```bash
env -u NO_COLOR TERM=xterm-256color \
  asciinema record --headless --overwrite --return \
  --window-size 80x24 \
  --command "bash -lc 'make demo && ./demo'" \
  demo.cast
```

Prefer a script file to heavily quoted `bash -lc` for staged output,
sleeps, redraws, or setup: it is easier to inspect and reduces quoting failures.

Asciinema sets `ASCIINEMA_SESSION` inside the recorded session.
That can be useful when diagnosing whether a command is running
inside the recorder.

## Useful agg options

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

## Inspecting casts

Asciicast v3 files are line-oriented: first JSON metadata, then event records:

```json
{"version":3,"term":{"cols":80,"rows":10},"timestamp":1782065682,"command":"bash demo.sh","env":{"SHELL":"/bin/zsh"}}
[0.013, "o", "visible output\r\n"]
[0.000, "x", "0"]
```

`"o"` marks terminal output; `"x"` marks exit status.

Inspect raw events with `head`, `sed`, or a structured JSON tool
when debugging TUI output, ANSI escape sequences, screen redraws,
unexpected colors, or missing final output.
