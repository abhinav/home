---
name: animated-explainer
description: >
  Use when the user asks to explain or teach a concept with a Manim animation.
  Do not use for static diagrams, decorative motion, interactive visualizations,
  or editing existing footage.
---

# Animated explainer

Deliver a finished Manim animation and editable Python source.
Make one mechanism, relationship, or state change easier to understand than
prose or a static diagram.

## Plan the visible explanation

Identify the viewer's starting knowledge, what they should explain or predict
after watching, and what is out of scope.
Choose content from that outcome; research the actual implementation or current
technical documentation for claims about a real system.

Use one small continuing example, keeping entities, names, positions, colors,
and notation stable so changes reveal the mechanism.
Outline a concrete question, baseline, and how the mechanism answers it.
Introduce prerequisite concepts and notation before using them.
Combine stages for a simple explanation;
add a changed input or limiting case only when needed to distinguish the rule
from an accidental result.

Before scene code, storyboard each visible beat:

- The understood starting state and active question or claim.
- The one transformation supplying new information and its completed, inspectable state.
- Any displayed wording and time to read, follow the transformation, and inspect it.

Each beat should change understanding, not merely add motion.
Split unrelated mechanisms into separate scenes.
Choose runtime from reading and inspection needs;
if the requested duration is insufficient, cut nonessential content or state the
scope or duration tradeoff.

Review the complete storyboard before implementing:
every inference must use prior knowledge or information already shown;
visuals and text must carry the reasoning without narration or production notes;
the ending must answer the opening question.
Fix missing prerequisites and unsupported conclusions, then proceed when sufficient.
Keep the storyboard beside the scene source for later review.

## Compose and build

Use a stable text region beside the mechanism when explanation helps;
use the full frame if a side region makes the visual too small.
Use text when it supplies a question, rule, or conclusion the viewer cannot
recover visually; omit text that merely narrates the action.

Keep at most one short heading and one concise statement visible.
Align text within fixed safe margins and update it with the corresponding state.
Use consistent terms and visual grammar without relying on color alone.
Hold completed states long enough to read text and inspect results together.

Use continuing Manim objects for continuing concepts.
Prefer transforming or moving established objects when identity matters;
group related objects to preserve relationships during layout changes.

Before acquiring Manim with `mise`, choosing a non-default format, or diagnosing
a render failure, read [Manim toolchain](references/manim-toolchain.md)
for commands, version authority, and environment boundaries.

## Render, inspect, and deliver

Render and inspect one representative scene at draft quality before the full render.
At the delivered size, correct clipping, overlap, wrapping, contrast,
accidental motion, and unstable identity in the source.
Render MP4 unless the user requests another supported representation.
Keep editable scene source beside the rendered artifact.

Show the animation in Codex and watch it beginning to end.
Inspect frames before, during, and after every important transition:
finished states must be legible, text must fit and match the active claim,
and the ending must remain visible long enough to understand.
The complete animation must establish the requested explanation without the chat.

Return the editable source and show the rendered animation in Codex using an
absolute local path.
When the user asks for an animation, a plan, storyboard, source file,
or render command alone is not delivery.
