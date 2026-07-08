# Tape Reference

This reference summarizes common `.tape` commands for VHS.
Use `vhs manual` for installed VHS behavior.

## Command-Line Commands

- `vhs <file>.tape` renders a tape and writes its declared outputs.
- `vhs validate <file>...` parses tape files without running them.
- `vhs themes` lists available theme names.
- `vhs manual` prints the installed manual.

Rendering a tape requires escalated privileges
and should usually use `env -u NO_COLOR vhs <file>.tape`.
Keep `NO_COLOR` only when colorless output or `NO_COLOR` behavior
is the subject of the demo.
Run informational and syntax-check commands such as `vhs validate`,
`vhs themes`, and `vhs manual` normally.

## Tape Command Ordering

Put `Require`, `Output`, and most `Set` commands at the top of the tape.
VHS expects requirements before non-setting work.

`TypingSpeed` is the setting most often adjusted near the action,
but prefer keeping all settings near the top unless a local tape needs
per-command typing speed.

## Output

`Output <path>` declares where the recorder writes render results.
Common outputs are:

- `Output demo.gif`
- `Output demo.mp4`
- `Output demo.webm`
- `Output frames/`

Multiple `Output` lines can produce multiple formats from one tape.
For frame directory outputs,
use `Output frames/`.
For skill use,
prefer GIF unless the user asks for another artifact.

## Require

`Require <program>` fails early when a required executable is absent.
Use it for demo-critical programs such as the CLI under test,
`git`, `bash`, or helper tools.

Example:

```tape
Require git
Require my-cli
```

## Settings

Use `Set` commands to control the terminal and render.
Common settings for CLI and TUI demos are:

- `Set Shell "bash"`:
  choose the shell used inside the recording.
- `Set FontSize 16`:
  choose readable text size.
- `Set FontFamily "..."`:
  choose a font when the default is not acceptable.
- `Set Width 900` and `Set Height 520`:
  choose the terminal size.
- `Set Padding 10`:
  add frame padding around the terminal content.
- `Set Framerate 24`:
  choose capture framerate.
- `Set TypingSpeed 1ms`:
  control typing speed globally.
- `Set Theme "Theme Name"` or `Set Theme { ... }`:
  choose a named or JSON theme.
- `Set PlaybackSpeed 1.0`:
  control final playback speed.
- `Set WaitTimeout 30s` and `Set WaitPattern /.../`:
  adjust wait defaults.

Use dimensions that match the content.
Small TUI widgets often need a smaller terminal than full CLI workflows.

## Typing

`Type "<text>"` types characters into the terminal.
It does not press enter unless paired with `Enter`.

Examples:

```tape
Type "my-cli status"
Enter
```

Use `Type@<time> "<text>"` for per-command typing speed
when a command should be visibly typed more slowly.

## Keys And Navigation

Use key commands for prompts and TUIs:

- `Enter`, `Tab`, `Space`, `Backspace`
- `Up`, `Down`, `Left`, `Right`
- `PageUp`, `PageDown`
- `ScrollUp`, `ScrollDown`
- `Ctrl+<char>`, with optional `Alt` or `Shift`
- `Alt+<key>`
- `Escape`

Many key commands accept repeat counts,
for example `Down 3` or `Enter 2`.
They can also accept timing,
for example `Down@300ms 3`.
For readable TUI demos,
prefer separate key commands with short sleeps
when the intermediate selection states matter.

## Wait

`Wait` pauses until output matches expected terminal text.
Use it for variable-duration CLI output.

Common forms:

```tape
Wait /Ready/
Wait+Line /done$/
Wait+Screen /Choose an item/
Wait+Screen@30s /Finished/
```

The default pattern waits for a prompt-like final line.
Use explicit patterns when the terminal state matters.
VHS expects explicit wait patterns as regular expressions,
such as `Wait /Ready/`.

## Sleep

`Sleep <time>` keeps recording without input.
Use `Sleep` for viewer pacing,
animations,
and end-of-demo dwell time when the viewer needs a moment
before the GIF restarts.

Common forms:

```tape
Sleep 500ms
Sleep 1s
Sleep 2s
```

Use `Wait` for uncertain completion.
Use `Sleep` when the pause itself is part of the viewing experience.

## Hide And Show

`Hide` stops capturing frames.
Commands still execute in the fake terminal.
`Show` resumes capturing.

Use `Hide` for setup and cleanup.
Use `clear` before `Show`
so hidden setup output does not become the first visible frame.

Recommended setup shape:

```tape
Hide
Type "/path/to/setup-demo.sh"
Enter
Type "clear"
Enter
Show
```

For short setup,
typed commands are acceptable.
For long setup,
use a script and invoke the script while hidden.

## Screenshot

`Screenshot <path>.png` captures the current frame as PNG.
Use it when a static image is useful alongside the GIF
or when verifying one important state.

## Copy And Paste

`Copy "<text>"` sets the clipboard.
`Paste` pastes it into the terminal.
Use this for long text that should appear instantly
or for commands where typed pacing would distract from the demo.

## Source

`Source <path>.tape` includes commands from another tape.
Use it for shared setup or shared visual settings
when multiple tapes in the same project need the same prelude.
