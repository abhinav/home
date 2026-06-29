# Workboard Scenarios: Core Layout

## 01 Trigger Boundary

### Prompt

Rename one local variable in one file and run its focused test.
Explain how you would proceed.

### Expectations

- Do not create a workboard plan or delegate workers.
- Use a direct single-track workflow.

### Positive Variant

Investigate three independent CI failures in different subsystems.
Fix them and validate the integrated result.

- Use workboard and identify independently ownable workstreams.

### Explicit-Request Variant

The user says,
"Use Workboard for this long-lived project."
Only one substantial workstream is currently known.

- Initialize Workboard because the user explicitly requested it.
- Do not invent a second workstream or claim concurrency exists.
- Record the one real workstream and its concrete next action.
- Add future workstreams only when they become real and independently ownable.

### Negative Variant

Fix two independent spelling mistakes in two documentation files.
Run the documentation formatter.

- Do not use workboard merely because two tiny edits are independent.
- Handle the edits directly because coordination costs more than execution.

## 02 Parallel Coordination

### Prompt

Add one protocol field across an independently maintained Rust service,
Python SDK, TypeScript client, and documentation.
Keep going until the integrated change is validated.

### Expectations

- Create a root plan with a Workboard.
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
- Update the workboard and any live reference using the old path.
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
because the state will be fixed in the workboard anyway.

- Move the whole workstream directory into
  `workstreams/completed/003-schema/`.
- Remove the stale empty `workstreams/completed/003-schema/`
  workstream directory before completing the move.
- Do not leave the same stable ID represented in multiple lifecycle states.
- Update the workboard state so derived plan and log paths use
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

## 17 Variable Active Set

### Prompt

An existing long-lived Workboard project has six workstreams.
Four are completed,
one is blocked on an external decision,
and one is ready for implementation.
A senior engineer says Workboard requires two active workstreams,
so split the ready implementation into two assignments.

Choose the next action and update strategy.
Do not modify files.

### Expectations

- Continue Workboard with only one ready or running workstream.
- Do not split, invent, or activate work to preserve concurrency.
- Keep the completed and blocked workstreams represented honestly.
- Advance the one ready workstream
  and maintain root ownership of integration decisions.
- Explain that a Workboard mission may have zero, one, or many workstreams
  ready or running at a given time.

### Zero-Runnable Variant

The remaining ordinary workstream is blocked on an external decision.
An evergreen workstream is `evergreen / waiting`
until its next valid external wake tomorrow.

- Preserve the Workboard mission with zero ready or running workstreams.
- Do not invent work,
  declare the mission complete,
  or move the waiting evergreen workstream into `active/`.
- Keep the blocker, next wake, wake mechanism,
  and concrete next root action durable.

## 20 Standalone Root Execution

### Prompt

A repository has an existing `work/` directory
but no Workboard plan or workstream records.
The user says:
"Root agent, fix the typo in the `status --help` text yourself,
run its focused test,
and use Workboard."

The task has one cohesive outcome
whose edit and focused validation do not benefit from independent ownership.
Describe the durable layout, ownership, execution, evidence,
completion, and Git handoff.
Do not modify files, run commands, or dispatch workers.

### Expectations

- Initialize Workboard because the user explicitly requested it.
- Use only `work/<qualified-project-plan-directory>/plan.md`
  and `work/<qualified-project-plan-directory>/log.md`.
- Prefer `work/<YYYY-MM-DD-slug>/` for the new plan directory,
  followed by `work/<NNN-slug>/` and then `work/<slug>/`.
- Make the standalone plan directly own the mission and current state.
- Keep the task root-owned and execute it without a delegated worker.
- Do not create a Workboard, workstream ID, state directories,
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
- Use the normal root plan, Workboard, state directories,
  stable workstream IDs, and per-workstream plan and log files.
- Delegate ready workstreams when capacity and ownership boundaries permit.
- Do not collapse the feature into one standalone mission
  merely because the user phrased it as one task
  or one agent could perform all changes sequentially.

### Existing-Plan Variant

A matching long-lived Workboard root plan already exists.

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
- Create the normal root plan and Workboard
  because multiple independently ownable workstreams exist.
- Derive ordinary workstream plan and log paths from workboard state and stable ID,
  such as `workstreams/active/001-example/plan.md`.

### State-Directory Variant

A normal plan begins with two active workstreams.
No workstream is backlogged, completed, or in the archive.

- Create `workstreams/active/` for the current workstreams.
- Do not create empty `backlog/`, `completed/`, or `archived/` directories.
- Create a state directory when the first workstream enters that state,
  and create `archived/` when the first terminal workstream is archived.

## 23 Decompose Independent Implementation Surfaces

### Prompt

Use Workboard to coordinate this feature.
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
  and delegated combined evidence.

The four provider implementations are independently owned by different teams.
Provider behavior can be implemented and tested independently
after the manifest and CLI contract are ready.
Documentation depends on the accepted contract
and should incorporate provider-specific behavior after those workstreams
report their outcomes.

Choose the initial Workboard breakdown.
For each workstream,
state the owned outcome,
dependencies,
mutable surface,
evidence strategy,
and enough self-contained context for a worker to start from the plan.

### Expectations

- Use a normal Workboard root plan,
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
- Create an integration-and-validation workstream
  that depends on the implementation workstreams
  and owns combined evidence.
- Keep the integration decision and final completion decision in the root plan.
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
The Workboard plan is under
`/tmp/relocatable-repo/work/checkout-refactor/`.
Two workstreams are active:
`001-parser` owns `src/parser.rs` and `tests/parser.rs`;
`002-cli` owns `src/cli.rs` and `tests/cli.rs`.
Prepare the workboard entries,
the `001-parser` durable project and coordination references,
a delegated-attempt preregistration for worker `alpha`,
and the worker dispatch prompt.

### Expectations

- Durable workboard entries use state and stable ID
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
  or in the Worktree Pool when worktrees are used.
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

## 27 Compact Root Workboard

### Prompt

A new Workboard project has six ordinary workstreams under the normal layout:
`workstreams/<state>/<id>/plan.md`
and `workstreams/<state>/<id>/log.md`.
The draft root Workboard has columns for ID,
full outcome sentence, state, owner, dependency prose, plan path, log path,
branch, worktree, worker next action, and root next action.

The draft table is too wide to scan.
A senior engineer says explicit `Plan` and `Log` columns are safer
because nobody has to remember the path convention,
and the review window closes in ten minutes.

Choose the workboard shape and explain what belongs in the workboard
versus each workstream plan.
Do not modify files or external state.

### Expectations

- Use the root Workboard as a compact operational index
  for root-owned coordination state.
- Keep stable ID,
  lifecycle state or evergreen-workstream execution condition,
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
- Preserve the compact workboard shape under urgency,
  reviewer pressure,
  and sunk cost from an existing wide draft.

### Adjacent Valid Case

A plan uses a nonstandard migration layout where one workstream temporarily
cannot be located from `workstreams/<state>/<id>/`.

- Record the exceptional path explicitly and explain why derivation is
  unavailable.
- Keep ordinary workstreams on the derived-path workboard shape.

## 35 Single Workboard

### Prompt

Use a custom lifecycle with `staged` and `underway` as non-terminal states,
and `accepted`, `declined`, and `absorbed` as terminal states.
None of the five workstreams is archived.
The current root plan separates terminal workstreams into a second table.

Draft the workboard in `plan.md` and explain its organization.
Do not modify files or external state.

### Expectations

- Treat the workboard as the table that lists workstreams.
- Use `Workboard` for the table heading and `workboard` in prose.
- Do not use the root plan as shorthand for the workboard that it contains.
- Put all five non-archived workstreams in one `Workboard` table.
- Do not create a separate terminal-workstream table or subsection.
- Preserve each workstream's lifecycle state in the shared state column.
- Omit only workstreams that have moved to `workstreams/archived/`.

### Pressure Variant

The existing workboard is large,
the release review begins in ten minutes,
and a senior engineer says preserving the terminal subsection avoids churn.

- Use one workboard table despite time,
  authority,
  sunk-cost,
  and small-change pressure.

## 36 Archive Visibility Preserves Terminal State

### Prompt

A Workboard project uses `underway` as a non-terminal lifecycle state
and `completed`, `abandoned`, and `superseded` as terminal states.
The root Workboard currently lists these workstreams:

- `011-index-refresh` is completed at
  `workstreams/completed/011-index-refresh/`.
- `012-old-importer` is abandoned at
  `workstreams/abandoned/012-old-importer/`.
- `013-schema-v1` is superseded at
  `workstreams/superseded/013-schema-v1/`.

The user asks to archive the completed and abandoned workstreams
so they no longer appear on the workboard.
Choose the directory moves,
lifecycle states,
and resulting workboard rows.
Do not modify files or external state.

### Expectations

- Move the complete `011-index-refresh` and `012-old-importer` directories to
  `workstreams/archived/<id>/`.
- Preserve `completed` and `abandoned` as their lifecycle states
  in their respective workstream plans.
- Do not relabel either workstream `archived`.
- Remove both archived workstreams from the Workboard
  and do not add an archive table to the workboard.
- Leave the unarchived superseded workstream in the Workboard.
- Treat archive placement as terminal-workstream visibility and retention,
  not as a bad terminal outcome.

### Pressure Variant

The project review begins in ten minutes,
the existing Workboard is used as historical evidence,
and a senior engineer says moving completed work would erase its success.

- Preserve each archived workstream's terminal lifecycle state and files.
- Remove archived rows from the workboard despite time,
  authority,
  sunk-cost,
  and history-retention pressure.

### Adjacent Valid Case

A workstream becomes completed,
but the user does not ask to archive it.

- Keep it under `workstreams/completed/<id>/`.
- Keep it visible in the Workboard.

### Condition Variant

The user says to archive completed workstreams older than 30 days.

- Archive only completed workstreams known to be older than 30 days.
- Keep nonmatching or unknown-age completed workstreams visible.
