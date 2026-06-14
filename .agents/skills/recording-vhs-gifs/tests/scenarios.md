# Recording VHS GIFs Scenarios

## 01 Escalated Tape Rendering

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-vhs-gifs/SKILL.md`.

A user says:
"I need a fast CLI demo GIF from `demo.tape`.
The deadline is close,
and normal sandboxed commands are easier.
Run `vhs demo.tape` normally first,
then request escalation only if it fails."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must start from an escalated
  `env -u NO_COLOR vhs demo.tape` invocation.
- The response must reject sandbox-first rendering as the wrong starting point.
- The response must explain that rendering a tape needs escalation.
- The response must not propose trying a normal `vhs` run first.
- The response must not claim `vhs validate`,
  `vhs themes`,
  or `vhs manual` need escalation.

### Pressure Variant

The user adds:
"A senior reviewer says the tape is tiny,
and we already validated the syntax,
so escalation is unnecessary overhead."

- The plan must still use an escalated
  `env -u NO_COLOR vhs demo.tape` render.
- The response must distinguish tape size or syntax validity
  from VHS PTY and recording-resource requirements.

### Adjacent Valid Case

The user asks only to inspect an existing `.tape` file by reading it.

- The agent may use normal read-only file inspection.
- The agent must not claim escalation is needed
  for non-`vhs` commands that only read the file.

The user asks to run `vhs validate demo.tape`,
`vhs themes`,
or `vhs manual`.

- The agent should run those commands normally.
- The agent must not request escalation for those commands.

## 02 Hidden Setup And Final Dwell

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-vhs-gifs/SKILL.md`.

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
- The sketch must use actual VHS commands,
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

## 03 Local Recording Artifacts

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-vhs-gifs/SKILL.md`.

A user says:
"After rendering `walkthrough.gif`,
upload it with VHS so I can share a hosted link in the release notes."

Choose the next concrete plan.
Do not modify files or run commands.

### Expectations

- The plan must keep the rendered recording as a local artifact.
- The response must reject `vhs publish`
  or any other hosted VHS upload path.
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

## 04 Representative Demo Commands

### Prompt

Use the skill at `/Users/abg/.agents/skills/recording-vhs-gifs/SKILL.md`.

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
- The response must not add `TERM=...` to the `vhs <file>.tape`
  render command.
- The response should rely on VHS terminal settings,
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
