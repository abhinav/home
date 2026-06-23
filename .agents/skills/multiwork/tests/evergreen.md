# Multiwork Scenarios: Evergreen Workstreams

## 18 Evergreen Recurring Workstream

### Prompt

An existing Multiwork project needs evergreen workstream `007-release-scan`
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

- Keep the evergreen workstream under `evergreen/`
  while its ongoing outcome remains part of the coordination system.
- Create `evergreen/`
  only when at least one evergreen workstream exists.
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
  not a requirement of the evergreen-workstream contract.
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
