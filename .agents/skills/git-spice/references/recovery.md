# Recovery

Use this reference when raw Git was used for an operation git-spice owns,
or when `git-spice ls` reports stale stack state.

Do not push,
publish,
or create a pull request until the branch is integrated into git-spice.

## Raw Git branch creation

If the user created a branch with raw Git:

1. Inspect the current branch with `git branch --show-current`.
2. Rename it if needed with `git-spice branch rename <branch-name>`.
3. Track it with `git-spice branch track`.
4. Inspect the stack with `git-spice ls`.

## Raw Git commit or amend

If the user created or amended a commit with raw Git:

1. Inspect the commit with `git log -1 --oneline`
   or `git show`.
2. Fix the commit message if needed with
   `git-spice commit amend -m '<full-message>'`.
3. Inspect the stack with `git-spice ls`.

For a message-only amend,
there must be no staged changes unless the user explicitly asked to amend
content too.
