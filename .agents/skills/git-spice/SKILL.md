---
name: git-spice
description: >
  Use when performing Git repository operations involving commits, amendments,
  fixups, branch creation or movement, stacked branches, pushes,
  pull request creation, metadata updates, merges, review submission,
  publishing, or recovery from raw Git usage.
  git-spice is mandatory for supported repository operations.
---

# git-spice

## Mandatory Workflow

This skill is the authoritative and mandatory workflow for:

- Commits, amendments, and fixups
- Branch creation or movement and stacked branches
- Pushes, pull request metadata, submission, or merging,
  review submission, and publishing
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
| Create a branch and commit staged changes | Use `-F -` with a single-quoted heredoc for the complete message |
| Create a branch below current, before the diff exists | `git-spice branch create --no-prompt --below --no-commit '<branch-name>'` |
| Current branch is trunk and the user did not name `main`, `master`, or trunk as the target | Create and commit in one command, using the form in `Supplying Commit Messages and Text Arguments`; stop if the user forbids branch creation |
| Commit staged changes to a non-trunk branch or explicitly named trunk | Use `-F -` with a single-quoted heredoc for the complete message |
| Continue a git-spice rebase after conflicts are resolved | `git-spice rebase continue --no-prompt --no-edit` |
| Amend the previous commit while keeping its message | `git-spice commit amend --no-prompt --no-edit` |
| Amend the previous commit with a new message | Use `-F -` with a single-quoted heredoc for the complete replacement |

Treat explicit message supply through `-F`,
`--no-commit`, and `--no-edit` as parts of the command contract,
not optional cleanup flags to remember later.
If you cannot choose the correct non-interactive form yet,
stop and resolve that uncertainty before invoking git-spice.

## Supplying Commit Messages and Text Arguments

For every newly supplied or replacement commit message,
pass the exact message on standard input with `-F -`
and a single-quoted heredoc delimiter:

```bash
git-spice commit create --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
```

A commit message is a document:
the heredoc keeps its source layout visible for review,
and the quoted delimiter passes its contents literally.
Load and apply `writing-commit-messages`
before invoking a command that supplies the visible message.

The file form is also available when needed:
`-F '<message-file>'` or `--message-file '<message-file>'`.
For file-backed messages,
write the exact commit message into the file.
Do not put shell escape sequences in the file contents;
the shell parses only the file-path argument,
and git-spice reads the message bytes literally.

For shell arguments other than commit-message input,
use single quotes for generated pull request titles and bodies.
A single-quoted shell argument preserves all input except an embedded single
quote.
Represent an embedded quote with this sequence:
close the argument, add an escaped quote, and reopen the argument.

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
- Merging pull requests and stacks

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

- Creating, naming, renaming, tracking, or positioning branches;
  creating, amending, or fixing up commits:
  `references/branch-and-commit-workflows.md`
- Restacking branches or continuing after rebase conflicts:
  `references/restacking-and-conflict-continuation.md`
- Commit messages:
  `writing-commit-messages`
- Pull request title or description drafting, revision, or review;
  pull request creation; PR templates; and metadata edits:
  `writing-commit-messages`
  and `references/pull-request-submission.md`
- Existing pull request branch updates, pushes, or publication:
  `references/pull-request-submission.md`
- Pull request merges:
  `references/pull-request-merges.md`
- Non-interactive commit splitting and other raw history surgery:
  `references/history-surgery.md`
- Branch topology surgery with `branch onto`, `upstack onto`, or `branch split`:
  `references/history-surgery.md`
- Planning more than one branch for one requested outcome,
  or splitting work into review branches:
  `references/designing-stacks.md`
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
- More than one branch is planned for one requested outcome,
  but the proposed review units have not been checked
  for self-containedness under `references/designing-stacks.md`.
- A topology-changing command such as `onto`, `--insert`, or `branch split`
  is being used for an ordinary restack or a different topology operation.
- A remote-tracking ref is being used where git-spice requires a local branch.
- A raw fetch is being used instead of `git-spice repo sync` for a
  git-spice-owned trunk update.
- A new pull request would be submitted without loading
  `references/pull-request-submission.md` and supplying the required metadata.
- A pull request merge plan has not established its operation groups,
  selectors, effective merge sets, and readiness mode under
  `references/pull-request-merges.md`.
- A commit or pull request message is being passed through unsafe shell
  quoting or command substitution.
- A mutating command would run without escalated filesystem privileges.
