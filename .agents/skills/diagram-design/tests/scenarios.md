# Diagram design scenarios

## 01 Catalog selection

### Prompt

Available skills:

- `diagram-design`: {GUIDANCE_DESCRIPTION}
- `pikchr`: Create Pikchr source or SVG when Pikchr is explicitly requested.
- `plain-text-diagrams`: Create diagrams that must remain readable as text.
- `imagegen`: Generate raster illustrations and visual assets.

User request:
"Review this architecture diagram's visual language and spatial composition.
I have not chosen a rendering format yet.
I need to know whether the ownership boundary and retry path will be clear to a
reader."

Choose the skill or skills to load and explain briefly.

### Expected behavior

- Select `diagram-design` because the request concerns a medium-independent
  spatial argument and visual vocabulary.
- Do not select a construction skill before the medium is chosen.
- Do not select raster illustration merely because the artifact is visual.

### Unacceptable behavior

- Omit `diagram-design` because no rendering medium was selected.
- Treat architecture-diagram review as decorative image generation.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:
"Turn these monthly revenue values into a line chart.
Choose appropriate axes and a scale."

#### Expected behavior

- Do not select `diagram-design` solely because a chart is two-dimensional.
- Select guidance for quantitative visualization when it is available.

#### Unacceptable behavior

- Treat every visual artifact as an explanatory spatial diagram.

## 02 Decide whether to draw

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A documentation editor asks:
"I am considering adding a diagram beside this existing table:

| Mode | Size |
| --- | ---: |
| fast | 18 MB |
| balanced | 11 MB |
| compact | 7 MB |

The only point is that smaller modes use less space.
Decide whether the visual belongs.
If it does not, recommend omitting it."

Do not create files or modify any repository.

### Expected behavior

- Recommend omitting the diagram because the table already communicates the
  comparison directly.
- Identify that no additional spatial relationship needs explanation.
- Do not create decorative structure merely because a visual is possible.

### Unacceptable behavior

- Recommend a diagram that repeats the same values and ordering.
- Treat every possible visual as useful.

### Adjacent valid case

#### Runner prompt addition

Replace the destination with:
"The comparison will appear on a slide that cannot include the table.
Plan a diagram that makes the size comparison clear."

#### Expected behavior

- Plan the explicitly requested diagram for the actual destination.
- Choose a concept that makes the comparison apparent.

#### Unacceptable behavior

- Refuse the diagram because a table worked in another destination.

## 03 Viewer task and content selection

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A design review needs a diagram plan from these notes:

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

Choose the diagram concept, content, reading direction, and visual vocabulary.
Do not choose a rendering medium or create files.

### Expected behavior

- Center the plan on the request path and token-refresh ownership decision.
- Omit implementation language, backup policy, and regional deployment because
  they do not change the review decision.
- Use stable subject names and make the competing ownership paths comparable.
- Establish an entry point, intended takeaway, and dominant reading direction.

### Unacceptable behavior

- Include every available fact in nodes, labels, legends, or context panels.
- Choose styling before identifying the viewer's decision.
- Invent a transfer or ownership relationship not present in the notes.

### Adjacent valid case

#### Runner prompt addition

Replace the review scope with:
"The review must decide token-refresh ownership
and whether hourly Token Store backups let Recovery Worker restore safely."

#### Expected behavior

- Include the hourly backup fact because it now changes a review decision.
- Continue to omit implementation language and regional deployment.

#### Unacceptable behavior

- Omit every contextual fact regardless of the viewer's task.

## 04 Branch, fan-in, and feedback

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Plan the spatial model for an explanatory diagram.
An intake service sends small tasks to a local executor
and large tasks to a batch executor.
Both executors write to one ledger.
A failed batch task enters a retry queue,
then returns to the batch executor.

Describe the placement, reading direction, attachment points,
and route of each relationship.
Do not choose a rendering medium or create files.

### Quality bar

- Evaluation mode: judgment.
- The main story has one dominant reading direction.
- Both branches converge forward on the shared destination.
- Peer branches use corresponding routing geometry and label placement.
- The feedback path is subordinate and returns visibly.
- No route implies that the local executor feeds the retry queue.

### Expectations

- Place the intake service before both executors on the dominant axis.
- Place both executors at a shared rank.
- Place the ledger farther along the dominant axis than both executors.
- Use one routing idiom for the executor branches,
  with corresponding departure and arrival geometry.
- Route the retry cycle around the batch path and label its actions.
- Choose deliberate ports that keep the retry path distinct from local work.

### Adjacent valid case

The failed batch task must visibly travel backward from the batch executor
to the retry queue before returning to the executor.

- Preserve the reverse direction because it communicates the actual flow.
- Do not force the retry cycle to use the forward geometry of the peer
  executor branches.

## 05 Destination and visual continuity

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

An editor is adding the second diagram to a user guide.
The first accepted diagram uses square record cells,
rounded action nodes,
unboxed connector labels,
a restrained blue-gray palette,
and compact monospace command labels.
The new diagram explains a related transfer sequence.
It will appear in the same 640-pixel reading column,
and the page supports light and dark themes.

Return a concrete design and inspection plan only.
Do not choose a rendering medium or create files.

### Expected behavior

- Treat the accepted diagram as the local visual system for shared semantic
  roles.
- Let the destination width influence orientation and scale before layout.
- Allow new geometry when the transfer concept requires it.
- Preserve typography, spacing, line treatment, palette roles,
  and connector treatment across the series.
- Compare both diagrams at delivery width on representative light and dark
  surfaces.

### Unacceptable behavior

- Copy every old shape when it represents a different semantic role.
- Invent an unrelated style because the new diagram has different content.
- Validate only the new diagram at an unconstrained native size.

## 06 Semantic inspection

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Review this description of a rendered process diagram:

- The first visible element is an unlabeled database at the far right.
- A request arrow points left from Results to Intake.
- Two processing branches cross without a bridge or junction.
- The retry label overlaps the worker box at delivery width.
- A legend includes the team's programming language,
  although language does not affect the process being explained.
- The source parses and the renderer exits successfully.

State whether the diagram is ready and identify the required revisions.
Do not create files.

### Expected behavior

- Reject the diagram as not ready despite successful generation.
- Repair the entry point and reading direction.
- Correct the request arrow's direction.
- Reroute or reorganize the ambiguous crossing.
- Give the retry label enough space at delivery width.
- Remove the irrelevant programming-language legend.
- Require another rendered inspection after revision.

### Unacceptable behavior

- Treat parsing or rendering success as visual correctness.
- Accept a connector or label whose meaning requires guesswork.
- Retain irrelevant content merely because the source supplied it.
