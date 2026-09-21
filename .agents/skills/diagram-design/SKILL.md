---
name: diagram-design
description: >
  Use when planning, creating, revising, or reviewing an explanatory 2D
  diagram's viewer task, visual argument, visual vocabulary, spatial layout,
  or semantic correctness, including when another diagram skill requires it.
  Pair it with medium-specific guidance for construction. Do not use for
  quantitative charts, decorative illustration, or medium mechanics alone.
---

# Diagram design

Treat a diagram as a spatial argument made for a particular reader and medium.
Position, connection, enclosure, visual treatment, and whitespace carry
meaning.
The useful artifact is not merely valid source or a well-formed drawing.
It is a rendered diagram whose concept, visual language, and proportions make
the intended relationship clear where the reader will encounter it.

Work through this model:

```text
artifact and destination
  -> viewer question
  -> diagram concept
  -> visual vocabulary
  -> spatial layout
  -> medium-specific construction
  -> rendered inspection in context
```

Use this skill before implementing the diagram in its selected medium.
This skill owns the reader's task, the destination contract, the visual
argument, the spatial model, and semantic inspection.
The medium-specific skill owns representation constraints, construction,
rendering, conformance checks, and delivery.

When the user or destination selects a medium, preserve that choice.
When no medium is selected,
identify the destination requirements and the representations that can preserve
the relationships the viewer must understand.
Choose or recommend a compatible medium only within that medium skill's entry
conditions.
Do not infer a medium that its skill reserves for explicit user selection.
Use the corresponding medium-specific skill before constructing the artifact.

## Decide whether to draw

Before drawing, identify the spatial relationship that the diagram will make
clearer.
Create a diagram when position, connection, enclosure, direction, or change
helps the viewer understand the subject more directly than linear prose.
This is often true when the viewer must follow branching and rejoining paths,
several actor handoffs, containment or hierarchy, state transitions,
feedback loops, structural alternatives, or change over time.

Use prose, a list, a table, or a code shape when that representation exposes
the relationship more directly.
Recommend omitting a candidate diagram when surrounding content already
communicates the same point without asking the reader to reconstruct a spatial
model.

When the user explicitly requests a diagram or a particular diagram medium,
produce the requested artifact.
You may briefly note a better representation when that observation helps the
user use or revise the result.
When a requested diagram carries little spatial information,
produce the smallest useful diagram instead of adding decorative structure.

For an accessibility-sensitive artifact,
state the diagram's material meaning in adjacent prose.

## Plan for the destination

Establish the diagram's contract before choosing its shape:

- Is it standalone or embedded in a larger document?
- What do the surrounding heading, prose, tables, code, and nearby diagrams
  already tell the reader?
- What reading width, height, and aspect ratio will it have?
- Will its background be light, dark, selectable, or unknown?
- Must the canvas be transparent, or should the diagram supply its own
  background?
- Which representations can the destination render faithfully?
- Does the user need editable source, a rendered artifact, or a review preview?
- Must the artifact remain useful when copied into another surface?

Treat surrounding content as part of the reader's available information.
Do not make an embedded diagram repeat the document around it.
Choose the concept and orientation for the destination's reading width.
Do not finish a wide diagram and solve the width problem by shrinking it until
its labels or relationships become hard to read.

When the destination has a hard width limit,
change orientation, shorten labels with a nearby legend, or split the story
into small panels before allowing the diagram to wrap or crowd.
When the destination supports several backgrounds or themes,
make every semantic distinction survive each supported surface.

## Start from the viewer's question

Before placing elements, identify:

- what the viewer already knows from the destination and surrounding content;
- what the viewer must understand, predict, compare, or decide;
- which element gives the viewer an entry point;
- which conclusion or destination should be apparent at the end; and
- which facts are available but do not change that outcome.

Write one internal sentence before laying out objects:

> After viewing this diagram, the reader understands ...

Use that sentence to choose the diagram concept.
A sequence emphasizes order and exchange.
Containment emphasizes ownership or composition.
Topology emphasizes connection.
State emphasizes transitions.
Comparison emphasizes differences.
Anatomy emphasizes parts.
A timeline emphasizes change over time.
Combine concepts only when the viewer question needs both.

Include only actors, states, boundaries, and relationships that change the
intended understanding.
Do not add a context panel, legend, or annotation merely because the source
material supplied another fact.
Use stable names from the subject rather than aliases or abbreviations the
viewer must decode.

Before choosing a visual vocabulary,
classify each candidate fact by what it contributes:

1. Include content that directly changes the viewer's intended understanding,
   prediction, comparison, or decision.
2. Include topology or context required to interpret that content correctly.
3. Omit incidental or explicitly excluded context.

An exclusion label still makes the excluded fact part of the diagram and
spends the viewer's attention on it.
Show a scope boundary only when understanding that boundary is itself part of
the viewer's task.
Do not advance to visual vocabulary or layout until every planned visible
element has a purpose in the first two groups.

## Establish a visual vocabulary

Before placing objects, decide how the diagram will express its semantic roles.
For each role that matters, choose a consistent treatment:

```text
role -> geometry or enclosure, line treatment, text treatment,
        label placement, connector ports, optional color or fill
```

The vocabulary belongs to the artifact, not to a universal shape catalog.
Repeated records might use adjacent cells in one diagram,
while a different subject might need a custom composite shape.
The same role should retain the same treatment throughout one diagram.
Different roles should not depend on a distinction the destination cannot
preserve.

Treat connector routing as part of the visual vocabulary.
Use one routing idiom for peer paths.
Give corresponding branches corresponding departure and arrival geometry,
angles or bends, and label placement.
Vary those treatments when the difference communicates a distinct
relationship,
not merely because one route or anchor was convenient.

Use the selected medium's native vocabulary when it expresses the subject well.
Use custom geometry when the relationship among its parts helps the reader
recognize a meaningful domain distinction.
Choose that geometry within the selected medium's supported shape vocabulary.
Do not add custom geometry, color, line weight, or ornament only as decoration.
Preserve a role in its label and relationships when a silhouette or visual
treatment would be ambiguous or inaccessible.

For a related series,
treat the first accepted diagram as a local design system.
Reuse its semantic palette roles, line weights, typography, corner treatment,
spacing rhythm, connector style, containment treatment, and destination scale.
Add a new shape when the new concept requires it,
but express that shape within the established system.
Compare related diagrams side by side at their delivery size.
Similarity in source or construction does not establish visual continuity.

## Build one story across the plane

Choose one dominant reading direction for the main story.
Use left to right, top to bottom, or another direction that fits the audience,
destination, and content.
Keep primary transitions moving in that direction.

Place the main path first.
Start each secondary branch at the element that creates it.
Place peer branches at a shared rank farther along the dominant axis,
and spread them across the perpendicular axis.
Make every branch rejoin the main path or terminate visibly.

Place a shared destination farther along the dominant axis than every branch
that feeds it.
Converge fan-in paths forward rather than placing the destination between peers
and making one path reverse direction.
Route a feedback path around the outside of the main path.
Label the feedback path's return when the action is not apparent.

Use proximity and whitespace to show grouping.
Use a surrounding boundary only when containment, ownership, or another real
boundary is meaningful.
Keep secondary detail visually subordinate to the path that answers the
viewer's question.

Avoid connector crossings.
A crossing makes the reader decide whether two paths connect.
Reorder elements, change the reading direction, route around the main story,
or split the diagram into small panels when paths would otherwise cross or
crowd.
When a medium provides an explicit bridge or crossover notation,
use it only when the notation is established for the destination and the
crossing remains easier to read than a revised layout.

For a two-way relationship,
give each direction its own path unless the relationship is genuinely
undirected.
Place peers so both directions can use compatible boundary ports without
reversing the main reading direction.

When the destination requires another orientation,
rebuild the reading direction, connection points, and routes together.
Rotating objects while retaining the old routing usually produces diagonal,
backward, or ambiguous connectors.

## Encode meaning as geometry

Before choosing medium syntax or marks,
identify the spatial relationships the implementation must preserve:

- equal or intentionally different sizes;
- aligned edges and shared ranks;
- repeated spacing and margins;
- containment bounds and interior whitespace;
- symmetric angles and corresponding points;
- meaningful attachment ports;
- visual precedence between primary and secondary paths; and
- the destination footprint at reading size.

Treat an arrow as a verb.
Its direction should match the action, transfer, sequence, or dependency that
the arrow represents.
Label the connector when the verb is not apparent from the endpoint names.
Use an undirected line for structure or association,
not for a process whose direction matters.

Give every meaningful relationship a visible start and end.
Connect paths to deliberate ports rather than letting proximity imply a
relationship.
Choose ports that reinforce the reading direction and keep routes out of nodes,
labels, and unrelated regions.

Treat text as geometry.
Fit objects to their required labels.
Reserve space on paths for connector labels.
Lengthen a segment when its label needs room.
Keep labels close to the object or relationship they name without interrupting
the geometry that carries that relationship.
When label length or connector count can affect the layout,
test the longest required label and every required connector.

Build the semantic structure before tuning global appearance:

1. establish the main direction and any structural scaffolding;
2. place primary actors, states, data, and meaningful boundaries;
3. place related, repeated, or subordinate structures;
4. choose attachment ports and route primary and secondary relationships;
5. derive contextual regions from the elements they contain;
6. add connector labels and remaining annotations; and
7. tune appearance without changing the established meaning.

The medium may require another construction order.
Follow that order while preserving this semantic dependency:
the viewer's task determines the content,
the content determines the spatial model,
and the spatial model determines the construction.

## Inspect the rendered story

Inspect the diagram in the destination or a faithful representation of it.
Use its actual reading width and every supported background or theme.
A successful generation command, parse, XML check, text-presence check, or
source review proves only the property it evaluates.
It does not prove that the rendered diagram communicates the intended
relationship.

Read the diagram as the intended viewer, then verify:

1. The entry point, reading direction, primary path, story destination,
   and intended takeaway are apparent from the diagram and the surrounding
   content available at its destination.
   The viewer does not need to reconstruct an unstated relationship.
2. Every required actor, state, boundary, and relationship is present.
   No unsupported or irrelevant element competes with the main story.
3. Every path reaches its intended endpoints.
   Every arrow points in the direction of the action it represents.
4. Labels, objects, and paths do not overlap, clip, crowd, or form ambiguous
   crossings at delivery size.
5. Peer paths use corresponding routing and label placement.
   Visible differences between them communicate meaning.
6. Each semantic role remains recoverable from its label, relationships, and
   visual treatment on every supported destination surface.
7. Related diagrams still look like one series at their delivery size.
8. Removing any remaining visual element would remove useful meaning.

Apply the medium-specific skill's conformance checks as part of the same
inspection.
Semantic correctness does not excuse malformed construction.
Mechanical conformance does not excuse a misleading rendered story.

If a check fails, repair or simplify the concept, vocabulary, or layout.
Rebuild the affected medium-specific construction and inspect it again.
If rendered inspection is unavailable, state that validation gap.
Do not present source validity or generation success as evidence of visual
correctness.
