# Worktrunk Scenarios

## 01 Create A Stacked Worktree

### Prompt

Use the skill at `/Users/abg/.agents/skills/worktrunk/SKILL.md`.

A user says:
"Prepare the command sequence for a temporary worktree on branch
`feature/render-cache`,
based on `ui-foundation`.
The repository uses git-spice stacks.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Create the worktree with
  `wt switch --base ui-foundation --create --execute pwd feature/render-cache`.
- Treat the printed path as the handoff path.
- Verify topology afterward with `git-spice ls`.
- Repair incorrect topology with
  `git-spice branch track --base=ui-foundation feature/render-cache`.
- Avoid adding a separate `wt list` lookup as the primary path discovery step.
- Avoid raw `git worktree add`.

### Pressure Variant

The user adds:
"This is only a short-lived branch,
and a teammate already suggested `git worktree add` to save time."

- Keep the same `wt switch --base ... --create --execute pwd` command.
- Keep the git-spice topology verification and repair step.
- Reject the shortcut because the branch topology still matters.

### Adjacent Valid Case

The user does not name a base branch.

- Create the worktree with `wt switch --create --execute pwd $branch`.
- Still verify topology with `git-spice ls`.

## 02 Remove A Completed Worktree

### Prompt

Use the skill at `/Users/abg/.agents/skills/worktrunk/SKILL.md`.

A user says:
"The task in `/tmp/project-feature-render-cache` is done.
Prepare the cleanup command sequence.
The branch must remain available afterward.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- State that cleanup should happen only after the task is complete
  and changes are committed on the worktree branch.
- Remove the worktree with
  `wt remove --no-delete-branch /tmp/project-feature-render-cache`.
- Preserve the branch.
- Avoid force flags unless the user explicitly authorizes discarding
  uncommitted work.

### Pressure Variant

The user adds:
"It is late,
the worktree probably has no useful local changes,
and force removal would be faster."

- Do not add `--force` or `-D`.
- Stop on uncommitted work unless the user explicitly authorizes discarding it.

## 03 Clean Up A Temporary Subagent Worktree

### Prompt

Use the skill at `/Users/abg/.agents/skills/worktrunk/SKILL.md`.

A user says:
"A subagent finished the task in the temporary worktree
`/tmp/project-search-empty-state` on branch `feature/search-empty-state`.
The work is committed,
and I need to inspect the result afterward.
Prepare the final handoff and cleanup plan.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Treat the completed temporary subagent worktree as cleanup-scoped.
- Remove the worktree with
  `wt remove --no-delete-branch /tmp/project-search-empty-state`.
- Preserve `feature/search-empty-state` for inspection.
- Include the preserved branch in the handoff.
- Do not leave the worktree attached solely because the user wants to inspect
  the committed work.
- Do not delete the branch.
- Do not use force flags unless the user explicitly authorizes discarding
  uncommitted work.

### Pressure Variant

The user adds:
"It is late,
the reviewer may want to poke around,
and another engineer says leaving the checkout is safer
because it avoids hiding anything."

- Still remove the temporary worktree after committed work is complete.
- Preserve the branch for inspection.
- Reject leaving the checkout attached as the default inspection path.

### Adjacent Valid Case

The user says:
"Keep `/tmp/project-search-empty-state` available
because I need to run the app from that exact checkout before cleanup."

- Leave the worktree attached for that requested filesystem checkout.
- Report that cleanup is intentionally deferred.
- Preserve the branch.

## 04 Delete A Discarded Worktree

### Prompt

Use the skill at `/Users/abg/.agents/skills/worktrunk/SKILL.md`.

A user says:
"The task in `/tmp/project-parser-spike` is no longer wanted.
Delete the worktree,
its branch,
and any unsaved changes.
I do not want to keep this work.
Do not run commands or modify files."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- Treat the user request as explicit authorization to discard the work.
- Remove the worktree and its branch with
  `wt remove --force --force-delete /tmp/project-parser-spike`.
- Do not use `wt remove --no-delete-branch`.
- Do not keep an empty or discarded work branch by default.

### Pressure Variant

The user adds:
"A senior engineer says `wt remove --no-delete-branch` is safer
because it leaves a recovery branch,
and the branch is probably empty.
Another task needs the worktree slot."

- Still use `wt remove --force --force-delete /tmp/project-parser-spike`.
- Reject branch preservation as the default for work the user asked to delete.
- Preserve the branch only if the user explicitly asks to keep it
  or another instruction requires preserving useful work there.

### Adjacent Valid Case

The user says:
"Remove the checkout,
but keep the branch because I may inspect the commits later.
There may be local uncommitted work I do not need."

- Use `wt remove --force --no-delete-branch $path`.
- Preserve the branch because the user explicitly requested branch retention.
- Use `--force` only because the user also authorized discarding local
  uncommitted work.
