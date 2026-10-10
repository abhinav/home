# Animated explainer scenarios

## 01 Catalog selection

### Prompt

Available skills:

- `animated-explainer`: `{GUIDANCE_DESCRIPTION}`
- `video-explainer`: Create assembled technical lesson videos with chapter
  structure and a broader production workflow.
- `visualize`: Create interactive visualizations and simulations directly in
  conversation.
- `pikchr`: Create static Pikchr diagrams and rendered SVG.

A user says:
"Use Manim to show me why a tracing garbage collector needs a gray set.
Keep a short statement beside the objects as their states change."

Choose the skill or skills to load and explain briefly.
Do not implement the request.

### Expected behavior

- Selects `animated-explainer`.
- Uses the requested Manim explanation as the routing distinction.
- Does not select an interactive, static-diagram, or broader video-production
  workflow.

### Unacceptable behavior

- Selects `video-explainer` because the rendered result is a video.
- Selects `visualize` merely because the result is visible in conversation.
- Selects `pikchr` despite the requested state change in Manim.

### Adjacent valid case: static diagram

#### Runner prompt addition

The user instead asks for an editable static component diagram in Pikchr.

#### Expected behavior

- Selects `pikchr`, not `animated-explainer`.

#### Unacceptable behavior

- Treats every explanatory visual as a Manim request.

### Adjacent valid case: interactive visualization

#### Runner prompt addition

The user instead asks for an interactive simulation with adjustable inputs.

#### Expected behavior

- Selects `visualize`, not `animated-explainer`.

#### Unacceptable behavior

- Replaces the requested interactive controls with a fixed Manim render.

## 02 Application plan

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user asks:
"Explain how a token bucket permits a short burst but limits sustained traffic.
Use Manim with concise text beside the mechanism and show the result in Codex."

Write the concrete production plan and delivery contract.
Do not modify files or run mutating commands.

### Expected behavior

- Plans a finished Manim animation and editable Python source, not only a
  storyboard.
- Routes Manim selection or acquisition through `mise`.
- Defines visible states and meaningful transformations around one stable
  example.
- Keeps side text concise and synchronized with the active visual claim.
- Includes a representative draft render before the complete render.
- Requires playback in Codex and visual inspection of the important states.
- Delivers the animation in Codex through an absolute local path.

### Unacceptable behavior

- Defaults to another animation engine or an interactive artifact.
- Stops after a storyboard, source file, or render command.
- Installs Manim globally or bypasses an existing `mise` environment.

## 03 Mise acquisition boundary

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

The current workspace does not declare Manim, `manim` is not on `PATH`, and
`mise` is available.
State the exact command shape you would use to inspect or acquire Manim for one
animation without changing project or global configuration.
Do not execute the command.

### Quality bar

- Evaluation mode: conformance.
- The answer uses a one-off `mise` environment and leaves configuration
  unchanged.
- A global package install or an unqualified `manim` command is a failure.

### Expectations

- Uses `mise x conda:manim@latest -- manim ...`.
- Explains that a durable `mise use` entry belongs only to a requested pinned
  project environment.

### Adjacent valid case

The workspace already declares Manim in its mise configuration.

- Uses `mise exec -- manim ...` and the configured version.
- Does not create a parallel one-off installation without a reason.

## 04 Rendered artifact

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

In a task-local temporary directory, create a short Manim animation explaining
how backpressure prevents an overfull queue from accepting unlimited work.
Use concise explanatory text beside the visual mechanism.
Return the editable source and rendered artifact paths.

### Expected behavior

- Produces editable Manim source and a playable animation.
- Shows one stable queue example whose state changes reveal the mechanism.
- Keeps side text legible, concise, and aligned with the active transition.
- Uses `mise` for Manim selection or acquisition.
- Plays the rendered result in Codex and inspects its important visual states.

### Unacceptable behavior

- Produces only a plan, storyboard, source file, or static image.
- Uses another animation engine.
- Produces unrelated decorative motion.
- Modifies the target skill or another shared workspace.

## 05 Story planning without narration

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user asks:
"Make a silent Manim animation explaining why a Bloom filter can say an absent
item might be present, but cannot say an inserted item is absent.
I know arrays and sets, but not hashing or probability.
Aim for about 40 seconds and use short text beside the animation."

Produce the concrete plan you would implement, including the visible content,
timing, next production action, and delivery contract.
Do not render or modify shared files.

### Expected behavior

- States the audience's starting knowledge, the capability the explanation
  establishes, and its scope.
- Introduces repeatable item-to-position mapping before relying on it.
- Uses visible shared positions to explain uncertain membership and preserved
  marks to explain why inserted items cannot be missed.
- Supplies the actual displayed explanations and plausible reading and
  inspection time, without relying on narration or production notes.
- Reviews the complete storyboard before scene implementation, resolving
  missing prerequisites and unsupported conclusions when present.
- Makes scope or duration tradeoffs explicit when necessary; a different
  defensible runtime, example, or sequence is acceptable.
- Preserves the finished animation and editable source as the production
  deliverables after this planning exercise.

### Unacceptable behavior

- Assumes hashing or probability knowledge the audience does not have.
- Places reasoning needed by the viewer only in planning prose.
- Squeezes essential definitions and results into unreadable holds.
- Treats a legibility check on one rendered scene as sufficient review of the
  whole explanation.

## 06 Simple explanation

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user asks:
"Make a silent 12-second Manim animation showing 3 + 2 = 5 by moving two groups
of dots together. This is for children who can count to five. Keep it simple."

Produce the concrete plan you would implement, including the visible content,
timing, next production action, and delivery contract.
Do not render or modify shared files.

### Expected behavior

- Uses the audience's counting knowledge and one continuous dot example.
- Keeps the explanation short, with time to inspect the resulting five dots.
- Omits explanatory prose when the dots and notation carry the meaning.
- Combines story stages rather than imposing chapters, a second example,
  or a separate lesson on prerequisites the audience already knows.
- Reviews the small storyboard and proceeds when it is sufficient.

### Unacceptable behavior

- Adds a mandatory counterexample, glossary, or long introduction.
- Treats planning as a request for user approval before routine production.
- Requires text alongside every transformation despite sufficient visuals.
