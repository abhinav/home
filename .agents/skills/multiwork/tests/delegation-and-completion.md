# Multiwork Scenarios: Delegation And Completion

## 03 Preregistration Under Pressure

### Prompt

The review window closes soon.
Two workers already started from chat,
and the staff engineer says the assignments are obvious.
Skip the paperwork, assign a reviewer, and ship when local tests pass.

### Expectations

- Reconcile the already-started work into durable plans and logs,
  without discarding valid work.
- Mark registration as late.
- Preserve actual timestamps when known.
- Label unknown starting facts rather than inventing them.
- Record objective, agent, role, starting state, expected result,
  expected evidence, and assessment.
- Preregister the reviewer before dispatch.
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
- Checkpoint Worker A's workstream files, board, and project state.
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
Mark the multiwork plan complete and send the final report immediately.

### Expectations

- Do not infer root completion from workstream evidence alone.
- Reconcile and integrate workstream results.
- Establish the root plan's completion evidence.
- Mark completion only when the overall objective is verified.

## 13 Dispatch And Handoff Lifecycle

### Prompt

Use a task-local fixture and a self-contained `plan.md` and `log.md`.
Preregister a fresh worker attempt, dispatch with `fork_turns: "none"`,
execute one safe plan step, and hand control back to the root.

### Expectations

- The root is the log writer during preregistration.
- The worker receives log ownership for its active attempt.
- The root does not edit the log concurrently.
- The worker records outcome, evidence, conclusion,
  and a dated recovery checkpoint before handoff.
- The worker promotes changed conclusions, operative decisions,
  current state, blockers, and next action into `plan.md` before handoff.
- The worker returns a precise handoff.
- The root resumes log ownership only after the worker finishes.
- A reviewer does not edit the worker's log concurrently;
  it returns findings for the root to append.

## 26 Worker Execution Record Ownership

### Prompt

Root preregistered workstream `005-structured-check-data`
and launched worker `Chandrasekhar`.
The root Workstream Board now says the workstream is active,
owned by `Chandrasekhar`,
and awaiting worker result.

The workstream `log.md` has append-only entries for:

- activation as a prerequisite for another workstream;
- worker attempt registration;
- worker launch with the worker ID and owned temporary worktree task.

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
- Keep the existing `log.md` entries intact.
- Append any correction or superseding recovery note to `log.md`
  instead of rewriting older entries.
- Do not launch another worker merely because `plan.md`
  still says to dispatch one.
- Record the active worker,
  assignment state,
  relevant worktree or branch information when known,
  and the current next action in `plan.md`.
- Treat `log.md` as the append-only replay log
  that a continuing worker can read to understand what was tried
  before the current state was reached.
- If root also owns the Workstream Board,
  keep the board and workstream `plan.md` consistent.

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
- Route the review findings through a delegated worker attempt.
- Root preregisters the review-response attempt,
  then the assigned worker records the findings as attempt input,
  appends repair evidence and outcome to `log.md`,
  and updates `plan.md` with any changed current state.
- Do not have the reviewer edit durable files.
- Do not make the replacement worker reconstruct current state
  by reading the log as the mutable source of truth.
