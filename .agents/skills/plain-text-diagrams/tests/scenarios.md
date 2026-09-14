# Plain-text diagrams scenarios

## 00 Shared diagram-design routing

### Prompt

Use the plain-text-diagrams skill at `{GUIDANCE_PATH}`.
The `diagram-design` skill is installed and discoverable by name.

A user asks:
"Create a compact plain-text diagram for a Markdown runbook.
An intake service sends small tasks to a local executor
and large tasks to a batch executor.
Both executors write to one ledger.
A failed batch task enters a retry queue,
then returns to the batch executor.
Return only the diagram."

Produce the requested artifact.

### Expected behavior

- Access `diagram-design` by name before choosing content or layout.
- Use its viewer and spatial model for reading direction,
  branches, forward fan-in, and the subordinate feedback path.
- Use plain-text guidance for rectangles, glyph ports, display columns,
  destination width, and delivery.

### Unacceptable behavior

- Build the grid from glyph mechanics alone without reaching
  `diagram-design`.
- Repeat the shared diagram-design guidance inside the plain-text skill instead
  of using its governing skill.
- Produce a semantically correct plan with malformed boxes or connectors.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:
"For an existing plain-text diagram in a Markdown file,
should I use ASCII or Unicode box-drawing characters?
Do not review or change the diagram."

#### Expected behavior

- Answer from the plain-text medium rules without loading `diagram-design`.
- Do not perform diagram planning or semantic inspection that the user did not
  request.

#### Unacceptable behavior

- Load shared design guidance for a medium-mechanics question that does not
  choose or review content or layout.

## 01 Catalog selection

### Prompt

Available skills:

- `plain-text-diagrams`: {GUIDANCE_DESCRIPTION}
- `pikchr`: Create Pikchr source or SVG when Pikchr is explicitly requested.
- `excalidraw`: Create hand-drawn diagrams and flowcharts.

User request:
"Add a diagram to a Markdown runbook showing how a request passes through
validation,
branch to either synchronous handling or a queue,
and later rejoin at result storage."

Choose the skill or skills to load and explain briefly.

### Expected behavior

- Select `plain-text-diagrams` because the Markdown runbook is a plain-text
  artifact and the branching and rejoining path benefits from spatial
  explanation.
- Base the choice on the destination and requested explanation rather than
  requiring the user to say "plain-text diagram."

### Unacceptable behavior

- Omit `plain-text-diagrams` because the user did not prescribe a format.
- Select a representation that cannot remain readable in the runbook's plain
  text.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:
"Return editable Pikchr source for this request path."

#### Expected behavior

- Select `pikchr`.

#### Unacceptable behavior

- Override the representation selected by the user.

### Open-format chat case

#### Runner prompt addition

Replace the user request with:
"Explain this request path in chat with a diagram.
Choose the representation that makes the relationships clearest."

#### Expected behavior

- Treat plain text as one suitable option rather than a requirement imposed by
  chat.
- Permit another suitable in-chat diagram representation when it better serves
  the explanation.

#### Unacceptable behavior

- Claim that chat requires a plain-text diagram.
- Rule out another suitable representation solely because the response appears
  in chat.

## 02 Proactive chat explanation

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Help me understand this upload path.
The edge service authenticates the upload.
Rejected uploads stop immediately.
Accepted uploads go to a scanner.
Clean files enter durable storage.
Suspicious files enter quarantine and a reviewer can either delete them
or release them into durable storage.
Answer in chat and choose the clearest representation."

Produce the response.

### Expected behavior

- Use a diagram because the explanation contains a main sequence,
  a terminating branch, and a branch that can rejoin the main destination.
- Plain text or another suitable in-chat representation is acceptable.
- Give the diagram one dominant reading direction.
- Keep any supporting prose concise and consistent with the diagram.

### Unacceptable behavior

- Use prose alone while forcing the viewer to reconstruct the branches.
- Claim that chat requires or excludes a particular diagram representation.
- Add a path that the request does not establish.

## 03 Branch, fan-in, and retry loop

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Create a compact diagram for a Markdown runbook.
An intake service sends small tasks to a local executor
and large tasks to a batch executor.
Both executors write to the same ledger.
A failed batch task enters a retry queue,
then returns to the batch executor.
Return only the diagram."

Produce the requested artifact.

### Quality bar

- Evaluation mode: judgment.
- Every stated relationship is recoverable without guessing.
- The main path has one reading direction;
  the retry path is subordinate and returns visibly.
- Connector columns, endpoints, corners, and junctions align.

### Expectations

- Use Unicode connectors and arrows.
- Show two branches that terminate at the same ledger.
- Give the two executor branches corresponding route geometry and label
  placement.
- Show `batch executor → retry queue → batch executor` as a directed cycle.
- Do not imply that the local executor feeds the retry queue.
- Enclose the diagram in a Markdown `text` fence.

## 04 Requested ASCII

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Draw an ASCII-only diagram for a plain-text email.
Show a parser sending valid records to storage
and invalid records to a rejection log.
Return only the diagram."

Produce the requested artifact.

### Expected behavior

- Use only ASCII characters.
- Preserve a clear branch and directed outcomes.
- Do not add Markdown fences unless the email format requires them.

### Unacceptable behavior

- Use Unicode box-drawing characters or arrows.
- Mix ASCII and Unicode connector systems.

## 05 Width and complexity pressure

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Put a plain-text architecture diagram in a commit message body.
It must fit within 72 columns.
Show a public gateway calling authentication and rate limiting,
then three regional coordinators,
each with a primary database, replica, cache, and audit sink.
Cross-region failover can target either neighboring coordinator."

Produce the requested artifact.

### Expected behavior

- Preserve the 72-column destination limit.
- Split the explanation into small labeled panels or layers if one canvas would
  create crossings or unreadable density.
- Keep cross-region failover distinct from each region's local flow.

### Unacceptable behavior

- Return one crowded canvas with ambiguous crossings.
- Allow any diagram line to exceed the destination width.
- Replace the requested plain-text artifact with another diagram format.

## 06 Rectangular shape construction

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Create a compact plain-text diagram for a Markdown operations guide.
An event source sends work to a routing service.
The routing service has a second line labeled `policy checks`.
It sends accepted work to a worker pool,
which has a second line labeled `four workers`.
Show every actor as a closed box.
Return only the diagram."

Produce the requested artifact.

### Quality bar

- Evaluation mode: conformance.
- Every box is visibly closed and aligned by display column.
- Every connector attaches to a compatible boundary port or arrowhead.

### Expectations

- Keep each box's left and right walls in the same columns on every row.
- Keep the top and bottom border widths equal.
- Pad multiline labels without moving a border.
- Use Unicode box-drawing characters and a Markdown `text` fence.

## 07 Line families and containment

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Create a plain-text diagram for a Markdown design note.
Inside a double-line `Processing system` boundary,
show two independent left-to-right flows.
Use light boxes and connectors for `Ingest → Archive`.
Use heavy boxes and connectors for `Alert → Pager`.
Include a compact legend for the line meanings.
No connector crosses the system boundary.
Return only the diagram."

Produce the requested artifact.

### Quality bar

- Evaluation mode: conformance.
- Each line family has one stated meaning and coherent geometry.
- The containing boundary encloses both flows without touching them.

### Expectations

- Use double glyphs for the complete outer boundary.
- Use light glyphs for every part of the normal flow.
- Use heavy glyphs for every part of the critical flow.
- Keep all rectangles closed and all connectors continuous.
- Include a legend that maps light and heavy lines to their roles.

## 08 Semantic roles without silhouettes

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Create a plain-text flow diagram for a Markdown troubleshooting guide.
The flow is `Read record → usable?`.
No goes to `Discard`.
Yes goes to `Normalize → Records database`.
Make the decision and database roles apparent.
Return only the diagram."

Produce the requested artifact.

### Quality bar

- Evaluation mode: judgment.
- A reader can identify the decision, its outcomes, and the database role
  without interpreting a decorative silhouette.
- Every shape and connector is closed, aligned, and traceable.

### Expectations

- Use labeled rectangles for the decision and database roles.
- Label the decision branches `yes` and `no`.
- Keep one dominant reading direction.
- Do not rely on a diamond or cylinder silhouette to carry meaning.

## 09 Peer routes and a shared destination

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:
"Create a compact plain-text diagram for a Markdown review guide.
A classifier sends accepted records to automatic review
and uncertain records to manual review.
Both review paths write to one audit store.
The two paths represent distinct review outcomes and must remain distinguishable.
Manual review can return an incomplete record to its intake queue.
Return only the diagram."

Produce the requested artifact.

### Quality bar

- Evaluation mode: judgment.
- Peer review paths use corresponding grid geometry and label placement.
- Both distinct relationships remain recoverable where they meet the store.
- The reverse return path remains visible and mechanically valid.

### Expectations

- Keep each review outcome visible through its arrival at the audit store.
- Use compatible boundary ports, continuous connector runs,
  and corresponding turns for the peer paths.
- Route the incomplete-record return outside the forward paths.
- Enclose the diagram in a Markdown `text` fence.

### Adjacent valid case

The two review paths instead represent the same relationship,
and a shared junction preserves the intended meaning.

- A shared junction remains acceptable.
- Do not keep paths separate merely to satisfy a one-path-per-port rule.
