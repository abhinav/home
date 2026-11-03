---
name: treehouse
description: >-
  Use when acquiring, using, inspecting, or returning temporary pooled
  Git worktrees with the `treehouse` CLI for isolated task work,
  delegated subagent work, or cleanup of leased treehouse worktree paths.
---

# Treehouse

Lease temporary pooled Git worktrees with `treehouse` for isolated task work.
Work only in the printed path and return it under the conditions below.
Return pooled worktrees for reuse; do not delete their directories, including with
`rm -rf`, `git worktree remove`, or `wt remove`.

## Sandbox escalation

Request escalated filesystem privileges before every `treehouse` operation.
Pool inspection, lease creation,
and lease return can read or update shared pool state outside the task checkout.

Use a short justification such as:
"Allow treehouse to inspect and update pooled worktree state."

## Lease a worktree

```bash
treehouse get --lease --lease-holder "$slug"
```

Use a short kebab-case `$slug` that identifies the owner or task,
such as `fix-api-timeout` or `review-pr-1234`.
Treat the command's stdout as the worktree path for the task.

Always include `--lease` and `--lease-holder`.
Never run `treehouse` without arguments.
Never run `treehouse get` without `--lease`.

## Work in the leased path

Use the printed path as the task checkout:

```bash
cd "$path"
```

For delegated subagent work,
give the subagent the leased path as the task path
and keep the lease active until the subagent has completed its handoff.

Use `treehouse status` when you need to inspect the pool,
find which paths are leased,
or confirm who holds a lease:

```bash
treehouse status
```

## Return a worktree

Return the leased path only after the assigned task is complete,
or after the user explicitly asks to abandon the assigned work:

```bash
treehouse return "$path"
```

Use the same path printed by `treehouse get --lease`.
Do not substitute a branch name,
lease-holder slug,
or parent directory.

For completed delegated work, return after handoff by default
when the result no longer depends on the checkout.
Before returning the path, verify completed work is durably preserved outside
the pooled checkout: a commit on the task branch, an applied destination change,
a patch artifact, or another explicit form suitable for the task.
A handoff summary alone is insufficient when the implementation exists only
as uncommitted checkout state.

Possible later inspection or follow-up does not justify retaining pooled capacity.
Leave the lease active only when:

- a concrete checkout-dependent action is ready to start immediately;
- the user asks to keep working in that path; or
- an environment-specific process must remain there.

When the action or process no longer needs the path,
return it before starting unrelated work.
For abandoned work, return only after the user authorizes abandoning
that task's uncommitted or unsubmitted state.
