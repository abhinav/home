# Workers

## Attempt Registration

The current writer preregisters each delegated attempt in the owning log
before dispatch.
Record the objective, worker or reviewer, relevant starting state,
expected result, expected evidence, and assessment method.
After the attempt,
append the outcome, evidence, conclusion, and concrete next action.
Record a dispatch failure as the outcome rather than deleting the entry.

If work started before registration,
record the known facts and mark the registration late.
Do not backdate or invent write-ahead state.

## Worker Dispatch

Before a fresh-context dispatch,
verify that the workstream `plan.md` can be executed without chat history.
Execution-critical context belongs in the plan, not only in the prompt.

Provide every worker or reviewer with:

- the stable workstream ID;
- the absolute project or worktree path;
- the `plan.md` and `log.md` paths;
- applicable repository instruction paths;
- a concise instruction to execute or review the plan.

The absolute paths are runtime handoff coordinates.
When the worker updates repository-local durable files,
it should continue using repository-root-relative paths for project files
and plan-directory-relative paths for files inside the Multiwork
coordination tree.

Give a worker temporary ownership of the workstream plan and log
for its assignment.
Require the worker to maintain the plan-defined supporting record,
including its attempt entry,
and return a precise handoff.
When evidence changes an operative conclusion, decision, state, or next action,
require the worker to update the workstream plan before handoff.

Do not give a reviewer log ownership.
Require the reviewer to return findings to the root,
which reconciles the outcome under the single-writer rule.
If no active worker owns the workstream files,
root appends the outcome.
If a worker still owns them,
root routes actionable findings through a preregistered review-response attempt
owned by that worker.
To use a replacement worker,
first checkpoint and complete the current ownership handoff;
root may preregister the replacement only after write authority returns.

Use `fork_turns: "none"` when the durable files contain the needed context.
Continue an existing healthy worker in its current workstream,
rather than replacing it for each revision.

For an evergreen workstream,
retain a worker across cycles only when the next cycle is near
and retaining ownership provides real value.
A waiting workstream does not require a live worker.

## Inactive Worker Checkpoint

Before closing a worker that is waiting for instructions:

1. Confirm that no command, review, assessment,
   or delegated attempt is in flight.
2. Have the assigned worker bring the supporting record and attempt outcome
   current in `log.md`,
   update `plan.md` with authoritative conclusions,
   actual project state, and concrete next action.
   Root does not edit those files concurrently.
3. Require a precise handoff.
   After handoff,
   write authority returns to root.
   The worker returns any assigned workspace still attached
   with its identity and quiescent observed state.
   Worker or runtime release does not release or remove that workspace.
4. Before unrelated work,
   root applies the workspace disposition procedure separately from worker release.
   Complete verified release or removal unless a named checkout-dependent action
   is ready to start now;
   scheduled future work holds no workspace lease.
5. Update the root board and mark the workstream unassigned.
6. Confirm that the durable files are sufficient for a fresh worker.
7. Release the worker using the runtime's supported lifecycle operation.
   If no release operation exists,
   leave the worker inactive after checkpointing and do not claim that its
   runtime capacity was freed.
