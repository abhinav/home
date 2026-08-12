---
name: pikchr
description: >
  Use when the user explicitly requests a Pikchr diagram, Pikchr source,
  a `.pikchr` file, or SVG rendered with Pikchr. Do not use for a general
  diagram request that does not select Pikchr as the format.
---

# Pikchr

Treat a Pikchr diagram as a spatial model of the relationship the viewer needs
to understand.
Choose a clear reading direction, keep secondary paths subordinate,
and use proximity, alignment, containment, and connection to carry meaning.
Do not rely on color alone.

## Build the layout from relationships

Pikchr evaluates source in order.
Later objects can derive their position and dimensions from earlier objects;
coordinates should usually be the result of those relationships,
not the model encoded in the source.

- Let the active direction establish the main sequence.
- Give meaningful objects stable labels and refer to their anchors.
- Place branches relative to the object they belong to.
- Use projections such as `(A, B)`, interpolation such as `1/2<A, B>`,
  and `until even with` for alignment and routing.
- Use containers for groups that should move and resize as a unit.
- Derive backgrounds and routes from the objects they enclose or connect.
- Establish shared diagram defaults once,
  then override them only where an object has a distinct role.
- Use `same` or `same as` within an object class,
  or macros for repeated visual structure;
  use labels, anchors, and containers for geometric relationships.
- Use literal distances for local gaps and margins,
  not to reconstruct the canvas.

For a maintained or structurally repeated diagram,
good organization usually lets a peer be inserted,
a label be lengthened, or a group be moved with local edits.
A throwaway diagram does not need a separate maintainability exercise.

Pikchr diagrams are code.
Use blank lines and comments to separate sections when that makes the source
easier to scan or change.

[The language reference](references/language-reference.md) covers the Pikchr
execution model, diagram-wide defaults, objects, labels, positions, paths,
containers, macros, expressions, text, and styling.

## Render and deliver

This skill requires `pikchr` on `PATH`.
If it is not installed, stop and report that the skill cannot run.

Generate raw SVG with:

```sh
pikchr --svg-only diagram.pikchr > diagram.svg
```

Match the representation the user requested:

- Return Pikchr source as a `pikchr` block or `.pikchr` file.
- Return an `.svg` artifact when SVG is requested.
- Return both when the user asks for editable source and rendered output.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
