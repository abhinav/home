---
name: diagram-design
description: >
  Plan, create, revise, or review an explanatory 2D diagram's viewer task,
  visual argument, visual vocabulary, spatial layout, or semantic correctness,
  including when another diagram skill requires it. Do not use for quantitative
  charts, decorative illustration, or medium mechanics alone.
---

# Diagram design

Design a spatial argument for a particular reader and destination.
Position, connection, enclosure, treatment, and whitespace carry meaning;
the rendered diagram must communicate at its actual reading size and surface.

Use this skill before construction for the viewer task, destination contract,
visual argument, spatial model, and semantic inspection.
The medium-specific skill owns representation constraints, construction,
rendering, conformance checks, and delivery; load and apply it before construction.
Preserve a medium selected by the user or destination.
If none is selected, establish destination requirements and representations
that preserve the required relationships, then choose or recommend a compatible
medium only within its skill's entry conditions.
Do not infer a medium reserved for explicit user selection.

## Decide whether to draw

Draw when position, connection, enclosure, direction, or change explains the subject
more directly than linear prose: branching and rejoining paths, actor handoffs,
containment or hierarchy, state transitions, feedback loops, structural alternatives,
or change over time.
Use prose, a list, table, or code shape when it exposes the relationship more directly.
Recommend omitting a candidate diagram when surrounding content already communicates
the point without requiring spatial reconstruction.

Produce an explicitly requested diagram in the selected medium.
You may briefly suggest a better representation when that helps use or revision;
if little spatial information exists, make the smallest useful requested diagram.
For an accessibility-sensitive artifact, state its material meaning in adjacent prose.

## Establish the destination and viewer task

Before choosing shape, establish:

- Standalone or embedded use, and what surrounding headings, prose, tables,
  code, or diagrams already supply.
- Reading width, height, aspect ratio, backgrounds that are light, dark, selectable, or unknown,
  and whether the canvas must be transparent or supply its background.
- Faithfully supported representations and what delivery the user needs:
  editable source, a rendered artifact, or a review preview.
  Establish whether the diagram must survive copying to another surface.

Use surrounding information rather than repeating it in an embedded diagram.
Choose concept and orientation for the reading width;
do not finish wide and shrink labels or relationships into illegibility.
For hard width limits, reorient, shorten labels with a nearby legend,
or use small panels before allowing wrapping or crowding.
Semantic distinctions must survive every supported background or theme.

Before placing elements, identify what viewers know and must understand,
predict, compare, or decide; their entry point and final conclusion;
and available facts that do not affect that outcome.
Write one internal sentence: "After viewing this diagram, the reader understands ..."

Establish the relevant entities or states and what connects or separates them.
For causes, trace who acts on what, which state changes or persists,
and how it enables or prevents the next action.
When independently acting entities or independently changing states interact
to explain the outcome, give them separate visual identities.
Expose interaction through connections, containment, alignment, or transitions.

Choose the concept from those relationships:

| Concept | Emphasis |
| --- | --- |
| Sequence | Order and exchange |
| Containment | Ownership or composition |
| Topology | Connection |
| State | Transitions |
| Comparison | Differences |
| Anatomy | Parts |
| Timeline | Change over time |

Combine concepts only when the viewer question needs both.
Choose a spatial encoding for every required relationship:
actor columns and message paths can expose handoffs, containment can show ownership,
and aligned state views can expose change and persistence.
Labels identify entities, actions, and conditions within that structure.
For comparisons, keep corresponding entities recognizable and changed relationships visible.
Use stable subject names, not aliases or abbreviations viewers must decode.

Before vocabulary or layout, classify each candidate fact:

- Include content directly changing the viewer's understanding, prediction,
  comparison, or decision.
- Include topology or context necessary to interpret that content.
- Omit incidental or explicitly excluded context.
  Do not add a panel, legend, or annotation merely because a fact was supplied.

Exclusion labels still spend attention on excluded facts.
Show a scope boundary only when understanding it is part of the viewer task.
Advance only when every planned visible element serves one of the two inclusion groups,
has subject meaning, and its connections, groups, or axes answer the viewer question.

## Establish the visual vocabulary

Choose consistent treatment for each semantic role before placing objects:

```text
role -> geometry or enclosure, line treatment, text treatment,
        label placement, connector ports, optional color or fill
```

Vocabulary belongs to the artifact, not a universal shape catalog.
Keep a role's treatment consistent and distinctions recoverable at the destination.
Use the medium's native vocabulary when it expresses the subject well;
custom geometry should make a meaningful domain distinction through its parts
and stay within the medium's supported vocabulary.
Do not add geometry, color, line weight, or ornament solely as decoration.
Preserve roles in labels and relationships when treatment is ambiguous or inaccessible.

Peer paths share one routing idiom, with corresponding departure and arrival geometry,
angles or bends, and label placement.
Vary treatment to express different relationships, not convenient anchors.

For a related series, use the first accepted diagram as a local design system:
reuse semantic palette roles, line weights, typography, corners, spacing rhythm,
connector style, containment treatment, and destination scale.
Add shapes when new concepts require them, within that system.
Compare diagrams side by side at delivery size;
similar source or construction does not establish visual continuity.

## Lay out the spatial argument

Choose one dominant reading direction fitting audience, destination, and content;
keep primary transitions moving that way.
Place the main path first, then secondary branches at the elements creating them.
Put peers at a shared rank farther along the dominant axis,
spread across its perpendicular axis.
Every branch must rejoin the main path or visibly terminate.
Put a shared destination farther along than all feeding branches;
converge forward rather than reversing a peer's path toward a destination between them.
Route feedback outside the main path and label its return when the action is unclear.

Group with proximity and whitespace.
Use surrounding boundaries only for meaningful containment, ownership, or other real boundaries.
Keep secondary detail subordinate to the path answering the viewer question.

Avoid crossings: they make viewers decide whether paths connect.
Reorder, change reading direction, route around the story, or use small panels
to prevent crossings or crowding.
Use a medium's bridge or crossover notation only when established for the destination
and easier to read than a revised layout.
For two-way relationships, give each direction its own path unless genuinely undirected.
Place peers for compatible boundary ports in both directions
without reversing the main reading direction.
If the destination requires reorientation, rebuild reading direction, ports,
and routes together rather than rotating objects while retaining old routes.

Before medium syntax, specify equal or intentionally different sizes,
aligned edges and shared ranks, repeated spacing and margins,
containment bounds and interior whitespace, symmetric angles and corresponding points,
meaningful ports, visual precedence between primary and secondary paths,
and the footprint at reading size.

Arrows are verbs: direction must match the action, transfer, sequence, or dependency.
Label connectors when endpoint names do not reveal the verb.
Use undirected lines for structure or association, not directional processes.
Give meaningful relationships visible starts and ends at deliberate ports;
do not substitute proximity for a connection.
Ports should reinforce reading direction and keep routes out of nodes, labels,
and unrelated regions.

Treat text as geometry: fit objects to required labels,
reserve space on paths for connector labels, and lengthen segments when needed.
Keep labels near their subjects without disrupting the relationship's geometry.
When label length or connector count can affect layout,
test the longest required label and every required connector.

Build semantics before tuning appearance:

1. Establish direction and structural scaffolding, then primary actors, states, data,
   and meaningful boundaries, followed by related, repeated, or subordinate structures.
2. Choose ports and route primary and secondary relationships.
3. Derive contextual regions from their contents, then add connector labels
   and remaining annotations.
4. Tune appearance without changing meaning.

Follow a different construction order when the medium requires it,
while preserving the dependency: viewer task determines content,
content determines spatial model, and spatial model determines construction.

## Inspect the rendered story

Inspect in the destination or a faithful representation, at actual reading width
and every supported background or theme.
Generation, parsing, XML, text-presence checks, and source review prove only
what they check, not visual communication.

Read as the intended viewer and verify:

- Entry, direction, main path, destination, and takeaway are apparent with the
  surrounding content available there.
  Trace visible relationships to answer the viewer question: action, affected state,
  and consequence for causes; the changed relationship for comparisons.
  Geometry must expose subject interaction beyond label reading order.
  Prose may interpret, but every relationship assigned to the diagram is recoverable there.
- All required actors, states, boundaries, and relationships are present;
  unsupported or irrelevant elements do not compete with the story.
- Paths reach intended endpoints and arrows match their actions.
- Labels, objects, and paths do not overlap, clip, crowd, or cross ambiguously
  at delivery size.
- Peer routing and labels correspond; visible differences convey meaning.
- Roles remain recoverable from labels, relationships, and treatment
  on every supported surface.
- Related diagrams retain continuity at delivery size.
- Removing any visual element would remove useful meaning.

Apply medium conformance checks in the same inspection.
Semantic correctness does not excuse malformed construction,
and mechanical conformance does not excuse misleading relationships.
If a check fails, repair or simplify concept, vocabulary, or layout,
rebuild affected construction, and inspect again.
If rendered inspection is unavailable, state that gap;
source validity or generation success is not evidence of visual correctness.
