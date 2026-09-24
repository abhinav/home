# Restacking and conflict continuation

Inspect the stack before topology changes:

```bash
git-spice ls --no-prompt
```

Load `history-surgery.md`
before stack surgery,
including `git-spice branch onto`,
`git-spice upstack onto`,
or `git-spice branch split`.
Those commands change stack topology.
Do not use them for ordinary restacking.

After resolving rebase conflicts,
continue through git-spice without opening an editor:

```bash
git-spice rebase continue --no-edit --no-prompt
git-spice ls --no-prompt
```

Do not use raw `git rebase --continue` after a git-spice rebase conflict.
git-spice still owns the stack metadata for the operation.
Always pass `--no-edit`;
without it,
`git-spice rebase continue` can invoke the editor
and leave the session waiting at an invisible prompt.

Before continuing a git-spice rebase or restack after resolving conflicts,
preserve the pre-rewrite branch content under a unique
`refs/backup/<descriptive-name>` ref:

```bash
git update-ref 'refs/backup/<descriptive-name>' '<pre-rewrite-commit>' ''
git show-ref --verify 'refs/backup/<descriptive-name>'
```

Do not create a visible backup branch.
Do not overwrite an existing backup ref;
choose a new descriptive name instead.
The empty old-value argument is the portable zero object ID.
Therefore, creation fails when the ref already exists.
After continuation,
compare the resulting patch with that reference and rerun checks for the
behavior the branch is intended to preserve.
Stack topology alone does not establish that conflict resolution preserved the
branch's semantics.
Do not publish or discard the recovery reference until both content and stack
topology have been verified.
After verification succeeds,
delete the temporary ref unless the user requested that it be retained:

```bash
git update-ref -d 'refs/backup/<descriptive-name>' '<pre-rewrite-commit>'
git show-ref --verify 'refs/backup/<descriptive-name>'
```

The final `git show-ref` must fail because the temporary ref no longer exists.

Restack preserves the recorded stack topology.
Use restack commands when the current task requires branches to be replayed on
their recorded bases,
for example before work that depends on the up-to-date stack shape.
If `git-spice ls` reports `(needs restack)`,
that is informational.
Do not restack solely because the marker is present,
especially when trunk is moving quickly
and the current task does not require replaying the branch.

Restack the current branch:

```bash
git-spice branch restack --no-prompt
git-spice ls --no-prompt
```

Restack the current branch and its upstack:

```bash
git-spice upstack restack --no-prompt
git-spice ls --no-prompt
```

Restack every branch in the current stack:

```bash
git-spice stack restack --no-prompt
git-spice ls --no-prompt
```

Choose the smallest restack scope that matches the stale part of the stack.
Do not use `git-spice branch onto <target>` merely because a branch needs
restacking.
`branch onto` changes the recorded base;
restack commands preserve the existing topology.

After any restack,
inspect the stack again:

```bash
git-spice ls --no-prompt
```
