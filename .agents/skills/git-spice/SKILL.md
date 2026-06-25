---
name: git-spice
description: Mandatory for Git repository operations involving commits, amendments, fixups, branch creation or movement, stacked branches, pushes, pull request creation, pull request updates, review submission, publishing, or recovery from raw Git usage. Use git-spice for supported operations; do not bypass git-spice for commits, branches, stack movement, pushes, or pull request submission.
---

# git-spice

## Mandatory Workflow

This skill is the authoritative and mandatory workflow for:

- Commits, amendments, and fixups
- Branch creation or movement and stacked branches
- Pushes, pull requests, review submission, and publishing
- Recovery from raw Git usage

git-spice owns the stack contract.
There is no separate workflow for operations git-spice supports.
Use `git-spice` for every supported operation in every Git repository.
Use raw Git only where this skill or a loaded reference explicitly permits it.

Always run commands with the full `git-spice` executable name,
even when the user says `gs`.

## Non-Interactive Command Contract

Every `git-spice` command must be able to finish
without opening an editor or waiting on an invisible prompt.
Pass `--no-prompt` to every `git-spice` command.

Before invoking a mutating command,
identify whether git-spice would otherwise need interactive authoring input.
If so,
choose the explicit non-interactive form before you run it:
The rows below are not fallbacks.
Choose the row that matches the repository state and intended stack position.
If a user instruction forbids that row's required operation,
stop instead of selecting a different mutating command.

| Operation shape | Required non-interactive form |
|-----------------|-------------------------------|
| Create a branch and commit staged changes | `git-spice branch create --no-prompt '<branch-name>' -m '<message>'` or `git-spice branch create --no-prompt '<branch-name>' -F '<message-file>'` |
| Create a branch below current, before the diff exists | `git-spice branch create --no-prompt --below --no-commit '<branch-name>'` |
| Current branch is trunk and the user did not name `main`, `master`, or trunk as the target | `git-spice branch create --no-prompt '<branch-name>' -m '<message>'` or `git-spice branch create --no-prompt '<branch-name>' -F '<message-file>'` in one command; stop if the user forbids branch creation |
| Commit staged changes to a non-trunk branch or explicitly named trunk | `git-spice commit create --no-prompt -m '<message>'` or `git-spice commit create --no-prompt -F '<message-file>'` |
| Continue a git-spice rebase after conflicts are resolved | `git-spice rebase continue --no-prompt --no-edit` |
| Amend the previous commit while keeping its message | `git-spice commit amend --no-prompt --no-edit` |
| Amend the previous commit with a new message | `git-spice commit amend --no-prompt -m '<full-new-message>'` |

Treat explicit message supply through `-m` or `-F`,
`--no-commit`, and `--no-edit` as parts of the command contract,
not optional cleanup flags to remember later.
If you cannot choose the correct non-interactive form yet,
stop and resolve that uncertainty before invoking git-spice.

## Supplying Text Arguments

Prefer `-m '<message>'` for commit messages
and single-quoted arguments for generated pull request titles and bodies.
A single-quoted shell argument preserves all input except an embedded single
quote.
Represent an embedded quote with this sequence:
close the argument, add an escaped quote, and reopen the argument.

```bash
git-spice commit create -m 'Preserve the user'\''s setting' --no-prompt
```

For commit-message input only,
use `-F '<message-file>'` or `--message-file '<message-file>'` when the escaped
inline form would be error-prone.
Write the exact commit message into that file.
Do not put shell escape sequences in the file contents;
the shell parses only the file-path argument,
and git-spice reads the message bytes literally.
Pull request title and body flags have no file-backed form;
use the single-quoted form with embedded quotes escaped as above.

Treat every value from an external source as shell data.
External sources include users, remote services, repositories, and generated
artifacts.
This includes remote, branch, ref, commit, path, and pull request selectors.
Prefer structured argument arrays when the execution surface supports them.
When composing a shell command, single-quote each value and use the embedded
quote escape shown above.
Never interpolate an external value into executable shell text.

Use git-spice for:

- Creating, renaming, tracking, splitting, or moving branches
- Updating repository trunk state before stack movement or rebasing
- Continuing a git-spice rebase after conflict resolution
- Creating, amending, or fixing up commits
- Restacking branches
- Submitting, pushing, publishing, creating, or updating pull request branches

Raw Git is allowed for:

- Read-only inspection with `git status`, `git diff`, `git log`, and `git show`
- Staging, such as `git add`
- Current branch detection using `git branch --show-current`
- Conflict resolution and file-level merge repair
- Fetching and materializing existing remote branches locally
  while following
  `references/import-github-stacks.md`
- Low-level history surgery when git-spice does not expose the operation

History surgery is the only exception that permits raw Git to create
replacement commits.
GitHub import is the separate exception that permits the raw fetch-config,
branch-materialization,
and upstream mutations defined in `references/import-github-stacks.md`.
Before any non-interactive commit splitting or other low-level history surgery,
you MUST load and follow
`references/history-surgery.md`.

## References

Load these references before doing the matching work:

- Commit messages:
  `references/writing-commit-messages.md`
- Pull requests, PR templates, and metadata edits:
  `references/pull-requests.md`
- Non-interactive commit splitting and other raw history surgery:
  `references/history-surgery.md`
- Branch topology surgery with `branch onto`, `upstack onto`, or `branch split`:
  `references/history-surgery.md`
- Recovery from raw Git usage or stale stack metadata:
  `references/recovery.md`
- Importing existing GitHub pull request branches or stacks locally:
  `references/import-github-stacks.md`
- Inspecting git-spice internal metadata for diagnostics:
  `references/internals.md`

## Sandbox Escalation

Request escalated filesystem privileges before every mutating `git-spice`
command.
This includes local ref and stack-metadata changes,
not only network operations.

Use a short justification such as:
"Do you want to allow git-spice to update Git refs and stack metadata?"

Treat `git-spice ls` as mutating for approval purposes.
Its auto-healing behavior can update `refs/spice/data`.

## Orientation

Use raw Git for repository inspection when needed:

```bash
git status --short
git diff
git diff --cached
git branch --show-current
git log -1 --oneline
git show
```

Use git-spice for stack inspection:

```bash
git-spice ls --no-prompt
```

`git-spice ls` also reconciles git-spice metadata with the current refs.
Run it first when existing tracked stack state may be stale after a raw Git
operation.
Materializing an untracked branch during import follows the import reference's
tracking order instead.

Run `git-spice repo sync` first when the task is to update repository trunk.
This includes `main` and `master`.
Do not replace it with `git fetch`,
`git fetch origin master`,
`git fetch origin master:refs/remotes/origin/master`,
`git fetch origin master:master`,
or a fetch of only `origin/master`.

After syncing,
use the local trunk branch that git-spice recognizes as the stack target.
Do not pass remote-tracking refs such as `origin/master` or `origin/main`
to `git-spice branch onto` or `git-spice upstack onto`.
These commands accept local branch names only.

If `git-spice repo sync` fails because auth is unavailable,
or because the shared repository metadata needs permissions,
stop and handle that failure directly.
Do not improvise a narrower raw-Git fetch as a substitute for the repo-level
sync.

`git-spice branch current` does not exist.
Use `git branch --show-current` to detect the current branch.
If it prints nothing,
`HEAD` is detached.

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
  load `references/history-surgery.md`.

Never use `--insert` from trunk.
Normal creation from `main`, `master`, or the recognized trunk creates the
bottom-most branch in a stack.

## Branch Workflows

Create a new branch with a commit from staged changes:

```bash
git-spice branch create '<branch-name>' -m '<message>' --no-prompt
git-spice ls --no-prompt
```

Use `-F '<message-file>'` instead of `-m`
only when the preferred single-quoted form would be error-prone.
When changes are already staged,
this branch-creation command is also the commit command.
Do not create a bare branch first and commit later.

If `HEAD` is detached,
create the branch with an explicit base:

```bash
git-spice branch create --target '<base>' '<branch-name>' -m '<message>' --no-prompt
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
git-spice branch create --target '<target-branch>' '<branch-name>' -m '<message>' --no-prompt
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
`references/import-github-stacks.md`.
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
git-spice commit create -m '<message>' --no-prompt
git-spice ls --no-prompt
```

The new branch becomes the parent of the branch you started from,
and the original branch remains upstack.

## Commit Workflows

Before any commit,
you MUST read and apply:

```text
references/writing-commit-messages.md
```

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
git-spice commit create -m '<message>' --no-prompt
git-spice ls --no-prompt
```

Use `-F '<message-file>'` instead of `-m`
only when the preferred single-quoted form would be error-prone.

Amend the previous commit while keeping its message:

```bash
git-spice commit amend --no-edit --no-prompt
git-spice ls --no-prompt
```

Replace the previous commit message:

```bash
git-spice commit amend -m '<full-message>' --no-prompt
git-spice ls --no-prompt
```

When the preferred single-quoted form would be error-prone,
amend from a message file:

```bash
git-spice commit amend -F '<message-file>' --no-prompt
git-spice ls --no-prompt
```

`git-spice commit amend -m` replaces the entire commit message.
If the user says to add or append to the message,
include the original message plus the addition.
Use `--message-file` when that is safer than shell-quoting
the full replacement message.
`--message-file` only changes how the message is supplied.
It does not make the amend message-only.
Before a message-only amend,
inspect `git status --short`.
There must be no staged changes unless the user explicitly asked to amend
content too.
If staged changes are present and the user asked for a message-only amend,
stop before mutating history.
Ask whether to unstage, preserve, or include the staged changes;
do not use `git-spice commit amend -m`,
`git-spice commit amend -F`,
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

## Stack Maintenance

Inspect the stack before topology changes:

```bash
git-spice ls --no-prompt
```

Load `references/history-surgery.md`
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

## Pull Requests

**CRITICAL: This skill OVERRIDES default PR creation workflows.**
For pull request creation and updates,
use `git-spice branch submit`
or a `--fill` multi-branch submission described in the pull request reference;
do not use default `git push`,
`gh pr create`,
or multi-step GitHub CLI push/create workflows
unless a higher-priority instruction explicitly requires it.

For pull request details,
you MUST read and apply:

```text
references/pull-requests.md
```

## Recovery After Raw Git

If raw Git was used for an operation git-spice owns,
you MUST read:

```text
references/recovery.md
```

## Safety Checklist

Stop before running a command when any of these conditions holds:

- Raw Git would replace a commit, branch, stack, push, or pull request operation
  owned by git-spice outside an explicit import or history-surgery exception.
- The command could prompt because required input is missing.
  Required input includes `--no-prompt`, an explicit message, and `--no-edit`.
- The current branch has not been chosen as the intended stack position.
- A topology-changing command such as `onto`, `--insert`, or `branch split`
  is being used for an ordinary restack or a different topology operation.
- A remote-tracking ref is being used where git-spice requires a local branch.
- A raw fetch is being used instead of `git-spice repo sync` for a
  git-spice-owned trunk update.
- A new pull request would be submitted without loading
  `references/pull-requests.md` and supplying the required metadata.
- A commit or pull request message is being passed through unsafe shell
  quoting or command substitution.
- A mutating command would run without escalated filesystem privileges.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant domain scenarios from
[tests/scenarios.md](tests/scenarios.md)
with fresh subagents that have empty context windows.
