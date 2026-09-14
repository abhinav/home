# Pikchr scenarios

## 00 Shared diagram-design routing

### Prompt

Use the Pikchr skill at `{SKILL_PATH}`.
The `diagram-design` skill is installed and discoverable by name.

A user asks:
"Plan and create an editable Pikchr diagram for a 640-pixel documentation
column.
It should explain how a request branches to synchronous work or a queue,
then rejoins at result storage.
Return Pikchr source and SVG."

Create artifacts under a task-local temporary directory.

### Expected behavior

- Access `diagram-design` by name before choosing content or layout.
- Use the viewer task and destination width to choose the concept,
  reading direction, vocabulary, and spatial model.
- Use Pikchr guidance for relative construction, rendering,
  medium-specific inspection, and delivery.
- Return both requested artifacts.

### Unacceptable behavior

- Construct the source from Pikchr mechanics alone without reaching
  `diagram-design`.
- Repeat the shared diagram-design guidance inside Pikchr instead of using its
  governing skill.
- Treat SVG generation as sufficient evidence of visual correctness.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:
"What command renders the existing `queue.pikchr` file to SVG?
Do not review or change the diagram."

#### Expected behavior

- Answer from Pikchr's rendering mechanics without loading `diagram-design`.
- Do not perform diagram planning or semantic inspection that the user did not
  request.

#### Unacceptable behavior

- Load shared design guidance for a medium-mechanics question that does not
  choose or review content or layout.

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

## 05 Viewer task and rendered inspection

### Prompt

Use the skill at `{SKILL_PATH}`.

A user asks:
"Create a Pikchr architecture diagram for a design review from these notes:
- Edge Router sends normalized sessions to Session Service.
- Session Service reads Token Store.
- Recovery Worker reads failed sessions and may refresh Token Store.
- The review must decide whether token-refresh ownership belongs to Session
  Service or Recovery Worker.
- All services use Rust.
- Token Store is backed up hourly.
- Recovery Worker runs in two regions.
- The review is not deciding implementation language, backup policy,
  or regional deployment.
Return editable Pikchr source and rendered SVG."

Create the requested artifacts under a task-local temporary directory.

### Expected behavior

- The diagram emphasizes the request path and token-refresh ownership decision.
- It omits implementation language, backup policy, and regional deployment
  because those facts do not change the review decision.
- The source uses stable subject names and relative layout.
- The SVG renders successfully and is inspected visually for legibility,
  clipping, overlap, connector endpoints, and ambiguous crossings.
- Reported validation distinguishes parsing or XML checks
  from inspection of the rendered image.

### Unacceptable behavior

- Excluded facts appear as nodes, labels, legends, or a context panel merely
  because they were available in the source notes.
- Parsing, XML validation, or text-presence checks are treated as sufficient
  evidence that the diagram is visually correct.
- The rendered diagram contains clipped or overlapping labels,
  ambiguous paths, or unreadable structure.

### Adjacent valid case

#### Runner prompt addition

Replace the review scope with:
"The review must decide token-refresh ownership
and whether hourly Token Store backups let Recovery Worker restore safely."

#### Expected behavior

- The hourly backup fact appears because it now changes a review decision.
- Implementation language and regional deployment remain omitted.

#### Unacceptable behavior

- The repair omits every contextual fact regardless of the viewer's task.

## 06 Decide whether to draw

### Prompt

Use the skill at `{SKILL_PATH}`.

A documentation editor asks:
"I am considering adding a Pikchr diagram beside this existing table:

| Mode | Size |
| --- | ---: |
| fast | 18 MB |
| balanced | 11 MB |
| compact | 7 MB |

The only point is that smaller modes use less space.
Decide whether the visual belongs.
If it helps, create Pikchr source and SVG.
If it does not, recommend omitting it."

Do not modify the skill or any repository.

### Expected behavior

- Recommend omitting the diagram because the table already communicates the
  comparison directly.
- Explain which spatial relationship is absent or already clear.
- Do not create an artifact merely because the candidate format is available.

### Unacceptable behavior

- Create a decorative chart that repeats the same values and ordering.
- Treat every possible visual as useful.

### Adjacent valid case

#### Runner prompt addition

Replace the request with:
"Create a Pikchr diagram of the same data for a slide that cannot include the
table.
Return source and SVG."

#### Expected behavior

- Create the explicitly requested Pikchr artifact.
- Choose a visual form that makes the size comparison clear.

#### Unacceptable behavior

- Refuse the explicit request because a table would have been sufficient in a
different destination.

## 07 Embedded destination

### Prompt

Use the skill at `{SKILL_PATH}`.

Create a Pikchr diagram for an internal guide.
It will appear immediately below prose that already says,
"A controller asks two remote workers for status,
then stores the combined result."
The page has a 660-pixel reading column,
and readers may use either light or dark mode.
Use a transparent canvas.
The diagram should help readers understand which machine owns each component
and the request and response paths.
Return editable Pikchr source, SVG, and a raster preview at the destination
width.

Create artifacts under a task-local temporary directory.

### Expected behavior

- Use the surrounding prose as available context instead of repeating every
  stated action.
- Choose an orientation and scale that remain legible at 660 pixels.
- Preserve transparency and inspect representative light and dark destination
  surfaces.
- Return the requested source, SVG, and destination-width preview.

### Unacceptable behavior

- Finish a wide diagram and shrink it until its labels become hard to read.
- Add an opaque canvas or colors that disappear on one supported background.
- Treat an unconstrained full-size SVG as proof of destination legibility.

## 08 Custom visual vocabulary

### Prompt

Use the skill at `{SKILL_PATH}`.

Create a Pikchr diagram for a scheduling guide.
It must show three repeated job capsules.
Each capsule has an input port,
a processing chamber,
an output port,
and one status marker.
Jobs move left to right,
and the second capsule routes a rejected job downward to review.
Establish a coherent visual vocabulary so the repeated internal structure and
different semantic roles remain recognizable.
Use a custom composite shape if that communicates the capsule better than a
generic box.
Return editable Pikchr source and SVG.

Create artifacts under a task-local temporary directory.

### Expected behavior

- Assign consistent geometry, styling, label placement, and connection points
  to repeated semantic roles.
- Group the capsule's internal parts as one coherent unit.
- Reuse the stable capsule construction through a macro or explicit repeated
  construction with shared prototypes.
- Keep each capsule's ports and internal parts addressable to later paths.
- Connect the normal and rejected paths through meaningful ports.

### Unacceptable behavior

- Draw unrelated generic boxes and explain their roles only in a legend.
- Use custom geometry that is decorative rather than semantically useful.
- Hide ports or internal parts behind an abstraction that later paths cannot
  address.
- Tune each repeated capsule independently.

## 09 Paint order and connector labels

### Prompt

Use the skill at `{SKILL_PATH}`.

Create a transparent Pikchr sequence-style diagram with three actor lanes.
Put a pale ownership region behind the middle lane,
draw two request arrows and their labels across lanes,
and place a response arrow beneath them.
The labels must interrupt their connector cleanly without a background-colored
halo,
and no later object may cover an arrowhead or actor border.
Return editable Pikchr source and SVG,
and explain how you checked the result.

Create artifacts under a task-local temporary directory.

### Expected behavior

- Paint the ownership region behind the foreground lanes and connectors.
- Split connectors around labels or use another real geometric gap.
- Preserve transparency without background-colored masks.
- Inspect arrowheads, actor borders, labels, and overlaps in the rendered
  result.

### Unacceptable behavior

- Paint a later fill over an earlier connector, arrowhead, or border.
- Hide a connector beneath an opaque label patch or halo.
- Claim that successful parsing establishes correct paint order.

## 10 Visual language across a series

### Prompt

Use the skill at `{SKILL_PATH}`.

You are adding the second diagram to a user guide.
The first accepted Pikchr diagram uses square record cells,
rounded action nodes,
unboxed connector labels,
a restrained blue-gray palette,
and compact monospace command labels.
The new diagram explains a related transfer sequence.
It will be embedded in the same 640-pixel reading column,
and the page supports light and dark themes.
The editor asks for your concrete design and validation plan before you draw it.

Return the plan only.
Do not create files or modify any repository.

### Expected behavior

- Treat the accepted diagram as the local visual system for shared semantic
  roles.
- Let the destination width influence orientation and scale before layout.
- Allow new geometry when the transfer concept requires it,
  while keeping typography, spacing, strokes, palette roles, and connector
  treatment coherent.
- Compare both diagrams at delivery width on representative light and dark
  surfaces.

### Unacceptable behavior

- Copy every old shape even when it represents a different semantic role.
- Invent an unrelated style because the new diagram has different content.
- Validate only the new diagram at its unconstrained native size.

## 11 Parametric geometry

### Prompt

Use the skill at `{SKILL_PATH}`.

Create a Pikchr diagram for an instrumentation guide.
A controller sits at the center of twelve sensor spokes.
Four threshold rings cross every spoke.
Mark one reading on each spoke at its intersection with a threshold ring,
connect readings around the controller to show the observed contour,
and emphasize two anomalous readings.
The source should remain practical if the sensor count changes from twelve to
sixteen.
Return editable Pikchr source and SVG.

Create artifacts under a task-local temporary directory.

### Expected behavior

- Derive spoke angles and threshold distances from shared variables.
- Keep every reading intersection addressable for the observed contour.
- Preserve a local change path for a different sensor count.

### Unacceptable behavior

- Tune independent canvas coordinates for every spoke or ring.
- Draw the contour approximately without anchoring it to the readings.
- Introduce an abstraction that prevents later paths from addressing individual
  readings.

## 12 Peer routes and shared anchors

### Prompt

Use the skill at `{SKILL_PATH}`.

Create a Pikchr diagram for a review guide.
A classifier sends accepted records to automatic review
and uncertain records to manual review.
Both review paths write to one audit store.
The two paths represent distinct review outcomes and must remain distinguishable.
Manual review can return an incomplete record to its intake queue.
Return editable Pikchr source and SVG,
and explain how you inspected the rendered result.

Create artifacts under a task-local temporary directory.

### Quality bar

- Evaluation mode: judgment.
- Peer review paths use corresponding routing geometry and label placement.
- Every relationship remains visually recoverable at its endpoints.
- The reverse return path remains visible without determining the geometry of
  the forward peer paths.

### Expectations

- Use one routing idiom for the peer review paths.
- Keep distinct relationships visible where they meet the audit store.
- Derive nearby named points from the store when its built-in anchors do not
  provide enough separation.
- Inspect the rendered paths and arrowheads together rather than relying on
  successful SVG generation.

### Adjacent valid case

The two review paths instead represent the same relationship,
and their overlap at the audit store remains visually unambiguous.

- A shared destination anchor remains acceptable.
- Do not offset paths merely to satisfy a one-path-per-anchor rule.
