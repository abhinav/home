# Workers

## Attempt Registration

After accepting assignment and workstream-file ownership,
the executor preregisters the delegated attempt in the owning log
before meaningful execution.
Record the objective, executor, relevant starting state,
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
and plan-directory-relative paths for files inside the Workboard
coordination tree.

After the executor accepts the assignment,
require it to report acceptance to root.
Root records the accepted executor and runtime assignment;
that update transfers temporary ownership of the workstream plan and log.
Require the executor to preregister before meaningful work,
maintain the plan-defined supporting record,
including its attempt entry,
and return a precise handoff.
When evidence changes an operative conclusion, decision, state, or next action,
require the worker to update the workstream plan before handoff.

For review tasks,
root assigns a reviewer directly after any current executor hands off.
The reviewer accepts ownership,
preregisters the review attempt,
keeps the plan and log current,
and hands both files back with the findings.
Assign any resulting repair to the executor that owns the repair outcome.

Use `fork_turns: "none"` when the durable files contain the needed context.
Continue an existing healthy worker in its current live assignment.
After checkpoint and release,
record the handoff and assign a replacement for later follow-up.

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
5. Update the workboard and mark the workstream unassigned.
6. Confirm that the durable files are sufficient for a fresh worker.
7. Release the worker using the runtime's supported lifecycle operation.
   If no release operation exists,
   leave the worker inactive after checkpointing and do not claim that its
   runtime capacity was freed.
