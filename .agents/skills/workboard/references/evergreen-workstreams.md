# Evergreen Workstreams

An evergreen workstream remains part of the durable coordination system
while it performs recurring bounded cycles.
It is not continuously executing,
and it does not require a worker while waiting.

## Cycle Contract

Add the following information to the workstream plan
in the sections that best fit the mission:

- cycle purpose and owned ongoing outcome;
- wake condition, cadence, deadline, and timezone when relevant;
- actual wake mechanism and its identifier when one exists;
- durable cursor, checkpoint, or input boundary;
- exact input scope and procedure for one cycle;
- evidence produced by a changed, unchanged, failed,
  or inconclusive cycle;
- action to take when a condition is met;
- next-wake calculation and missed-cycle handling;
- retry and recovery rules;
- stop, retirement, or completion condition when one exists.

The plan is authoritative for the current execution condition,
cursor, blockers, and next wake.
The workboard summarizes those values.
Advance a cursor only through inputs successfully assessed
under the cycle contract.
After a partial or failed cycle,
preserve a boundary that will not skip unassessed inputs.

## Workboard Example

```markdown
| ID | State / condition | Owner | Depends on | Runtime | Root next action / wake |
| --- | --- | --- | --- | --- | --- |
| `003-status-scan` | evergreen / waiting | unassigned | None | none | At `2026-06-08 09:00 America/Los_Angeles`, wake through automation `daily-status`; scan strictly after cursor `1842`. |
```

Keep the workstream under `evergreen/`
while its ongoing outcome remains part of the coordination system.
Create `evergreen/` only when at least one evergreen workstream exists.
Use `waiting`, `ready`, `running`, or `blocked`
as its execution condition.

## Log Additions

Use a cycle ledger or similarly clear structure.
For each cycle,
record material such as:

- scheduled and actual wake time;
- wake cause and mechanism;
- starting cursor or input boundary;
- inspected range, query, or source revision;
- observations, changes, and artifacts;
- condition or threshold assessment;
- action taken or explicit no-change result;
- ending cursor or checkpoint;
- errors, uncertainty, and recovery notes;
- next wake condition.

This cycle record supplements the delegated-attempt entry.
The attempt entry may summarize or reference the detailed cycle evidence.

## Dispatch And Sleep

Each independently dispatched cycle is a new delegated attempt.
Preregister it after the wake condition is satisfied and before dispatch.
The wake event alone is not an attempt.
Routine follow-up within one running cycle remains part of that attempt.

When a wake condition is satisfied:

1. Reconcile the plan and workboard with actual time and external state.
2. Set the execution condition to `ready`.
3. Preregister the bounded delegated cycle in the workstream log.
4. Dispatch the worker and set the condition to `running`.
5. Record evidence and outcome.
6. Promote the resulting cursor, condition, blockers,
   next action, and next wake into the plan and workboard.
7. Record a dated recovery checkpoint in the log.
8. Return the condition to `waiting`,
   or set it to `blocked` when recovery is required.
9. Release the inactive worker when retaining it has no near-term value
   or capacity is needed.

Do not hold a worker in a sleep loop to provide scheduling.
Workboard files record the contract and state;
the named external mechanism wakes the root.
