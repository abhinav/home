---
name: recording-cli-gifs
description: >
  Use when creating, editing, validating, rendering, or debugging
  local CLI and TUI demo GIFs with asciinema+agg, Betamax, or VHS,
  including recorder selection, scripted terminal recordings,
  `.tape` files, captions, keyboard overlays, waits, pacing,
  and reproducible demo artifacts.
---

# Recording CLI GIFs

Make a glanceable loop around one takeaway, with real terminal behavior
as its evidence, not a narrated lesson or proof that a command can run.
Keep recordings local; do not publish them to hosted services.

## Design the visible argument

Set an internal brief: audience, one takeaway, and boundary.
Use it to remove material, not as GIF content.
Show one command, interaction, transition, or before-and-after result.
If that needs several definitions, examples, exceptions, or an argument,
narrow the takeaway or use documentation or video.

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
Reserve motion for the relevant change;
let the final visible state embody the takeaway.
Wait for uncertain program state instead of guessing its duration.
Pause only for comparison, reading, or final inspection.

Assume little reading time: let terminal state and motion carry the meaning.
Use a short cue only when visible states cannot show where to look.
Skip title cards, glossaries, and prose recaps by default;
spend little or no time on prose that delays behavior.

| Viewer needs | Presentation decision |
| --- | --- |
| Context from hidden setup, a step's purpose, or where to look would otherwise be unclear | With Betamax, use a concise `Caption` to frame the terminal evidence, without replacing or restating it. |
| Invisible navigation keys, shortcuts, or other input caused a visible change the viewer must understand | Use the least noisy keyboard overlay mode that reveals that input. |
| Only to notice that an unfamiliar field changed | Show the change without defining or interpreting the field. |
| The field's meaning is essential | Verify its meaning and narrow the GIF until it can be shown briefly. |

With Betamax, decide for each visible state whether to add, update, clear,
or omit a presentation message.

Keep captions and keyboard overlays out of terminal output
so presentation guidance does not masquerade as program behavior.

## Choose the recorder by control model

Determine who drives each action after capture begins:

| Control model | Recorder |
| --- | --- |
| A finite command, script, or child shell drives all visible behavior and exits by itself | asciinema+agg, including a deterministic TUI demo mode that performs the movement itself. |
| The recorder must deliver visible typing, navigation keys, interactive responses, terminal-state waits, screenshots, or other choreography | A tape runner. Known keystrokes do not make an interactive asciinema session controllable. |

Read only the matching operational reference:

- Before selecting, writing, or rendering a Betamax or VHS tape, read
  [references/tape-reference.md](references/tape-reference.md).
- Before writing, recording, rendering, or debugging an asciinema pipeline, read
  [references/asciinema-agg-reference.md](references/asciinema-agg-reference.md).

The reference specifies the operation.
Every concrete command or operational plan must retain its required
recorder-boundary settings, flags, ordering, and escalation boundary;
do not reconstruct them from memory.

## Record and verify

Check that the selected recorder is installed before depending on it.
Request escalation for recorder operations that open PTY,
terminal-capture, or rendering resources.
Run informational, syntax-check, and read-only inspection commands normally;
the matching reference supplies supported command forms and exceptions.
Keep asciinema recordings finite and headless,
without depending on later human input.

Validate each boundary separately:

1. Inspect or syntax-check the tape, script, or finite command.
2. Record the real terminal behavior.
3. Render the local artifact.
4. Verify the artifact type and inspect the visible result.
5. Confirm that the GIF proves the learning outcome without hidden context.

Syntax validity does not establish recorder success,
recorder success does not establish render success,
and a valid GIF does not establish that the viewer can follow the explanation.
