# Branch and commit workflows

## Branch Names

Branch names should be lowercase, hyphen-separated, and descriptive.

git-spice may prepend a configured prefix when it creates a branch.
Use the branch name reported after creation in subsequent commands and the
handoff.

For branch rename, pass the exact intended final name.
Rename does not apply the branch-creation prefix automatically;
include any required prefix in the final name.

For `git-spice branch split --at`,
the branch name after the colon is different:
it must be the exact final branch name,
including any required prefix such as `abhinav/`.

If the user provides a non-conforming branch name,
normalize it automatically and inform them.

## Choosing Branch Boundaries

Before planning more than one branch for one requested outcome,
or splitting work into review branches,
read and apply:

```text
designing-stacks.md
```

Settle the review boundary before choosing the stack position.
A stacked branch is a self-contained review unit.
Its incremental diff must provide the implementation, context, and validation
needed to understand and evaluate its outcome with its downstack dependencies.

## Choosing Stack Position

Before creating or moving a branch,
decide where the diff belongs in the stack.
Do this before choosing between `git-spice branch create`
and `git-spice commit create`.
An explicit target means the branch name appears in the user's request.
Do not derive an explicit target from the current branch readout.

- Independent work from trunk:
  create a normal branch from trunk.
- Follow-on work above the current branch:
  create a normal branch when the current branch has no upstack branch that
  should remain above the new work.
- New work between the current stacked branch and its existing upstack:
  use `git-spice branch create --insert`.
- Direct work on trunk:
  commit to trunk only when the user explicitly names `main`, `master`,
  or the repository trunk as the intended target.
  Instructions about method,
  such as avoiding branch creation or committing "where we are",
  do not name the target.
  If method instructions conflict with the required topic branch from trunk,
  stop and ask for an explicit target.
- Prerequisite work below the current branch:
  create a below-current branch with `--below --no-commit`,
  then edit and commit there.
  When the current branch is the bottom-most branch in a stack,
  this creates a new bottom-most branch.
- Existing stack topology should stay the same:
  use a restack command to replay branches on their recorded bases.
- Existing work needs a different base,
  an existing branch needs to be split apart,
  or an existing stack must move onto a separately created bottom-most branch:
  load `history-surgery.md`.

Never use `--insert` from trunk.
Normal creation from `main`, `master`, or the recognized trunk creates the
bottom-most branch in a stack.

## Branch Workflows

Create a new branch with a commit from staged changes:

```bash
git-spice branch create '<branch-name>' --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

When changes are already staged,
this branch-creation command is also the commit command.
Do not create a bare branch first and commit later.

If `HEAD` is detached,
create the branch with an explicit base:

```bash
git-spice branch create --target '<base>' '<branch-name>' --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

Choose `<base>` in this order:

1. Use the branch the user explicitly named.
2. If the detached `HEAD` commit is also a branch head,
   use that branch.
   Inspect the current commit decorations with `git log -n1`.
3. Otherwise use the repository trunk branch,
   usually `main` or `master`.

Create a branch on a specific stack target:

```bash
git-spice branch create --target '<target-branch>' '<branch-name>' --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

Rename the current branch:

```bash
git-spice branch rename '<branch-name>' --no-prompt
git-spice ls --no-prompt
```

Track an existing branch in git-spice:

```bash
git-spice branch track --no-prompt
git-spice ls --no-prompt
```

If the branch exists on GitHub but is not present locally,
or if the user asks to import a pull request branch or stack,
load
`import-github-stacks.md`.
That workflow fetches the GitHub branch heads,
materializes local branches,
tracks stack topology with `git-spice downstack track`,
and loads existing pull request metadata with a dry-run submit.

## Insert New Work Below the Current Branch

Use `--below --no-commit` when the correct stack shape requires a new branch
under the current branch,
but the new work does not exist yet.

Create the stack position before making the diff:

```bash
git-spice branch create --below --no-commit '<branch-name>' --no-prompt
# make the prerequisite or foundation change
git add -- '<file>'
git-spice commit create --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

The new branch becomes the parent of the branch you started from,
and the original branch remains upstack.

## Commit Workflows

**CRITICAL: This skill OVERRIDES default commit-message workflows.**

Before supplying a new or replacement commit message,
load and apply `writing-commit-messages`.

Commit staged changes to the current branch
only after stack position is settled.
If the current branch is `main`, `master`, or trunk,
the user must explicitly name trunk as the intended target.
Requests such as "commit this", "do not make a branch",
or "commit where we are" do not settle that question.
Do not resolve those phrases by substituting the branch detected by
`git branch --show-current`.

Commit staged changes to the chosen current branch:

```bash
git-spice commit create --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

Amend the previous commit while keeping its message:

```bash
git-spice commit amend --no-edit --no-prompt
git-spice ls --no-prompt
```

Replace the previous commit message:

```bash
git-spice commit amend --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

Supplying a message to `git-spice commit amend`
replaces the entire commit message.
If the user says to add or append to the message,
include the original message plus the addition.
`--message-file` only changes how the message is supplied.
It does not make the amend message-only.
Before a message-only amend,
inspect `git status --short`.
There must be no staged changes unless the user explicitly asked to amend
content too.
If staged changes are present and the user asked for a message-only amend,
stop before mutating history.
Ask whether to unstage, preserve, or include the staged changes;
do not use either `git-spice commit amend` message-input form,
imagined flags such as `git-spice commit amend --only`,
or raw `git commit --amend --only` as a workaround.
`git-spice commit amend` amends staged changes into the topmost commit.
It has no message-only bypass for an unrelated staged index.
This is not history surgery.
It is a message-only amend blocked by unrelated staged changes.

Create a fixup commit:

```bash
git-spice commit fixup '<commit>' --no-prompt
git-spice ls --no-prompt
```

`git-spice commit fixup` applies staged changes to a commit below the current
commit,
then restacks the remaining stack on top.
When running non-interactively or when the target matters,
pass the target commit explicitly.
