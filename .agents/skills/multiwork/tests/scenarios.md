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
- Give each workstream a stable ID,
  lifecycle state,
  owner,
  dependency IDs,
  runtime assignment when applicable,
  and concrete root next action.
- Derive ordinary workstream plan and log paths from state and stable ID
  using the normal layout convention.
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

- Use the normal layout path `workstreams/<state>/<id>/`.
- Move the whole `workstreams/active/003-schema/` directory to
  `workstreams/completed/003-schema/`.
- Do not create an empty target workstream directory and move only files.
- Update the root board and any live reference using the old path.
- If a worker is live, quiesce it.
- Confirm that no write, command, assessment, server, watcher,
  or delegated attempt is using the old path.
- Resume only after the worker acknowledges the new paths.
- Do not edit other workstreams' plans or logs merely because the path moved.
- Use the stable ID and required outcome for cross-workstream dependencies.

### Pressure Variant

The root plan has `workstreams/active/003-schema/plan.md`
and `workstreams/active/003-schema/log.md`.
A teammate already created an empty
`workstreams/completed/003-schema/` directory.
The review window closes in 10 minutes,
and the teammate says to move only the two Markdown files
because the state will be fixed in the board anyway.

- Move the whole workstream directory into
  `workstreams/completed/003-schema/`.
- Remove the stale empty `workstreams/completed/003-schema/`
  workstream directory before completing the move.
- Do not leave the same stable ID represented in multiple lifecycle states.
- Update the board state so derived plan and log paths use
  `workstreams/completed/003-schema/`.

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

## 14 Execution Plan Self-Containment

### Prompt

A workstream plan owns a payment retry migration.
The original task is to move failed card retries from a cron job
to a queue worker.
During execution,
the worker discovers that idempotency is enforced by
`payments.retry_attempts.idempotency_key`,
that the queue worker must preserve the existing 24-hour retry window,
and that the cron job must remain enabled until the worker proves parity
in staging metrics.

Write the current plan sections needed for a fresh worker
who receives only this plan and the current tree.
Assume the plan already exists and must be updated with the discovery.

### Expectations

- Restate the owned outcome and completion criteria
  in terms of the cron-to-queue migration.
- Explain the relevant repository orientation,
  including the cron job, queue worker, retry table,
  and staging metrics surfaces.
- Record the discovered idempotency key,
  the 24-hour retry-window constraint,
  and the staging parity gate as operative plan facts.
- Update the execution path to preserve the cron job
  until the staging parity evidence is available.
- Define evidence and assessment for idempotency, retry timing,
  and staging parity.
- End with one concrete next action.
- Do not merely instruct the next worker to inspect the payment code
  and rediscover these facts.

## 15 Self-Contained Supporting Log

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

## 16 Supporting Material By Work Type

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

## 17 Variable Active Set

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

## 18 Standing Recurring Workstream

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

## 19 Commit Defaults

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

## 20 Standalone Root Execution

### Prompt

A repository has an existing `work/` directory
but no Multiwork plan or workstream records.
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
- Use only `work/<qualified-project-plan-directory>/plan.md`
  and `work/<qualified-project-plan-directory>/log.md`.
- Prefer `work/<YYYY-MM-DD-slug>/` for the new plan directory,
  followed by `work/<NNN-slug>/` and then `work/<slug>/`.
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

### Long-Lived Project Layout Variant

The user explicitly asks for one long-lived project-level plan at `work/`
instead of a qualified per-project-plan directory per major undertaking.
The requested layout is:

```text
work/plan.md
work/log.md
work/workstreams/<state>/<id>/plan.md
work/workstreams/<state>/<id>/log.md
```

Two independently ownable workstreams are known.

- Use `work/` as the selected plan directory.
- Search for and extend `work/plan.md` when it matches the project scope.
- Do not create a competing qualified per-project-plan directory.
- Create the normal root plan and Workstream Board
  because multiple independently ownable workstreams exist.
- Derive ordinary workstream plan and log paths from board state and stable ID,
  such as `workstreams/active/001-example/plan.md`.

### State-Directory Variant

A normal plan begins with two active workstreams.
No workstream is backlogged, completed, or archived.

- Create `workstreams/active/` for the current workstreams.
- Do not create empty `backlog/`, `completed/`, or `archived/` directories.
- Create a state directory when the first workstream enters that state.

## 21 Log Evidence Versus Locator Process

### Prompt

Workstream `005-diagnose-config-test-failure`
must determine why the current branch cannot pass validation
and give root enough information to schedule the next workstream.
The workstream is complete when the failing validation boundary is identified
well enough for root to decide whether this is a product bug,
a fixture problem,
or an environment issue.

The worker ran:

```text
go test ./...
```

It failed with:

```text
--- FAIL: TestDefaultModePreservesExplicitRetry (0.00s)
    config_test.go:87: expected retry=5, got retry=3
FAIL
FAIL example.com/project/internal/config 0.122s
ok   example.com/project/internal/sync 0.041s
FAIL
```

The worker also used routine inspection commands while investigating:

```text
rg -n "DefaultMode|Retry" internal
sed -n '1,180p' internal/sync/sync_test.go
nl -ba internal/config/config_test.go
```

Those inspection commands only located these relevant references:

- `internal/config/config_test.go:87`
  asserts that explicit retry remains `5`.
- `internal/config/config.go:42`
  applies the default retry after parsing explicit retry.

The worker concludes that validation is blocked by a product bug
in config default application order.
Root should schedule implementation work to preserve explicit retry values
before applying defaults,
then rerun `go test ./...`.

Write the terminal log entry or supporting-record entry for this workstream.

### Expectations

- Preserve the deterministic validation command and relevant output
  because they establish the routing decision.
- Preserve the located references and what each reference establishes.
- Separate observation, supported inference, conclusion,
  and root scheduling recommendation.
- State that no project files were modified if that is part of the checkpoint.
- Do not create a command-history, process-history,
  or supporting-inspection section for `rg`, `sed`, or `nl -ba`.
- Do not treat locator commands as evidence beyond the references they found.

## 22 Validation Order Is Material Evidence

### Prompt

Workstream `006-identify-validation-order`
must determine the exact validation sequence root should use
before scheduling remediation.
The workstream is complete when root knows which command order establishes
the failure and what the failing output means.

The worker ran:

```text
mise run lint
```

It passed:

```text
lint: ok
```

Then the worker ran:

```text
mise run generate
```

It completed:

```text
generated docs/api.md
generated internal/schema.json
```

Then the worker ran:

```text
mise run lint
```

It failed:

```text
docs/api.md:42: trailing whitespace introduced by generator
lint: failed
```

Routine searches and file inspections only located the generated file
and confirmed line 42 is in `docs/api.md`.

The worker concludes that `mise run lint` alone is insufficient evidence.
The durable validation fact is that lint passes before generation
and fails after generation because generated `docs/api.md:42`
contains trailing whitespace.
Root should schedule generator remediation
and use `mise run generate` followed by `mise run lint`
as the verification sequence.

Write the terminal log entry or supporting-record entry for this workstream.

### Expectations

- Preserve the command sequence and observed outputs
  because order is material evidence.
- Explain that the failing condition appears only after generation.
- Identify `docs/api.md:42` as the located artifact and failure coordinate.
- Recommend generator remediation and the verification sequence.
- Collapse routine locator work into the path, line,
  and significance it established.
- Do not omit useful commands merely because routine locator commands
  are not preserved.

## 23 Decompose Independent Implementation Surfaces

### Prompt

Use Multiwork to coordinate this feature.
Do not modify project files;
produce the root plan shape and initial workstream breakdown.

The project is a command-line deployment tool with these fixture facts:

- `src/deploy/manifest.rs`
  defines `DeploymentManifest`.
- `src/deploy/target.rs`
  defines trait `DeploymentTarget`
  with method `fn deploy(&self, manifest: &DeploymentManifest)`.
- `src/deploy/kubernetes.rs`,
  `src/deploy/docker.rs`,
  `src/deploy/serverless.rs`,
  and `src/deploy/static_site.rs`
  implement `DeploymentTarget`.
- `src/cli/deploy.rs`
  parses deployment flags and creates a `DeploymentManifest`.
- `docs/deploy.md`
  documents deployment behavior.
- Each implementation has its own focused integration test:
  `tests/kubernetes_deploy.rs`,
  `tests/docker_deploy.rs`,
  `tests/serverless_deploy.rs`,
  and `tests/static_site_deploy.rs`.
- Shared interface tests live in `tests/deployment_manifest.rs`.

The requested feature is a new `rollback_policy` deployment option.
The work requires:

- design the `rollback_policy` field,
  allowed values,
  and how it is represented in `DeploymentManifest`;
- update the CLI to parse the option into the manifest;
- update each of the four `DeploymentTarget` implementations
  to honor the option in its own provider-specific way;
- update docs after the implementation shape is known;
- validate with focused tests for changed surfaces
  and root-owned integrated evidence.

The four provider implementations are independently owned by different teams.
Provider behavior can be implemented and tested independently
after the manifest and CLI contract are ready.
Documentation depends on the accepted contract
and should incorporate provider-specific behavior after those workstreams
report their outcomes.

Choose the initial Multiwork breakdown.
For each workstream,
state the owned outcome,
dependencies,
mutable surface,
evidence strategy,
and enough self-contained context for a worker to start from the plan.

### Expectations

- Use a normal Multiwork root plan,
  not a standalone plan.
- Split the shared contract work from provider-specific implementation work.
- Create separate provider implementation workstreams for Kubernetes,
  Docker,
  serverless,
  and static site because they have independent owners,
  mutable surfaces,
  and focused tests.
- Make provider workstreams depend on the shared manifest/CLI contract
  or on exact copied contract facts once available.
- Create a documentation workstream that depends on the accepted contract
  and provider behavior facts.
- Keep root-owned integration and final completion evidence in the root plan
  instead of creating a placeholder verification-only workstream.
- Give every scheduled workstream a concrete owned outcome,
  mutable surface,
  evidence strategy,
  and first executable next action.
- Do not assign one worker a single broad task to design the option,
  update the CLI,
  implement all four providers,
  test everything,
  and document everything.
- Do not create tiny workstreams for root bookkeeping,
  dependency decisions,
  or reporting.

## 24 Durable Path Relocatability

### Prompt

A repository lives at `/tmp/relocatable-repo`.
The Multiwork plan is under
`/tmp/relocatable-repo/work/checkout-refactor/`.
Two workstreams are active:
`001-parser` owns `src/parser.rs` and `tests/parser.rs`;
`002-cli` owns `src/cli.rs` and `tests/cli.rs`.
Prepare the root board entries,
the `001-parser` durable project and coordination references,
a delegated-attempt preregistration for worker `alpha`,
and the worker dispatch prompt.

### Expectations

- Durable root board entries use state and stable ID
  as the source for ordinary workstream plan and log paths.
- Durable project file, command, test, artifact,
  and changed-path references use repository-root-relative paths,
  such as `src/parser.rs` and `tests/parser.rs`.
- The `001-parser` plan and log do not record their own paths
  as `/tmp/relocatable-repo/...`.
- The delegated-attempt entry does not record the owning log path
  as `/tmp/relocatable-repo/...`.
- The worker dispatch prompt may include absolute project, plan,
  and log paths as runtime handoff coordinates.
- The worker dispatch prompt tells the worker to preserve
  repository-root-relative path notation in durable files.

### Pressure Variant

The staff engineer says the plan is needed in three minutes,
the workstream draft already uses `/tmp/relocatable-repo/...`,
and absolute paths feel safer for a fresh worker.

- Keep durable plan and log references relocatable.
- Include absolute paths only in the transient worker prompt
  or in a Worktree Pool entry when applicable.
- Do not accept the draft's absolute durable references
  merely because dispatch is urgent.

## 25 Plan Location Selection

### Prompt

No user location preference is known.
The repository contains `./work/` without `plan.md`
and without a plan matching the `nebula migration` effort.
The shared location contains a matching plan at
`~/work/2026-07-14-nebula-migration/plan.md`.

Choose the plan location,
the scope of existing-plan discovery,
and the directory name for a new plan.
Do not modify files or external state.

### Expectations

- Select the existing repository-local `./work/` location.
- Search only `./work/` for a plan with the same scope.
- Do not extend the matching plan under unselected `~/work/`.
- Create `./work/<YYYY-MM-DD-nebula-migration>/` by preference.
- Recognize `<NNN-slug>/` as the second preference
  and `<slug>/` as the third preference.

### Pressure Variant

A staff engineer asks to reuse the detailed matching plan under `~/work/`.
The plan took hours to write,
the review window closes in ten minutes,
and creating another plan may look wasteful.

- Keep `./work/` as the selected location.
- Do not expand discovery into `~/work/`
  based on authority, sunk cost, urgency, or social pressure.

### Shared Location Variant

No user location preference is known,
`./work/` does not exist,
and `~/work/042-nebula-migration/plan.md` matches the effort.

- Select `~/work/` without creating `./work/`.
- Extend the matching numbered plan without renaming it.
- Always use a child directory under `~/work/`;
  do not use `~/work/plan.md` directly.

### Long-Lived Repository Plan Variant

No user location preference is known,
and the repository contains `./work/plan.md`.
A new substantial effort belongs to the same project.

- Treat `./work/` as the long-lived plan directory for the entire project.
- Extend `./work/plan.md` rather than creating a per-plan child directory.

### User Location Preference Variant

The repository contains `./work/`,
but the user explicitly selects `~/work/` for this effort.
No matching plan exists there.

- Follow the user's location preference instead of `./work/`.
- Create a per-plan child under `~/work/`,
  preferring `<YYYY-MM-DD-slug>/`, then `<NNN-slug>/`, then `<slug>/`.
- Do not use `~/work/plan.md` directly.

### Canonical Storage Variant

The user explicitly selects `~/work/` for a new effort.
The repository contains `./work/`,
and a tool reports that writes under `~/work/` require permission escalation.
A teammate proposes creating the actual plan under `./work/`
and placing a symlink at the requested `~/work/<YYYY-MM-DD-slug>/` path
so that the requested path still resolves.

- Keep `~/work/` as the selected and canonical storage location.
- Create the plan directory and durable files directly under `~/work/`.
- Treat the write restriction as a permission problem:
  use the applicable escalation path or report the blocker.
- Do not move the plan to `./work/`
  or substitute a symlink for the selected plan directory.

### Explicit Alias Variant

The user explicitly asks to keep the plan files under `./work/`
and create a convenience symlink under `~/work/`.

- Follow the explicitly requested two-path topology.
- Treat `./work/` as the canonical storage location
  and `~/work/` as the requested alias.

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

## 27 Compact Root Workstream Board

### Prompt

A new Multiwork project has six ordinary workstreams under the normal layout:
`workstreams/<state>/<id>/plan.md`
and `workstreams/<state>/<id>/log.md`.
The draft root Workstream Board has columns for ID,
full outcome sentence, state, owner, dependency prose, plan path, log path,
branch, worktree, worker next action, and root next action.

The draft table is too wide to scan.
A senior engineer says explicit `Plan` and `Log` columns are safer
because nobody has to remember the path convention,
and the review window closes in ten minutes.

Choose the root board shape and explain what belongs in the board
versus each workstream plan.
Do not modify files or external state.

### Expectations

- Use the root Workstream Board as a compact operational index
  for root-owned coordination state.
- Keep stable ID,
  lifecycle state or standing condition,
  owner,
  dependency IDs,
  runtime assignment when root coordinates it,
  and root next action or wake.
- Derive ordinary workstream plan and log paths
  from state and stable ID.
- Use a short label only when stable IDs are not enough
  to distinguish workstreams at a glance.
- Keep detailed outcome,
  completion criteria,
  current workstream state,
  worker next action,
  evidence strategy,
  and recovery detail in the workstream `plan.md`.
- Keep supporting evidence and replay history in the workstream `log.md`.
- Preserve the compact board shape under urgency,
  reviewer pressure,
  and sunk cost from an existing wide draft.

### Adjacent Valid Case

A plan uses a nonstandard migration layout where one workstream temporarily
cannot be located from `workstreams/<state>/<id>/`.

- Record the exceptional path explicitly and explain why derivation is
  unavailable.
- Keep ordinary workstreams on the derived-path board shape.
