# Stack Design Scenarios

## 01 Design self-contained review units

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A feature is planned as two stacked branches.
The first branch adds a low-level request builder in one package,
but nothing uses it and it has no behavioral tests.
The second branch adds the public operation that uses the builder
and contains all tests for the feature.

The branch names have already been announced,
a reviewer prefers small diffs,
and the release cutoff is in 20 minutes.
The current split was chosen because the files live in different packages.
Choose the review-branch plan without modifying files or Git state.

### Quality Bar

- Evaluation mode: judgment.
- Each resulting incremental diff is self-contained as a review unit.
- The plan derives branch boundaries from engineering outcomes and dependencies,
  rather than chronology, file organization, or pressure to preserve topology.
- The plan does not treat fewer branches as an objective.

### Expectations

- Combine or redistribute the implementation and tests
  so every retained branch contains enough implementation, context,
  and validation to evaluate its outcome.
- Inspect each resulting branch against its parent before handoff.
- Explain the review-unit boundary without treating the existing branch count
  as fixed.
- Do not modify files or Git state.

### Pressure Variant

The reviewer says the existing split is easier to scan
and asks you to preserve it unchanged because both diffs are small.

- Continue to require self-contained review units.
- Permit two branches if their contents are revised
  so each incremental diff carries a coherent outcome and its validation.
- Treat authority, sunk cost, time pressure, and small diff size
  as unrelated to the self-containedness decision.

### Adjacent Valid Case

The first branch adds a complete reusable request-building capability
with a documented contract, direct consumers, and contract tests.
The second branch adds one optional application workflow using that capability.

- Permit separate stacked branches.
- Place the application workflow above the reusable capability.

## 02 Establish release conditions by default

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
Read-only decision exercise; do not change files, Git, or external systems.
A user asks you to finalize a stack plan for a cache replacement.
Proposed order:
(1) replace an in-process cache adapter while retaining the public lookup contract,
(2) route the service's read traffic through the replacement,
(3) remove the old cache path.
Each branch includes focused tests
and a reviewer can understand its incremental diff.
Only the tip has run the whole repository suite.
The author says the middle branches are implementation checkpoints,
the entire stack is intended to land in one afternoon,
and arranging more validation will miss the review slot.
No release or deployment contract has been established in the task.
Choose now between handing off this plan as ready or revising it.
State the smallest next action and the evidence that would settle your choice.
Do not ask the user for more information.

### Quality bar

- Evaluation mode: judgment.
- The plan accounts for deployment after every bottom-up merge by default.
- Each resulting state can remain healthy if later branches never land.

### Expectations

- Revise the plan to establish intermediate release states and their evidence;
  existing branch boundaries may remain if they satisfy those conditions.
- Establish compatibility with current callers and rollout states,
  and evidence that consumers no longer need the path before its removal.
- Require relevant checks at each branch without relying on upstack fixes.
  Do not prescribe the whole repository suite indiscriminately.
- Do not treat tip-level validation or a promise of rapid merges
  as establishing intermediate health.

### Adjacent valid case

The task now supplies verified release conditions:
the replacement preserves the current lookup contract;
traffic switches after compatible instances are available;
removal waits until supported consumers no longer use the old path.
Relevant checks and compatibility probes have passed at each branch head.

- Permit the three review units with their release conditions.
- Do not require combining valid prerequisites with their consumers.
- Do not add a new rollout system or redundant validation solely to split work.

## 03 Separate a refactor from a small policy decision

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
This is read-only; do not modify files, Git state, or external systems.
Settle a stack plan for a request timeout change.
Branch one extracts a well-tested 35-line timing block
into a shared helper used by two callers, preserving all behavior.
Branch two changes the helper's default deadline from 10 seconds to 15 seconds
and adds two boundary tests.
Branch three makes an existing batch API call the helper
with a caller-supplied deadline and includes its tests.
All intermediate states build and pass CI.
The reviewer suggests folding branch two into branch one:
the changed constant is easy to spot,
a separate three-line semantic change feels too small for a PR,
and the release cutoff is close.
Choose the final branch boundaries and justify each review decision.
Do not ask for more information.

### Expectations

- Preserve separate review decisions for extraction, default policy,
  and batch integration, with implementation and evidence in each branch.
- Keep the extraction behavior-preserving relative to its parent.
- Put dependent work above the extraction;
  a fork or a linear stack is defensible when dependencies are explained.
- Do not reject an independent policy decision merely because its diff is small.

### Adjacent valid case

The extraction is unnecessary for the requested behavior.
The only structural edit is a local variable needed to express
one new timeout condition in the existing function.
There is no separate reusable capability or cleanup outcome.

- Keep that structural edit with the behavior and its tests.
- Do not invent a refactor branch for a necessary local implementation detail.

## 04 Keep one feature's evidence together

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
Do not modify files, Git, or external systems.
A stack adds a configurable deadline to an existing synchronous API.
The implementation is twelve lines in the existing function;
tests and a paragraph of docs make the complete change forty lines.
The author proposes four branches:
(1) add the timeout parameter to an internal helper
and prove its default preserves behavior,
(2) pass the parameter from the public API and test timeout errors,
(3) add the non-default timeout tests,
(4) document the option.
All four branches build and their tests pass;
each branch has a one-sentence purpose.
The senior reviewer prefers a branch per concern,
the names have been announced,
and the author wants to start review in ten minutes.
Choose the final branch plan
and explain what makes each retained branch worth a separate review.
Do not ask for more information.

### Expectations

- Combine this feature's implementation, tests, and necessary documentation.
- Require a material independent review decision to justify an extra branch.
- Do not split solely by file, implementation stage, or a branch-per-concern rule.

## 05 Order a protocol transition by compatibility

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
This is a read-only planning exercise:
do not change files, Git state, or external systems.
A service change has two proposed review branches.
The lower branch replaces the service's emitted audit record field
`actor` with `principal` and updates the emitter's contract tests.
The upper branch updates the separately deployed indexer
to consume `principal` and includes integration tests.
Each branch builds and its own tests pass;
the full stack passes integration.
The team has used module-based splits,
the two reviewers have already reserved time for those diffs,
and the release cutoff is in 20 minutes.
The user asks: "Settle the stack plan and the evidence needed before handoff."
Give a concise concrete choice, branch order, and validation scope.
Do not ask for more information;
make any necessary planning assumption explicit.

### Expectations

- Establish compatible consumer support before changing producer output.
- Account for separately deployed versions and retained old records.
- Permit additive or dual-format transitions supported by the stated contract;
  do not require a particular number of branches.
- Preserve release health if the stack stops after any merge.
- Do not rely on full-stack integration or close merge timing
  to repair a lower branch's runtime dependency on an upper branch.
