# Workers And Worktrees

## Worker Dispatch

Before a fresh-context dispatch,
verify that the workstream `plan.md` can be executed without chat history.
Execution-critical context belongs in the plan, not only in the prompt.

Provide every worker or reviewer with:

- the stable workstream ID;
- the absolute project or worktree path;
- the absolute `plan.md` and `log.md` paths;
- applicable repository instruction paths;
- a concise instruction to execute or review the plan.

Give a worker temporary ownership of the log for its assignment.
Require the worker to maintain the plan-defined supporting record,
including its attempt entry,
and return a precise handoff.
When evidence changes an operative conclusion, decision, state, or next action,
require the worker to update the workstream plan before handoff.

Do not give a reviewer log ownership.
Require the reviewer to return findings to the root,
which appends the reviewer outcome after the review finishes.

Use `fork_turns: "none"` when the durable files contain the needed context.
Continue an existing healthy worker in its current workstream,
rather than replacing it for each revision.

For a standing workstream,
retain a worker across cycles only when the next cycle is near
and retaining ownership provides real value.
A waiting workstream does not require a live worker.

## Inactive Worker Checkpoint

Before closing a worker that is waiting for instructions:

1. Confirm that no command, review, assessment,
   or delegated attempt is in flight.
2. Bring the supporting record and attempt outcome current in `log.md`.
3. Update `plan.md` with authoritative conclusions,
   actual project state, and concrete next action.
4. Update the root board and mark the workstream unassigned.
5. Confirm that the durable files are sufficient for a fresh worker.
   Then close the worker.

## Worktree Assignment

Before assigning or reassigning a pooled worktree, inspect:

- the absolute path, branch, and current revision;
- tracked, staged, untracked, and relevant ignored state;
- merge, rebase, cherry-pick, bisect, or other Git operation state;
- prior and current worker ownership;
- background processes, servers, ports, or assessments still using it;
- generated files, caches, dependencies, or local configuration;
- whether any of that state could contaminate evidence;
- whether the workstream depends on uncommitted state outside the worktree;
- whether shared outputs or external systems make concurrent isolation unsafe.

Record the result in the root plan's Worktree Pool.
Do not erase unexplained state.

When a workstream finishes in a worktree,
default to a committed handoff on the worktree's branch.
An explicit user instruction or clear user preference overrides this default.
If work remains uncommitted, keep the worktree assigned.
Release it only after the root records and preserves that state.
