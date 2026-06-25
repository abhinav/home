# Recovery

Use this reference when raw Git was used for an operation git-spice owns,
or when `git-spice ls` reports stale stack state.

Do not push, publish, or create a pull request until the branch is integrated
into git-spice.

## Auto-Heal First

Run:

```bash
git-spice ls --no-prompt
```

`git-spice ls` reconciles git-spice metadata with current refs
and auto-heals recoverable stale state.
If the resulting stack is correct,
no additional repair is needed.
Continue below only when the branch is still missing or incorrectly tracked.
Auto-healing does not satisfy a separate requested branch rename.
If the tracked branch still has the wrong name,
continue with the rename step below.

## Raw Git branch creation

If the user created a branch with raw Git:

1. Inspect the current branch with `git branch --show-current`.
2. Track it with `git-spice branch track --no-prompt`.
3. If the name needs normalization, rename the now-tracked branch with
   `git-spice branch rename --no-prompt '<exact-final-name>'`.
4. Inspect the stack with `git-spice ls --no-prompt`.

## Raw Git commit or amend

If the user created or amended a commit with raw Git:

1. Inspect the commit with `git log -1 --oneline`
   or `git show`.
2. Fix the commit message if needed with
   `git-spice commit amend --no-prompt -m '<full-message>'`.
3. Inspect the stack with `git-spice ls --no-prompt`.

For a message-only amend,
there must be no staged changes unless the user explicitly asked to amend
content too.
