---
name: pikchr
description: >
  Use when the user explicitly requests a Pikchr diagram, Pikchr source,
  a `.pikchr` file, or SVG rendered with Pikchr. Do not use for a general
  diagram request that does not select Pikchr as the format.
---

# Pikchr

Use `$diagram-design` before choosing the diagram's content or layout.
It owns the viewer task, destination contract, visual argument,
visual vocabulary, spatial composition, and semantic inspection.
This skill owns their implementation and medium-specific validation in Pikchr.

When the user explicitly requests a Pikchr artifact,
produce the requested artifact.
Use the concept, vocabulary, and spatial model established with
`$diagram-design` as the contract for the Pikchr source.

Work through the Pikchr-specific part of the model:

```text
diagram-design spatial model
  -> visual invariants and addressable geometry
  -> relative Pikchr construction
  -> source and paint order
  -> SVG rendering
  -> semantic and Pikchr-specific inspection in context
```

## Realize the visual vocabulary in Pikchr

When choosing Pikchr objects or expressing positions and paths,
read [Language basics and relative geometry](references/language-basics-and-relative-geometry.md)
for syntax, evaluation, anchors, and routing.

Translate the selected vocabulary into built-in Pikchr objects,
labeled primitives, and paths.
When the vocabulary requires custom geometry,
compose it from Pikchr primitives so its meaningful parts remain addressable.

Give each composite object a predictable footprint and meaningful connection
points.
Group its parts when they should move as one unit.
Preserve the local design system established with `$diagram-design` through
Pikchr geometry, fills, strokes, typography, spacing, and connector treatment.

## Encode the relationships as geometry

Treat Pikchr source as a model of visual invariants rather than a transcript of
drawing commands.
Encode the visual invariants established with `$diagram-design` as relative,
addressable relationships in Pikchr.

Implement the chosen visual vocabulary with the smallest construction strategy
that preserves those invariants and leaves later relationships addressable:

- Compose labeled primitives and paths for a role represented by custom
  geometry.
- Use a macro for a stable compound that repeats as one semantic unit.
- Use `move`, named points, invisible objects, or invisible paths as scaffolding
  when visible objects do not provide the needed anchors.
- Use variables, distances, headings, and labeled intersections for parametric
  structures such as radial, organic, or repeated geometric forms.

When using variables, expressions, macros, or diagnostic statements,
read [Macros and diagnostics](references/macros-and-diagnostics.md)
for their syntax and evaluation behavior.

A repeated source fragment does not automatically deserve a macro.
Keep a construction explicit when later paths must address its individual
parts,
or design the macro so those parts remain reachable.
Optimize the source for useful relationships and anchors,
not for the fewest lines.

When selecting shared defaults, dimensions, colors, strokes, or text attributes,
read [Defaults and styling](references/defaults-and-styling.md).

Establish one representative object as the size and style prototype for its
role,
then propagate that treatment through shared defaults, `same`, or `same as`.
Build the structural relationships before tuning global appearance values.

Treat text as geometry.
Implement the label space established with `$diagram-design` by sizing objects,
lengthening path segments,
or using an invisible path when text needs an orientation or alignment that no
visible object supplies.

## Build the spatial model

When using containers or controlling drawing layers and paint order,
read [Containers and paint order](references/containers-and-paint-order.md)
for grouping, scoping, backgrounds, and layering mechanics.

Build the source in semantic phases:

1. establish the main direction and any structural or invisible scaffolding;
2. define prototypes, primary domain objects, and their labels;
3. place related or repeated structures;
4. add primary connectors, subordinate branches, and connector labels;
5. derive contextual regions or group backgrounds; and
6. add remaining annotations and tune appearance.

Pikchr evaluates source in order.
Later objects can derive their position and dimensions from earlier objects.
Coordinates should usually be the result of those relationships,
not the model encoded in the source.

- Let the active direction establish a local sequence.
  Reset it before another phase when retaining it would be surprising.
- Give semantic or long-range objects stable labels and refer to their anchors.
  Relative occurrences can remain clearer within a small local pattern.
- Place branches relative to the object they belong to.
- Use projections such as `(A, B)`, interpolation such as `1/2<A, B>`,
  and `until even with` for alignment and routing.
- Use containers for groups that should move and resize as a unit.
- Derive backgrounds and routes from the objects they enclose or connect.
- Use literal distances for local gaps and margins,
  not to reconstruct the canvas.

For a maintained or structurally repeated diagram,
good organization usually lets a peer be inserted,
a label be lengthened,
or a group be moved with local edits.
A throwaway diagram does not need a separate maintainability exercise.

Pikchr diagrams are code.
Use blank lines and comments to separate sections when that makes the source
easier to scan or change.

## Control paint order

Pikchr is a one-pass language.
Source order affects both what later statements can reference and what later
objects paint over.

- Paint backgrounds and containment regions behind foreground objects.
- Route connectors to explicit ports rather than through nodes.
- Split a connector around its label when the label needs a clear gap.
- Do not use a background-colored halo or mask to hide a route.
- Check whether a later fill or stroke covers an earlier arrowhead, connector,
  border, or label.

When several paths meet an object at one anchor,
inspect the combined result.
Use separate nearby anchors when overlap obscures a relationship the viewer
must distinguish
or makes the visible result depend accidentally on paint order.
Reuse one anchor when the overlap preserves the intended meaning
and remains visually unambiguous.
When built-in object anchors do not provide enough separation,
derive nearby named points from those anchors
instead of encoding unrelated canvas coordinates.

It is often clearer to define the foreground first,
derive a background from its finished extent,
then use `behind` to paint the later-defined background underneath it.
Inspect the rendered result because valid source does not reveal every overlap.

## Render and inspect in the destination

This skill requires `pikchr` on `PATH`.
If it is not installed, stop and report that the skill cannot run.

Generate a light-mode SVG with:

```sh
pikchr --svg-only diagram.pikchr > diagram.svg
```

Generate a dark-mode SVG with:

```sh
pikchr --dark-mode --svg-only diagram.pikchr > diagram-dark.svg
```

Use the mode that matches a fixed destination.
When the destination can use light and dark backgrounds,
choose colors and fills that remain legible in both.
Inspect the rendered image on representative light and dark surfaces.
Do not add an opaque canvas when the destination requires transparency.

Inspect the diagram at its actual reading width.
A successful command proves that the source parses and produces SVG.
It does not prove that the diagram communicates the intended relationship.
Apply the complete semantic inspection from `$diagram-design`,
then verify the Pikchr construction:

1. Every path reaches its intended Pikchr anchors and ports.
   Paths that share an anchor remain visually unambiguous.
2. Labels have real geometric space and do not rely on a background-colored
   mask to hide a route.
3. No later fill or stroke covers an earlier arrowhead, connector, border,
   or label.
4. Composite objects keep their intended footprint,
   and later relationships can address every required part.
5. Repeated roles retain their prototype's geometry and styling.
6. Transparency, fills, strokes, and text remain legible on every supported
   destination background.

If a semantic or Pikchr-specific check fails,
repair or simplify the concept, layout, or construction and render it again.
If visual inspection is unavailable, state that validation gap.
Do not present parsing, XML validation, or text-presence checks as evidence of
visual correctness.

## Deliver the requested artifact

Match the representation to the request and medium:

- Return Pikchr source as a `pikchr` block or `.pikchr` file.
- Return an `.svg` artifact when SVG is requested or supported.
- Return a raster preview when it makes review easier or the destination needs
  one.
- Return source and rendered output when the user needs an editable artifact and
  a visual review surface.
