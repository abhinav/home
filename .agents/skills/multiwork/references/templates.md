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

Stable workstream IDs do not change.
Non-archived plan and log paths derive from lifecycle state and stable ID:
`workstreams/<state>/<id>/plan.md`
and `workstreams/<state>/<id>/log.md`.
Archived paths derive from `workstreams/archived/<id>/`;
the workstream plan retains the terminal lifecycle state.
Create each state directory only when a workstream first enters that state.

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
| `002-example` | completed | None | `001-example` | None | Preserve completion evidence. |

Keep every non-archived workstream in `Workstream Board`,
regardless of lifecycle state.
Omit archived terminal workstreams from the project board.
Use `condition` for evergreen workstreams.
For ordinary workstreams,
omit it or use a value already meaningful to the plan.
Keep lifecycle transitions synchronized with the workstream directory.
For archival,
preserve the terminal state in the plan and remove the board row.
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

Include this section whenever the mission uses worktrees.
Record actual workspace handoffs and their current ownership.

| Workspace / handoff | State | Scope | Owner / prior owner | Observed state | Risks / preserved work | Next action / disposition |
| --- | --- | --- | --- | --- | --- | --- |
| `<identity, path, and execution context>` | in-use | `001-example` or root integration | `<agent-id>` / `<prior-id>` | `<actual state>` | `<risks or durable result>` | `<concrete next action>` |
```

## Workstream `plan.md`

```markdown
# 001-example: <Action-Oriented Outcome>

This plan is a living, self-contained mission packet.
An agent with only the current project state and this file must be able to
continue without prior conversation or another workstream's files.

Treat purpose, boundaries, dependencies, completion criteria,
and assessment criteria as mostly stable.
Treat current context, progress, operative decisions, discoveries,
observed evidence, outcomes, ownership, blockers,
and the next action as mutable.
Update mutable content at every material checkpoint.
Revise stable content only when the work itself changes,
and record why in `log.md`.

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
Keep this section synchronized with the current implemented or investigated
design rather than leaving completed work in future tense.
Use reference-first prose,
and use a compact code or data example when it materially improves the reader's
understanding of a contract or choice.
Record relevant rejected alternatives and discoveries that shaped the result.
Do not outsource known design choices to the worker.>

## Evidence And Assessment

<Before execution,
state what evidence the work will produce and how the result will be assessed.
Use commands, tests, focused probes, expected behavior, or artifact inspection.
Source coverage, a written rubric, independent review,
or another method may better suit the outcome.
Name a fast feedback check only when it is useful.
Define success, failure, and any acceptable inconclusive result.
As work proceeds,
record the observed evidence,
the conclusion it supports,
and any remaining uncertainty.
At completion,
state the final evidence and how it establishes the completion criteria.>

## Supporting Record

<Define what belongs in sibling `log.md`,
how the work-specific record is organized,
and when it is updated.
Keep current executable truth in this plan;
use the append-only log for supporting evidence and history.>

## Recovery

<Explain safe retries, rollback, or preservation needs.
State how to recover from partial or risky steps.>

## Current State And Next Action

<Write a concise status and handoff that a reader can trust without `log.md`.
Do not create a second copy of the design, decisions, discoveries, or evidence.
Point to their named sections in this plan when a reader needs that detail.
State current progress, remaining work or blockers,
branch or worktree state, uncommitted changes,
and the current owner or active attempt.
At completion,
state whether the completion criteria were met
and replace obsolete prospective instructions elsewhere in the plan.
End with one concrete next action,
or state why no workstream action remains and name any root follow-up.>
```

## Workstream `log.md`

Keep stable context brief but sufficient to interpret the record independently.
Use plan-defined sections for supporting evidence and append-only history.
Delegated attempts are one required entry type,
not the entire log structure.

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
Choose a structure suited to implementation, research, design, or operations.
Use chronology only when sequence itself matters.
Every section must support interpretation, auditability, recovery,
or reconstruction of current plan state.
This file must be understood without reading `plan.md`.>

## <Plan-Defined Supporting Section>

<Record the work-specific evidence and history defined by the plan.
Lead with stable paths, symbols, APIs, commands, sources, measurements,
or artifacts.
Connect each material entry to its conclusion or uncertainty
and resulting plan update or next action.
Preserve detail needed to verify, audit, or resume the durable state;
omit locator steps and non-material process history.
Use headings, tables, chronology, or indexes that fit the work.>

## Delegated Attempts

Append one subsection per delegated attempt.
Preregister each attempt before dispatch.
During an assigned worker attempt,
the worker maintains the attempt entry and keeps `plan.md` synchronized
until handoff.

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

See [log-patterns.md](log-patterns.md)
for examples adapted to implementation, research, design,
and root orchestration.

See [evergreen-workstreams.md](evergreen-workstreams.md)
for recurring-cycle additions to the workstream plan, log, and root board.
