# Log Patterns

Adapt these patterns to the work.
They are examples, not required schemas.
Omit sections that do not earn their place.

Every log should briefly identify the workstream and outcome,
explain its organization,
and record a dated latest recovery checkpoint for honest interpretation.
The associated plan remains authoritative for mutable current state.
The log is append-only replay:
append new entries for superseding facts, decisions, and recovery state
instead of rewriting older entries.
Every delegated attempt still needs write-ahead preregistration.

## Record Selection

Record material that matters for audit, interpretation, or resumption.
Organize detail around the durable facts needed to reconstruct plan state:
what evidence was obtained,
what conclusion or uncertainty it established,
what changed in the operative plan,
and what next action follows.
Preserve command, output, source, or artifact detail when it establishes one
of those facts or would be needed to rerun, verify, audit, or resume safely.

Do not turn the log into a chat transcript or indiscriminate command history.
Collapse process steps that only show how the agent found a fact into the
resulting observation or conclusion.
When an investigation step only locates a path, symbol, line, artifact,
or owner,
record the located reference and why it matters.
Omit sections that show only effort or non-material process history.

Distinguish observations from inferences and decisions.
When a new entry supersedes an older entry,
leave the older entry intact and append the superseding fact or decision.
Update the plan when the resulting current state changes.

## Implementation

Useful sections may include:

- a change ledger naming paths, symbols, commits, and invariants;
- a validation ledger with commands, observed results, and failures;
- behavioral observations and residual risks;
- reviewer findings and their disposition;
- delegated attempts and handoffs.

A validation ledger should connect each check to the fact,
conclusion, or recovery decision it establishes.
Group or summarize related checks when that makes the established state
clearer.

### Reference-first code entry

For implementation work where a contract shape drives a choice,
a compact code example can make the record easier to reconstruct:

````markdown
### Lease contract — `internal/lease/store.go`

```go
type LeaseStore interface {
    Acquire(context.Context, string, time.Duration) (Lease, error)
    Release(context.Context, Lease) error
}
```

`LeaseStore.Acquire` returns typed `ErrHeld`
so callers retain holder and expiry diagnostics.
The PostgreSQL implementation in `internal/lease/postgres/store.go`
uses `INSERT ... ON CONFLICT` to coordinate across service replicas.
A process-local `map[string]bool` was rejected because it cannot preserve that
cross-replica invariant.

PostgreSQL timestamp precision truncated sub-millisecond TTLs,
so the adapter normalizes `time.Duration` values to milliseconds.
`go test ./internal/lease/...` passed 18 tests on commit `abc9876`.
````

The example is concise but reconstructable:
it shows the contract,
names the implementation,
records the choice and rejected alternative,
captures the discovery and consequence,
and anchors validation to a command and commit.
Use this shape only when the code contract is material.
For other implementation work,
stable paths and symbols may be enough.
For research,
design,
or operations,
use the corresponding sources, measurements, artifacts, or outputs instead.

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
- worktree assignment history when the workboard snapshot is insufficient;
- integration observations, returned evidence,
  and root reconciliation decisions;
- reviewer outcomes identified by owning workstream ID
  and dated acceptance decisions.

Do not copy detailed workstream evidence into the root log.
Name the stable workstream ID,
state the exact outcome used by the root,
and record the root's own conclusion or integration decision.
