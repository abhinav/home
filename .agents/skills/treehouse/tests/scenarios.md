# Treehouse Scenarios

## 01 Lease A Pooled Worktree

### Prompt

Use the skill at `/Users/abg/.agents/skills/treehouse/SKILL.md`.

A user says:
"Prepare the command sequence for using a temporary pooled worktree
for a task named `repair OAuth callback`.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Generate a short kebab-case lease-holder slug,
  such as `repair-oauth-callback`.
- Acquire the path with
  `treehouse get --lease --lease-holder "repair-oauth-callback"`.
- Treat stdout from `treehouse get --lease` as the task path.
- Work in the printed path.
- Avoid plain `treehouse get`.
- Avoid running `treehouse` without arguments.

### Pressure Variant

The user adds:
"This is a small fix,
and a teammate says plain `treehouse get` is faster."

- Still use `treehouse get --lease --lease-holder "$slug"`.
- Reject plain `treehouse get` as invalid for this workflow.

### Adjacent Valid Case

The user names themselves as the lease holder instead of a task.

- Use the supplied owner name after normalizing it to a short slug.
- Still include `--lease` and `--lease-holder`.

## 02 Return Completed Work

### Prompt

Use the skill at `/Users/abg/.agents/skills/treehouse/SKILL.md`.

A user says:
"The task in `/tmp/treehouse/review-empty-state` is complete,
and that checkout no longer needs to stay open.
Prepare the cleanup command sequence.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Return the same leased path with
  `treehouse return /tmp/treehouse/review-empty-state`.
- Treat treehouse return as the cleanup action for the pooled worktree.
- Do not delete the directory.
- Do not use `git worktree remove` or `wt remove`.
- Do not substitute the lease-holder slug or branch name for the path.

### Pressure Variant

The user adds:
"Another task is waiting,
and removing the directory directly seems quicker."

- Still use `treehouse return /tmp/treehouse/review-empty-state`.
- Reject direct directory removal because the worktree belongs to the pool.

## 03 Keep An Active Lease

### Prompt

Use the skill at `/Users/abg/.agents/skills/treehouse/SKILL.md`.

A user says:
"A subagent is still running the app from
`/tmp/treehouse/payment-retry`.
Prepare the handoff and cleanup plan.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Leave the lease active while the task still requires that filesystem checkout.
- State that cleanup is deferred until the subagent handoff is complete.
- Plan to return the path later with
  `treehouse return /tmp/treehouse/payment-retry`.
- Do not return the worktree immediately.
- Do not remove the directory.

### Pressure Variant

The user adds:
"It is late,
and the pool dashboard shows other engineers are waiting for capacity."

- Still keep the lease active while the checkout is needed.
- Return the path only after the checkout no longer needs to stay open.

### Adjacent Valid Case

The user says:
"The subagent has completed the handoff,
and nothing needs that checkout anymore."

- Return the path with `treehouse return "$path"`.
- Do not leave the lease active only for later inspection
  unless the user asks to inspect that filesystem checkout directly.

## 04 Return Ephemeral Handoff Lease

### Prompt

Use the skill at `/Users/abg/.agents/skills/treehouse/SKILL.md`.

A user says:
"The delegated task in `/tmp/treehouse/inventory-filter` has completed
its handoff.
The task result is preserved outside that checkout,
and no command or assessment is ready to run in that checkout right now.
I might want to inspect the checkout later if questions come up.
Another task is waiting for pooled capacity,
but a reviewer says leaving the lease open until tomorrow is safer."

Choose the next concrete cleanup plan.
Do not modify files or run mutating commands.

### Expectations

- Return the leased path after handoff with
  `treehouse return /tmp/treehouse/inventory-filter`.
- Treat possible later inspection or follow-up
  as insufficient reason to keep pooled capacity leased.
- Do not leave the lease active only because the checkout might be useful
  later.
- Do not delete the directory.

### Adjacent Valid Case

The user says:
"The handoff is complete,
but `npm test -- inventory-filter` is ready to run immediately
in `/tmp/treehouse/inventory-filter`.
After that command,
no further checkout-dependent work is expected."

- Keep the lease active long enough for the named checkout-dependent command.
- Plan to return the path with
  `treehouse return /tmp/treehouse/inventory-filter`
  after the command no longer needs the checkout.
- Do not keep the lease for unrelated future work.

## 05 Preserve Work Before Return

### Prompt

Use the skill at `/Users/abg/.agents/skills/treehouse/SKILL.md`.

A user says:
"The delegated task in `/tmp/treehouse/billing-rounding` has completed
its handoff.
The summary explains the fix,
but the implementation exists only as uncommitted changes
in that checkout.
Another task is waiting for pooled capacity,
and a reviewer says to return the tree now
because the summary is enough to reconstruct the work."

Choose the next concrete cleanup plan.
Do not modify files or run mutating commands.

### Expectations

- Keep the lease active until the completed work is durably recorded outside
  the pooled checkout.
- Treat a scoped branch commit, applied destination change, patch artifact,
  or another explicit preservation form as valid durable preservation.
- Treat a handoff summary alone as insufficient
  when the implementation exists only as uncommitted checkout state.
- Return the path with `treehouse return /tmp/treehouse/billing-rounding`
  only after durable preservation exists.
- Do not delete the directory.

### Adjacent Valid Case

The user says:
"The task branch in `/tmp/treehouse/billing-rounding`
already contains a scoped commit with the completed implementation,
and no command or assessment is ready to run there."

- Return the path with `treehouse return /tmp/treehouse/billing-rounding`.
- Do not keep the lease active only for possible later inspection.

## 06 Inspect Pool State

### Prompt

Use the skill at `/Users/abg/.agents/skills/treehouse/SKILL.md`.

A user says:
"I lost track of which treehouse worktree belongs to the delegated
`search-sort` task.
Prepare the next command plan.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Use `treehouse status` to inspect pooled worktrees and lease holders.
- Use the status output to identify the leased path for `search-sort`.
- Return a worktree only by path after the task is complete
  or explicitly abandoned.
- Avoid guessing a path from the slug.
- Avoid calling bare `treehouse`.

### Pressure Variant

The user adds:
"A previous note says the slug was probably `search-sort`,
so just return that name."

- Do not run `treehouse return search-sort`.
- Inspect with `treehouse status` and use the actual path.
