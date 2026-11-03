# Recovery

After raw Git performs an operation owned by git-spice, or tracked state is stale,
do not push, publish, or create a PR before integrating the branch into git-spice.
First allow auto-healing:

```bash
git-spice ls --no-prompt
```

If the stack is correct, no additional tracking repair is needed.
Continue only for missing or incorrect tracking, or a requested rename still outstanding;
auto-healing does not fulfill that rename.

For a raw-created branch:

1. Inspect with `git branch --show-current`.
2. Run `git-spice branch track --no-prompt`.
3. If normalization is needed, run
   `git-spice branch rename --no-prompt '<final-name>'`.
4. Inspect with `git-spice ls --no-prompt`.

For a raw-created or amended commit:

1. Inspect with `git log -1 --oneline` or `git show`.
2. Correct its message if needed.
3. Inspect with `git-spice ls --no-prompt`.

A message-only amend requires no staged changes unless content amendment
was explicitly requested too; follow [Branch and commit workflows](branch-and-commit-workflows.md)
when staged changes would block the amend.
