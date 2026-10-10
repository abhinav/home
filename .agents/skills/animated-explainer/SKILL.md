---
name: animated-explainer
description: >
  Use when the user asks to explain or teach a concept with a Manim animation,
  especially an algorithm, equation, data flow, or system state transition
  with concise on-screen text. Do not use for static diagrams, decorative
  motion, interactive visualizations, or editing existing footage.
---

# Animated explainer

Create the finished Manim animation and its editable Python source.
The animation should make one mechanism, relationship, or state change easier
to understand than prose or a static diagram would.

## Establish the visual claim

Identify what the viewer already knows, what the viewer should be able to
explain or predict after watching, and what the explanation leaves out.
Use that outcome to choose the content; omit details that do not help establish it.
Research the actual implementation or current technical documentation when the
animation makes claims about a real system.

Choose a small example that exposes the important change.
Keep its entities, names, positions, colors, and notation stable so the viewer
can attribute each result to the animated transformation.

## Storyboard visible states

Before writing scene code, outline the explanation from the viewer's starting
knowledge to the promised outcome.
Identify the concepts and notation each step depends on; introduce the needed
prerequisites before using them.
Start with a concrete question, establish the relevant baseline, and show how
the mechanism answers that question through one continuing example.
Combine these stages when a simple explanation needs only a few beats.
Include a changed input or limiting case when the viewer needs it to distinguish
the rule from an accidental result of the example.

Turn the outline into a storyboard of visible states.
For each beat, define:

- the state the viewer already understands;
- the question or claim currently being explained;
- the one transformation that supplies new information;
- the completed state the viewer needs time to inspect;
- the wording of any displayed explanation; and
- time to read, follow the transformation, and inspect its result.

Each beat should change the viewer's model, not merely add motion.
Split unrelated mechanisms into separate scenes instead of crowding one frame.
Choose the runtime from those reading and inspection needs.
If a requested duration cannot accommodate the essential explanation, reduce
nonessential content or make the scope or duration tradeoff explicit.

Review the complete storyboard before implementing it.
Check that each inference uses the viewer's prior knowledge or information
already established on screen, that the visible changes and text carry the
reasoning without voice-over or production notes, and that the ending answers
the opening question.
Revise missing prerequisites or unsupported conclusions at this stage;
retain a sufficient storyboard and proceed to implementation.
Keep the storyboard beside the scene source so later changes can be checked
against the intended explanation.

## Compose the frame

Reserve a stable region beside the visual field when text helps interpret the
animation.
Use the visual field for the mechanism.
For each beat, use explanatory text when it supplies a question, rule, or
conclusion the intended viewer cannot recover from the visual alone.
Omit explanatory text that only repeats the visible action.

- Keep at most one short heading and one concise statement visible at a time.
- Align text consistently and keep it within fixed safe margins.
- Update the text with the corresponding visual state.
- Match recurring terms to the visual grammar without relying on color alone.
- Hold completed states long enough for the text and visual result to be read
  together.

Use the full frame when a side region would make the primary visual too small.

## Build with Manim

Represent continuing concepts with continuing Manim objects.
Prefer transforming or moving an established object over replacing it with an
unrelated lookalike when identity matters to the explanation.
Group related objects so layout changes preserve their relationships.

Before acquiring Manim with `mise`, choosing a non-default output format, or
diagnosing a render failure, read
[the Manim toolchain reference](references/manim-toolchain.md).

## Render and inspect

Render one representative scene at draft quality before the complete
animation.
Inspect it at its delivered size and correct clipping, overlap, wrapping,
contrast, accidental motion, and unstable object identity at the source.

Render the final animation as an MP4 unless the user requests another
Manim-supported representation.
Keep the scene source beside the rendered artifact so later revisions remain
local.

Completion requires all of the following:

1. The rendered animation plays in Codex.
2. Frames around every important transition show finished, legible states.
3. Text fits at the delivered size and remains synchronized with the visual
   claim.
4. The animation establishes the requested explanation without relying on the
   surrounding conversation.

Return the editable source and show the rendered animation in Codex with an
absolute local path.
Do not stop at a plan, storyboard, source file, or render command when the user
asked for the animation.
