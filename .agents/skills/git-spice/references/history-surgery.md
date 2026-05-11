# History Surgery

Use this reference for uncommon branch topology surgery,
commit splitting,
or raw Git history surgery.

Topology surgery changes the stack graph.
Restacking preserves the existing stack graph
and should stay in the main `git-spice` skill.

This reference also defines the narrow raw-Git exception to the main skill.
Outside a raw history-surgery window,
raw `git branch`,
raw `git commit`,
raw `git commit --amend`,
raw `git push`,
and `gh pr create` remain red-alert violations.

Prefer git-spice where it provides the operation:

- Use `git-spice branch onto` when the current branch should move to a
  different base:

  ```bash
  git-spice branch onto <target>
  git-spice ls
  ```

- Use `git-spice upstack onto` when the current branch and its upstack should
  move to a different base:

  ```bash
  git-spice upstack onto <target>
  git-spice ls
  ```

  These `onto` commands are stack surgery.
  They change the recorded base for existing work.
  Do not use them for ordinary restacking,
  where the desired topology is unchanged
  and branches only need to replay on recorded bases.
- Use `git-spice branch split` for branch-level splitting.
- Use `git-spice commit split` for interactive hunk selection
  on the current commit.
- Use raw Git only for non-interactive commit-level surgery
  that git-spice does not expose.

## Split a branch

Use `git-spice branch split --at <commit>:<new-branch-name>`
when taking a branch that already has commits
and splitting it into multiple branches.
Do not use `git-spice branch create --insert`
to peel existing commits out of the current branch.

Agents always pass exact split points and branch names with `--at`.
Do not rely on the interactive split prompt.
The branch name after the colon is the exact final branch name,
including any required user prefix.

Split at one commit:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split --at <commit>:<new-branch-name>
git-spice ls
```

To split at multiple commits,
pass multiple `--at` values:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split \
  --at <lower-commit>:<final-lower-branch-name> \
  --at <higher-commit>:<final-higher-branch-name>
git-spice ls
```

For example,
to split the previous commit into a prerequisite branch:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split --at HEAD^:abhinav/prerequisite-topic
git-spice ls
```

For a branch with commits `A`, `B`, and `C`,
where `C` is `HEAD`,
use multiple `--at` values when `A` should become the lower branch
and `B+C` should become the upper branch:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split \
  --at <A-commit>:<final-lower-branch-name> \
  --at <C-commit>:<final-upper-branch-name>
git-spice ls
```

If the original branch name is assigned to one of the lower splits,
provide a new branch name for the `HEAD` split too.

## Safety gate

Before branch topology surgery,
confirm that the user asked to change stack topology,
such as moving work to a different base
or splitting an existing branch apart.
These git-spice commands are mutating,
so request escalated filesystem privileges before running them.

Before raw history surgery,
confirm the user asked for low-level history surgery
or that the task cannot be performed with a git-spice command.

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
treat that as informational.
Restack through git-spice only when the next task requires the branch to be
replayed on its recorded base:

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
