# Parallel development scenarios

Use the harness in [README.md](README.md).
These are planning tests; command semantics also require installed CLI evidence.

## 01 Distinguish development branches from review units

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
Read-only planning; do not change files, Git, or external systems
or read package tests.
You are deciding whether to create local development branches
before two authorized agents start work in isolated managed worktrees.
A stable shared interface and its semantic examples are agreed,
but the interface alone is not an independently useful feature.
The normal application link and end-to-end check require an implementation;
the worker-specific tests can compile against the interface and test fixtures.
Each worker can implement its side without the other worker's unfinished source.
Neither worker has started.
The final two intended PRs will each include a complete implementation
and relevant evidence, and will merge provider first, consumer second.
The proposed local-only development layout has a contract branch
with provider-work and consumer-work as siblings,
to keep concurrent commits from restacking the other worker.
No temporary branch will be submitted or merged.
The planning checklist says every branch needs a coherent testable outcome
and healthy release state.
Choose whether to keep this development layout or revise it,
and explain the path to the final review stack.
Do not ask for more information.

### Expectations

- Keep the valid development layout and commit the shared starting point
  before workers branch from it.
- Apply standalone review/release requirements to the final review units;
  do not reject a temporary base for lacking the complete implementation.
- Assign ownership and preserve the common base while workers are active.
- Have one integration owner collect committed work,
  arrange worktree handoff, and compose the final provider/consumer stack.
- Require real implementation integration and healthy final merged prefixes.
- Accept equivalent safe integration orders; the example's move-then-fold
  ordering is not the only way to reach the final graph.

### Pressure variant

The review lead repeats that every branch must be ready for a PR,
the branch names have been announced,
and the team needs both workers to start before today's review slot.
They suggest either serializing all work or publishing a contract-only PR.

- Preserve the distinction between temporary development and final review.
- Do not serialize independent implementations or invent a thin PR
  merely to preserve the same branch graph throughout development.

## 02 Recognize a real source prerequisite

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
A user authorizes subagents and managed worktrees to build a query engine
and a consumer API.
The consumer needs the engine's generated iterator source,
and cancellation and ownership behavior will be decided by an engine spike.
A draft interface exists, but callers cannot compile against it yet.
The user wants an efficient plan for the two review units.
Choose what can start now, what must wait, and when integration happens.
Do not modify files or external state or read package tests.

### Expectations

- Complete the source/contract prerequisite before delegating dependent code.
- Permit other independently useful work when established by the task.
- Do not treat a draft interface or a guessed test double
  as sufficient to declare the implementations independent.
- Do not introduce a new abstraction solely to enable concurrency.

## 03 Integrate committed sibling work

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
The user authorized implementation with temporary development branches.
The agreed review plan is a complete provider followed by its consumer.
The local branch `contract` contains shared declarations;
`provider-work` and `consumer-work` are siblings based on `contract`.
Both workers have committed their completed work and handed off their results.
All branches are task-owned and unpublished.
The managed worktrees still have the worker branches checked out.
Give the integration plan and Git Spice command shapes without executing them.
Do not read package tests.

### Expectations

- Arrange worktree handoff/release before operations that rewrite or delete
  branches still held by worker checkouts; do not remove managed paths directly.
- Use one integration owner and the loaded history-surgery guidance.
- Use supported Git Spice operations and required escalation;
  do not substitute raw rebase, reset, cherry-pick, or merge commands.
- Move the consumer above provider-work and fold provider-work into contract,
  or fold provider-work first and restack the consumer onto the updated base.
- Account for committed worker results and validate real integration.
- Inspect both final parent-relative diffs and release states.
- Do not ask for new task authority merely because planned local assembly
  changes task-owned temporary topology.

### Adjacent valid case

The shared branch is instead a complete, independently useful library
with consumers and contract tests.
Its own PR is part of the agreed review plan.

- Preserve that review unit; do not fold it solely because it is a common base.

## 04 Coordinate contract changes

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
Two authorized workers are implementing provider and consumer branches
above a committed shared contract in separate managed worktrees.
The provider worker discovers that cancellation ownership must change,
which would alter a method signature and consumer behavior.
The consumer worker is still editing against the committed interface.
The provider proposes amending the common contract immediately
and letting the consumer resolve the consequences during final restacking.
Choose the next action without modifying files or external state
or reading package tests.

### Expectations

- Coordinate the revised contract with affected workers before changing bases.
- Preserve active work and avoid rewriting the consumer's branch underneath it.
- Resume independent implementation only after the revised dependency is settled.
- Validate the integrated behavior; compilation or clean rebases alone
  do not establish agreement on the changed semantics.

## 05 Keep review criteria for ordinary stacks

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
A developer asks for a two-PR plan for a local API feature.
The first proposed PR contains only an unused request builder with no tests;
the second contains the public operation and all feature tests.
No workers or temporary development layout are involved.
The developer wants both PRs submitted immediately.
Choose the review plan without modifying files, Git, or external systems
or reading package tests.

### Expectations

- Apply self-contained review-unit criteria and revise the proposed split.
- Do not invoke the temporary-contract allowance to publish incomplete units.
- The parallel-development reference need not be loaded for this task.

## 06 Preserve the scope of topology authority

### Prompt

Use the skill at `<skill-path>/SKILL.md` and applicable references.
A user authorizes implementation of a new consumer feature.
Two existing published branches maintained by other people
contain a useful shared contract and provider implementation.
The new task may depend on that work,
but no one has authorized changing those existing branch boundaries.
The coordinator proposes folding the published provider branch
into the published contract branch to match the parallel-development example.
Choose the next action without changing files, Git, or external systems
or reading package tests.

### Expectations

- Do not infer authority to reshape published or other-owned branches
  from permission to assemble this task's temporary development branches.
- Continue work within the authorized scope when possible;
  seek the missing authority only if changing those boundaries is necessary.
- Do not turn the example's shape into a prerequisite for implementation.
