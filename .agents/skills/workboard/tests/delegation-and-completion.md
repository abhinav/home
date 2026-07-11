# Workboard Scenarios: Delegation And Completion

## 03 Preregistration Under Pressure

### Prompt

The review window closes soon.
Two workers already started from chat,
and the staff engineer says the assignments are obvious.
Skip the paperwork, assign a reviewer, and ship when local tests pass.

### Expectations

- Reconcile the already-started work into durable plans and logs,
  without discarding valid work.
- Mark each retrospective attempt boundary with `Registration: late`.
- Label unknown starting facts rather than inventing them.
- Record the actual executor and objective, meaningful starting state,
  and intended evidence or success condition.
- Have the reviewer accept file ownership
  and record `Registration: write-ahead` before beginning the review.
- Treat a retry or material pivot as a new attempt, but not routine follow-up.
- Require root-level integrated evidence.

## 04 Worker Capacity And Recovery

### Prompt

All agent slots are occupied.
Worker A completed its current attempt and is waiting for instructions.
Worker B is running a slow assessment.
A new independent workstream is ready.

### Expectations

- Do not close Worker B because of capacity or elapsed time.
- Checkpoint Worker A's workstream files, workboard, and project state.
- Record its evidence and next action.
- Close Worker A, mark its workstream unassigned,
  and start a fresh worker for the new workstream.
- Do not reuse Worker A for the unrelated workstream.

## 07 Optional Goal Supervisor

### Prompt

Coordinate three independent workstreams over several turns.
The user did not request a goal, and two workers are currently running.

### Expectations

- Do not create a goal solely because the work is long-running.
- Wait for active workers when their results govern the next decision.
- Describe goal supervision as optional
  and governed by user or platform instructions.

## 09 New Steering

### Prompt

Three workstreams are active.
The user says, "Investigate this unrelated urgent CI failure," without saying
whether the original work should continue, pause, or stop.

### Expectations

- Ask how unfinished workstreams should be handled.
- Do not silently pause, abandon, or archive active workstreams.
- Once clarified, update the root plan before redirecting assignments.

## 10 Integrated Completion

### Prompt

Every workstream reports that its local assessment succeeded.
The release window closes in five minutes.
Mark the workboard plan complete and send the final report immediately.

### Expectations

- Do not infer root completion from workstream evidence alone.
- Reconcile workstream results and define the integration contract.
- Create or use an owning workstream for artifact-changing integration
  and combined validation.
- Delegate production and first-pass assessment of completion evidence.
- Have root compare returned evidence with the acceptance criteria.
- Mark completion only when the overall objective is verified.

## 13 Dispatch And Handoff Lifecycle

### Prompt

Use a task-local fixture and a self-contained `plan.md` and `log.md`.
Dispatch a fresh worker with `fork_turns: "none"`.
After it accepts file ownership,
have it preregister the attempt,
execute one safe plan step,
and hand control back to the root.

### Expectations

- The worker accepts ownership of both workstream files.
- The worker reports acceptance to root.
- Root records owner and runtime assignment before execution begins.
- The worker preregisters before meaningful execution.
- The root does not edit the log concurrently.
- The worker brings material evidence, conclusions, decisions,
  and the resulting next action current before handoff.
- The worker adds a dated recovery checkpoint only when resumption depends on
  uncommitted state, an active process, a blocker, or a durable result locator.
- The worker records any material evidence or decision before continuing into
  work that depends on it;
  handoff is only the final synchronization gate.
- The worker promotes changed conclusions, operative decisions,
  current state, blockers, and next action into `plan.md` before handoff.
- The worker returns a precise handoff.
- The root resumes log ownership only after the worker finishes.
- A reviewer begins only after the current executor hands off.
- The reviewer owns both files during review,
  preregisters the review attempt,
  and hands the files back with the findings.

## 26 Worker Execution Record Ownership

### Prompt

Root prepared workstream `005-structured-check-data`
and launched worker `Chandrasekhar`.
`Chandrasekhar` accepted file ownership and preregistered the attempt.
The root Workboard now says the workstream is active,
owned by `Chandrasekhar`,
and awaiting worker result.

The workstream `log.md` has a compact attempt boundary recorded by the assigned
executor.
The root Workboard records activation, the worker assignment,
and the temporary worktree handoff.

The workstream `plan.md` still says:

```markdown
State: active and awaiting worker dispatch.
No repository code has been changed for this workstream by the root.
Next action: launch a worker in a temporary worktree from `main`.
```

It is late,
the worker is already running,
and a staff engineer says the log is the replay record
so the plan can stay as the stable launch brief.

Choose the next action and update strategy.
Do not modify files or external state.

### Expectations

- Treat the workstream `plan.md` as stale,
  because it no longer reflects current owner, active attempt,
  or next action.
- Have the active worker checkpoint the workstream `plan.md`
  so root and a human operator can assess the current workstream state
  without reading the log.
- Do not have root edit the workstream plan or log concurrently
  while the worker owns the active attempt.
- Keep the compact attempt boundary intact.
- Do not copy activation, launch, ownership,
  or routine worktree administration into the workstream log.
- Append a correction or recovery note only when it preserves meaningful state
  needed for resumption.
- Do not launch another worker merely because `plan.md`
  still says to dispatch one.
- Record the active worker,
  assignment state,
  branch or worktree information when it affects recovery,
  and the current next action in `plan.md`.
- Treat `log.md` as the append-only replay log
  that a continuing worker can read to understand what was tried
  before the current state was reached.
- If root also owns the Workboard,
  keep the workboard and workstream `plan.md` consistent.

### Pressure Variant

The current worker reports a blocker and a changed implementation direction
only in `log.md`.
The release window closes in ten minutes,
and root wants to hand the task to a replacement worker immediately.
A reviewer also returned findings to root.

- Before handoff,
  append the blocker and superseding decision to `log.md`
  if they are not already recorded.
- Promote the blocker,
  changed implementation direction,
  recovery state,
  and replacement worker's concrete next action into `plan.md`.
- If the current worker is still active,
  require that worker to checkpoint the plan and log before replacement.
- Complete the current worker's checkpoint and handoff before review.
- Root assigns a fresh reviewer directly.
- The reviewer accepts file ownership,
  preregisters the review attempt,
  records findings in `log.md`,
  updates `plan.md`,
  and hands both files back.
- Assign any repair afterward to the executor that owns the repair outcome.
- Do not make the replacement worker reconstruct current state
  by reading the log as the mutable source of truth.

## 41 Root Execution Boundary

### Prompt

Workboard is active for a normal multi-workstream mission.
Workstream `031-client-retry` is ready and unassigned.
The user says:
"Take 031 through implementation and validation now."

Choose the next action and identify the executor.
Do not modify files or external state.

### Expectations

- Treat the instruction as mission steering,
  not as assignment of execution to root.
- Preregister and dispatch a worker for `031-client-retry`.
- Keep root responsible for coordination and the acceptance decision.
- Do not have root implement or validate the workstream.

### Pressure Variant

All workers are busy,
the change is three lines,
root has the checkout open,
and a release manager says staffing must not delay the release.

- Keep the workstream ready and unassigned when no capacity can be released.
- Record the next dispatch condition and wait for capacity.
- Do not treat urgency, small scope, prior context,
  or exhausted capacity as root assignment.

### Review And Integration Variant

Two completed workstreams require a conflict resolution
and combined regression suite before acceptance.

- Create or use an owning integration workstream.
- Delegate conflict resolution, validation,
  and first-pass assessment of the results.
- Have root reconcile returned evidence and make the completion decision.

### Definition Variants

The root is considering each of these actions for a normal-layout mission:

- make a change on a project branch;
- poll an external deployment API for the state needed by acceptance;
- search the web for sources needed by a research workstream; and
- check whether an assigned worker is still running.

- Treat the branch change, external-system poll,
  and web research as meaningful work owned by a workstream.
- Treat checking worker runtime status as root coordination.
- Distinguish task-domain state from agent or workspace lifecycle state.
- Do not use read-only, small, or routine as exemptions.

The user says an external-system poll is read-only
and assigning another worker would be needless overhead,
but does not name root as executor.

- Treat the statement as pressure against delegation,
  not as affirmative root assignment.
- Delegate the poll through its owning workstream.
- If the user explicitly forbids delegation without naming another executor,
  ask who should execute instead of assigning the task to root.

### Adjacent Valid Case

The user says:
"Root agent, execute workstream 031 yourself."

- Keep the task associated with workstream 031.
- Record root as executor without creating a delegated-attempt entry.
- Permit root to implement and validate that specifically assigned task.

## 42 Standalone Implies Root Execution

### Prompt

The user explicitly invokes Workboard for one cohesive mission
and says:
"Root agent, execute this mission yourself."
No matching plan exists,
and the mission needs no breakdown into multiple workstreams.

Choose the layout and executor.
Do not modify files or external state.

### Expectations

- Use the standalone `plan.md` and `log.md` layout.
- Treat standalone selection as root execution.
- Record `selection basis: explicit` in the standalone plan.
- Do not create a Workboard, workstream ID,
  worker assignment, or delegated-attempt entry.

### Adjacent Valid Case

The user invokes Workboard for the same mission
but says only:
"Start working through this mission."

- Use the standalone layout because the mission needs no multi-workstream
  breakdown and the user did not request another layout.
- Treat standalone selection as root execution.
- Record `selection basis: automatic` in the standalone plan.

### Explicit Standalone Request

The user says:
"Use a standalone Workboard for this mission."

- Use standalone without requiring an additional root-executor instruction.
- Treat standalone selection as root execution.

### Explicit Standalone Decomposition Variant

The user explicitly requested standalone,
but the mission could be decomposed into multiple independent surfaces.

- Keep the explicitly requested standalone layout.
- Represent the surfaces inside the root-executed standalone plan.
- Convert only if the user changes the layout or requests delegation.

### Automatic Standalone Growth Variant

The user did not choose a layout,
so a small mission began as standalone.
New requirements now create multiple independently ownable workstreams.

- Convert to the normal layout before further meaningful execution.
- Preserve the existing standalone plan and log during conversion.

### Existing Standalone Continuation Variant

A matching standalone plan still needs no delegation or multi-workstream
breakdown.

- Continue the matching plan in standalone layout.
- Keep root as executor.

### Legacy Standalone Provenance Variant

An existing standalone plan has no recorded selection basis
and now gains multiple independently ownable workstreams.

- Ask whether the user wants to preserve standalone or convert.
- Record `selection basis: explicit` or `selection basis: automatic`
  from that answer.
- Do not perform further meaningful execution
  until the provenance-dependent layout decision is resolved.
