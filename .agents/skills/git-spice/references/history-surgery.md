# History Surgery

Use this reference for uncommon branch topology surgery, commit splitting, or
raw Git history surgery.

Topology surgery changes the stack graph.
Restacking preserves the existing stack graph
and should stay in the main `git-spice` skill.

This reference also defines the narrow raw-Git exception to the main skill.
Outside a raw history-surgery window, raw Git may not create or move branches
or create or amend commits.
It may not push or create pull requests.
The read-only `git branch --show-current` command remains permitted by the main
skill.
The separate GitHub-import exception is defined only in
`import-github-stacks.md`.

Prefer git-spice where it provides the operation:

- Use `git-spice branch onto` when the current branch should move to a
  different base:

  ```bash
  git-spice branch onto '<target>' --no-prompt
  git-spice ls --no-prompt
  ```

- Use `git-spice upstack onto` when the current branch and its upstack should
  move to a different base:

  ```bash
  git-spice upstack onto '<target>' --no-prompt
  git-spice ls --no-prompt
  ```

  These `onto` commands are stack surgery.
  They change the recorded base for existing work.
  Do not use them for ordinary restacking,
  where the desired topology is unchanged
  and branches only need to replay on recorded bases.
- Use `git-spice branch split` for branch-level splitting.
- Do not use `git-spice commit split` in an agent session.
  It invokes interactive hunk selection that `--no-prompt` cannot suppress.
- Use raw Git only for non-interactive commit-level surgery
  that git-spice does not expose.

Inside an approved raw history-surgery window, use the low-level Git tools the
operation requires.
These tools can include:

- `git reset`, `git checkout`, and `git switch`
- `git restore` and `git add`
- Replacement `git commit` commands

The normal repository-state and destructive-operation safeguards still apply.

## Move A Stack Onto A New Bottom-Most Branch

The main skill owns normal creation, `--insert`, and the preferred `--below`
workflow.
Use this alternative only when the new bottom-most branch is created separately
from trunk and the existing stack must move onto it:

```bash
git-spice branch checkout '<trunk>' --no-prompt
# make the bottom-most branch change
git add -- '<file>'
git-spice branch create '<new-bottom>' -m '<message>' --no-prompt
git-spice upstack onto '<new-bottom>' --branch '<old-bottom>' --no-prompt
git-spice ls --no-prompt
```

`git-spice branch create` requires the intended change to be staged.
Do not use an empty commit as a placeholder for this workflow.

This form is topology surgery because it changes the recorded base of
the existing stack.

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
git-spice branch split --at '<commit>:<new-branch-name>' --no-prompt
git-spice ls --no-prompt
```

To split at multiple commits,
resolve every split point and verify their ancestry first.
Pass multiple `--at` values from oldest commit to newest commit.
git-spice does not sort or validate their order:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split --no-prompt \
  --at '<lower-commit>:<final-lower-branch-name>' \
  --at '<higher-commit>:<final-higher-branch-name>'
git-spice ls --no-prompt
```

For example,
to split the previous commit into a prerequisite branch:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split --at HEAD^:abhinav/prerequisite-topic --no-prompt
git-spice ls --no-prompt
```

For a branch with commits `A`, `B`, and `C`,
where `C` is `HEAD`,
use multiple `--at` values when `A` should become the lower branch
and `B+C` should become the upper branch:

```bash
# mutating: request escalated filesystem privileges first
git-spice branch split --no-prompt \
  --at '<A-commit>:<final-lower-branch-name>' \
  --at '<C-commit>:<final-upper-branch-name>'
git-spice ls --no-prompt
```

If the original branch name is assigned to one of the lower splits,
provide a new branch name for the `HEAD` split too.

Before any branch split, inspect the stack for an associated pull request:

```bash
git-spice ls --no-prompt
```

An original branch with a pull request number must keep its name on the `HEAD`
split.
With prompts disabled, git-spice otherwise leaves the open change request on
whichever split retains the original name.
A request that assigns the original name to a lower partial branch requires an
explicit safe reassignment plan before topology mutation.

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
git-spice ls --no-prompt
git log --oneline --decorate -n 10
```

Do not start if unrelated worktree changes are present.
Preserve or stash unrelated user work before reshaping history.

Request escalated filesystem privileges before running mutating raw Git
history-surgery commands.
Use a short justification such as:
"Do you want to allow raw Git history surgery to rewrite commits?"

Create a unique backup ref before destructive history edits:

```bash
git update-ref 'refs/backup/<descriptive-name>' '<pre-surgery-commit>' ''
git show-ref --verify 'refs/backup/<descriptive-name>'
```

The empty old-value argument is the portable zero object ID.
Therefore, backup creation fails if that ref already exists.
Do not create a visible backup branch or retry by overwriting an existing
backup ref.

Raw Git may create replacement commits inside the surgery window.
Do not use raw `git commit` for ordinary new or follow-up work.
It also remains prohibited for fixups, amends, branches, pushes, and pull
request submission.

## Split the current commit

For splitting the current `HEAD` commit into replacement commits:

```bash
git reset --mixed HEAD^
git add -- '<first-partition>'
git commit -m '<first-message>'
git add -- '<second-partition>'
git commit -m '<second-message>'
git-spice ls --no-prompt
```

Keep raw `git commit` usage confined to replacement commits
created as part of the split.
Use full commit messages that satisfy
`writing-commit-messages.md`.

## Split a lower commit

Choose the complete editor-free sequence before splitting a lower commit.
For a linear branch, use the backup ref created above to retain the original
tail.
Reset the current branch to the target, split that commit, then replay the later
commits:

```bash
git reset --hard '<target-commit>'
git reset --mixed '<target-commit>^'
git add -- '<first-partition>'
git commit -m '<first-message>'
git add -- '<second-partition>'
git commit -m '<second-message>'
git cherry-pick --no-edit '<target-commit>..refs/backup/<descriptive-name>'
git-spice ls --no-prompt
```

If cherry-pick stops on a conflict, resolve and stage the files.
Then continue without an editor:

```bash
git -c core.editor=true cherry-pick --continue
```

Stop before mutation if the tail contains merges or another repository-specific
constraint makes this linear replay incorrect.

After the raw sequence:

```bash
git log --oneline --decorate -n 10
git-spice ls --no-prompt
```

If `git-spice ls` reports an upstack branch as `needs restack`,
treat that as informational.
Restack through git-spice only when the next task requires the branch to be
replayed on its recorded base:

```bash
git-spice upstack restack --no-prompt
git-spice ls --no-prompt
```

If git-spice stack tracking is missing or stale,
repair it with:

```bash
git-spice branch track --no-prompt
git-spice ls --no-prompt
```

After the surgery, return to git-spice.
Use it for amend, fixup, branch movement, push, submit, and pull request updates.

After the replacement commits, stack topology, and relevant behavior are
verified, delete the temporary backup ref unless the user requested retention:

```bash
git update-ref -d 'refs/backup/<descriptive-name>' '<pre-surgery-commit>'
git show-ref --verify 'refs/backup/<descriptive-name>'
```

The final `git show-ref` must fail because the temporary ref no longer exists.
