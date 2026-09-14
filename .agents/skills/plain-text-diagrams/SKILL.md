---
name: plain-text-diagrams
description: >
  Use when a diagram must be readable as plain text, including when the user
  requests text characters or the destination is a plain-text artifact such as
  Markdown, a commit message, or terminal output. Plain-text diagrams can also
  be used in chat when they suit the explanation.
---

# Plain-text diagrams

Use `$diagram-design` before choosing the diagram's content or layout.
It owns the viewer task, destination contract, visual argument,
visual vocabulary, spatial composition, and semantic inspection.
This skill owns their implementation and medium-specific validation on a
character grid.

Create the diagram itself from text characters.
When the user selects another representation, preserve that choice.
Use the concept, vocabulary, and spatial model established with
`$diagram-design` as the contract for the plain-text artifact.

## Choose plain text

Create or repair a plain-text diagram when the user requests one
or when a diagram must remain readable in a plain-text destination.

When the destination requires plain text,
apply `$diagram-design` to decide whether spatial arrangement improves the
explanation.
When it does, construct the diagram in plain text.

In chat, consider plain text alongside other suitable diagram representations.
Plain text is useful when a compact, inline, copyable diagram serves that task.
Use it only when it is the representation selected with `$diagram-design`.

## Construct the spatial model on a character grid

Use the dominant reading direction, main path, branches, fan-in,
feedback routes, meaningful boundaries, and attachment ports established with
`$diagram-design`.
Adapt that spatial model to a discrete grid without changing the relationships
it expresses.

Realize the routing idiom chosen with `$diagram-design` consistently on the
grid.
Give peer paths corresponding runs, turns, attachment ports, and label offsets
when the available grid permits them.
When peer paths meet a shared destination,
keep separate visible routes when merging would erase a relationship the viewer
must distinguish.
Use a shared junction when coalescence preserves the intended meaning.

Construct the drawing in layers:

1. Place every node and meaningful boundary.
2. Validate each closed shape independently.
3. Choose the port on each boundary where every relationship starts or ends.
4. Route connectors between those ports.
5. Add connector labels without moving the established paths.

For two-way relationships,
prefer peers side by side and give each direction its own row.
When another orientation better serves the main story,
retain separate connectors with compatible boundary ports.

```text
            failed
┌────────┐          ┌───────┐
│ Worker ├─────────→│ Retry │
│        │←─────────┤       │
└────────┘  retry   └───────┘
```

When either orientation works for a two-branch fan-out,
place the source on the left and stack the branches on the right.
This keeps both turns on one vertical spine:

```text
                  ┌──────────┐
             ┌───→│ Branch A │
┌────────┐   │    └──────────┘
│ Source ├───┤
└────────┘   │    ┌──────────┐
             └───→│ Branch B │
                  └──────────┘
```

The upper `┌` exposes down and right ports.
The lower `└` exposes up and right ports.

Avoid connector crossings.
A junction character represents a connection.
Plain text has no dependable visual bridge for two lines that cross without
connecting.
Reorder elements, change the reading direction, or split the diagram into
small panels when the relationships would otherwise cross or crowd each other.

## Build rectangular nodes and boundaries

Use orthogonal rectangles as the supported shape vocabulary for nodes,
states, decisions, data stores, and containers.
Preserve decision, database, queue, and other roles in their labels.
Express the role in the label, such as `Decision: valid?`
or `Results database`.
Use labeled connectors to show outcomes such as `yes` and `no`.
This keeps the meaning recoverable without relying on a silhouette.

Choose the left and right display columns
and the top and bottom rows before adding content.
Set the inner width from the widest content row plus consistent padding.
Reuse that inner width for every content row and both horizontal borders.
The top and bottom borders must span the same columns.
Keep each side border in its chosen column on every intervening row.
Pad shorter content rows with spaces inside the border.
Never move a border inward to fit the text.
Each corner must connect one horizontal border to one vertical border.
Complete and validate one rectangle before placing the next.
When a long horizontal layout makes those columns hard to audit,
switch the main story to a vertical direction
so each connector label occupies its own row.

A multiline node follows one fixed frame:

```text
┌───────────────┐
│ Router        │
│ policy checks │
└───────┬───────┘
```

Build a containing boundary by the same rules.
Leave visible whitespace between the container and every contained element.
Place the boundary label immediately inside or beside the boundary.
Keep the border continuous rather than replacing border glyphs with label text.

Represent roles commonly shown with a diamond, cylinder, or another silhouette
as labeled rectangles.
Reproduce another shape only when the user supplies a literal template
or the destination has an established notation that defines its geometry.

## Give the marks stable meaning

Use light Unicode box-drawing characters and arrows by default:
`─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼` and `→ ← ↑ ↓`.
Use ASCII connectors only when the user specifically requests ASCII.

Choose a line family deliberately:

- Light: `─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼`.
- Heavy: `━ ┃ ┏ ┓ ┗ ┛ ┣ ┫ ┳ ┻ ╋`.
- Double: `═ ║ ╔ ╗ ╚ ╝ ╠ ╣ ╦ ╩ ╬`.

Use heavy or double lines for a defined distinction,
such as a primary path, a trust boundary, or the current focus.
State that distinction in a label or compact legend when it is not apparent.
Use the same family for the same relationship.
Keep each connected path or boundary in one line family.
When two families must meet,
use a mixed-weight glyph only when its Unicode port pattern matches both lines.
Otherwise simplify the connection to one family
or terminate an arrow at the boundary.

Apply the arrow semantics chosen with `$diagram-design`.
Label the connector when the verb is not apparent from the endpoint names.
Place that label immediately above or below the connector.
Center it over the connector's glyph run.
Keep it clear of endpoint boxes and boundaries.
Keep the connector glyphs continuous rather than replacing part of the path
with label text or spaces.

Join connector segments with the character that represents their topology.
For example, `├` has connections above, below, and right.
`┬` has connections left, right, and down.
`┼` connects all four directions.
Treat those directions as ports.
When a path continues through adjacent connector or border glyphs,
both glyphs must expose a port toward each other.

Make each connector continuous from its source boundary
to the arrowhead at its destination boundary:
`│ A ├──→│ B │`.
An arrowhead may terminate at a visible node boundary without continuing
through that boundary.
For example, `┐` connects left and down,
so a path that also continues right needs `┬` rather than `┐`.

When a path continues through a box border,
replace the plain border with the matching tee from that line family.
Use `├` when the connector leg lies to the right.
Use `┤` when the connector leg lies to the left.
For a vertical leg, match the visible topology:

```text
───┬───     │
   │     ───┴───
leg below  leg above
```

Choose the tee from these physical leg positions,
not from the flow direction or the border's location on the box.
Use a junction glyph only for the legs it connects.
Reroute lines that merely cross.

## Work in display columns

Use spaces, never tabs, for layout.
Do not rely on trailing spaces.

Align by rendered display columns rather than by byte count or Unicode code
point count.
Wide characters, combining marks, emoji, and font substitution can change the
rendered width.
Avoid width-ambiguous characters in alignment-sensitive labels when practical.
Inspect the destination rendering when they are necessary.

Connect each path to a visible boundary, junction, or arrowhead at its endpoint.
Proximity to an unboxed label does not create a connection.
Route the connector to the label on the same row,
or give the node a visible boundary when it needs a vertical attachment.
A bracketed label such as `[Worker]` marks the label's sides,
but it has no top or bottom border for a vertical attachment.
Use a full box when paths need to enter from several directions.
Use consistent internal padding when boxes are peers.

Build each vertical run around one chosen display column.
Place compatible ports at both endpoints.
Place every intermediate connector in that same column.
Build each horizontal run between its endpoint ports.
Keep every intermediate display column continuous.

Fit the diagram within the destination's usable width.
If a line would wrap,
change orientation, shorten labels with a nearby legend,
or split the story into panels.
Never depend on soft wrapping to preserve geometry.

In Markdown, use a fenced `text` block unless the surrounding artifact has
another established preformatted convention.
In formats without fences,
preserve the destination's literal-text convention.

## Validate the rendered story and character grid

Read the diagram as the intended viewer.
Apply the complete semantic inspection from `$diagram-design`,
then verify the plain-text construction:

1. The entry point, reading direction, primary path, and story destination are
   apparent without introductory prose.
2. Each semantic role remains recoverable from its label and relationships
   within the supported rectangle vocabulary.
3. Every corner, tee, and junction has the same connected legs as the
   relationship it depicts.
4. At each adjacent connector pair,
   both glyphs expose a port toward the other.
5. Vertical segments remain in one display column.
   Horizontal segments are unbroken.
6. Labels do not disturb alignment or connector continuity.
7. Every closed rectangle keeps the same left and right columns
   from its top border through its bottom border.
8. The diagram renders without wrapping in the destination surface.
9. ASCII-only destinations contain no Unicode drawing characters.

If a semantic or grid check fails,
repair the layout or simplify the diagram before delivery.
Inspect the diagram in the destination when font substitution,
ambiguous character widths, or wrapping could change the geometry.

## Tests

When changing this guidance,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
