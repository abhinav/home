# Multiwork Scenarios

## 01 Trigger Boundary

### Prompt

Rename one local variable in one file and run its focused test.
Explain how you would proceed.

### Expectations

- Do not create a multiwork plan or delegate workers.
- Use a direct single-track workflow.

### Positive Variant

Investigate three independent CI failures in different subsystems.
Fix them and validate the integrated result.

- Use multiwork and identify independently ownable workstreams.

### Explicit-Request Variant

The user says,
"Use Multiwork for this long-lived project."
Only one substantial workstream is currently known.

- Initialize Multiwork because the user explicitly requested it.
- Do not invent a second workstream or claim concurrency exists.
- Record the one real workstream and its concrete next action.
- Add future workstreams only when they become real and independently ownable.

### Negative Variant

Fix two independent spelling mistakes in two documentation files.
Run the documentation formatter.

- Do not use multiwork merely because two tiny edits are independent.
- Handle the edits directly because coordination costs more than execution.

## 02 Parallel Coordination

### Prompt

Add one protocol field across an independently maintained Rust service,
Python SDK, TypeScript client, and documentation.
Keep going until the integrated change is validated.

### Expectations

- Create a root plan with a Workstream Board.
- Give each workstream a stable ID, owner, and durable paths.
- Record state, dependencies, branch or worktree, and concrete next action.
- Give each workstream an evidence and assessment strategy.
- Advance eligible workstreams concurrently.
- Keep root ownership of integration and completion.

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

## 05 State Directory Move

### Prompt

Workstream `003-schema` is complete.
Move it from `active/` to `completed/`.
Other workstreams depend on its result.
Explain what must change.

### Expectations

- Move the directory.
- Update the root board and any live reference using the old path.
- If a worker is live, quiesce it.
- Confirm that no write, command, assessment, server, watcher,
  or delegated attempt is using the old path.
- Resume only after the worker acknowledges the new paths.
- Do not edit other workstreams' plans or logs merely because the path moved.
- Use the stable ID and required outcome for cross-workstream dependencies.

## 06 Self-Contained Dependency References

### Prompt

Workstream `002-client` depends on the schema produced by `001-schema`.
Write the dependency portions for both files:
`002-client/plan.md` and `002-client/log.md`.

### Expectations

- Name `001-schema` by stable ID and state the exact required contract.
- Include the dependency facts needed to act in each file.
- Do not reference another workstream's `plan.md` or `log.md` path.

## 07 Optional Goal Supervisor

### Prompt

Coordinate three independent workstreams over several turns.
The user did not request a goal, and two workers are currently running.

### Expectations

- Do not create a goal solely because the work is long-running.
- Wait for active workers when their results govern the next decision.
- Describe goal supervision as optional
  and governed by user or platform instructions.

## 08 Worktree Suitability And Pooling

### Prompt

Three workstreams edit different source directories.
All regenerate one shared lockfile
and require the same uncommitted schema change.
Two pooled worktrees exist.
Assign the work efficiently.

### Expectations

- Do not infer safe worktree isolation from different source directories.
- Identify shared outputs and uncommitted state as hazards.
- Do not assign the mutating workstreams to separate worktrees
  while they require the same uncommitted schema state.
- Before reuse, inspect and record identity, ownership, relevant state,
  processes, hazards, and availability.
- Do not clean or reset unexplained state.

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

## 11 Fresh-Context Executability

### Prompt

Create a task-local fixture project with these files and facts:

- `AGENTS.md` requires Cargo and preservation of public APIs.
  It requires focused tests before the full suite.
- `src/ingest.rs` sends `Event` values to hourly counters.
- `src/window.rs` calculates bucket boundaries.
- `tests/hourly_counts.rs` contains analogous boundary integration tests.
- The defect is doubled counts at a daylight saving time boundary.
- Hourly aggregation is UTC-based.
  It is keyed by the Unix timestamp of each UTC hour's start.
- `Event` and public APIs must not change.

Coordinate two substantial independent workstreams.
One workstream fixes the boundary calculation and regression coverage.
The other independently prepares rollout constraints, risks, observability,
and a decision-ready rollout framework while the remedy is being developed.
It incorporates the accepted remedy details before final completion.
Create the root and workstream files and preregister the attempts.
Stop before dispatch.

### Harness

After Agent A stops,
run the two-phase harness from `tests/README.md`
against the boundary-fix workstream.

### Expectations

- The plan explains the purpose, outcome, and repository orientation.
- It names relevant paths, symbols, governing instructions, and boundaries.
- It records dependency contracts, resolved decisions, and a concrete approach.
- It defines the evidence strategy, recovery, current state, and next action.
- The plan defines non-obvious terms and summarizes required source facts.
- The plan contains no placeholders or reliance on the original conversation.
- The plan does not use broad repository exploration
  as a substitute for task-specific context.
- Agent B receives the project, governing instructions, and `plan.md`.
  It does not receive the original prompt, skill, or workstream log.
- Agent B executes the first safe plan step and returns evidence.
  It does not request missing task context or read another workstream's files.

## 12 Validation Fits The Work

### Prompt

Coordinate three non-code workstreams.
One workstream assesses architecture option A from fixture documents.
Another independently assesses option B from the same source set.
After both assessments are ready,
the third synthesizes the evidence and drafts a rollout design.
Define workstream assessment and root completion evidence.

### Expectations

- Match assessment to each artifact and claim.
- For research, use source coverage, citations, claim-to-evidence traceability,
  alternatives, and stated uncertainty.
- For design, use requirements, constraints, risks,
  and review against explicit criteria.
- Treat commands as optional.
  Use them only when they establish relevant evidence.
- Do not invent build commands, tests, or mutable code surfaces
  to fill a template.
- Distinguish workstream evidence from root completion evidence.

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

## 14 Self-Contained Supporting Log

### Prompt

Instantiate `plan.md` and `log.md`
for a workstream that investigates a production metric change.
Keep both files independently understandable
while avoiding needless duplication.
Preregister one delegated attempt.

### Expectations

- Put the full mission, project orientation, decisions,
  and execution path in `plan.md`.
- Define the log's useful contents, organization, and update rules in `plan.md`.
- Keep identity, owned outcome, essential context, dependency contracts,
  and a dated latest recovery checkpoint in `log.md`.
- Treat `plan.md` as authoritative if mutable current state differs.
- Preserve detailed supporting material outside attempt lifecycle entries,
  such as metric observations, queries and results, source inventories,
  hypotheses, disconfirming evidence, reviewer findings, or artifact indexes.
- Preregister attempt-specific intent, starting state, expected evidence,
  and assessment before dispatch.
- Append the attempt outcome afterward,
  summarizing or referencing the detailed supporting record.
- Do not duplicate the plan's full implementation narrative
  or turn the log into a transcript of every command and message.

## 15 Supporting Material By Work Type

### Prompt

Create self-contained `plan.md` and `log.md` examples
for four fixture-owned records:

- an implementation workstream with failed and successful checks;
- a research workstream with sources, contradictory claims,
  query results, screenshots, and a rejected hypothesis;
- a design workstream with constraints, alternatives, tradeoffs,
  a decision, and unresolved risk;
- root orchestration with ownership changes, reconciliation decisions,
  combined evidence, and one unresolved integration question.

Each record has exactly one delegated attempt.
Show what belongs in each log and what remains authoritative in its plan.
Stop before dispatch.

### Expectations

- Keep preregistration and outcome fields for each delegated attempt.
- Do not force all four logs into one fixed schema.
- Implementation logs preserve changed paths or symbols,
  behavioral observations, check results, failures, and residual risks.
- Research logs preserve source provenance, claim-to-evidence links,
  contradictions, gaps, alternatives, and uncertainty.
- Design logs preserve requirements, constraints, options, tradeoffs,
  decisions with rationale, review findings, and open risks.
- Root logs preserve root-owned coordination, reconciliation,
  integration evidence, unresolved conflicts,
  and dated acceptance assessments.
- Attempt entries may summarize or reference supporting sections;
  they are not the sole evidence store.
- Every plan and log is understandable without inherited conversation
  or another workstream's files.
- Promote current conclusions, decisions, state, and next actions to the plan.
- Preserve detailed provenance and chronology in the log.
- Before handoff,
  synchronize the plan with the latest recovery checkpoint recorded in the log.

### Log-Only Readback

Run the log self-containment harness from `tests/README.md`
against at least one generated workstream log.

- The fresh agent correctly explains the outcome and record organization.
- It identifies material evidence, uncertainty,
  and the dated latest recovery checkpoint.
- It does not require the plan, original prompt,
  conversation, or another workstream's files to interpret the record.
- It does not treat the checkpoint as guaranteed current beyond its timestamp
  or attempt to execute the mission from the log alone.

## 16 Variable Active Set

### Prompt

An existing long-lived Multiwork project has six workstreams.
Four are completed,
one is blocked on an external decision,
and one is ready for implementation.
A senior engineer says Multiwork requires two active workstreams,
so split the ready implementation into two assignments.

Choose the next action and update strategy.
Do not modify files.

### Expectations

- Continue Multiwork with only one ready or running workstream.
- Do not split, invent, or activate work to preserve concurrency.
- Keep the completed and blocked workstreams represented honestly.
- Advance the one ready workstream and maintain root integration ownership.
- Explain that a Multiwork mission may have zero, one, or many workstreams
  ready or running at a given time.

### Zero-Runnable Variant

The remaining ordinary workstream is blocked on an external decision.
A standing workstream is `active / waiting`
until its next valid external wake tomorrow.

- Preserve the Multiwork mission with zero ready or running workstreams.
- Do not invent work,
  declare the mission complete,
  or move the waiting standing workstream out of `active/`.
- Keep the blocker, next wake, wake mechanism,
  and concrete next root action durable.

## 17 Standing Recurring Workstream

### Prompt

An existing Multiwork project needs workstream `007-release-scan`
to inspect a release-status source every weekday at 09:00 Pacific time.
Each cycle scans strictly after a durable cursor,
records changes,
opens a bounded response when a threshold is crossed,
and otherwise waits for the next scheduled scan.

Capacity is scarce.
A manager asks to keep one worker alive in a sleep loop forever
because it is simpler.
No wake automation is configured yet,
and yesterday's wake was missed.

Describe the durable plan, board, log, attempt boundaries,
worker lifecycle, missed-wake handling, and immediate next action.
Do not configure an external scheduler or modify files.

### Expectations

- Keep the standing workstream under `active/`
  while its ongoing outcome remains part of the mission.
- Use a separate execution condition:
  `waiting`, `ready`, `running`, or `blocked`.
- Define the cycle purpose, schedule, timezone, actual wake mechanism,
  cursor, input boundary, procedure, evidence, no-change behavior,
  next-wake calculation, recovery, and any stop condition in `plan.md`.
- Keep the authoritative current cursor, condition, blockers,
  and next wake in the plan and root board.
- Record cycle evidence and dated recovery checkpoints in `log.md`.
- Treat each independently dispatched cycle as a new preregistered attempt.
- Do not treat the wake event itself as a delegated attempt.
- Keep routine follow-up within one running cycle in the same attempt.
- Do not move the workstream to `backlog/` or `completed/`
  after an unchanged cycle.
- Do not hold a worker in a sleep loop merely to provide scheduling.
- Release an inactive worker after durable checkpointing
  when retaining it has no near-term value or capacity is needed.
- State plainly that Multiwork records recurrence but does not schedule wakes.
- Record that no wake mechanism is currently configured.
- Reconcile the missed wake and actual external state before dispatch.
- Do not advance the cursor past inputs that were not successfully assessed.
- Make the immediate next action concrete:
  resolve or configure a real wake mechanism,
  then preregister and dispatch the overdue bounded cycle.

### Adjacent Valid Variant

The next cycle is due in five minutes,
capacity is available,
and the same healthy worker retains useful external session state.

- Permit retaining that worker across the short wait.
- Treat retention as an optimization,
  not a requirement of the standing-workstream contract.
- Keep the next wake and recovery state durable despite worker retention.

### Configured-Wake Variant

Automation `release-status-weekdays`
already wakes the root thread at 09:00 America/Los_Angeles on weekdays.
The user selected that mechanism.

- Record the exact automation identity, cadence, timezone,
  and next wake in the plan and board.
- Accept the configured mechanism without replacing it
  or prescribing another scheduler technology.
- Do not imply that Multiwork itself provides the wake.
- On wake,
  reconcile actual state before preregistering and dispatching the due cycle.

## 18 Commit Defaults

### Shared-Tree Prompt

Use Multiwork for a substantial implementation workstream.
The workstream operates in the repository's current working tree,
not in a separate worktree.
The user gives no commit instructions,
and no clear user preference establishes another behavior.

Describe the expected Git handoff.
Do not modify files or run commands.

### Expectations

- Leave the workstream changes uncommitted by default.
- Do not create commits merely for coordination, preregistration,
  evidence recording, handoff, or workstream completion.
- Preserve unrelated repository state.

### Worktree Variant

The workstream instead operates in an assigned worktree with its own branch.
The user gives no commit instructions,
and no clear user preference establishes another behavior.

- Commit the completed workstream changes to the worktree's branch by default.
- Keep the commit scoped to the workstream.
- Follow governing repository commit instructions.

### Preference Override Variant

The user explicitly asks for the opposite behavior,
or a clear established user preference requires it.

- Follow the explicit instruction or clear preference
  instead of the location-based default.

## 19 Standalone Root Execution

### Prompt

A repository has no Multiwork plan or workstream records.
The user says:
"Fix the typo in the `status --help` text,
run its focused test,
and use Multiwork."

The task has one cohesive outcome
whose edit and focused validation do not benefit from independent ownership.
Describe the durable layout, ownership, execution, evidence,
completion, and Git handoff.
Do not modify files, run commands, or dispatch workers.

### Expectations

- Initialize Multiwork because the user explicitly requested it.
- Use only `work/<plan-slug>/plan.md` and `work/<plan-slug>/log.md`.
- Make the standalone plan directly own the mission and current state.
- Keep the task root-owned and execute it without a delegated worker.
- Do not create a Workstream Board, workstream ID, state directories,
  nested workstream files, or a separate ledger.
- Do not create a delegated-attempt entry for root execution.
- Record supporting evidence and a dated recovery checkpoint in `log.md`.
- Mark the standalone mission complete after the edit and focused test pass.
- Retain the completed plan and log as durable history.
- Leave changes uncommitted by default because no worktree is used.

### Decomposition Pressure Variant

The user describes one complex feature as a single task.
Implementing it requires a service contract change,
independent client-library updates,
and an operator migration guide.
Each outcome is substantial,
has a distinct mutable surface and evidence boundary,
and can advance independently.

- Identify the independently ownable outcomes before choosing a layout.
- Use the normal root plan, Workstream Board, state directories,
  stable workstream IDs, and per-workstream plan and log files.
- Delegate ready workstreams when capacity and ownership boundaries permit.
- Do not collapse the feature into one standalone mission
  merely because the user phrased it as one task
  or one agent could perform all changes sequentially.

### Existing-Plan Variant

A matching long-lived Multiwork root plan already exists.

- Extend the matching plan instead of creating a standalone plan.
- Follow the existing plan's layout and lifecycle.

### State-Directory Variant

A normal plan begins with two active workstreams.
No workstream is backlogged, completed, or archived.

- Create `workstreams/active/` for the current workstreams.
- Do not create empty `backlog/`, `completed/`, or `archived/` directories.
- Create a state directory when the first workstream enters that state.
