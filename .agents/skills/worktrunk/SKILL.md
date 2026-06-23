---
name: worktrunk
description: >-
  Use when creating or removing temporary Git worktrees with `wt`,
  especially for isolated task branches, subagent handoffs,
  and branches that should keep git-spice topology.
---

# Worktrunk

Use `wt` to manage temporary Git worktrees for isolated task branches.
Keep the workflow small:
create the worktree,
verify the branch topology,
work in the new path,
commit completed changes,
then remove the worktree with the branch disposition the task requires.
For delegated subagent work in a temporary worktree,
completed committed work is cleanup-scoped by default:
remove the worktree and preserve the branch for inspection,
unless the user explicitly asks to keep the worktree path available
or the task still requires that filesystem checkout.

## Create a worktree

Create a new branch worktree and print its path:

```bash
wt switch --create --execute pwd $branch
```

When the new branch should be based on a specific branch,
name that base explicitly:

```bash
wt switch --base $base --create --execute pwd $branch
```

Use `$branch` as the branch name for the temporary worktree.
Use `$base` as the branch that should sit immediately below `$branch`
in the git-spice stack.
Treat the path printed by `pwd` as the handoff path for the task.

## Verify git-spice topology

After creating the worktree,
always inspect the stack topology:

```bash
git-spice ls
```

If `$branch` is not tracked on the intended `$base`,
repair the topology with git-spice:

```bash
git-spice branch track --base=$base $branch
```

## Remove a worktree

Remove the worktree only after the task assigned to it is complete
and its changes are committed on the worktree branch,
or after the user explicitly asks to discard the assigned work.

For completed work,
keep the branch when deleting the worktree:

```bash
wt remove --no-delete-branch $path
```

When a subagent finishes assigned work in a temporary worktree,
include this removal in the handoff after the work is committed.
Preserve the branch so the main agent or user can inspect the commits.
Leave the worktree attached only when the user asks to inspect that path,
continue work there,
or keep an environment-specific checkout alive.

For discarded work,
delete the worktree and its branch together:

```bash
wt remove --force --force-delete $path
# --force-delete permits deleting the branch
# --force permits deleting untracked or uncommitted work
```

Use the worktree path for `$path`.
Treat requests to delete, discard, throw away, or clean up unsaved changes
as authorization to use `--force --force-delete`.
Do not preserve the branch in that case unless the user explicitly asks to keep
it or another instruction requires preserving useful work there.
In that case, `--force` may still be necessary to discard uncommitted work.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
