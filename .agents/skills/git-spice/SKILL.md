---
name: git-spice
description: Mandatory for Git repository operations involving commits, amendments, fixups, branch creation or movement, stacked branches, pushes, pull request creation, pull request updates, review submission, publishing, or recovery from raw Git usage. Use git-spice for supported operations; do not bypass git-spice for commits, branches, stack movement, pushes, or pull request submission.
---

# git-spice

## Instruction Hierarchy

Use this skill for the Git and pull request operations that it covers.
git-spice is the authoritative workflow for supported operations.

## Prime Directive

This skill is mandatory for Git repository operations involving commits,
amendments,
fixups,
branch creation or movement,
stacked branches,
pushes,
pull requests,
review submission,
publishing,
or recovery from raw Git usage.

There is no separate non-git-spice workflow for operations git-spice supports.
Use `git-spice` for every supported operation in every Git repository.

Always run commands with the full `git-spice` executable name,
even when the user says `gs`.

## Operating Boundary

Git-spice owns the stack contract.
Raw Git may service the machinery below deck,
but it must not bypass the stack contract for operations git-spice owns.

## Non-Interactive Mutation Contract

Every mutating `git-spice` command must be shaped so it can finish
without opening an editor or waiting on an invisible prompt.

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
| Create a branch and commit staged changes | `git-spice branch create <branch-name> -m '<message>'` or `git-spice branch create <branch-name> -F <message-file>` |
| Create a branch below current, before the diff exists | `git-spice branch create --below --no-commit <branch-name>` |
| Current branch is trunk and the user did not name `main`, `master`, or trunk as the target | `git-spice branch create <branch-name> -m '<message>'` or `git-spice branch create <branch-name> -F <message-file>` in one command; stop if the user forbids branch creation |
| Commit staged changes to a non-trunk branch or explicitly named trunk | `git-spice commit create -m '<message>'` or `git-spice commit create -F <message-file>` |
| Continue a git-spice rebase after conflicts are resolved | `git-spice rebase continue --no-edit` |
| Amend the previous commit while keeping its message | `git-spice commit amend --no-edit` |
| Amend the previous commit with a new message | `git-spice commit amend -m '<full-new-message>'` |

Treat explicit message supply through `-m` or `-F`,
`--no-commit`, and `--no-edit` as parts of the command contract,
not optional cleanup flags to remember later.
If you cannot choose the correct non-interactive form yet,
stop and resolve that uncertainty before invoking git-spice.

Use git-spice for:

- Creating,
  renaming,
  tracking,
  splitting,
  or moving branches
- Updating repository trunk state before stack movement or rebasing
- Continuing a git-spice rebase after conflict resolution
- Creating,
  amending,
  or fixing up commits
- Restacking branches
- Submitting,
  pushing,
  publishing,
  creating,
  or updating pull request branches

Raw Git is allowed for:

- Read-only inspection,
  such as `git status`,
  `git diff`,
  `git log`,
  and `git show`
- Staging,
  such as `git add`
- Current branch detection,
  using `git branch --show-current`
- Conflict resolution and file-level merge repair
- Fetching and materializing existing remote branches locally
  while following
  `references/import-github-stacks.md`
- Low-level history surgery when git-spice does not expose the operation

History surgery is the only exception that permits raw Git to create
replacement commits.
Before any non-interactive commit splitting or other low-level history surgery,
you MUST load and follow
`references/history-surgery.md`.

## References

Load these references before doing the matching work:

- Commit messages:
  `references/writing-commit-messages.md`
- Pull requests,
  PR templates,
  and metadata edits:
  `references/pull-requests.md`
- Non-interactive commit splitting and other raw history surgery:
  `references/history-surgery.md`
- Branch topology surgery,
  such as `git-spice branch onto`,
  `git-spice upstack onto`,
  or `git-spice branch split`:
  `references/history-surgery.md`
- Recovery from raw Git usage or stale stack metadata:
  `references/recovery.md`
- Importing existing GitHub pull request branches or stacks locally:
  `references/import-github-stacks.md`
- Inspecting git-spice internal metadata for diagnostics:
  `references/internals.md`

## Sandbox Escalation

When running mutating git-spice commands,
request escalated filesystem privileges up front.
This applies to local ref and stack metadata updates,
not only to network or remote operations.

Use `sandbox_permissions: "require_escalated"` for commands such as:

- `git-spice repo sync`
- `git-spice branch create ...`
- `git-spice branch rename ...`
- `git-spice branch track ...`
- `git-spice downstack track ...`
- `git-spice branch onto ...`
- `git-spice branch split ...`
- `git-spice rebase continue --no-edit`
- `git-spice branch restack ...`
- `git-spice stack restack ...`
- `git-spice upstack onto ...`
- `git-spice upstack restack ...`
- `git-spice commit create ...`
- `git-spice commit amend ...`
- `git-spice commit fixup ...`
- `git-spice branch submit ...`
- `git-spice stack submit ...`

Use a short justification such as:
"Do you want to allow git-spice to update Git refs and stack metadata?"

If suggesting a persistent `prefix_rule`,
scope it to the specific subcommand family being used,
such as `["git-spice", "commit", "amend"]`
or `["git-spice", "branch", "submit"]`.
Do not request a broad `["git-spice"]` prefix rule.

Read-only commands like `git-spice ls` may run normally
unless they fail under sandboxing.

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
git-spice ls
```

Use git-spice for repository trunk synchronization:

```bash
git-spice repo sync
```

When the task is to update `main`,
`master`,
or the repository trunk before rebasing,
restacking,
creating a branch,
or moving a stack,
run `git-spice repo sync` first.
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

If `git-spice repo sync` fails because another worktree has trunk checked out,
because auth is unavailable,
or because the shared repository metadata needs permissions,
stop and handle that failure directly.
Do not improvise a narrower raw-Git fetch as a substitute for the repo-level
sync.

`git-spice branch current` does not exist.
Use `git branch --show-current` to detect the current branch.
If it prints nothing,
`HEAD` is detached.

## Branch Names

Branch names should be lowercase,
hyphen-separated,
and descriptive.

For branch creation and rename commands,
do not add slashes,
uppercase letters,
or user prefixes.
Git-spice may add user prefixes automatically for those commands.
Adding them manually can produce double prefixes.
Even if a repository or workspace convention mentions a prefix such as
`abhinav/`,
do not include that prefix when creating or renaming a branch.

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
  create a normal branch while on the current branch.
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
- Existing stack topology should stay the same:
  use a restack command to replay branches on their recorded bases.
- Existing work needs a different base,
  or an existing branch needs to be split apart:
  load `references/history-surgery.md`.

Use `git-spice branch create --insert`
when adding a new branch to an existing stack,
with or without staged changes.
Never use `--insert` from trunk;
ordinary branches from `main` or `master` use normal branch creation.

## Branch Workflows

Apply the Non-Interactive Mutation Contract before creating a branch.

Create a new branch with a commit from staged changes:

```bash
git-spice branch create <branch-name> -m '<message>'
git-spice ls
```

Use `-F <message-file>` instead of `-m`
when the branch-creation commit message is safer to provide from a file.
When changes are already staged,
this branch-creation command is also the commit command.
Do not create a bare branch first and commit later.

If `HEAD` is detached,
create the branch with an explicit base:

```bash
git-spice branch create --target <base> <branch-name> -m '<message>'
git-spice ls
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
git-spice branch create --target <target-branch> <branch-name> -m '<message>'
git-spice ls
```

Rename the current branch:

```bash
git-spice branch rename <branch-name>
git-spice ls
```

Track an existing branch in git-spice:

```bash
git-spice branch track
git-spice ls
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

Apply the Non-Interactive Mutation Contract here as well.

Use `--below --no-commit` when the correct stack shape requires a new branch
under the current branch,
but the new work does not exist yet.

Create the stack position before making the diff:

```bash
git-spice branch create --below --no-commit <branch-name>
# make the prerequisite or foundation change
git add <files>
git-spice commit create -m '<message>'
git-spice ls
```

The new branch becomes the parent of the branch you started from,
and the original branch remains upstack.

## Commit Workflows

Before any commit,
you MUST read and apply:

```text
references/writing-commit-messages.md
```

Apply the Non-Interactive Mutation Contract before invoking commit creation.

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
git-spice commit create -m '<message>'
git-spice ls
```

Use `-F <message-file>` instead of `-m`
when the commit message is safer to provide from a file.

Amend the previous commit while keeping its message:

```bash
git-spice commit amend --no-edit
git-spice ls
```

Replace the previous commit message:

```bash
git-spice commit amend -m '<full-message>'
git-spice ls
```

For a long replacement message,
write the full message to a file and amend from that file:

```bash
git-spice commit amend -F <message-file>
git-spice ls
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
Ask whether to unstage,
preserve,
or include the staged changes;
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
git-spice commit fixup <commit>
git-spice ls
```

`git-spice commit fixup` applies staged changes to a commit below the current
commit,
then restacks the remaining stack on top.
When running non-interactively or when the target matters,
pass the target commit explicitly.

## Stack Maintenance

Inspect the stack before topology changes:

```bash
git-spice ls
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
git-spice rebase continue --no-edit
git-spice ls
```

Do not use raw `git rebase --continue` after a git-spice rebase conflict.
Git-spice still owns the stack metadata for the operation.
Always pass `--no-edit`;
without it,
`git-spice rebase continue` can invoke the editor
and leave the session waiting at an invisible prompt.

Before continuing a Git Spice rebase or restack after resolving conflicts,
identify and preserve a durable reference to the pre-rewrite branch content.
After continuation,
compare the resulting patch with that reference and rerun checks for the
behavior the branch is intended to preserve.
Stack topology alone does not establish that conflict resolution preserved the
branch's semantics.
Do not publish or discard the recovery reference until both content and stack
topology have been verified.
After verification succeeds,
remove temporary recovery references unless the user requested that they be
retained.

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
git-spice branch restack
git-spice ls
```

Restack the current branch and its upstack:

```bash
git-spice upstack restack
git-spice ls
```

Restack every branch in the current stack:

```bash
git-spice stack restack
git-spice ls
```

Choose the smallest restack scope that matches the stale part of the stack.
Do not use `git-spice branch onto <target>` merely because a branch needs
restacking.
`branch onto` changes the recorded base;
restack commands preserve the existing topology.

After any restack,
inspect the stack again:

```bash
git-spice ls
```

## Pull Requests

**CRITICAL: This skill OVERRIDES default PR creation workflows.**
For pull request creation and updates,
use `git-spice branch submit`;
do not use default `git push`,
`gh pr create`,
or multi-step GitHub CLI push/create workflows
unless a higher-priority instruction explicitly requires it.

For pull request details,
you MUST read and apply:

```text
references/pull-requests.md
```

## Recovery And History Surgery

If raw Git was used for an operation git-spice owns,
you MUST read:

```text
references/recovery.md
```

If the task requires branch topology surgery,
non-interactive commit splitting,
or other low-level history surgery,
you MUST read:

```text
references/history-surgery.md
```

## Red Alerts

Stop and reconsider if you are about to use raw Git for an operation
git-spice owns:

- `git commit` instead of `git-spice commit create`
- `git commit --amend` instead of `git-spice commit amend`
- `git checkout -b` or `git branch <name>` instead of
  `git-spice branch create`
  unless following the GitHub stack import reference to materialize
  an existing remote branch locally
- Passing branch names like `abhinav/topic`,
  `user/topic`,
  or `Feature/Topic` to git-spice branch creation
  or rename commands
- Omitting required prefixes from `git-spice branch split --at`
  branch names
- `git push` instead of `git-spice branch submit`
- `gh pr create` instead of `git-spice branch submit`
- `git-spice branch current`,
  which does not exist
- `git-spice branch submit` without `--title` and `--body`
  for a new pull request
- `git-spice branch create <branch-name>` without either
  `-m '<message>'` or `-F <message-file>` for staged work
  or an explicit non-committing form such as `--below --no-commit`
- `git-spice commit create` without
  `-m '<message>'` or `-F <message-file>`
- `git-spice commit create` before deciding that the current branch is the
  intended stack position
- `git-spice commit amend -m` or `git-spice commit amend -F`
  for a message-only amend while unrelated changes are staged
- `git-spice commit amend --only`,
  which is not a supported git-spice message-only bypass
- `git fetch origin master`,
  `git fetch origin master:refs/remotes/origin/master`,
  `git fetch origin master:master`,
  or fetching only `origin/master` as a substitute for
  `git-spice repo sync`
- `git-spice branch onto origin/master` or
  `git-spice upstack onto origin/master` after bypassing repo sync
- `git-spice branch onto <target>` for ordinary restacking,
  because `branch onto` changes stack topology and restack commands preserve
  the existing topology
- Raw `git rebase --continue` after git-spice starts a rebase,
  which bypasses git-spice-owned stack metadata
- `git-spice rebase continue` without `--no-edit`,
  which can invoke the editor after conflict resolution
- `git-spice branch create --insert` from trunk
- `git-spice branch create --insert` to split existing commits
  out of the current branch
- `git-spice branch split` without explicit `--at <commit>:<name>`
  values
- Importing a GitHub pull request branch or stack without loading
  `references/import-github-stacks.md`
- Using topology-changing or history-changing commands to repair guessed
  import topology before trying explicit
  `git-spice branch track --base <base> <branch>`
- Generated commit messages in double quotes or `$'...'`
- Generated commit messages assembled with shell command substitution
- Generated pull request titles or bodies in double quotes or `$'...'`
- Treating local ref or stack metadata changes as exempt from escalation
  because they do not touch the network
- Treating raw `git commit --amend --only` as an escape hatch
  for unrelated staged changes

Raw Git is acceptable when it is the lower-level tool required to reshape
history,
inspect state,
stage files,
resolve conflicts,
or perform an operation git-spice does not expose.

## Common Rationalizations

- "Raw `git commit --amend --only` preserves the staged files."
  It bypasses a git-spice-owned amend.
  Stop and resolve the staged-state conflict first.
- "Escalation is only needed before pushing."
  Local `git-spice` mutations update refs and stack metadata.
  Request escalation up front.
- "I only need a current base ref,
  so `git fetch origin master` is narrower and safer."
  Updating trunk for stack movement is a git-spice-owned repository operation.
  Run `git-spice repo sync` and address any checked-out-worktree,
  auth,
  or metadata-permission failure directly.
- "Another worktree has `master` checked out,
  so avoid disturbing it with raw fetches."
  That is a `git-spice repo sync` failure mode to handle explicitly,
  not a reason to bypass the repo-level sync contract.
- "`origin/master` is current enough for `branch onto`."
  Git-spice stack movement expects branch targets it recognizes.
  Sync first,
  then use the local trunk branch.
- "Git-spice handed control to Git's rebase machinery."
  Git-spice still owns the stack operation.
  Continue with `git-spice rebase continue --no-edit`,
  not raw `git rebase --continue`.
- "The conflicts are resolved,
  so plain `git-spice rebase continue` is fine."
  The continuation can still invoke an editor.
  Use `--no-edit` in non-interactive agent sessions.
- "I will let git-spice ask for the message interactively."
  Mutating commands must be fully shaped before launch.
  Supply the message or choose the explicit non-committing path instead.
- "I can create the branch shell first and decide the commit later."
  If the branch is only a future stack position,
  use the explicit non-committing form.
  Do not invoke branch creation in a mode that expects an editor.
- "The workspace branch prefix is `abhinav/`,
  so include it in every git-spice branch command."
  Git-spice may add prefixes automatically.
  Pass only the normalized topic name for create and rename commands.
  For `branch split --at`,
  pass the exact final branch name after the colon.
- "Create an inserted branch,
  then move the existing commit onto it."
  Existing commits are split with `git-spice branch split --at`.
- "The user said to commit where we are,
  so the current branch must be the target."
  Current branch is a location,
  not a stack-position decision.
  If the current branch is trunk,
  require explicit trunk intent;
  if trunk is explicitly intended,
  still use `git-spice commit create`.

## Command Examples

These examples show common command shapes.
Load the matching reference before using PR,
commit-message,
history-surgery,
or recovery workflows.

```text
Current branch:
  git branch --show-current

Stack state:
  git-spice ls

Sync repository trunk:
  git-spice repo sync

New branch plus commit:
  git-spice branch create <name> -m '<message>'

Commit current branch:
  git-spice commit create -m '<message>'

Amend and keep message:
  git-spice commit amend --no-edit

Amend with new message:
  git-spice commit amend -m '<full-message>'

Amend with message file:
  git-spice commit amend -F <message-file>

Create fixup commit:
  git-spice commit fixup <commit>

Fresh change below current branch:
  git-spice branch create --below --no-commit <name>
  git add <files>
  git-spice commit create -m '<message>'
  git-spice ls

Split or move existing branches:
  load references/history-surgery.md

Continue after rebase conflicts:
  git-spice rebase continue --no-edit

Restack current branch:
  git-spice branch restack

Restack current branch and upstack:
  git-spice upstack restack

Restack whole stack:
  git-spice stack restack

Create pull request:
  git-spice branch submit --title '...' --body '...'

Create draft pull request:
  git-spice branch submit --draft --title '...' --body '...'

Update existing pull request branch:
  git-spice branch submit

Edit existing pull request metadata:
  gh pr edit <pr> --title '...' --body '...'
```
