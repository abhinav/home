# Parallel development

Schedule by source dependencies; choose the final stack by review outcomes.
When worktrees and subagents are available and authorized, prefer parallel work
whose workers need only an agreed contract, not unfinished sibling implementations.
A provider may be needed for integration and release but not to start its consumer.
Confirm shared declarations and observable behavior are settled enough for
independent implementation and tests.
If a worker needs source not yet present, or implementation must first resolve
the contract, complete that prerequisite before dependent work.
Do not add an abstraction solely to manufacture parallelism.

## Establish the development layout

Choose review units and one integration owner before dispatch.
Commit shared declarations, contract documentation, and useful fixtures before workers branch.
Give each worker a separate branch and managed worktree
using the repository's required manager.
Assign ownership of implementations, shared contract, and topology operations.
Sibling branches on a common base avoid rewriting active descendants;
worktrees isolate files, not shared refs or cross-branch git-spice operations.
Keep the common base stable while workers are active.
Coordinate contract changes with every affected worker before updating bases
and resuming independent work.

A temporary contract branch need not justify its own PR or the feature's complete
release readiness.
Keep development-only branch boundaries out of PR submission and merge;
identify where their contents belong in the final review stack.
Worker tests and test implementations show contract progress;
completion still requires real implementation integration.

## Assemble the review stack

After workers commit and hand off, one integration owner assembles review units.
Coordinate worktree release or checkout changes through the manager before rewriting
or deleting branches held by workers.
Use git-spice; load [History surgery](history-surgery.md) before moves or folds.

One valid composition, not a required topology:
`A` starts with a shared contract, `A-impl` adds the provider, and `B` adds the consumer.
An arrow means the branch on the right is based on the branch on the left;
braces mark siblings.

```text
Development: A -> {A-impl, B}
Integration: A -> A-impl -> B
Review:      A -> B
```

Move `B` onto `A-impl`, then fold `A-impl` into `A`:
`A` now contains contract and complete provider; `B` adds the consumer.
A shared prerequisite may remain its own review branch when it meets review criteria.

Before handoff or submission, verify real implementations together, inspect final diffs
against parents, and apply [Designing stacks](designing-stacks.md) review and release criteria.
Account for every worker's committed result and remove development-only boundaries
from the submitted stack.
