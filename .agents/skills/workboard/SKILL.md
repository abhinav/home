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
The root agent remains responsible for coordination, sequencing,
integration decisions, and completion decisions.

## Root Execution Boundary

In the normal layout,
the root is the coordinator and assigned workstream owners are the executors.
Root ownership means accountability for coordination and decisions;
it does not authorize the root to perform meaningful project work.

The root may execute a meaningful task only when the user affirmatively names
the root as executor for that task.
Otherwise,
the root assigns the task to a workstream and delegates it.
Requests or imperatives addressed to the root steer the mission;
they do not assign execution to root unless they affirmatively name root
as executor for the task.
Saying that delegation is unnecessary, slow, or undesirable
does not count as root assignment.
In the normal layout,
if the user forbids delegation without naming the root as executor,
ask who should execute instead of inferring root execution.

Meaningful work is any action whose primary purpose is to create, modify,
retrieve, or independently evaluate task-domain state or evidence
needed to advance or assess the mission outcome.
Task-domain state is the project, branch, service, external system,
source material, or evidence the mission is about;
it excludes Workboard records and agent or workspace lifecycle state.
An action remains meaningful when it is read-only, small, or routine.
As a heuristic,
if the action would still need to happen after removing Workboard
and ownership bookkeeping,
delegate it.
Working on a branch,
polling a task-domain external system,
and researching through web search are examples of meaningful work.

The root may inspect root-owned coordination records
and agent or workspace lifecycle state to coordinate safely,
edit root-owned coordination files,
create and transition workstreams,
preregister and dispatch attempts,
steer workers and monitor agent or workspace lifecycle state,
receive handoffs,
compare returned evidence with acceptance criteria,
make acceptance decisions,
record coordination and completion state,
and dispose of workspaces.

When the user explicitly assigns a normal-layout task to the root,
keep the task in its owning workstream,
and record the root as executor.
Root execution is not a delegated attempt.

Standalone mode is the layout exception described below;
selecting it identifies the root as executor.

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
   and the mission satisfies the standalone criteria below,
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
   Use the lifecycle procedure below for state transitions and archival.
   Do not create empty state directories or `archived/` in advance.

When decomposing implementation work,
verify that each unit can satisfy its required validation
and safely cross every intended integration, merge, and deployment boundary
once its declared prerequisites are satisfied.
Keep ordered units separate only when each becomes independently valid
and landable after those prerequisites.
If no ordering allows each unit to pass and land safely,
combine the coupled work.

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

After Workboard has been selected under Start step 1,
use the standalone layout for a new plan when either:

- the user asks for a standalone Workboard; or
- the user does not choose a layout
  and the mission is small enough that it needs no breakdown
  into multiple independently ownable workstreams.

An explicit standalone request controls the new layout,
even when the mission could be decomposed.
Without one,
use the normal layout when the user requests delegation
or the mission needs multiple workstreams.
When standalone applies,
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
It records whether standalone selection was `explicit` or `automatic`
so future continuation can apply the correct conversion rule.
For a legacy standalone plan without that provenance,
continue while the distinction is immaterial.
Before a provenance-dependent layout decision,
ask whether the user wants to preserve standalone or convert,
then record the selection basis before further meaningful execution.
The sibling `log.md` is the self-contained supporting record.

Standalone mode implies that the root executes the plan directly.
Do not create a Workboard, workstream ID, state directories,
nested workstream files, worker assignment,
or delegated-attempt entry merely to represent the one workstream.

When the user did not explicitly request standalone,
assess the mission's outcomes, mutable surfaces, dependencies,
and evidence boundaries.
Use the normal layout when that assessment yields
multiple independently ownable workstreams.

Continue a matching plan in its existing layout
unless the user changes the layout or a conversion rule below applies.
If any standalone mission later requires delegation,
convert it to the normal layout before delegation or parallel execution,
preserving the existing plan and log content in the new durable structure.
If an automatically selected standalone mission later gains
multiple independently ownable workstreams,
convert it before further meaningful execution.
An explicitly requested standalone plan remains standalone
until the user changes the layout or requests delegation.

## Terminology

Workboard is the coordination workflow
and the canonical name of its workstream table.
In the normal layout,
the root `plan.md` contains a workboard,
normally headed `Workboard`, that lists its workstreams.
`Workstream Board`, `project board`, `root board`, and `board`
are aliases for the workboard.
Use `workboard` as the canonical name.
The normal-layout root plan contains the workboard;
the root plan is not itself the workboard.
Other clear project-specific terms remain valid.

## Root Plan

In the normal layout,
the root `plan.md` is the authoritative coordination snapshot.
Only the root agent edits its Workboard.

For every non-archived normal-layout workstream,
the Workboard records its stable ID, lifecycle state, current owner,
dependencies, runtime assignment when applicable,
and the root's concrete next coordination action.
The workboard is an operational index,
focused on root-owned coordination state.
Keep those workstreams in one Workboard table.
Archived terminal workstreams do not appear on the workboard;
the lifecycle procedure below governs archival placement.
Classify states according to the lifecycle defined by the project.
A plan may add a short label when stable IDs are not enough
to distinguish workstreams at a glance.
The Workboard lifecycle state and state directory must agree;
derive plan and log paths from that state and stable ID:
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
completion criteria, and the Worktree Pool when worktrees are used.
Add a root `log.md` when returned evidence, decisions, or coordination history
would make `plan.md` hard to skim.

## File Ownership

Each durable coordination file has exactly one permitted writer at a time.
The permitted writer is responsible for keeping that file current
under its contract.

| File | Permitted writer |
| --- | --- |
| Root `plan.md` | Root agent only. |
| Root `log.md` | Root agent only. |
| Workstream `plan.md` and `log.md` while unassigned | Root agent as custodian. |
| Workstream `plan.md` and `log.md` during execution | Assigned executor. |
| Workstream `plan.md` and `log.md` after handoff | Root agent as custodian. |

The executor is the worker, reviewer,
or explicitly assigned root agent performing the workstream's current task.
During execution,
the executor owns both workstream files and keeps them current.
Before meaningful execution,
a delegated executor follows the attempt contract below.
An explicitly assigned root executor records execution in the log
without a delegated-attempt entry.
At handoff,
the executor checkpoints both files and reports the current state;
write authority then returns to root.
Root-owned files are never edited by another executor.
If the root needs a live worker's workstream plan or log updated,
the root instructs that worker to checkpoint the files instead of editing them
concurrently.

The Workboard owner names the current executor,
or root as custodian while the workstream is unassigned.
Runtime assignment names the live agent when one exists.
A workspace's responsible owner controls its lifecycle and disposition;
its active checkout user performs the current workspace action.

## Workstream Files

In the normal layout,
each workstream has exactly the two durable files
whose paths derive from its Workboard state and stable ID:

- `plan.md` is the complete mission and continuation guide.
  It defines the useful supporting record for this workstream.
- `log.md` is that self-contained supporting record.
  The Supporting Logs section defines its replay contract.

Write `plan.md` for an agent that receives only that file and the current tree.
The plan is the living current state;
the log preserves the replay history behind it.
Treat purpose, boundaries, dependencies, completion criteria,
and assessment strategy as mostly stable.
Update progress, decisions, discoveries, blockers, evidence, ownership,
and the next action at every material checkpoint.
Revise stable intent only when the mission changes,
and record why in the log.
Write reference-first prose,
using compact code or data examples only when they clarify a material contract.

A self-contained plan must:

- explain why the work matters,
  state the owned outcome and required contracts,
  and explain how completion is recognized;
- be executable without the root conversation, agent memory,
  or reconstruction of the task through inspection;
- orient the reader to the current repository or project state;
  name relevant paths, modules, symbols, services, commands, artifacts,
  and terms;
  and explain how those parts fit together;
- summarize required facts from other sources instead of merely linking to them;
- record known requirements, decisions, constraints, and acceptance details
  at the level needed to act without re-deciding the mission;
- name the mutable surface, important exclusions, environmental assumptions,
  prerequisites, and governing repository instructions;
- describe dependencies by stable workstream ID;
- record resolved decisions, rationale, relevant rejected alternatives,
  and discoveries that shaped the concrete execution path;
- define an evidence and assessment strategy appropriate to the outcome;
- define what belongs in the sibling log,
  how the record is organized, and when it should be updated;
- state recovery considerations, current progress, and known artifacts;
- record working state, blockers, and one concrete next action;
- when complete,
  summarize what was achieved against the completion criteria,
  how it was achieved,
  and any remaining gaps or follow-up.

### Dependency References

A workstream may name another workstream by stable ID.
It must state the exact outcome or contract it requires.
It must not refer to another workstream's `plan.md` or `log.md` path.
Moving a workstream between state directories therefore does not require edits
to other workstreams.

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
record root-owned coordination, reconciliation of returned evidence,
integration decisions, and the basis for acceptance decisions.
Do not mirror workstream detail already preserved in a workstream log.

## Lifecycle Transitions And Archival

You must use the following transition procedure
when changing a workstream's lifecycle state or archive placement.
This includes moving a workstream between state directories,
marking it completed, promoting it from backlog, pausing it,
archiving it, or restoring it from the archive.

1. Have any live executor checkpoint the workstream plan and log,
   stop all work that uses the old path,
   and complete an ownership handoff to root.
   Confirm that root has write authority
   and that no command, assessment, server, watcher,
   or delegated attempt is still using the old path.
2. Root checkpoints any root-owned coordination record
   that explains the transition
   and verifies that the workstream plan and log describe the handoff state.
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
5. For continuing execution,
   root reassigns the executor with the new runtime handoff paths.
   The executor accepts the assignment and file ownership before resuming.

Treat directory placement, lifecycle state, Workboard visibility,
ownership, runtime assignment, and archival placement
as one atomic transition.
Archive placement controls Workboard visibility;
it does not replace the workstream's terminal lifecycle state.

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
The root defines the combined acceptance criteria,
delegates meaningful validation under the Root Execution Boundary,
and makes the final decision by reconciling returned evidence.

## Delegate Attempts

Every delegated meaningful task needs an owning workstream and workstream log.
Use the existing owning workstream for follow-up within its outcome.
Create another workstream when review, synthesis,
integration support, or validation owns an independently useful outcome.
The root log records root coordination and reconciliation;
it does not replace a workstream for delegated execution.

Before dispatch,
root remains the recorded custodian
and names the intended executor in the next coordination action.
After accepting the assignment and file ownership,
the executor reports acceptance to root.
Root records the executor as Workboard owner and runtime assignment;
that update completes the ownership transfer.
The delegated executor then preregisters the attempt
in the owning workstream's `log.md` before meaningful execution.
This includes worker assignments, retries, material pivots, and reviewer passes.
Routine follow-up within the same objective and strategy is not a new attempt.

Keep preregistration lightweight.
Record enough starting state, expected evidence, and assessment detail
to judge the attempt afterward.
Append its observed outcome and resulting next action.
If dispatch fails before acceptance,
root retains file ownership and records the failed assignment.

For delegated review tasks,
root delegates directly to a reviewer rather than an implementation worker.
The reviewer follows the executor ownership and attempt contracts,
then hands both files back with the findings.
Route any repair through the executor that owns the repair outcome.

If an attempt already started without preregistration, preserve valid work and
reconcile it immediately.
Record the actual worker, objective, and starting state,
plus the fact that registration was late.
Be as accurate as the available evidence permits.
Do not invent a write-ahead entry
or restart work solely to make the log orderly.

## Worker Lifecycle

Assign a persistent worker to each ready delegated non-review workstream.
Continue the same live worker for follow-up while its assignment is retained.
After checkpoint and release,
assign a replacement and record the new ownership handoff.
Never reuse a worker for an unrelated workstream.
This assignment rule applies to workstreams in the normal layout,
not to a root-executed standalone plan.

When capacity is unavailable,
keep the ready workstream unassigned,
record which handoff or release will permit dispatch,
and wait.
Capacity controls dispatch timing;
it never transfers workstream execution to the root.

When the next meaningful decision depends on worker results,
the root must wait for them.
Goal supervision does not replace waiting for in-flight work.

When capacity is full,
release completed workers and safely resumable inactive workers
after checkpointing their durable state.
Do not close a worker merely because
a long command or assessment is still running.

Use reviewers as fresh, usually single-shot executors.

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
Root scope means standalone execution,
an explicitly root-assigned normal-layout task,
or coordination-only setup, recovery, or disposition.
It does not independently authorize meaningful root execution.
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
the executor returns any assigned workspace still attached,
with its identity and quiescent observed state.
The handoff transfers responsible workspace ownership to root
for retention, release, or removal.
Root retains the workspace only when an immediate next action
requires workspace-local state absent from the durable result,
such as uncommitted generated files, local runtime state,
or an active process that the action will consume.
In that case,
record the owning workstream,
dispatch its executor under the Root Execution Boundary,
and record that executor as active checkout user.
A request to inspect or evaluate the durable result in the producing checkout
does not establish that requirement by itself.
Otherwise,
root runs and verifies the governing release or removal workflow immediately.
Preserve any durable branch or commit
unless an explicit disposal decision says otherwise.

Clean or quiescent state, administrative lease closure, ownership transfer,
rebinding, and workspace preparation are not release proof.
Root performs and verifies post-handoff disposition
even when another workflow normally assigns cleanup to the former worker;
an active checkout user does not become the responsible owner.
If the required branch or commit placement remains unresolved,
report that blocker and hand control back promptly;
do not remain idle while holding the workspace.

## Steering And Completion

Advance every ready workstream by dispatching it when capacity is available,
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

The root reconciles workstream results,
coordinates any required integration through an assigned workstream,
and makes the completion decision from returned evidence.
An integration action that operates on task-domain state or evidence
is meaningful work and follows the Root Execution Boundary.
After the final executor handoff,
or after standalone root execution ends,
root accepts the outcome,
synchronizes the final plan and log state,
confirms that every non-evergreen workstream is in a project-defined
terminal state,
and releases or removes every used workspace with verified evidence.
Evergreen workstreams may remain evergreen,
and archival remains optional unless the user supplied an archival condition.
Root records mission completion only after those steps finish.

## Tests

When changing this skill, read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents using `fork_turns: "none"`.
