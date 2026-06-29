---
name: workboard
description: >-
  Coordinate autonomous execution across a substantial multi-workstream effort,
  or when the user explicitly asks to use Workboard or Multiwork.
  Workstreams should be independently ownable,
  and the durable coordination model must justify its overhead.
  Use for delegated workers, durable plans, supporting logs,
  write-ahead preregistration, evergreen recurring workstreams,
  root-level integration, and validation.
  Unless the user explicitly requests Workboard or Multiwork,
  do not use it for ordinary single-track work, sequential checklists,
  plan-only requests,
  or small tasks where coordination costs more than execution.
---

# Workboard

Workboard was previously named Multiwork.
Treat `Multiwork` and `$multiwork` as aliases for Workboard.
Continue existing plans, logs, instructions, and directories in place;
do not rename durable records solely to adopt the new name.

Coordinate independent workstreams
through durable files and delegated ownership.
The root agent remains responsible for sequencing, integration, and completion.

## Start

1. Confirm that the effort contains or is expected to contain
   at least two substantial, independently ownable workstreams,
   or that the user explicitly asked to use Workboard or Multiwork.
   An explicit user request overrides the normal trigger boundary.
   Do not invent workstreams to meet this boundary.
2. Choose the plan location.
   Follow the user's requested location or clear location preference.
   Otherwise:

   - If `./work/plan.md` exists,
     use `./work/` as the long-lived plan directory for the entire project.
   - If `./work/` exists without `plan.md`,
     use a per-plan child directory under `./work/`.
   - If `./work/` does not exist,
     use a per-plan child directory under `~/work/`.

   Do not create `./work/` solely for Workboard.
   An explicit user request may establish `./work/`
   as a long-lived project plan even when `./work/plan.md` does not yet exist.

   Treat the selected location as the canonical storage location,
   not merely as an entrypoint that resolves to storage elsewhere.
   Create each new plan directory and its durable files directly under
   the selected location.
   If the selected location is not writable,
   use the applicable permission or escalation path,
   or report the access blocker while preserving the selected location.
   Do not relocate the plan to another root and replace the selected plan
   directory with a symlink unless the user explicitly requests that topology.

   Name a per-plan child directory using the first applicable form:

   1. `<YYYY-MM-DD-name>/`
   2. `<NNN-name>/`
   3. `<name>/`

   The dated form applies to a new plan by default,
   the numbered form if part of an existing convention.
   `<name>/` applies only via explicit user instruction.
   Treat an instruction as storage-specific only when it refers to the path,
   directory, or directory ID.
   A selected-location convention is a discovered convention in that location,
   not an inferred preference.
   A user supplied `name` without a date or number prefix
   does not make `<name>/` applicable.
   The date or number prefix is part of the directory ID,
   not part of the project or mission name.
   Derive `name` from the user-stated project or mission identity.

   Always use a child directory under `~/work/`;
   never use `~/work/plan.md` directly.
3. Before creating a plan,
   search the selected location for an existing plan with the same scope.
   Extend a matching plan instead of creating another one.
4. Identify the substantial independently ownable outcomes
   the user asked you to manage
   before choosing a layout.
   Do not eagerly plan workstreams
   for work the user has not asked you to manage.
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
6. Organize workstreams shown on the workboard under
   `workstreams/<state>/<id>/` as states become needed.
   Suggested states are `backlog/`, `active/`, `evergreen/`,
   and `completed/`.
   A root plan may define another clear lifecycle.
   Store archived terminal workstreams under `workstreams/archived/<id>/`.
   Archive placement preserves the workstream's lifecycle state
   and means that the workstream no longer appears on the workboard.
   Archive only when the user asks
   or when a user-specified archival condition matches the workstream.
   Terminal state alone does not trigger archival.
   Do not create empty state directories or `archived/` in advance.

When decomposing implementation work,
verify that each unit can satisfy its required validation
and safely cross every intended integration, merge, and deployment boundary
once its declared prerequisites are satisfied.
Keep ordered units separate only when each becomes independently valid
and landable after those prerequisites.
If no ordering allows each unit to pass and land safely,
combine the coupled work.

The number of workstreams ready or running at one time may be zero, one,
or many.
Do not create, split, or activate work merely to preserve concurrency.

## Reference Map

Read the focused reference when its decision applies:

- [templates.md](references/templates.md) for default layouts and file shapes;
- [log-patterns.md](references/log-patterns.md)
  when defining or revising a supporting record;
- [workers.md](references/workers.md)
  before dispatching or releasing a worker;
- [evergreen-workstreams.md](references/evergreen-workstreams.md)
  when a workstream performs recurring bounded cycles; and
- [worktrees.md](references/worktrees.md)
  when the mission uses worktrees or another managed workspace.

## Standalone Plan

When an explicit Workboard request starts with no matching existing plan
and contains one cohesive root-owned outcome
that does not benefit from independent ownership,
the root may represent the mission with only:

```text
<plan-directory>/
  plan.md
  log.md
```

Select `<plan-directory>` using the location and naming rules above.

The standalone `plan.md` directly owns the mission and current state.
It contains the workstream outcome, context, boundaries, execution path,
evidence strategy, recovery, and concrete next action.
The sibling `log.md` is the self-contained supporting record.

The root executes a standalone plan directly.
Do not create a Workboard, workstream ID, state directories,
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

## Terminology

Workboard is the coordination workflow
and the canonical name of its workstream table.
The root `plan.md` contains a workboard,
normally headed `Workboard`, that lists its workstreams.
`Workstream Board`, `project board`, `root board`, and `board`
are aliases for the workboard.
Use `workboard` as the canonical name.
The root plan contains the workboard;
the root plan is not itself the workboard.
Other clear project-specific terms remain valid.

## Root Plan

The root `plan.md` is the authoritative coordination snapshot.
Only the root agent edits its Workboard.

For each workstream that has not been archived,
the Workboard must identify its stable ID and lifecycle state.
It also records the current owner,
dependencies by stable ID,
runtime assignment when applicable,
and the root's concrete next coordination action.
The workboard is an operational index,
focused on root-owned coordination state.
Keep every non-archived workstream in one Workboard table.
Archived terminal workstreams do not appear on the workboard.
Their files under `workstreams/archived/<id>/` retain their terminal lifecycle
state and durable history.
Classify states according to the lifecycle defined by the project.
A plan may add a short label when stable IDs are not enough
to distinguish workstreams at a glance.
For non-archived workstreams using the normal layout,
the lifecycle state in the workboard
and the `workstreams/<state>/<id>/` directory must agree.
For non-archived workstreams using the normal layout,
derive plan and log paths from the workboard state and stable ID:
`workstreams/<state>/<id>/plan.md`
and `workstreams/<state>/<id>/log.md`.
For an archived workstream,
derive its paths from `workstreams/archived/<id>/`
and its lifecycle state from its own plan.
Use explicit plan or log path fields for documented nonstandard layouts
or migration states where derivation is unavailable.
In durable repository-local plans and logs,
write project paths relative to the repository root
and coordination-file paths relative to the plan directory.
For an evergreen workstream,
also record its execution condition and next wake condition.

The root plan also records project-level constraints, integration order,
completion evidence, and the Worktree Pool when worktrees are used.
Add a root `log.md` when root-owned evidence, decisions, or coordination history
would make `plan.md` hard to skim.
Also create it before delegating
a review, synthesis, or integration-support attempt whose result informs root
reconciliation.

## File Ownership

Each durable coordination file has exactly one permitted writer at a time.
The permitted writer is responsible for keeping that file current
under its contract.

| File | Permitted writer |
| --- | --- |
| Root `plan.md` | Root agent only. |
| Root `log.md` | Root agent only. |
| Workstream `plan.md` before dispatch | Root agent. |
| Workstream `log.md` before dispatch | Root agent. |
| Workstream `plan.md` during an active worker attempt | Assigned worker. |
| Workstream `log.md` during an active worker attempt | Assigned worker. |
| Workstream files after handoff | Root agent until reassignment. |
| Reviewer pass | Reviewer reports to root; reviewer does not edit durable files. |

Root-owned files are never edited by workers or reviewers.
Workstream files are written by the assigned worker only while that worker
is actively working on the workstream.
At handoff,
write authority returns to root after the worker checkpoints the workstream plan,
appends the required log entries,
and reports the current state.
If the root needs a live worker's workstream plan or log updated,
the root instructs that worker to checkpoint the files instead of editing them
concurrently.

## Workstream Files

Each workstream has exactly two durable files by default,
stored together under `workstreams/<state>/<id>/` while it appears on the
workboard and under `workstreams/archived/<id>/` after archival:

- `plan.md` is the complete mission and continuation guide.
  It defines the useful supporting record for this workstream.
- `log.md` is that self-contained supporting record.
  It includes write-ahead entries for delegated attempts,
  but it is not merely an attempt ledger.
  It is the append-only replay log for the workstream:
  add new entries for new evidence, decisions, attempts, superseding facts,
  corrections, and recovery checkpoints instead of rewriting history.

Write each workstream `plan.md`
for an agent that receives only that file and the current tree.
The plan must contain every task-specific fact, assumption, decision, and
instruction needed to continue without the root conversation or agent memory.
It is operational guidance for doing the work,
not just a request to inspect files or decide the work later.
Because the plan is the living current state,
distinguish mostly stable intent
from mutable state that changes as work proceeds.
Purpose, boundaries, dependencies, completion criteria,
and the assessment strategy are usually stable.
Progress, operative decisions, discoveries, blockers, evidence, outcomes,
ownership,
and the next action are mutable.
Update the mutable state at every material checkpoint.
Revise stable intent only when the work itself changes,
and record why in the log.
The root and human operator use the workstream plan to assess current state.
A casual reader should be able to identify that state from headings and first
sentences before reading supporting detail.
Workers continuing or taking over a task use the sibling log to replay how
the current approach was reached,
but the current approach itself must be promoted into the plan.
At completion,
make the outcome and remaining work understandable from the plan alone,
and remove prospective text that contradicts the finished state.
Write reference-first prose throughout:
name the concrete file, symbol, API, command, source, artifact, or decision
before explaining its significance.
For code-facing work,
use a compact code or data example when it materially clarifies the contract
or choice;
do not require one when stable references and prose are clearer.

A self-contained plan must:

- explain why the work matters and state the owned outcome;
- explain how completion is recognized;
- orient the reader to the relevant repository or project state;
- name concrete paths, modules, symbols, services, and commands;
- name relevant artifacts and terms;
- explain how those parts fit together;
- explain what currently exists and how the implemented paths, symbols,
  interfaces, data shapes, or system boundaries work together;
- summarize required facts from other sources instead of merely linking to them;
- record known requirements, decisions, constraints, contracts, and acceptance
  details at the level needed to act without re-deciding the mission;
- name the mutable surface, important exclusions, environmental assumptions,
  prerequisites, and governing repository instructions;
- describe dependencies by stable workstream ID;
- state each exact required outcome or contract;
- record resolved decisions and a concrete execution path, including where and
  why changes or investigations occur;
- record the rationale for material decisions,
  relevant rejected alternatives,
  and discoveries or surprises that shaped the current result;
- define an evidence and assessment strategy appropriate to the outcome;
- define what belongs in the sibling log,
  how the record is organized, and when it should be updated;
- state recovery considerations, current progress, and known artifacts;
- record working state, blockers, and one concrete next action;
- when complete,
  summarize what was achieved against the completion criteria,
  how it was achieved,
  and any remaining gaps or follow-up.

A plan is not self-contained merely because it names files to inspect.
Inspection should verify or refine an already specified path.
It must not reconstruct the project context or decide what the task means.
Keep the plan current as facts, decisions, and progress change.
Every revision must remain internally consistent
and executable from empty context.

### Dependency References

A workstream may name another workstream by stable ID.
It must state the exact outcome or contract it requires.
It must not refer to another workstream's `plan.md` or `log.md` path.
Moving a workstream between state directories therefore does not require edits
to other workstreams.

Independently,
the sibling `log.md` must identify the workstream and owned outcome.
It must include essential context and a dated latest recovery checkpoint,
so an empty-context reader can interpret and resume the record honestly.
Do not duplicate the plan's full implementation narrative in the log.
Do not silently edit or delete earlier log entries when new information
supersedes them.
Append the new information,
state what it supersedes,
and promote the resulting current state into the plan.

## Supporting Logs

The plan states the current executable truth:
the mission, operative decisions, current state, and next action.
The log is the append-only replay record that supports that truth.
If a mutable value differs between the files,
the plan is authoritative.

Choose a log structure suited to the workstream.
Every log section should earn its place by improving interpretation,
auditability, recovery, or plan reconstruction.
Write log entries reference-first.
Lead with concrete paths, symbols, APIs, commands, sources, measurements,
commits, or artifacts,
then explain the behavior or conclusion each reference establishes.
Use compact code, data, output, or artifact examples when they materially
improve understanding.
Distinguish observations from inferences and decisions.
Append corrections and superseding facts instead of silently rewriting history.

When log evidence establishes what now exists,
how it works,
a material decision or rationale,
a discovery that shaped the result,
the current state,
the outcome,
or the next action,
promote a concise account into the plan.
Leave detailed provenance and chronology in the log.
Before handoff,
synchronize the plan with the latest dated recovery checkpoint in the log.
For completed work,
reread the plan without the log and replace stale prospective text so the plan
alone explains the final design or result,
material choices,
outcome evidence,
and remaining follow-up.
Each file remains self-contained:
neither may depend on another workstream's plan or log,
and the log must explain its own organization and stable context.

For a root log,
record root-owned coordination, reconciliation, integration,
combined assessment, and the evidence behind root decisions.
Do not mirror workstream detail already preserved in a workstream log.

See [log-patterns.md](references/log-patterns.md)
for adaptable record shapes.

## Lifecycle Transitions And Archival

You must use the following transition procedure
when changing a workstream's lifecycle state or archive placement.
This includes moving a workstream between state directories,
marking it completed, promoting it from backlog, pausing it,
archiving it, or restoring it from the archive.

1. Quiesce any live worker for the workstream first.
   Confirm that no write, command, assessment, server, watcher,
   or delegated attempt is using the old path.
2. Checkpoint the workstream plan, log, and any root-owned coordination record
   that explains the transition.
   Before archiving,
   confirm that the lifecycle state is terminal and record that state in the
   workstream plan.
3. Move the whole workstream directory.
   For a lifecycle transition on the workboard,
   move `workstreams/<old-state>/<id>/` to
   `workstreams/<new-state>/<id>/`.
   For archival,
   move it to `workstreams/archived/<id>/` without changing its lifecycle state.
   For restoration,
   move it from `workstreams/archived/<id>/` to the terminal state directory
   recorded in its plan.
   Do not create an empty target directory and move only `plan.md` and `log.md`,
   because that leaves stale empty workstream directories behind
   and can make the same stable ID appear in multiple lifecycle states.
4. Update the root Workboard for the same stable ID.
   For a lifecycle transition,
   set the lifecycle state,
   owner,
   runtime assignment,
   and next action or wake so they describe the new state.
   For archival,
   remove the row from the Workboard.
   For restoration,
   add the row back to the Workboard with its preserved terminal state.
5. Update live handoff references and give any continuing worker
   the new runtime handoff paths. Resume only after acknowledgement.

Rationalizations to reject during lifecycle transitions:

- "Workboard cleanup can happen later."
  Update the root Workboard as part of the transition.
- "Only path updates are needed to prevent broken links."
  Update paths and lifecycle fields together.
- "Do not disturb the workboard status because another dashboard scrapes it."
  Keep the workboard truthful;
  stale status is not a safe compatibility layer.
- "Archive is a lifecycle state."
  Archive placement controls workboard visibility;
  preserve the workstream's terminal lifecycle state.
- "Keep archived rows on the workboard for history."
  The archived workstream files are the durable history;
  remove archived workstreams from the workboard.

## Artifacts

Assume project directories may be committed to version control.
When a Workboard plan directory is inside a project,
treat the plan directory and its workstream directories
as part of that version-controlled boundary.

Store small inspection artifacts with the owning workstream
when keeping them near the workstream improves later audit or recovery.
Small artifacts may include concise notes, indexes, summaries,
or other evidence that belongs with the workstream's durable record.

Large artifacts may include profiler dumps, traces, recordings, archives,
datasets, or other bulky generated files.
Do not place large generated artifacts inside a version-controlled boundary
unless the user clearly chose that commit-bound location.
If the user named an artifact location outside that boundary, use that location.
When no location is specified, choose a holding location
from the conversation context and current environment.
Record the absolute artifact path and purpose in the owning log.

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
Record enough starting state, expected evidence, and assessment detail
to judge the attempt afterward.
Append its observed outcome and resulting next action.
If dispatch fails, record that outcome rather than deleting the entry.

Keep one writer for each workstream plan and log at a time.
The permitted current writer preregisters the attempt before dispatch.
An assigned worker owns both files until handoff,
maintains the plan-defined supporting record,
and keeps the plan synchronized with current state.
Root does not edit those files concurrently.
A reviewer returns findings to the root instead of editing durable files.
Root routes actionable findings through the current owner
or through a replacement worker after handoff.
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

Read [workers.md](references/workers.md)
before dispatch, review routing, handoff, or worker release.

## Worker Lifecycle

Assign a persistent worker to each ready workstream when capacity permits.
Continue the same worker for follow-up within that workstream.
Never reuse a worker for an unrelated workstream.
This assignment rule applies to workstreams in the normal layout,
not to a root-executed standalone plan.

When the next meaningful decision depends on worker results,
the root must wait for them.
Goal supervision does not replace waiting for in-flight work.

When capacity is full,
release completed workers and safely resumable inactive workers
after checkpointing their durable state.
Do not close a worker merely because
a long command or assessment is still running.

Use reviewers as fresh, usually single-shot agents.
The root reconciles reviewer findings with the worker and owns acceptance.

See [workers.md](references/workers.md)
for dispatch and inactive-worker checkpoint procedures.

## Evergreen Workstreams

An evergreen workstream performs a recurring bounded cycle
while its ongoing outcome remains part of the durable coordination system.
It may alternate among these execution conditions:

- `waiting`: no cycle is due;
- `ready`: its wake condition is satisfied;
- `running`: a cycle is in flight;
- `blocked`: a required condition cannot currently be satisfied.

Execution condition is separate from lifecycle state.
An evergreen workstream uses the `evergreen` lifecycle state
while it waits between cycles.
Create `evergreen/` only when at least one evergreen workstream exists.
Do not place an evergreen workstream under `active/`
merely because it can wake later.
Do not move it to `backlog/` or `completed/` after a quiet cycle.

The plan and workboard keep the cycle contract, cursor, execution condition,
and next wake concrete.
A waiting evergreen workstream does not require a live worker.
Workboard records recurrence but does not create wall-clock wakes;
name the external mechanism that wakes the root.

See [evergreen-workstreams.md](references/evergreen-workstreams.md)
for the cycle contract and concise templates.

## Worktrees

Worktrees are optional.
Prefer separate worktrees for concurrent mutating workstreams
when repository state and integration boundaries make isolation sound.
Do not use separate worktrees when workers must share uncommitted state.
Do not use them when generated files, lockfiles, ports, schemas,
external environments, or other shared surfaces make isolation unsafe.

When worktrees are used,
the root records actual workspace handoffs in the root plan's Worktree Pool.
An extant workspace is either `available` or `in-use`.
An `in-use` workspace has one declared workstream or root scope,
one responsible owner,
an optional active checkout user,
and one concrete next action.
Before root completion,
no workspace may remain `in-use`,
and every workspace used by the mission must be released as `available`
or have verified removal evidence.

When a workstream does not use a worktree,
leave its changes uncommitted by default.
When a workstream uses an isolated Git worktree with a writable task branch,
commit completed implementation changes to that branch before handoff by
default.
Keep the commit scoped to the workstream
and follow governing repository commit instructions.
For another kind of workspace,
preserve completed work through its normal durable result before handoff.
An explicit user instruction,
clear user preference,
repository rule,
or workstream plan may require another preservation form.
At durable handoff from an ephemeral workspace,
the worker returns any assigned workspace still attached,
with its identity and quiescent observed state.
Before unrelated work,
root accepts the handoff and completes disposition:

- If no named checkout-dependent command or assessment is ready to start now,
  root runs and verifies the governing release or reset workflow
  for reusable capacity,
  or removes the temporary workspace.
  A durable branch or commit preserves the result independently of the checkout;
  preserve its ref unless an explicit disposal decision says otherwise.
  Record later actions without a workspace lease,
  and acquire capacity when a checkout-dependent action becomes ready.
- If a named checkout-dependent action is ready to start now,
  retain the workspace as `in-use` under root,
  record the active checkout user and action,
  and complete disposition immediately afterward.

Retain a temporary workspace after handoff only when the next action is ready
to start now and requires that workspace's current checkout state.
Otherwise,
a durable branch or commit preserves the result independently of the workspace.
Release or remove the workspace right away unless the next assessment
needs workspace-local state that is not preserved in the durable result,
such as uncommitted generated files, local runtime state,
or an active process that the assessment will consume immediately.
A request to inspect or evaluate the durable result in the producing checkout
does not establish that requirement by itself.
The next assessment must identify workspace-local state
that is absent from the durable result.

Clean or quiescent state, administrative lease closure, ownership transfer,
rebinding, and workspace preparation are not release proof.
Root performs and verifies post-handoff disposition
even when another workflow normally assigns cleanup to the former worker;
an active checkout user does not become the responsible owner.
If the required branch or commit placement remains unresolved,
report that blocker and hand control back promptly;
do not remain idle while holding the workspace.

See [worktrees.md](references/worktrees.md)
for workspace intent, ownership, preservation,
release, removal, and completion guidance.

## Steering And Completion

Advance every ready workstream
without forcing unrelated work into serial execution.
It is valid for only one workstream to be ready or running.
It is also valid for all evergreen workstreams to be waiting.
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
