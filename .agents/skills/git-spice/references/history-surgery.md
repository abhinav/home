# History Surgery

Use this reference only when the user explicitly asks for history surgery,
or when a task cannot be performed with git-spice topology commands.

This reference defines the narrow raw-Git exception to the main skill.
Outside the surgery window,
raw `git branch`,
raw `git commit`,
raw `git commit --amend`,
raw `git push`,
and `gh pr create` remain red-alert violations.

Prefer git-spice where it provides the operation:

- Use `git-spice branch split` for branch-level splitting.
  Agents always pass exact split points and branch names:

  ```bash
  git-spice branch split --at <commit>:<new-branch-name>
  ```

  The name after the colon is the exact final branch name,
  including any required user prefix.

  To split at multiple commits,
  pass multiple `--at` values:

  ```bash
  git-spice branch split \
    --at <lower-commit>:<final-lower-branch-name> \
    --at <higher-commit>:<final-higher-branch-name>
  ```

  Use `git-spice branch split --at` when taking a branch
  that already has commits
  and splitting it into multiple branches.
  Use `git-spice branch create --insert` only when adding a new branch
  to an existing stack,
  with or without staged changes.
- Use `git-spice commit split` for interactive hunk selection
  on the current commit.
- Use raw Git only for non-interactive commit-level surgery
  that git-spice does not expose.

## Safety gate

Before raw history surgery,
confirm the user asked for history surgery
or that the task cannot be performed with a git-spice topology command.

Then inspect state:

```bash
git status --short
git-spice ls
git log --oneline --decorate -n 10
```

Do not start if unrelated worktree changes are present.
Preserve or stash unrelated user work before reshaping history.

Request escalated filesystem privileges before running mutating raw Git
history-surgery commands.
Use a short justification such as:
"Do you want to allow raw Git history surgery to rewrite commits?"

Create a backup ref before destructive history edits.
This raw branch command is allowed only as a backup step inside the surgery
window:

```bash
git branch backup-before-history-surgery
```

Raw Git may create replacement commits inside the surgery window.
Do not use raw `git commit` for ordinary new work,
follow-up commits,
fixups,
amends,
branches,
pushes,
or pull request submission.

## Split the current commit

For splitting the current `HEAD` commit into replacement commits:

```bash
git reset --mixed HEAD^
git add <first-partition>
git commit -m '<first-message>'
git add <second-partition>
git commit -m '<second-message>'
git-spice ls
```

Keep raw `git commit` usage confined to replacement commits
created as part of the split.
Use full commit messages that satisfy
`~/.agents/skills/git-spice/references/writing-commit-messages.md`.

## Split a lower commit

For splitting a lower commit,
use the repository-appropriate raw Git rebase or reset sequence
to stop at that commit,
split it into replacement commits,
then continue the rebase.

After the raw sequence:

```bash
git log --oneline --decorate -n 10
git-spice ls
```

If `git-spice ls` reports an upstack branch as `needs restack`,
restack through git-spice:

```bash
git-spice upstack restack
git-spice ls
```

If git-spice stack tracking is missing or stale,
repair it with:

```bash
git-spice branch track
git-spice ls
```

After the surgery,
use git-spice again for amend,
fixup,
branch movement,
push,
submit,
and pull request updates.
