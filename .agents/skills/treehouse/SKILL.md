---
name: treehouse
description: >-
  Use when acquiring, using, inspecting, or returning temporary pooled
  Git worktrees with the `treehouse` CLI for isolated task work,
  delegated subagent work, or cleanup of leased treehouse worktree paths.
---

# Treehouse

Use `treehouse` to lease temporary pooled Git worktrees for isolated task work.
Keep the workflow small:
lease a pooled worktree with an informative holder name,
work only in the printed path,
finish or explicitly defer the assigned task,
then return the same path to the pool.

`treehouse` worktrees are pooled resources.
Do not delete the worktree directory when the task is done.
Return it to the pool so later tasks can reuse it.

## Sandbox Escalation

Request escalated filesystem privileges before every `treehouse` operation.
Pool inspection, lease creation,
and lease return can read or update shared pool state outside the task checkout.

Use a short justification such as:
"Allow treehouse to inspect and update pooled worktree state."

## Lease a worktree

Request a leased worktree and print its path:

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

Perform the assigned work in that worktree.
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

For completed delegated work,
return the leased path after handoff by default
when the result no longer depends on that filesystem checkout.
Before returning the path,
verify that completed work is durably recorded outside the pooled checkout,
such as in a commit on the task branch,
an applied destination change,
a patch artifact,
or another explicit preservation form suitable for the task.
A handoff summary by itself is not durable preservation
when the implementation exists only as uncommitted checkout state.
A possible later inspection or follow-up is not enough reason
to keep pooled capacity leased.
Leave the lease active only when a concrete checkout-dependent action
is ready to start immediately,
when the user asks to keep working in that path,
or when an environment-specific process must remain there.
After the checkout-dependent action or process no longer needs the path,
return the path before starting unrelated work.

For abandoned work,
return the path only after the user has authorized abandoning that task's
uncommitted or unsubmitted state.
Do not remove the directory with `rm -rf`,
`git worktree remove`,
or `wt remove`.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
