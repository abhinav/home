---
name: recording-cli-gifs
description: >
  Use when creating, editing, validating, rendering, or debugging
  local CLI and TUI demo GIFs with asciinema+agg or VHS,
  including recorder selection, scripted terminal recordings,
  `.tape` files, Hide/Show sections, waits, sleeps,
  and reproducible demo artifacts.
---

# Recording CLI GIFs

Treat a demo GIF as a glanceable loop,
not as a narrated lesson or proof that a command can run.
Reason across four boundaries:
what the viewer knows and should notice,
what stays stable and visibly changes,
who drives each action after capture begins,
and what evidence supports the recording's claims.

Keep recordings local.
Do not publish recordings to hosted services.

## Model the viewer

Set an internal brief with the audience, one takeaway, and the boundary.
Use the brief to remove material,
not as content for the GIF.

Show one command, interaction, transition, or before-and-after result.
If that requires several definitions, examples, exceptions, or an argument,
narrow the takeaway or use documentation or video.

Assume little reading time.
Let the real terminal state and motion carry the meaning.
Use a short cue only when the visible states cannot show where to look.
Skip title cards, glossaries, and prose recaps by default.

If the viewer only needs to notice that an unfamiliar field changed,
show the change without defining or interpreting the field.
When meaning is essential,
verify it and narrow the GIF until it can be shown briefly.

## Design the visible argument

Use one small example and the shortest visible sequence that proves the takeaway:

1. Start at the useful initial state.
2. Show the representative command or interaction.
3. Change one relevant thing while keeping identity and context stable.
4. Hold the result long enough to inspect.
5. Return to the opening state without implying a false reverse transition.

Hide setup, cleanup, and unrelated output unless they are the subject.
Keep visible commands representative of real use,
with recording-only environment configuration at the recorder boundary.
Preserve identity through stable position, naming, color, and notation.
Reserve motion for the relevant change,
and let the final visible state embody the takeaway.

Treat time as part of the explanation:

- Wait for uncertain program state instead of guessing its duration.
- Pause only for comparison, reading, or final inspection.
- Spend little or no time on prose that delays the behavior.

## Choose the recorder by control model

Use asciinema+agg when a finite command, script, or child shell
drives the complete visible behavior and exits by itself.

Use VHS when the recorder must deliver visible typing, navigation keys,
interactive responses, terminal-state waits, screenshots,
or other choreography after recording begins.

Known keystrokes do not make an interactive asciinema session controllable.
If the recorder must send those keys, use VHS.
If a program's deterministic demo mode performs the same movement itself,
asciinema+agg remains appropriate.

Once the control model is known,
read only the matching operational reference:

- Read [references/tape-reference.md](references/tape-reference.md)
  before writing or rendering a VHS tape.
- Read [references/asciinema-agg-reference.md](references/asciinema-agg-reference.md)
  before writing, recording, rendering, or debugging an asciinema pipeline.

Treat the selected reference as the specification for the operation,
not as optional background.
Any concrete command or operational plan must preserve its required
recorder-boundary settings, flags, ordering, and escalation boundary.
Do not reconstruct those details from memory.

Use installed manuals and `--help` output as the source of truth
when local tool behavior may differ from a reference.

## Preserve operational boundaries

Check that the selected recorder is installed before depending on it.

Request escalation for recorder operations that open PTY,
terminal-capture, or rendering resources.
Run informational, syntax-check, and read-only inspection commands normally.
Use the matching reference for the supported command forms and exceptions.

Keep asciinema recordings finite and headless.
Do not start a session that depends on later human input.

Validate each boundary separately:

1. Inspect or syntax-check the tape, script, or finite command.
2. Record the real terminal behavior.
3. Render the local artifact.
4. Verify the artifact type and inspect the visible result.
5. Confirm that the GIF proves the learning outcome without hidden context.

Syntax validity does not establish recorder success.
Recorder success does not establish render success.
A valid GIF does not establish that the viewer can follow the explanation.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
