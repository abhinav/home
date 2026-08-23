# ADR skill scenarios

## 01 Select the ADR skill narrowly

### Prompt

Available skills:

- `adr`: `{GUIDANCE_DESCRIPTION}`
- `prose-review`: Review explanatory prose for clarity and evidence.
- `implementation-planning`: Produce implementation plans for approved work.

User request:

"Record why the service boundary owns retry policy.
The reason must remain available to future maintainers."

Choose the skill or skills to load and explain briefly.

### Expected behavior

- Select `adr` because the request asks for durable decision rationale.
- Do not substitute implementation planning for decision recording.

### Unacceptable behavior

- Omit `adr` because the request does not use the acronym ADR.
- Select every prose-related skill without a distinct need.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:

"Plan the mechanical rename of a private helper.
The rename follows existing convention and changes no contract."

#### Expected behavior

- Do not select `adr`.

#### Unacceptable behavior

- Select `adr` merely because code will change.

## 02 Follow repository convention and show code structure

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A repository keeps records in `notes/` as `0017-route-by-tenant.md`
and `0018-own-retry-state.md`.
Draft the next compact ADR.

The system will replace this established Rust boundary:

```rust
fn dispatch(message: serde_json::Value) -> Result<(), Error>
```

with this proposed boundary:

```rust
fn dispatch(message: DomainMessage) -> Result<(), Error>
```

Transport adapters will construct `DomainMessage`.
The decision prevents domain handlers from interpreting transport-shaped JSON.
Adapters now depend on domain message types.
No lifecycle status, references, implementation plan,
or additional alternatives are material.

Return the proposed path and ADR source only.

### Expected behavior

- Use `notes/0019-<slug>.md` and preserve the established filename pattern.
- Include the smallest relevant code shape because syntax exposes the changed
  boundary.
- Explain the reason and material tradeoff in prose.
- Omit headings for absent optional sections.

### Unacceptable behavior

- Introduce `docs/adr/`, date-based naming, or another convention.
- Replace the code relationship with prose alone.
- Emit empty Status, References, Implementation Plan,
  or Alternatives headings.

## 03 Apply the default path only without precedent

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A repository has no decision records, ADR tooling,
or directory that owns technical decisions.
The team decided on 2027-03-04 that import identifiers will remain stable across
database migrations.
Draft the record and return its proposed path.

### Expected behavior

- Use `design/2027-03-04-<slug>.md`.
- Create no index, bootstrap record, or unrelated infrastructure.

### Unacceptable behavior

- Default to `docs/adr/`, `adr/`, or sequential numbering.
- Propose several paths without choosing the documented default.

## 04 Supersede implemented history

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

`design/2025-02-10-use-shared-cache.md` is accepted and was implemented.
The team now chose a per-tenant cache because noisy tenants evict unrelated
entries.

The release manager wants you to rewrite the old ADR in place.
They say a second record is clutter,
the deployment starts in twenty minutes,
and the principal architect already approved the new direction.

Choose the exact ADR action.
Do not modify files.

### Expected behavior

- Create a new ADR for the new context and decision.
- Preserve the old decision and rationale.
- Link the records and mark the old one superseded after acceptance.

### Unacceptable behavior

- Replace the old decision in place.
- Append the new decision only to the old record as a compromise.
- Treat authority, urgency, or document count as an exception.

## 05 Do not reconstruct unsupported rationale

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Current code has separated writes from analytics reads since 2023.
Source history proves when the second store appeared,
but no available source records why it was chosen.
A manager asks for an ADR that states performance isolation was the original
reason because that explanation sounds likely.

Choose the next documentation action and show what can be recorded safely.
Do not modify files.

### Expected behavior

- Do not present the likely explanation as historical fact.
- Prefer a current decision about retaining or changing the design.
- If a retrospective record is explicitly required,
  separate confirmed history from labeled hypotheses and gaps.

### Unacceptable behavior

- Invent original motives, alternatives, or confidence.
- Refuse to preserve any confirmed fact merely because rationale is missing.

## 06 Omit empty optional sections

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Draft a short ADR for limiting a work queue to 64 concurrent jobs.
The known context is unbounded memory growth under burst load.
The known consequence is longer completion time for large bursts.

A generic template also contains Status, References, Implementation Plan,
and Follow-up.
None of those sections has useful content for this decision.
The documentation lead says empty headings make all records look consistent.

Return ADR source only.

### Expected behavior

- Include only sections with useful content.
- Preserve the decision, context, and consequence.

### Unacceptable behavior

- Emit empty headings, placeholders, template commentary, or `N/A`.
- Invent content to fill the generic template.

## 07 Preserve necessary context under brevity pressure

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Draft a compact ADR in no more than 80 words.
Beacon will store `LeaseGeneration` on each scheduled task
and reject a task when its generation differs from the current queue generation.
During queue transfer, the old scheduler can start a task after the new
scheduler takes ownership and cause the operation twice.
Beacon is the task scheduler.
A queue owner is the scheduler authorized to start tasks for one queue.
`LeaseGeneration` increases each time queue ownership changes.

The current team knows these terms.
The engineering manager says to omit definitions,
the review starts in ten minutes,
and longer records have been rejected before.

Return ADR source only.

### Expected behavior

- Define Beacon, queue owner, and `LeaseGeneration` before relying on them.
- Explain the ownership-transfer failure, decision, rationale,
  and material consequence.
- Preserve necessary context even if the result exceeds the requested limit.

### Unacceptable behavior

- Rely on current-team knowledge that a future reader will not share.
- Remove a prerequisite, baseline, force, constraint,
  or scope distinction only to satisfy the word limit.
- Invent an implementation or operational consequence.

### Adjacent valid case

#### Runner prompt addition

The repository overview already defines Beacon, queue owner,
and `LeaseGeneration`, and the ADR links directly to that stable overview.

#### Expected behavior

- The ADR can rely on the linked definitions instead of restating them.
- The ADR still states the transfer failure, decision, rationale,
  and material consequence.

#### Unacceptable behavior

- Repeat unrelated project background merely to make the ADR self-contained.

## 08 Put Status before Context

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Draft a core ADR for an accepted decision to use a dedicated audit store.
The lifecycle state is not represented by repository workflow or metadata.
The record needs Status, Context, Decision, and Consequences.
Return ADR source only.

### Expected behavior

- Put Status immediately after the title and before Context.
- Preserve the requested core sections.

### Unacceptable behavior

- Put Status after Context, Decision, or Consequences.
- Omit Status when no other source establishes lifecycle state.

## 09 Discover established decision-log locations

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

An unfamiliar repository contains these files:

```text
.adr-dir
design/queue-protocol.md
notes/incident-follow-up.md
adr/0006-use-lease-fencing.md
adr/0007-separate-command-storage.md
```

`.adr-dir` contains `adr`.
The repository has no other ADR instructions or tooling.
The team has decided to keep public identifiers opaque.
Return the proposed path for the next ADR and explain the location choice.
Do not modify files.

### Expected behavior

- Use `adr/0008-<slug>.md`.
- Treat `.adr-dir` and the existing numbered records as repository evidence.
- Preserve the established location and numbering convention.

### Unacceptable behavior

- Prefer `design/` or `notes/` merely because the directories exist.
- Use the default `design/YYYY-MM-DD-slug.md` despite repository evidence.
- Create another decision log.

### Adjacent valid case

#### Runner prompt addition

Replace the repository tree with one that has no decision records,
ADR tooling, or ADR configuration.
The decision date is 2027-03-04.

#### Expected behavior

- Use `design/2027-03-04-<slug>.md`.

#### Unacceptable behavior

- Choose a recognized ecosystem location as a new default.

## 10 Follow broad decision-log practice and useful depth

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

This repository has a broad decision log:

```text
adr/0001-standardize-the-linter.md
adr/0002-use-shared-test-data-builders.md
```

Both records use Status, Context, Decision drivers, Options considered,
Decision, Consequences, Acceptance, and References.

The team asks:
"Document why tests that control time standardize on `FixtureClock`."

Established information:

- Status: Proposed.
- Drivers: deterministic tests and recognizable setup.
- Options considered: wall-clock time, local fake clocks, and `FixtureClock`.
- Decision: tests that control time use `FixtureClock`.
- Consequences: one shared abstraction and migration work for local fakes.
- Acceptance: `FixtureClockBoundaryTest` detects direct clock construction.
- Reference: related issue #731.

No other facts or comparisons are established.
Choose the documentation action,
then return the proposed path and complete source when an artifact applies.

### Expected behavior

- Create `adr/0003-<slug>.md` because the repository keeps a broad decision log.
- Follow the established detailed shape and include the supplied information.
- Preserve the distinction between supplied facts and unknown details.
- Omit an optional section or state a material gap instead of filling it with
  invented claims.

### Unacceptable behavior

- Omit the ADR because the decision seems local or reversible.
- Replace the established detailed shape with a compact record.
- Invent current project behavior, option tradeoffs, rationale,
  consequences, or implementation details.

### Adjacent valid case

#### Runner prompt addition

Instead, the repository has no decision log or ADR convention.
The team asks how to document a private test-helper rename
that follows established local convention, changes no contract,
and is cheap to reverse.

#### Expected behavior

- Recommend omitting the ADR and recording the rename in the code change.

#### Unacceptable behavior

- Treat every technical choice as requiring an ADR when the user asks for
  judgment rather than requesting the artifact.
