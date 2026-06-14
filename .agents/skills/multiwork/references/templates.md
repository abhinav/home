# Multiwork Templates

Use these as starting points and adapt them to the project.
Do not leave placeholders in an active plan.

## Standalone Layout

Use this compact layout only when no matching Multiwork plan already exists
and the mission has one cohesive root-owned outcome
that does not benefit from independent ownership:

```text
<base>/<plan-slug>/
  plan.md
  log.md
```

The standalone `plan.md` uses the workstream plan sections below,
but its title names the mission without a workstream ID.
It directly records the mission's current state and completion.
The sibling `log.md` uses the workstream log shape below,
but records no delegated attempt unless delegation later occurs.

Do not add a Workstream Board, state directories,
or nested workstream records to this layout.
If independently ownable work or delegation later becomes necessary,
convert the mission to the default layout before dispatch.

## Default Layout

Use the selected plan directory as the root of the layout.
By default,
that directory is a per-undertaking directory:

```text
<base>/<plan-slug>/
  plan.md
  workstreams/
    active/
      001-example/
        plan.md
        log.md
```

A repository convention or explicit user request may instead make the selected
plan directory a long-lived project base:

```text
<base>/
  plan.md
  log.md
  workstreams/
    active/
      001-example/
        plan.md
        log.md
```

In either shape,
ordinary workstream plan and log paths derive from lifecycle state
and stable ID relative to the selected plan directory.
For example,
`001-example` in `active` has plan path
`workstreams/active/001-example/plan.md`.

Create each state directory only when a workstream first enters that state.
For example,
do not create `backlog/`, `completed/`, or `archived/`
while every known workstream is active.

The root moves workstream directories between lifecycle states.
Stable workstream IDs do not change.
The root board should describe the workstream's current lifecycle state
and root-owned coordination state.
For ordinary workstreams,
derive the plan and log paths from lifecycle state and stable ID:
`workstreams/<state>/<id>/plan.md`
and `workstreams/<state>/<id>/log.md`.

## Root `plan.md`

```markdown
# <Plan Name>

## Objective

<Explain the overall result, why it matters, and how completion is recognized.>

## Plan Layout

<Name the root plan, optional root log, workstream directory pattern, and any
associated artifact locations.>

## Constraints And Boundaries

<Record project-wide scope, exclusions, assumptions, approvals, and shared
surfaces that affect coordination.>

## Workstream Board

| ID | State / condition | Owner | Depends on | Runtime | Root next action / wake |
| --- | --- | --- | --- | --- | --- |
| `001-example` | active / running | `<agent-id>` | None | `<branch>` / `<path>` | <Concrete root action.> |

Use `condition` for standing workstreams.
For ordinary workstreams,
omit it or use a value already meaningful to the plan.
When a workstream moves between lifecycle states,
update this field in the board and move the workstream directory
so derived plan and log paths remain true.
Use the board for root-owned coordination state.
A plan may add a short label when stable IDs are not enough
to distinguish workstreams at a glance.
Use explicit path fields only for documented nonstandard layouts
or migration states where path derivation is unavailable.

## Integration

<Explain how the workstream outcomes combine, their ordering, and the shared
interfaces or artifacts that the root owns.>

## Completion Evidence

<State the overall criteria and how the root will establish them.
Use commands and expected outputs when deterministic checks apply.
Use observable behavior, artifact inspection, or a written review rubric when
those better fit the result.>

## Worktree Pool

Omit this section when no pool is used.

| Path | Branch / revision | Assignment | Owner / prior owner | Dirty state | Git operation | Processes / assessments | Risks / notes | Available |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<absolute path>` | `<branch>` / `<commit>` | `001-example` | `<agent-id>` / `<prior-id>` | clean | none | none | no shared-output hazard | no |
```

## Workstream `plan.md`

```markdown
# 001-example: <Action-Oriented Outcome>

This plan is a living, self-contained mission packet.
An agent with only the current project state and this file must be able to
continue without prior conversation or another workstream's files.

## Purpose And Completion

<Explain why the work matters and what will exist or be known afterward.
State how a human can recognize completion.>

## Context And Orientation

<Describe the current state relevant to this work
as if the reader knows nothing about the project.
Name concrete repository-relative paths, modules, symbols, services, commands,
artifacts, and source-of-truth facts.
Define non-obvious terms and explain how the named parts fit together.
Summarize required facts from referenced material instead of merely linking to
it.>

## Boundaries And Ownership

- Project or worktree: `<repository root, worktree identity,
  or machine-local worktree path when that absolute assignment matters>`
- Governing instructions: `<repository-relative instruction paths>`
- Mutable surface: `<files, modules, systems, artifacts, or questions>`
- Out of bounds: `<important exclusions>`
- Environment and prerequisites: `<assumptions required to act safely>`

## Dependencies

<Use `None.` when there are no dependencies.
Otherwise list stable workstream IDs, exact required outcomes, and how readiness
is recognized.>

- `002-contract`: <Exact outcome or contract required.
  State how readiness is recognized.>

Do not link to another workstream's `plan.md` or `log.md`.
Include the dependency facts needed to act in this file.

## Decisions And Approach

<Record resolved decisions with brief rationale.
Describe the concrete execution path in order.
Name the files, symbols, systems, evidence sources, or artifact locations
involved and explain why each step is needed.
Do not outsource known design choices to the worker.>

## Evidence And Assessment

<State what evidence the work will produce and how the result will be assessed.
Use commands, tests, focused probes, expected behavior, or artifact inspection.
Source coverage, a written rubric, independent review,
or another method may better suit the outcome.
Name a fast feedback check only when it is useful.
Define success, failure, and any acceptable inconclusive result.>

## Supporting Record

<Define what belongs in sibling `log.md`,
why that material helps interpretation or resumption,
how it is organized, and when it is updated.
Keep the current mission, operative decisions, current state,
ownership, blockers, and next action authoritative in this plan.
Treat `log.md` as the append-only replay log:
append material evidence, decisions, superseding facts,
attempt outcomes, and recovery checkpoints there,
then promote any changed current state back into this plan.>

## Recovery

<Explain safe retries, rollback, or preservation needs.
State how to recover from partial or risky steps.>

## Current State And Next Action

<Record completed and remaining work, discoveries, blockers, and decisions.
Record artifacts, branch or worktree state, uncommitted changes,
current owner or active attempt,
and evidence already collected.
End with one concrete next action that can begin immediately.>
```

## Workstream `log.md`

Keep stable mission context brief.
Include enough to identify the workstream,
understand the record's organization,
and resume honestly without another workstream or the root conversation.
Use plan-defined sections for supporting evidence and history.
Delegated attempts are one required entry type,
not the entire purpose of the log.
Do not copy the plan's full implementation narrative.
Treat the log as append-only replay.
When information changes,
append the superseding evidence or decision instead of rewriting older entries.
The plan remains the current-state surface.

```markdown
# 001-example Log

## Workstream Context

- Outcome: <Owned result.>
- Essential context: <Facts needed to interpret the record below.>
- Mutable surface: `<files, modules, systems, artifacts, or questions>`
- Dependencies: <Stable IDs and exact required outcomes, or none.>
- Latest recovery checkpoint: `<timestamp>`.
  <Project or worktree, artifacts, uncommitted state,
  blocker, and the next action recorded at that time.
  The workstream plan is authoritative for mutable current state.>

## Log Format

<Define the workstream-specific sections and fields used below.
Every section should explain how it supports interpretation,
auditability, recovery, or reconstruction of the current plan state.
This file must be understood without reading `plan.md`.>

## <Plan-Defined Supporting Section>

<Record useful evidence, observations, sources, measurements, decisions,
artifacts, validation history, reviewer findings, or recovery detail.
Organize entries around the durable fact they establish,
the conclusion or uncertainty,
and the resulting plan update or next action.
Include command, output, source, or artifact detail when it is needed to
reconstruct, verify, audit, or resume that durable state.
Summarize process steps that do not change interpretation or recovery.
If a step only found the relevant path, symbol, line, artifact, or owner,
record the located reference and its significance,
not the search or inspection step.
Omit sections that only show non-material process history.
Each section must contribute to interpreting evidence,
reconstructing recovery, auditing a material interaction, or updating the plan.
When a section would only show effort, routine exploration,
or provenance for steps that produced no durable fact,
replace it with the located reference, observation,
or conclusion that supports the plan.
Use headings, tables, chronology, or indexes that fit the work.>

## Delegated Attempts

Append one subsection per delegated attempt.
Preregister each attempt before dispatch.
During an assigned worker attempt,
the worker appends material evidence, decisions, validation results,
superseding facts, blockers, recovery checkpoints,
and attempt outcomes here until handoff.
The worker also keeps `plan.md` synchronized with the current state
that those entries establish.

### Attempt <number>: <short objective>

#### Preregistration

- Registration: write-ahead | late
- Recorded at: `<timestamp>`
- Attempt began at: `<timestamp or unknown>`
- Agent: `<worker or reviewer ID>`
- Role: worker | reviewer
- Objective: <Distinct objective, retry, or material pivot.>
- Starting state: `<commit, artifact revision, environment, or unknown>`
- Expected result: <Artifact, conclusion, or observable change.>
- Expected evidence: <What the attempt should produce.>
- Assessment: <How the result will be judged.>

Use `late` when the attempt began before this entry.
Label unavailable facts `unknown`.
Do not infer or backdate them.

#### Outcome

- Result: <Observed result or dispatch failure.>
- Evidence: <Relevant artifacts, sources, commits, or changed paths.
  Include observations or review findings.>
- Conclusion: <What the evidence establishes and any remaining uncertainty.>
- Next action: <Concrete prose.>
```

Append corrections and superseding facts rather than erasing earlier entries.
Do not log routine messages or every command.

See [log-patterns.md](log-patterns.md)
for examples adapted to implementation, research, design,
and root orchestration.

See [standing-workstreams.md](standing-workstreams.md)
for recurring-cycle additions to the workstream plan, log, and root board.
