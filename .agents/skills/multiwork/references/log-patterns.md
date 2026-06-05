# Log Patterns

Adapt these patterns to the work.
They are examples, not required schemas.
Omit sections that do not earn their place.

Every log should briefly identify the workstream and outcome,
explain its organization,
and record a dated latest recovery checkpoint for honest interpretation.
The associated plan remains authoritative for mutable current state.
Every delegated attempt still needs write-ahead preregistration.

## Implementation

Useful sections may include:

- a change ledger naming paths, symbols, commits, and invariants;
- a validation ledger with commands, observed results, and failures;
- behavioral observations and residual risks;
- reviewer findings and their disposition;
- delegated attempts and handoffs.

## Research

Useful sections may include:

- a source inventory with provenance and what each source establishes;
- claims mapped to evidence, confidence, and unresolved gaps;
- queries, filters, result snapshots, and negative results;
- contradictory evidence, rejected hypotheses, and remaining uncertainty;
- screenshots or other artifacts with capture context and interpretation;
- delegated attempts and reviewer findings.

## Design

Useful sections may include:

- requirements, constraints, and evaluation criteria;
- options, tradeoffs, rejected alternatives, and decision rationale;
- sketches, prototypes, review findings, and unresolved risks;
- evidence that a design satisfies or fails each criterion;
- delegated attempts and decision checkpoints.

## Root Orchestration

A root log records only root-owned supporting material,
such as:

- launches, ownership changes, handoffs, and reconciliation decisions;
- dependency or sequence changes and why they were necessary;
- worktree assignment history when the board snapshot is insufficient;
- integration observations, conflicts, resolutions, and combined evidence;
- root-level delegated reviews and dated acceptance assessments.

Do not copy detailed workstream evidence into the root log.
Name the stable workstream ID,
state the exact outcome used by the root,
and record the root's own conclusion or integration decision.

## Promotion Rule

Logs preserve supporting detail and chronology.
Plans preserve the current executable truth.

When evidence establishes a durable fact,
changes a decision,
alters recovery state,
or determines the next action,
update the plan with that conclusion.
Keep the underlying evidence and history in the log.
Synchronize the plan before handoff.

Append corrections and superseding facts rather than erasing prior entries.
Distinguish observed facts from inferences and recommendations.
