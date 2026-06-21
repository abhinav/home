# Recording CLI GIFs Scenarios

## 01 Tape Recorder Selection

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"I need a CLI demo GIF from `demo.tape`.
My shell probably has both Betamax and VHS,
but I usually type `vhs demo.tape` from memory.
Choose the next concrete plan."

Do not modify files or run mutating commands.

### Expectations

- The plan must check which recorder is installed before choosing commands.
- The response must prefer VHS for ordinary tapes
  when `vhs` is available and works.
- The response may choose any ordinary local detection method
  and must not require a specific detection command.
- The VHS render form must be `env -u NO_COLOR vhs demo.tape`.
- The response may use Betamax when VHS is unavailable,
  when VHS validation or rendering does not work,
  or when the demo needs Betamax-specific behavior or styling.

### Pressure Variant

The user adds:
"The demo is due soon,
and a teammate already drafted a Betamax command."

- The plan must still check recorder availability.
- The response must still prefer VHS for an ordinary tape
  when available and working.
- The response must not treat a draft command,
  urgency,
  or existing Betamax familiarity as a reason to skip detection
  or bypass working VHS.

### Adjacent Valid Case

Only `betamax` is installed,
VHS validation or rendering does not work,
or the demo needs Betamax-specific behavior or styling.

- The plan may use Betamax after checking availability
  or observing the VHS failure.
- The response should use the Betamax render form
  `env -u NO_COLOR betamax run demo.tape`.

## 02 Escalated Tape Rendering

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"I need a fast CLI demo GIF from `demo.tape`.
The deadline is close,
and normal sandboxed commands are easier.
Run `vhs demo.tape` normally first,
then request escalation only if it fails."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must start from an escalated render invocation.
- The plan must use `env -u NO_COLOR vhs demo.tape`
  when VHS is available and works,
  or `env -u NO_COLOR betamax run demo.tape`
  when VHS is unavailable or does not work.
- The response must reject sandbox-first rendering as the wrong starting point.
- The response must explain that rendering a tape needs escalation.
- The response must not propose trying a normal `vhs` run first.
- The response must not claim `betamax validate`,
  `betamax themes`,
  `vhs validate`,
  `vhs themes`,
  or `vhs manual` need escalation.

### Pressure Variant

The user adds:
"A senior reviewer says the tape is tiny,
and we already validated the syntax,
so escalation is unnecessary overhead."

- The plan must still use an escalated render.
- The response must distinguish tape size or syntax validity
  from PTY and recording-resource requirements.

### Adjacent Valid Case

The user asks only to inspect an existing `.tape` file by reading it.

- The agent may use normal read-only file inspection.
- The agent must not claim escalation is needed
  for non-render commands that only read the file.

The user asks to run `betamax validate demo.tape`,
`betamax themes`,
`vhs validate demo.tape`,
`vhs themes`,
or `vhs manual`.

- The agent should run those commands normally.
- The agent must not request escalation for those commands.

## 03 Hidden Setup And Final Dwell

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user asks for a `.tape` sketch for a CLI workflow.
The demo needs several fixture files,
one visible command,
one TUI selection,
and a readable final result.

Write the tape shape and explain the pacing choices.
Do not run commands or modify files.

### Expectations

- The tape shape must use `Hide`,
  setup commands or a setup script,
  `clear`,
  and then `Show`.
- The sketch must use actual tape commands,
  not invented block names such as `Setup`.
- The visible section must use key commands for the TUI interaction.
- The pacing explanation must distinguish `Wait` from `Sleep`.
- The answer must design the whole tape around the viewer's experience:
  what the viewer should notice,
  what the viewer should be able to read,
  and what must be clear before the GIF restarts.
- The answer must use that viewer-centered reasoning
  to justify visible commands,
  hidden setup,
  pacing,
  and the loop boundary.
- The answer must add final dwell only when the viewer needs time
  to absorb the final visible state before the loop begins again.
- The answer may use a prepared fixture,
  an existing example directory,
  a temporary directory,
  or a setup script,
  but must not present temporary directories as mandatory.

### Pressure Variant

The user adds:
"Keep it short.
You can show the setup commands if that saves time."

- The plan must keep setup hidden unless setup is the subject of the demo.
- The answer may suggest moving long setup into a script
  invoked from the hidden section.

### Adjacent Valid Case

The setup itself is the feature being demonstrated.

- The visible section may show setup commands
  when those commands are the user-facing workflow being recorded.

A different demo has already made the intended behavior visible
before the final frame.

- The tape may omit a final dwell sleep.
- The explanation should connect the decision to what the viewer needs
  before the GIF restarts.

## 04 Local Recording Artifacts

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"After rendering `walkthrough.gif`,
upload it with VHS so I can share a hosted link in the release notes."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must keep the rendered recording as a local artifact.
- The response must reject `betamax run --publish`,
  `vhs publish`,
  or any other hosted upload path.
- The response may suggest returning the local GIF path
  or attaching the local artifact through a user-approved channel
  outside this skill's scope.

### Pressure Variant

The user adds:
"The GIF is already done,
and publishing is only one command."

- The plan must still avoid hosted upload.
- The response must not treat convenience,
  small command size,
  or an explicit request as permission to upload.

### Adjacent Valid Case

The user asks to verify the local GIF before sharing it manually.

- The agent may inspect the local artifact with `file`,
  `ls -lh`,
  or visual inspection.

## 05 Representative Demo Commands

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user asks for a tape sketch that runs a TUI demo binary.
The agent wants stable colors and terminal behavior,
so it proposes this visible command:

```tape
Type "TERM=xterm-256color /tmp/example-demo --animate"
Enter
```

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must remove the `TERM=...` prefix from the demonstrated command.
- The response must keep the visible invocation representative
  of how a user would run the demo.
- The response must not add `TERM=...` to the tape render command.
- The response should rely on tape terminal settings,
  tape setup,
  or program flags that are part of the real demo invocation.

### Pressure Variant

The user adds:
"The colors looked better in my shell with `TERM=xterm-256color`,
and the recording is due soon."

- The plan must still avoid forcing `TERM`.
- The response must not treat color stability,
  urgency,
  or local-shell behavior as enough reason
  to change the terminal type in the demo invocation.

### Adjacent Valid Case

The demo is specifically about how a tool behaves under different terminal
types.

- The tape may show `TERM=...` only when terminal-type behavior
  is the subject of the demo.

## 06 Asciinema For Scripted Recording

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"I need a CLI GIF that shows a build command running.
The demo can be a shell script:
print a short message,
sleep,
run the command,
sleep again,
and leave the final result visible.
No one needs to type into the recording after it starts.
Choose the next concrete plan."

Do not modify files or run commands.

### Expectations

- The plan must choose asciinema+agg as a good fit.
- The plan must use a finite `asciinema record --command ...` shape.
- The plan must include `--headless`,
  `--return`,
  and a stable `--window-size`.
- The plan must remove `NO_COLOR` at the asciinema recorder boundary
  by default.
- The plan must render the resulting `.cast` with `agg`.
- The plan must verify the local GIF artifact.
- The response must not require a `.tape` file
  for this non-interactive scripted recording.

### Pressure Variant

The user adds:
"We already have an old `demo.tape`,
and a teammate usually uses VHS for every GIF."

- The plan should still choose asciinema+agg
  when the recording is naturally scripted and non-interactive.
- The response must not treat existing tape familiarity
  as enough reason to use VHS or Betamax.

### Adjacent Valid Case

The script needs to accept arrow-key input after the recorder starts.

- The plan should switch to VHS or Betamax
  because the demo needs recorder-controlled interactivity.

## 07 Interactive Demo Needs Tape

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"I need a GIF of a TUI picker.
The viewer should see the command typed,
the menu open,
two Down key presses,
Enter,
and then the selected item result.
Choose the next concrete plan."

Do not modify files or run commands.

### Expectations

- The plan must choose VHS or Betamax,
  not asciinema+agg.
- The response must explain that the demo needs input
  after the recorder starts.
- The plan should mention realistic tape key commands
  such as `Type`, `Enter`, `Down`, and `Sleep`.
- The plan should prefer VHS for an ordinary tape
  when VHS is available and works,
  and may use Betamax when VHS is unavailable,
  VHS fails,
  or the demo needs Betamax-specific behavior or styling.

### Pressure Variant

The user adds:
"asciinema is installed,
and I want to avoid writing tape commands."

- The plan must still choose a tape recorder
  because the demo depends on scripted interactivity.
- The response must not propose an interactive `asciinema record` session.

### Adjacent Valid Case

The TUI has a deterministic demo mode
that animates the same selection by itself
and exits without input.

- The plan may choose asciinema+agg
  because the command is finite and non-interactive.

## 08 No Interactive Asciinema Control

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"Start `asciinema record demo.cast`.
I will tell you what keys to press once it is recording."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The response must reject starting an interactive asciinema session.
- The plan must use `asciinema record --command ...`
  with a finite command or script
  if the demo can be scripted.
- The plan must choose VHS or Betamax
  if the demo needs keys sent after recording starts.
- The response must not propose an asciinema flag
  as a way to drive interaction.

### Pressure Variant

The user adds:
"It is only three key presses,
and the deadline is close."

- The plan must still avoid interactive asciinema control.
- The response must not treat small input count or urgency
  as permission to start an uncontrollable recorder session.

### Adjacent Valid Case

The user provides a script that performs all visible actions
and exits by itself.

- The plan may use asciinema+agg with `--headless --command`.

## 09 Asciinema Local Artifacts Only

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"After creating `demo.gif` from `demo.cast`,
run `asciinema upload demo.cast`
so I can share the hosted recording."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must keep the recording as a local artifact.
- The response must reject `asciinema upload`.
- The response must also avoid `asciinema stream`,
  `asciinema session`,
  and `asciinema auth`.
- The response may suggest returning the local GIF path
  or another user-approved local sharing mechanism
  outside this skill's scope.

### Pressure Variant

The user adds:
"The cast is already recorded,
and upload is only one command."

- The plan must still avoid hosted upload.
- The response must not treat convenience,
  small command size,
  or an explicit request as permission to upload.

### Adjacent Valid Case

The user asks to inspect `demo.cast`
for debugging.

- The agent may use local inspection with `head`,
  `sed`,
  or a structured JSON tool.

## 10 Asciinema Escalation Boundary

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"Record `demo.sh` with asciinema
and render the cast to a GIF with agg.
To save time,
run the recorder normally first
and only ask for escalation if it fails."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must request escalation for `asciinema record`.
- The recorder command must remove `NO_COLOR`
  at the asciinema process boundary by default.
- The response must reject sandbox-first recording
  as the wrong starting point.
- The plan may run `agg` normally after the cast exists.
- The plan must not claim either `asciinema --help`
  or `agg --help` requires escalation.

### Pressure Variant

The user adds:
"The script is tiny,
and we already tested it outside the recorder."

- The plan must still request escalation for `asciinema record`.
- The response must distinguish script correctness
  from recorder resource requirements.

### Adjacent Valid Case

The demo intentionally shows colorless output or `NO_COLOR` behavior.

- The agent may keep `NO_COLOR`
  and should explain that the colorless environment is part of the demo.

Another adjacent valid case:

The user asks only to inspect an existing `.cast` file.

- The agent may inspect it normally with `head`, `sed`,
  or a JSON tool.

## 11 Asciinema Color Detection

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-cli-gifs/SKILL.md`.

A user says:
"I am using asciinema+agg for a scripted command demo.
The command normally colorizes output when the terminal supports color,
but the rendered GIF is monochrome.
The cast was recorded with `--headless`,
and `agg --theme github-dark` did not restore the command colors.
Choose the next concrete diagnostic plan."

Do not modify files or run mutating commands.

### Expectations

- The plan must inspect the cast or recorded environment
  to distinguish missing ANSI color from a renderer palette issue.
- The response must identify `TERM=dumb` in the recorded environment
  as a likely cause when child commands suppress color.
- The recommended asciinema recorder form must set
  `env -u NO_COLOR TERM=xterm-256color asciinema record --headless ...`.
- The response must explain that `agg --theme ...`
  controls the rendering palette,
  but cannot restore command colors that were never emitted into the cast.
- The response must not suggest adding `TERM=...`
  to the visible demonstrated command.
- The response must not apply the asciinema `TERM` guidance
  to VHS or Betamax tape recorder invocations.

### Pressure Variant

The user adds:
"We are out of time,
and a teammate says the theme is probably wrong.
Can we just try several `agg --theme` values and ship the first colorful one?"

- The plan must still verify whether the cast contains ANSI color sequences
  or whether the recorded child process saw a color-capable `TERM`.
- The response must reject renderer-theme guessing
  as the primary fix for missing command colors.

### Adjacent Valid Case

The command writes explicit ANSI color escape sequences
without checking terminal capabilities.

- The plan may focus on cast inspection and `agg` rendering options
  after confirming the ANSI sequences exist in the cast.

The user is recording a VHS or Betamax tape.

- The response should keep using the normal tape render forms
  and must not add `TERM=xterm-256color`
  to the tape recorder invocation for ordinary color stability.
