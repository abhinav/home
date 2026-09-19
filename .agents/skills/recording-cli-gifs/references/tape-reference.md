# Tape reference

Use this reference after the parent skill selects the tape control model.
It governs selection between Betamax and VHS, the order of tape commands,
and the runner-specific validation and render forms.

## Choose Betamax or VHS

Inspect an existing tape and applicable repository instructions
before choosing a runner.

- Follow an explicit user or repository selection.
- Otherwise use Betamax for a new compatible tape when it is installed.
- Use Betamax for an existing tape when it supports every command
  and no local rule selects VHS.
- Use VHS when Betamax is unavailable.

Do not rewrite a working tape merely to change runners.

## Build the tape in execution order

Use the following order when creating or changing a tape.
For an existing tape that only needs rendering,
inspect it for runner compatibility and continue at validation.

### 1. Declare startup configuration

Put `Output`, `Require`, and `Set` commands before runtime commands.
Put Betamax `Env` commands in this startup block as well.
These commands affect shell creation,
terminal dimensions, capture timing, and rendering.

Keep settings together unless the visible interaction needs a deliberate change
such as a different typing speed for one command.

#### Outputs

`Output <path>` declares an artifact written after the tape finishes.
Common visual outputs include:

```tape
Output demo.gif
Output demo.webp
Output final.png
Output demo.mp4
Output demo.webm
```

Prefer GIF unless the user requests another primary artifact.
Multiple `Output` commands can write several artifacts from one capture.

Betamax can also write terminal state as JSON
and numbered PNG frames to an extensionless directory:

```tape
Output final-state.json
Output frames
```

Terminal-state JSON provides supplementary semantic evidence.
It does not establish that a human can follow the rendered artifact.

#### Requirements and environment

`Require <program>` fails early when a needed executable is absent.
Name programs that the tape actually invokes:

```tape
Require git
Require my-cli
```

Betamax `Env <key> <value>` configures the spawned shell:

```tape
Env TZ UTC
Env MY_CLI_DEMO 1
```

Keep recording configuration out of the visible demonstrated command
unless that configuration is part of the user workflow.

#### Settings

Use `Set` commands to control the terminal and render.
Common settings include:

- `Set Shell "bash"` chooses the shell inside the recording.
- `Set Theme "Theme Name"` chooses a theme.
- `Set FontSize 16` controls text size.
- `Set FontFamily "..."` chooses a font when needed.
- `Set Width 900` and `Set Height 520` control output dimensions.
- `Set Padding 10` adds space around terminal content.
- `Set Framerate 24` controls capture cadence.
- `Set TypingSpeed 35ms` controls visible typing speed.
- `Set PlaybackSpeed 1.0` controls output playback speed.
- `Set WaitTimeout 30s` controls the default wait timeout.

Choose dimensions that fit the demonstrated content.
Small TUI widgets usually need less terminal space than full CLI workflows.

### 2. Prepare hidden state

`Hide` stops appending frames while commands continue to run in the PTY.
`Show` resumes capture and immediately captures the current terminal state.

Use hidden sections for setup and cleanup that are not the subject of the GIF.
Clear the terminal before `Show`
so setup output does not become the first visible frame:

```tape
Hide
Type "/path/to/setup-demo.sh"
Enter
Wait /SETUP_READY/
Type "clear"
Enter
Show
```

For long setup, prefer a script invoked from the hidden section.

### 3. Drive the visible interaction

#### Typing and keys

`Type "<text>"` types printable characters.
It does not press Enter unless followed by `Enter`:

```tape
Type "my-cli status"
Enter
```

Use `Type@<duration> "<text>"`
when one command needs a different typing speed.

Tape runners support key commands for prompts and TUIs, including:

- `Enter`, `Tab`, `Space`, `Backspace`, and `Delete`;
- `Up`, `Down`, `Left`, and `Right`;
- `PageUp`, `PageDown`, `Home`, and `End`;
- `Ctrl+<char>`, optionally combined with `Alt` or `Shift`;
- `Alt+<key>`, `Escape`, and function keys.

Many keys accept repeat counts or timing,
such as `Down 3` or `Down@300ms 3`.
Use separate key commands with short pauses
when intermediate selection states carry the visible argument.

`Copy "<text>"` stores text for a later `Paste`.
Use it when long input should appear immediately
or visible typing would distract from the takeaway.

#### Betamax captions

When the parent skill calls for a presentation message,
`Caption <text>` sets a single-line message for later visual frames:

```tape
Caption "Choose the profile used by later commands"
Type "my-cli profile choose"
Enter
Wait+Screen "Profiles"
Sleep 700ms

Caption "The active profile is now staging"
Wait+Screen "Active: staging"
Sleep 2s
```

A caption remains active until another `Caption` replaces it
or `Caption ""` clears it.
Changing a caption does not capture a frame or add duration.
Follow a caption-only change with `Sleep`
when the stable terminal state should hold the new message.

Captions appear in GIFs, videos, PNG outputs, frame directories,
and screenshots.
They do not write to the PTY, change wait matching,
or appear in state JSON.

#### Betamax keyboard overlays

When the parent skill calls for visible input,
choose the least noisy keyboard overlay mode that reveals the action:

- `Set KeyboardOverlay Keys` shows key commands such as `Down`,
  `Enter`, and `Ctrl+C`.
- `Set KeyboardOverlay Input` also shows short typed input.
- `Set KeyboardOverlay All` shows all input events.
- `Set KeyboardOverlay Off` disables the overlay.

Use the caption row when overlays must not cover terminal cells:

```tape
Set KeyboardOverlay Keys
Set KeyboardOverlayLocation CaptionRow
```

The caption row reserves presentation space before Betamax derives the terminal
grid.
Captions are left-aligned, and keyboard chips are right-aligned.
Long captions can be truncated when both share the row.

Corner locations such as `BottomRight` preserve the terminal grid
but can cover terminal content.
When the GIF demonstrates centering, wrapping, modal placement,
or split-pane layout,
inspect the grid and visible content after choosing an overlay location.

Keyboard overlays do not change bytes sent to the PTY, wait matching,
state JSON, or final output dimensions.

### 4. Synchronize state and pace the viewer

Use `Wait` for uncertain program state instead of guessing its duration.
Common forms include:

```tape
Wait
Wait /Ready/
Wait+Line /done$/
Wait+Screen /Choose an item/
Wait+Screen@30s /Finished/
```

Betamax also accepts plain substring targets,
such as `Wait+Screen "Choose an item"`.
Use regular-expression targets when a tape must also run with VHS.

Use `Wait+Screen` for full-screen TUIs, status lines,
and output whose cursor position can change.
Use a regular expression for changing text
and a plain substring when stable text names the desired state.

Treat waits as assertions and synchronization points.
Put a semantic wait after each meaningful application transition
before adding viewer pacing.

`Sleep <duration>` continues capture without input:

```tape
Sleep 500ms
Sleep 1s
Sleep 2s
```

Use `Wait` to establish that a state exists.
Use `Sleep` only for the time the viewer needs after that state is true.

### 5. Capture the review state before cleanup

`Screenshot <path>.png` writes the current decorated visual frame.
Betamax `State <path>.json` writes terminal text, scrollback, cursor metadata,
and styles.

Place review checkpoints after the semantic wait and before hidden cleanup:

```tape
Wait+Screen "Saved profile"
State snapshots/profile-saved.json
Screenshot snapshots/profile-saved.png
Sleep 2s

Hide
Type "exit"
Enter
```

Final PNG and JSON `Output` artifacts reflect terminal state
after the tape finishes, including commands run during hidden cleanup.
When cleanup follows the visible result,
use `Screenshot` or `State` as the stable review endpoint.

State checks can verify terminal claims,
but the rendered GIF still needs visual inspection.

## Validate, render, and inspect

Use the command forms for the selected runner:

| Runner | Validate | Render |
| --- | --- | --- |
| Betamax | `betamax validate demo.tape` | `betamax run demo.tape` |
| VHS | `vhs validate demo.tape` | `env -u NO_COLOR vhs demo.tape` |

Run validation and informational commands normally.
Request escalation before rendering
because the runner opens a PTY and writes media.

Betamax supplies the recording terminal environment to its child shell,
so its render command does not need a color wrapper.
Betamax validation checks parsing and startup-command ordering.
It does not start the shell,
check `Require` programs or themes, or prove that outputs can be written.

The VHS render form removes `NO_COLOR` at the recorder boundary.
Keep `NO_COLOR` only when colorless output or its behavior
is the subject of the demo.

Other runner commands include:

- `betamax themes` and `vhs themes` list theme names.
- `vhs manual` prints the VHS manual.
- `betamax new <file>.tape` creates an authorized starter tape.

After rendering, verify each declared artifact type
and inspect the visible result against the parent skill's viewer brief.
