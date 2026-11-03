# Restacking and conflict continuation

Inspect the stack before topology changes:

```bash
git-spice ls --no-prompt
```

Load [History surgery](history-surgery.md) before `branch onto`, `upstack onto`,
`branch split`, or `branch fold`; these change topology and are not restack commands.
Restack replays recorded bases without changing topology.
Use it only when the task needs that replay, with the smallest scope matching stale branches.
`(needs restack)` is informational, not a reason to restack by itself,
especially with rapidly moving trunk.

```bash
git-spice branch restack --no-prompt   # current branch
git-spice upstack restack --no-prompt  # current branch and upstack
git-spice stack restack --no-prompt    # whole current stack
```

Choose one scope, then inspect with `git-spice ls --no-prompt` after restacking.
Do not substitute `branch onto`: it changes the recorded base.

## Continue resolved conflicts

Before continuing a rebase or restack, retain pre-rewrite content under a unique ref:

```bash
git update-ref 'refs/backup/<descriptive-name>' '<pre-rewrite-commit>' ''
git show-ref --verify 'refs/backup/<descriptive-name>'
```

Do not use a visible backup branch or overwrite an existing ref.
The empty old-value is the portable zero object ID, making creation fail on collision.
Continue through git-spice, which owns the metadata:

```bash
git-spice rebase continue --no-edit --no-prompt
git-spice ls --no-prompt
```

Never use raw `git rebase --continue` here.
`--no-edit` prevents an invisible editor prompt.
Compare the resulting patch with the backup and rerun checks of intended behavior;
topology alone does not establish semantic preservation.
Do not publish or discard the ref before content and topology are verified.
After verification, delete it unless the user requested retention:

```bash
git update-ref -d 'refs/backup/<descriptive-name>' '<pre-rewrite-commit>'
git show-ref --verify 'refs/backup/<descriptive-name>'
```

The final verification must fail because the ref no longer exists.
