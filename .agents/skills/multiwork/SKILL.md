---
name: multiwork
description: >-
  Coordinate autonomous execution across a substantial multi-workstream effort,
  or when the user explicitly asks to use Multiwork.
  Workstreams should be independently ownable,
  and the durable coordination model must justify its overhead.
  Use for delegated workers, durable plans, supporting logs,
  write-ahead preregistration, standing recurring workstreams,
  root-level integration, and validation.
  Unless the user explicitly requests Multiwork,
  do not use it for ordinary single-track work, sequential checklists,
  plan-only requests,
  or small tasks where coordination costs more than execution.
---

# Multiwork

Coordinate independent workstreams
through durable files and delegated ownership.
The root agent remains responsible for sequencing, integration, and completion.

## Start

1. Confirm that the effort contains or is expected to contain
   at least two substantial, independently ownable workstreams,
   or that the user explicitly asked to use Multiwork.
   An explicit user request overrides the normal trigger boundary.
   Do not invent workstreams to meet this boundary.
2. Follow an existing repository convention or the user's requested location.
   Otherwise use `./work/<plan-slug>/`.
   When repository-local files are unsuitable,
   fall back to `~/.multiwork/<project-name>/<plan-slug>/`.
   In durable repository-local plans and logs,
   write project paths relative to the repository root
   and coordination-file paths relative to the plan directory.
3. Search for an existing multiwork plan with the same scope and extend it.
4. Identify the substantial independently ownable outcomes
   before choosing a layout.
   When no matching plan exists
   and the mission has one cohesive root-owned outcome
   that does not benefit from independent ownership,
   use the standalone plan layout described below.
   Otherwise create the root `plan.md`
   and a `workstreams/` directory that contains the lifecycle state
   directories for known workstreams.
5. Use `NNN-slug` IDs by default.
   The root assigns numbers monotonically and never renumbers or reuses them.
   A plan may instead choose `YYYY-MM-DD-slug` and record that convention once.
6. Organize workstreams under `workstreams/<state>/<id>/`
   as states become needed.
   Suggested states are `backlog/`, `active/`, `completed/`, and `archived/`.
   A root plan may define another clear lifecycle.
   Do not create empty state directories in advance.

The number of workstreams ready or running at one time may be zero, one,
or many.
Do not create, split, or activate work merely to preserve concurrency.

See [templates.md](references/templates.md)
for the default layout and file shapes.

## Standalone Plan

When an explicit Multiwork request starts with no matching existing plan
and contains one cohesive root-owned outcome
that does not benefit from independent ownership,
the root may represent the mission with only:

```text
work/<plan-slug>/
  plan.md
  log.md
```

The standalone `plan.md` directly owns the mission and current state.
It contains the workstream outcome, context, boundaries, execution path,
evidence strategy, recovery, and concrete next action.
The sibling `log.md` is the self-contained supporting record.

The root executes a standalone plan directly.
Do not create a Workstream Board, workstream ID, state directories,
nested workstream files, worker assignment,
or delegated-attempt entry merely to represent the one workstream.

Before selecting this layout,
identify the mission's meaningful outcomes, mutable surfaces, dependencies,
and evidence boundaries.
Use the normal layout when multiple substantial outcomes
can be owned and advanced independently,
even when the user described them as one task
or one agent could execute them sequentially.
Do not collapse a decomposable mission into a standalone plan
to avoid coordination overhead.

Use the normal multi-workstream layout
when the mission already has a matching root plan,
requires delegation,
or contains multiple independently ownable workstreams.
If a standalone mission later gains such work,
convert it to the normal layout before delegation or parallel execution,
preserving the existing plan and log content in the new durable structure.

## Root Plan

The root `plan.md` is the authoritative coordination snapshot.
Only the root agent edits its Workstream Board.

For each workstream,
the Workstream Board must identify its stable ID, outcome, and state.
It also records the current owner, dependencies, current plan and log paths,
branch or worktree when applicable, and concrete next action.
Store repository-local plan and log paths as relocatable paths
from the plan directory,
such as `workstreams/active/001-example/plan.md`.
For a standing workstream,
also record its execution condition and next wake condition.

The root plan also records project-level constraints, integration order,
completion evidence, and any optional worktree pool.
Add a root `log.md` when root-owned evidence, decisions, or coordination history
would make `plan.md` hard to skim.
Also create it before delegating
a review, synthesis, or integration-support attempt whose result informs root
reconciliation.

## Workstream Files

Each workstream has exactly two durable files by default,
stored together in one workstream directory under `workstreams/<state>/<id>/`:

- `plan.md` is the complete mission and continuation guide.
  It defines the useful supporting record for this workstream.
- `log.md` is that self-contained supporting record.
  It includes write-ahead entries for delegated attempts,
  but it is not merely an attempt ledger.

Write each workstream `plan.md`
for an agent that receives only that file and the current tree.
The plan must contain every task-specific fact, assumption, decision, and
instruction needed to continue without the root conversation or agent memory.
It is operational guidance for doing the work,
not just a request to inspect files or decide the work later.
Because the plan is a living document,
update it when discoveries, decisions, evidence, or changed constraints alter
the executable path.

A self-contained plan must:

- explain why the work matters and state the owned outcome;
- explain how completion is recognized;
- orient the reader to the relevant repository or project state;
- name concrete paths, modules, symbols, services, and commands;
- name relevant artifacts and terms;
- explain how those parts fit together;
- summarize required facts from other sources instead of merely linking to them;
- record known requirements, decisions, constraints, contracts, and acceptance
  details at the level needed to act without re-deciding the mission;
- name the mutable surface, important exclusions, environmental assumptions,
  prerequisites, and governing repository instructions;
- describe dependencies by stable workstream ID;
- state each exact required outcome or contract;
- record resolved decisions and a concrete execution path, including where and
  why changes or investigations occur;
- define an evidence and assessment strategy appropriate to the outcome;
- define what belongs in the sibling log,
  how the record is organized, and when it should be updated;
- state recovery considerations, current progress, and known artifacts;
- record working state, blockers, and one concrete next action.

A plan is not self-contained merely because it names files to inspect.
Inspection should verify or refine an already specified path.
It must not reconstruct the project context or decide what the task means.
Keep the plan current as facts, decisions, and progress change.
Every revision must remain internally consistent
and executable from empty context.

Independently,
the sibling `log.md` must identify the workstream and owned outcome.
It must include essential context and a dated latest recovery checkpoint,
so an empty-context reader can interpret and resume the record honestly.
Do not duplicate the plan's full implementation narrative in the log.

## Supporting Logs

The plan states the current executable truth:
the mission, operative decisions, current state, and next action.
The log preserves the detailed record that supports that truth.
If a mutable value differs between the files,
the plan is authoritative.

Choose a log structure suited to the workstream.
Every log section should earn its place by improving interpretation,
auditability, recovery, or plan reconstruction.
Useful contents may include:

- sources, queries, measurements, observations, and claim-to-evidence links;
- commands, results, commits, changed paths, and validation history;
- hypotheses, contradictions, rejected alternatives, and decision inputs;
- sketches, screenshots, inventories, reviewer findings, and artifact indexes;
- delegated-attempt preregistrations and outcomes;
- blockers, handoffs, corrections, and recovery notes.

This list is illustrative, not a required schema.
Record material that matters for audit, interpretation, or resumption.
Do not turn the log into a chat transcript or indiscriminate command history.
Organize log detail around durable facts needed to reconstruct plan state:
what evidence was obtained,
what conclusion or uncertainty it established,
what changed in the operative plan,
and what next action follows.
Preserve command, output, source, or artifact detail when it establishes one
of those facts or would be needed to rerun, verify, audit, or resume safely.
Collapse process steps that only show how the agent found the fact into the
resulting observation or conclusion.
When an investigation step only locates
the relevant path, symbol, line, artifact, or owner,
record that located reference and why it matters;
do not preserve the locator step itself as supporting evidence.
A section whose only purpose is to show non-material process history
should be omitted or replaced by the durable facts the process established.
Each section must contribute to interpreting evidence,
reconstructing recovery, auditing a material interaction, or updating the plan.
If a section would only show effort, routine exploration,
or provenance for steps that produced no durable fact,
replace it with the located reference, observation,
or conclusion that supports the plan.
Distinguish observations from inferences and decisions.
Append corrections and superseding facts instead of silently rewriting history.

When log evidence changes execution,
promote the resulting conclusion, decision, current state, or next action
into the plan.
Leave detailed provenance and chronology in the log.
Before handoff,
synchronize the plan with the latest dated recovery checkpoint in the log.
Each file remains self-contained:
neither may depend on another workstream's plan or log,
and the log must explain its own organization and stable context.

For a root log,
record root-owned coordination, reconciliation, integration,
combined assessment, and the evidence behind root decisions.
Do not mirror workstream detail already preserved in a workstream log.

See [log-patterns.md](references/log-patterns.md)
for adaptable record shapes.

A workstream may name another workstream by stable ID.
It must state the exact outcome or contract it requires.
It must not refer to another workstream's `plan.md` or `log.md` path.
Moving a workstream between state directories therefore does not require edits
to other workstreams.

Before moving a workstream with a live worker, quiesce the worker.
Confirm that no write, command, assessment, server, watcher,
or delegated attempt is using the old path.
Checkpoint durable state and move the directory.
Update the board and live references.
Give the worker the new runtime handoff paths
and resume only after acknowledgement.

Move a workstream by moving the whole `workstreams/<old-state>/<id>/`
directory to `workstreams/<new-state>/<id>/`.
Do not create an empty target directory and move only `plan.md` and `log.md`,
because that leaves stale empty workstream directories behind
and can make the same stable ID appear in multiple lifecycle states.

## Evidence And Validation

Match validation to the workstream's result.
Use commands, tests, focused probes, observable behavior, artifact inspection,
source coverage, claim-to-evidence review, a written rubric, independent review,
or another assessment that can establish the result honestly.

Name a fast feedback check when one is useful.
Do not invent a command, test, or two-tier validator structure
merely to fill a template.
State what evidence will be produced and how it will be assessed.
Define success, failure, and any acceptable inconclusive result.

Workstream evidence does not complete the root plan by itself.
The root defines and establishes the combined acceptance evidence.

## Delegate Attempts

Preregister every delegated attempt
in the owning workstream's `log.md` before dispatch.
This includes worker assignments, retries, material pivots, and reviewer passes.
Routine follow-up within the same objective and strategy is not a new attempt.

Keep preregistration lightweight.
Record the objective, worker or reviewer, and relevant starting state.
Also record the expected result, expected evidence, and assessment method.
After the attempt,
append the outcome, evidence, conclusion, and concrete next action.
If dispatch fails, record that outcome rather than deleting the entry.

Keep one writer for each log at a time.
The root writes preregistration before dispatch.
An assigned worker may then maintain the plan-defined supporting record
and its attempt entry until handoff,
while the root does not edit that log concurrently.
The worker must also keep the workstream plan current
when evidence changes an operative decision, state, blocker, or next action.
A reviewer returns findings to the root instead of editing the workstream log;
the root appends the reviewer outcome after the reviewer finishes.
Record each ownership handoff in the log.

Every delegation needs an owning log.
Use a workstream log for workstream attempts.
For delegated review, synthesis, or integration-support attempts
that produce an independently useful artifact for root,
create and use the root `log.md` first.
The root still owns reconciliation, integration decisions,
and final acceptance evidence.

If an attempt already started without preregistration, preserve valid work and
reconcile it immediately.
Record the actual worker, objective, and starting state,
plus the fact that registration was late.
Be as accurate as the available evidence permits.
Do not invent a write-ahead entry
or restart work solely to make the log orderly.

Prefer `fork_turns: "none"` for independent workers, replacement workers,
and single-shot reviewers.
Before dispatch,
ensure the workstream files are sufficient for empty-context execution.
The prompt may name the absolute plan and log paths, project or worktree path,
and governing repository instructions.
Execution-critical task context must live in `plan.md`, not only in the prompt.
Those absolute paths are handoff coordinates;
the worker should keep durable repository-local references relocatable.

## Worker Lifecycle

Assign a persistent worker to each ready workstream when capacity permits.
Continue the same worker for follow-up within that workstream.
Never reuse a worker for an unrelated workstream.
This assignment rule applies to workstreams in the normal layout,
not to a root-executed standalone plan.

When the next meaningful decision depends on worker results,
the root must wait for them.
Goal supervision does not replace waiting for in-flight work.

When capacity is full, close completed workers.
Also close inactive workers waiting for instructions
when their workstream is safely resumable.
Before closing an inactive worker,
ensure its plan, log, and board entry are current.
Also record the actual repository state, evidence, and next action.
Then mark the workstream unassigned.
A replacement worker reconciles the durable files with actual project state.
Do not close a worker merely because
a long command or assessment is still running.

Use reviewers as fresh, usually single-shot agents.
The root reconciles reviewer findings with the worker and owns acceptance.

## Standing Workstreams

A standing workstream performs a recurring bounded cycle
while its ongoing outcome remains part of the active mission.
It may alternate among these execution conditions:

- `waiting`: no cycle is due;
- `ready`: its wake condition is satisfied;
- `running`: a cycle is in flight;
- `blocked`: a required condition cannot currently be satisfied.

Execution condition is separate from lifecycle state.
A standing workstream normally remains under `active/`
while it waits between cycles.
Do not move it to `backlog/` or `completed/` after a quiet cycle.

Its self-contained plan defines the cycle purpose, wake condition,
input boundary or durable cursor, procedure, evidence,
no-change behavior, next-wake calculation, missed-cycle handling,
and any stop condition.
The board records the current execution condition,
the next wake condition in concrete prose,
and the mechanism expected to wake the root.

Each independently dispatched cycle is a new delegated attempt.
Preregister it after the wake condition is satisfied and before dispatch.
The wake event alone is not an attempt.
Routine follow-up within one running cycle remains part of that attempt.

A waiting standing workstream does not require a live worker.
After a cycle,
checkpoint the plan, log, board, cursor, evidence, and next wake.
Then release an inactive worker when retaining it provides no near-term value
or capacity is needed.
A fresh worker may reconcile the durable state for the next cycle.

Multiwork records recurrence but does not create wall-clock wakes by itself.
Name the actual wake mechanism,
such as a platform automation, external scheduler, user return,
or authorized goal continuation.
Do not imply that a timestamp in Markdown schedules execution.

See [standing-workstreams.md](references/standing-workstreams.md)
for the cycle contract and concise templates.

## Worktrees

Worktrees are optional.
Prefer separate worktrees for concurrent mutating workstreams
when repository state and integration boundaries make isolation sound.
Do not use separate worktrees when workers must share uncommitted state.
Do not use them when generated files, lockfiles, ports, schemas,
external environments, or other shared surfaces make isolation unsafe.

For large repositories, the root may maintain a worktree pool in `plan.md`.
Before assignment or reassignment, verify and record the worktree's identity,
ownership, relevant state, active processes, hazards, and availability.
Preserve unexplained state.
Never clean or reset a pooled worktree merely to make it reusable.

When a workstream does not use a worktree,
leave its changes uncommitted by default.
When a workstream uses a worktree,
commit completed changes to the worktree's branch by default.
An explicit user instruction or clear user preference overrides either default.

See [workers-and-worktrees.md](references/workers-and-worktrees.md)
for concise dispatch and pool checklists.

## Steering And Completion

Advance every ready workstream
without forcing unrelated work into serial execution.
It is valid for only one workstream to be ready or running.
It is also valid for all standing workstreams to be waiting.
When new steering leaves the fate of unfinished workstreams unclear,
ask how they should be handled before changing state or ownership.
When intent is clear, update the root plan before redirecting execution.

Goal supervision is optional.
Use the Codex goal supervisor only when requested or authorized
by the user or governing platform instructions.
Keep mutable status in the plan files and point the goal at those files.

The root reconciles and integrates workstream results.
It establishes the root completion evidence
and records completion only when the overall objective is verified.

## Tests

When changing this skill, read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents using `fork_turns: "none"`.
