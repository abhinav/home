# Pikchr scenarios

## 01 Relative repeated group

### Prompt

Use the skill at `{SKILL_PATH}`.

A user asks:
"Create a Pikchr diagram of a document entering a review stage,
fan-out to three independent checkers,
and fan-in to a publish decision.
We expect to add more checkers later.
Return the Pikchr source and an SVG."

Create the requested artifacts under a task-local temporary directory.

### Expected behavior

- The source models the checkers as a relative, self-sizing group.
- Labels and anchors carry semantic identity and routing.
- The requested source and SVG are returned.
- Adding a checker requires local group and connection edits,
  not redistribution of unrelated nodes.

### Unacceptable behavior

- Checker positions depend on individually tuned canvas coordinates.
- The SVG or source is omitted.

### Pressure variant

#### Runner prompt addition

The user adds:
"This is only a small diagram and is due in ten minutes.
Please use fixed coordinates if that is faster;
we can clean it up when the fourth checker arrives."

#### Expected behavior

- The stated extension requirement still leads to a relative group.

#### Unacceptable behavior

- Time pressure is used to ignore the known extension requirement.

## 02 Throwaway source-only delivery

### Prompt

Use the skill at `{SKILL_PATH}`.

A user asks:
"Give me only a quick Pikchr snippet for two states and a transition.
This is throwaway code.
Do not create files or attach rendered output."

### Expected behavior

- The visible response contains only the requested Pikchr source.
- The source uses a direct relative layout.

### Unacceptable behavior

- The agent creates or attaches rendered output.
- The response adds a maintainability exercise or validation ceremony.

## 03 Trigger selection

### Prompt

Available skills:

- `pikchr`: Use when the user explicitly requests Pikchr source,
  a `.pikchr` file, or an SVG rendered with Pikchr.
- `imagegen`: Generate raster illustrations and visual assets.
- `excalidraw`: Create hand-drawn diagrams and flowcharts.

User request:
"Please express this queue topology as editable Pikchr source."

Choose the skill or skills to load and explain briefly.

### Expected behavior

- Select `pikchr`.
- Do not select a competing diagram or raster skill merely because the task
  is visual.

### Unacceptable behavior

- Omit `pikchr`.
- Select only a general visual skill.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:
"Sketch this queue topology as a hand-drawn diagram."

#### Expected behavior

- Do not select `pikchr` without another Pikchr-specific signal.

#### Unacceptable behavior

- Treat every diagram request as a Pikchr request.

## 04 Macro expansion inside surrounding syntax

### Prompt

Use the skill at `{SKILL_PATH}`.

A user asks:
"Return only Pikchr source for a reusable `taskcard` macro.
The macro should draw a styled box with two text lines,
and its body should remain readable across physical lines.
Create labeled `Queued` and `Running` cards with the macro,
then place `Running` relative to `Queued` using an attribute after the
`taskcard(...)` invocation."

### Quality bar

- Evaluation mode: conformance.
- Both labeled macro invocations and the trailing placement attribute parse.
- The macro expansion introduces no statement-ending newline where the label
  or trailing attribute requires uninterrupted syntax.

### Expectations

- The returned source renders successfully with `pikchr`.
- The macro body is either one physical line,
  or begins and ends with syntax tokens while internal breaks are escaped.
- A macro body beginning or ending with an unescaped newline is unacceptable
  when the invocation participates in the labeled object statement.

### Adjacent valid case

The user instead asks for an unlabeled macro that deliberately expands to two
complete object statements and is invoked by itself at a statement boundary.

- A multiline, multi-statement macro remains valid.
- The response must not claim that every newline in every macro body is invalid.
