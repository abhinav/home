---
name: plain-text-diagrams
description: >
  Use when a diagram must be readable as plain text, including when the user
  requests text characters or the destination is a plain-text artifact such as
  Markdown, a commit message, or terminal output. Plain-text diagrams can also
  be used in chat when they suit the explanation.
---

# Plain-text diagrams

Create the diagram from text characters; preserve another representation
selected by the user.
Before choosing content or layout, use `$diagram-design` for the viewer task,
destination contract, visual argument, vocabulary, spatial composition,
and semantic inspection.
This skill implements that contract on a character grid.

Create or repair a plain-text diagram when requested
or when the diagram must remain readable in a plain-text destination.
For that destination, use `$diagram-design` to decide whether spatial arrangement
improves the explanation; if so, construct it in plain text.
In chat, consider plain text alongside other suitable representations:
choose it with `$diagram-design` when a compact, inline, copyable diagram
serves the task.

## Construct the grid

Preserve the relationships in the spatial model from `$diagram-design`:
dominant direction, main path, branches, fan-in, feedback,
meaningful boundaries, and attachment ports.
Realize its routing idiom consistently.
Where the grid permits, give peer paths corresponding runs, turns, ports,
and label offsets.
Keep separate routes into a shared destination when merging would erase
a relationship the viewer must distinguish;
use a shared junction when coalescence preserves meaning.

Build and validate each node or meaningful boundary before placing the next.
Then choose boundary ports for every relationship, route between them,
and add connector labels without moving the paths.

For two-way relationships, prefer peers side by side with one row per direction.
When another orientation serves the story better,
retain separate connectors with compatible boundary ports:

```text
            failed
┌────────┐          ┌───────┐
│ Worker ├─────────→│ Retry │
│        │←─────────┤       │
└────────┘  retry   └───────┘
```

When either orientation works for a two-branch fan-out,
put the source on the left and stack branches on the right,
with both turns on one vertical spine:

```text
                  ┌──────────┐
             ┌───→│ Branch A │
┌────────┐   │    └──────────┘
│ Source ├───┤
└────────┘   │    ┌──────────┐
             └───→│ Branch B │
                  └──────────┘
```

Avoid crossings: a junction means connection,
and plain text has no dependable bridge for paths that cross without connecting.
Reorder, change reading direction, or split into small panels
when paths would cross or crowd.

## Build rectangles

Use orthogonal rectangles for nodes, states, decisions, stores, and containers.
Preserve roles in labels, such as `Decision: valid?` or `Results database`,
and outcomes on connectors, such as `yes` and `no`.
Use another shape only for a literal template supplied by the user
or an established destination notation that defines its geometry.

Choose the left and right display columns and top and bottom rows first.
Set the inner width from the widest content row plus consistent padding;
use it for every content row and both horizontal borders.
Keep side borders in their chosen columns, padding shorter rows inside them.
Never move a border inward to fit text.
Each corner connects one horizontal and one vertical border:

```text
┌───────────────┐
│ Router        │
│ policy checks │
└───────┬───────┘
```

Use consistent internal padding for peers.
Build containers the same way, with visible whitespace around every contained
item and a label immediately inside or beside the continuous border.
Do not replace border glyphs with label text.
If a long horizontal layout makes columns hard to audit,
switch the main story to vertical so connector labels have their own rows.

## Give marks stable meaning

Use light Unicode box-drawing characters and arrows by default.
Use ASCII connectors only when the user specifically requests ASCII;
ASCII-only destinations must contain no Unicode drawing characters.

| Family | Glyphs |
| --- | --- |
| Light | `─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼` |
| Heavy | `━ ┃ ┏ ┓ ┗ ┛ ┣ ┫ ┳ ┻ ╋` |
| Double | `═ ║ ╔ ╗ ╚ ╝ ╠ ╣ ╦ ╩ ╬` |
| Arrows | `→ ← ↑ ↓` |

Choose families deliberately.
Reserve heavy or double lines for a defined distinction,
such as a primary path, trust boundary, or focus;
label or explain it in a compact legend when not apparent.
Use the same family for the same relationship
and keep each connected path or boundary in one family.
Where families must meet, use a mixed-weight glyph only when its Unicode ports
match both lines; otherwise simplify to one family or end an arrow at the boundary.

Apply arrow semantics from `$diagram-design`.
When endpoint names do not reveal the verb,
label immediately above or below the connector, centered over its glyph run
and clear of boxes and boundaries.
Never replace connector glyphs with label text or spaces.

Treat glyph connections as ports.
Every adjacent pair along a path must expose ports toward each other.
Choose corners and junctions by their physical legs:

| Glyph | Connected directions |
| --- | --- |
| `┌` | Down, right |
| `└` | Up, right |
| `┐` | Left, down |
| `├` | Up, down, right |
| `┤` | Up, down, left |
| `┬` | Left, right, down |
| `┴` | Left, right, up |
| `┼` | All four |

A path continuing right through `┐` needs `┬` instead.
When a path continues through a box border,
replace the border with the matching tee in its family:
`├` for a leg to the right, `┤` for a leg to the left,
and vertical tees as shown:

```text
───┬───     │
   │     ───┴───
leg below  leg above
```

Choose by leg positions, not flow direction or the border's place on the box.
Use junctions only for connected legs; reroute mere crossings.

## Align and deliver

Use spaces, never tabs, without relying on trailing spaces.
Align by rendered display columns, not bytes or Unicode code points.
Wide characters, combining marks, emoji, and font substitution can change width;
avoid ambiguous widths in alignment-sensitive labels when practical
and inspect destination rendering when they are necessary.

Connect paths to visible boundaries, junctions, or arrowheads.
Keep each path continuous from its source boundary to its destination arrowhead:
`│ A ├──→│ B │`.
An arrowhead may end at a visible boundary without continuing through it.
Proximity to an unboxed label does not establish a connection:
route to the label on the same row or provide a border for vertical attachment.
`[Worker]` has side marks but no top or bottom border;
use a full box for attachments from several directions.

Choose one display column for each vertical run,
with compatible endpoint ports and every intermediate connector in that column.
Keep horizontal runs continuous through every column between endpoint ports.

Fit the destination's usable width without soft wrapping.
If needed, reorient, shorten labels with a nearby legend, or split into panels.
In Markdown, use a fenced `text` block unless an established preformatted
convention governs; elsewhere preserve the destination's literal-text convention.

## Validate before delivery

Read as the intended viewer and apply the complete semantic inspection
from `$diagram-design`.
Verify the grid against the construction rules above:

- Entry, direction, main path, and destination are apparent without introductory
  prose; labels and relationships preserve every semantic role in rectangles.
- Corners, tees, and junctions have the depicted legs;
  adjacent glyphs expose compatible ports.
- Vertical runs hold one column, horizontal runs remain unbroken,
  and labels preserve alignment and continuity.
- Closed rectangles keep their left and right columns from top to bottom.
- The destination renders without wrapping;
  ASCII-only destinations contain no Unicode drawing characters.

Repair or simplify a failed semantic or grid check before delivery.
Inspect in the destination when font substitution, ambiguous widths,
or wrapping could change the geometry.
