# History surgery

Use for branch topology changes, commit splitting, or unsupported raw history operations.
Restacking preserves recorded bases and follows
[Restacking and continuation](restacking-and-conflict-continuation.md).
Normal creation, insertion, and preferred below-current placement follow
[Branch and commit workflows](branch-and-commit-workflows.md).

## Authority and recovery point

Before topology surgery, confirm either explicit user authorization to change
topology or assembly of task-owned, unpublished development branches into planned
review units for an authorized implementation task.
That plan does not authorize reshaping published or other-owned branches.
Request filesystem escalation before mutating git-spice commands.

Raw Git is limited to noninteractive commit-level surgery git-spice cannot perform.
Before using it, confirm the user requested low-level surgery or the task cannot
be performed with a git-spice command.
Normal repository-state and destructive-operation safeguards still apply.
Before either kind of surgery, inspect:

```bash
git status --short
git-spice ls --no-prompt
git log --oneline --decorate -n 10
```

Do not start with unrelated worktree changes; preserve or stash unrelated work first.
Request escalated filesystem privileges before mutating raw surgery commands,
for example: "Allow raw Git history surgery to rewrite commits?"
Create a unique recovery ref before destructive history edits:

```bash
git update-ref 'refs/backup/<descriptive-name>' '<pre-surgery-commit>' ''
git show-ref --verify 'refs/backup/<descriptive-name>'
```

The empty old-value is the portable zero object ID: creation fails on collision.
Never use a visible backup branch or overwrite an existing recovery ref.
An approved window may use required low-level `git reset`, `git checkout`, `git switch`,
`git restore`, `git add`, and replacement `git commit` commands.
Raw replacement commits are confined to the surgery, not ordinary new or follow-on
work, fixups, amends, branch workflows, pushes, or PR submission.
The separate import exception is defined in [GitHub import](import-github-stacks.md).

## Choose the topology operation

Prefer git-spice when it supplies the operation:

```bash
git-spice branch onto '<target>' --no-prompt   # current branch to a different base
git-spice ls --no-prompt

git-spice upstack onto '<target>' --no-prompt  # current branch and upstack
git-spice ls --no-prompt
```

These change recorded bases; never substitute them for an ordinary restack.
Use `branch split` for branch-level splitting and `branch fold` to combine with a base.
Do not use `git-spice commit split`:
`--no-prompt` cannot suppress its interactive hunk selection.

### Move onto a separately created bottom branch

Use only when the new bottom branch is separately created from trunk
and the existing stack must move onto it:

```bash
git-spice branch checkout '<trunk>' --no-prompt
# make the bottom-most branch change
git add -- '<file>'
git-spice branch create '<new-bottom>' --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice upstack onto '<new-bottom>' --branch '<old-bottom>' --no-prompt
git-spice ls --no-prompt
```

Stage the intended change; do not use an empty placeholder commit.

### Fold a branch into its base

Confirm the selected branch, base, and affected upstack first:

```bash
git-spice branch fold --branch '<branch>' --no-prompt
git-spice ls --no-prompt
```

Fold moves commits into the base, deletes the selected branch,
and retargets its children; it removes the boundary without squashing commits.
Inspect content and relationships before continuing.

### Split existing branch commits

Use explicit `--at` points and complete final names, including required prefixes.
Do not use `branch create --insert` to peel existing commits or rely on split prompts.
Inspect `git-spice ls --no-prompt` before splitting for associated PRs.
A branch with a PR number must retain its original name on the `HEAD` split:
without prompts, the PR stays with whichever split retains that name.
Putting that name on a lower partial branch needs an explicit safe reassignment
plan before mutation.

```bash
git-spice branch split --at '<commit>:<new-branch-name>' --no-prompt
git-spice ls --no-prompt
```

For multiple splits, resolve points and verify ancestry first;
pass them oldest to newest because git-spice neither sorts nor validates order.
For commits `A`, `B`, `C` (`HEAD`), split at `A` and `C` to produce `A` below `B+C`:

```bash
git-spice branch split --no-prompt \
  --at '<A-commit>:<final-lower-branch-name>' \
  --at '<C-commit>:<final-upper-branch-name>'
git-spice ls --no-prompt
```

If the original name goes to a lower split, also provide a new name for `HEAD`,
subject to the associated-PR safeguard above.

## Split the current commit

Use full messages satisfying `writing-commit-messages`:

```bash
git reset --mixed HEAD^
git add -- '<first-partition>'
git commit -F - <<'FIRST_COMMIT_MESSAGE'
component: State the first outcome

Explain the first replacement commit's durable context.
FIRST_COMMIT_MESSAGE
git add -- '<second-partition>'
git commit -F - <<'SECOND_COMMIT_MESSAGE'
component: State the second outcome

Explain the second replacement commit's durable context.
SECOND_COMMIT_MESSAGE
git-spice ls --no-prompt
```

## Split a lower commit

Choose the complete editor-free sequence before mutation.
For a linear branch, the recovery ref retains the original tail:

```bash
git reset --hard '<target-commit>'
git reset --mixed '<target-commit>^'
git add -- '<first-partition>'
git commit -F - <<'FIRST_COMMIT_MESSAGE'
component: State the first outcome

Explain the first replacement commit's durable context.
FIRST_COMMIT_MESSAGE
git add -- '<second-partition>'
git commit -F - <<'SECOND_COMMIT_MESSAGE'
component: State the second outcome

Explain the second replacement commit's durable context.
SECOND_COMMIT_MESSAGE
git cherry-pick --no-edit '<target-commit>..refs/backup/<descriptive-name>'
git-spice ls --no-prompt
```

Stop before mutation if the tail contains merges or repository constraints
make linear replay incorrect.
If cherry-picking conflicts, resolve and stage, then continue without an editor:

```bash
git -c core.editor=true cherry-pick --continue
```

## Verify and return to normal operation

```bash
git log --oneline --decorate -n 10
git-spice ls --no-prompt
```

Treat `needs restack` as informational; replay only when the next task needs it:

```bash
git-spice upstack restack --no-prompt
git-spice ls --no-prompt
```

If tracking is missing or stale:

```bash
git-spice branch track --no-prompt
git-spice ls --no-prompt
```

Return to git-spice for amend, fixup, movement, push, submit, and PR updates.
After replacement commits, topology, and relevant behavior are verified,
delete the recovery ref unless the user requested retention:

```bash
git update-ref -d 'refs/backup/<descriptive-name>' '<pre-surgery-commit>'
git show-ref --verify 'refs/backup/<descriptive-name>'
```

The final verification must fail because the ref no longer exists.
