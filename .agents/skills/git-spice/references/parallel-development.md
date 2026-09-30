# Parallel development

Use source dependencies to schedule implementation
and review outcomes to choose the final stack.
When worktrees and subagent execution are available and authorized,
prefer parallel work where each worker needs only an agreed shared contract,
not the other worker's unfinished implementation.
A provider can be required for integration and release
without being required to start implementing its consumer.

Confirm that the common declarations and observable behavior
are settled enough for each worker to implement and test its part independently.
If a worker needs source that does not yet exist,
or implementation must first resolve the contract,
complete that prerequisite before starting the dependent work.
Do not add a new abstraction solely to manufacture parallelism.

## Establish the development layout

Choose the intended review units and integration owner before dispatch.
Commit the shared declarations, contract documentation, and useful fixtures
before workers branch from them.
Give each worker a separate branch and managed worktree
through the repository's required worktree manager.
Assign ownership of each implementation, the shared contract,
and the operations that change stack topology.

A common base with sibling implementation branches
lets workers commit without rewriting an active descendant branch.
Separate worktrees isolate files;
they do not isolate shared refs or Git Spice operations on other branches.
Keep the common base stable while workers are active.
If the contract must change, coordinate that change with every affected worker
before updating their bases and resuming independent work.

A temporary contract branch need not justify a standalone PR
or establish the complete feature's release readiness.
Its purpose is to carry the shared starting point for development.
Keep temporary branch boundaries out of PR submission and merge;
identify where their contents will belong in the final review stack.
Worker tests and test implementations establish progress against the contract;
completion still requires integration with the real implementations.

## Assemble the review stack

After workers commit their results and hand off their branches,
one integration owner assembles the intended review units.
Coordinate worktree release or checkout changes through the worktree manager
before rewriting or deleting branches held by workers.
Use Git Spice for topology changes;
load [History surgery](history-surgery.md) before moving or folding branches.

For example, let `A` begin with the shared contract,
`A-impl` implement its provider, and `B` implement its consumer.
An arrow means that the branch on its right is based on the one on its left;
braces identify sibling branches.

```text
Development: A -> {A-impl, B}
Integration: A -> A-impl -> B
Review:      A -> B
```

Move `B` onto `A-impl`, then fold `A-impl` into `A`.
The resulting `A` contains the contract and complete provider;
`B` adds the consumer.
This is one valid composition, not a required topology for every task.
Keep a shared prerequisite as its own review branch
when it independently satisfies the review criteria.

Before handoff or submission, verify the integrated implementations together,
inspect each final diff against its parent,
and apply the review and release criteria from `designing-stacks.md`.
Account for every worker's committed result and remove development-only
branch boundaries from the submitted stack.
