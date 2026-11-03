---
name: git-spice
description: >
  Use for Git commits, amendments, fixups, branch creation or movement,
  stacks, pushes, pull request creation or metadata, merges, review submission,
  publication, or recovery from raw Git. git-spice is mandatory for supported
  repository operations.
---

# git-spice

Use the full `git-spice` executable name, even when the user says `gs`,
for every supported operation in every Git repository.
It owns commits, branches, stack topology, trunk updates, restacking,
pushes, publication, pull requests, review submission, and merges.
Raw Git is permitted only where this skill or a loaded reference explicitly allows it.
Permissions include:

- Read-only inspection: `git status`, `git diff`, `git log`, `git show`,
  and `git branch --show-current`.
- Staging, conflict resolution, and file-level merge repair.
- The fetch configuration, remote-branch materialization, and upstream changes
  defined in [GitHub import](references/import-github-stacks.md).
- Unsupported low-level history operations under
  [History surgery](references/history-surgery.md),
  the only exception permitting replacement commits.

## Choose a noninteractive operation

Every git-spice command must include `--no-prompt` and finish without an editor
or invisible prompt.
Before mutation, settle the intended stack position and authoring input.
These forms match different states; they are not fallback commands.
If the user forbids a required operation, stop rather than substituting another mutation.
If the correct form is unclear, resolve that uncertainty before invoking git-spice.

| Operation | Required form |
| --- | --- |
| Create a branch and commit staged changes | `branch create` with a complete message through `-F -` and a single-quoted heredoc. |
| Create below current before the diff exists | `git-spice branch create --no-prompt --below --no-commit '<branch-name>'` |
| Current branch is trunk, not explicitly named as the target | Create and commit together; stop if branch creation is forbidden. Current-branch detection does not establish user intent. |
| Commit to a chosen non-trunk branch or explicitly named trunk | `commit create` with the complete message through `-F -` and a single-quoted heredoc. |
| Continue after resolved rebase conflicts | `git-spice rebase continue --no-prompt --no-edit` |
| Amend and retain the message | `git-spice commit amend --no-prompt --no-edit` |
| Amend with replacement text | `commit amend` with the complete replacement through `-F -` and a single-quoted heredoc. |

Message supply, `--no-commit`, and `--no-edit` are command requirements.

## Supply text literally

Load and apply `writing-commit-messages` before supplying any new or replacement
commit message.
Supply new or replacement text on literal standard input
with `-F -` and a single-quoted delimiter:

```bash
git-spice commit create --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
```

This preserves the message document's visible source layout and literal contents.
When needed, file input is available as `-F '<message-file>'`
or `--message-file '<message-file>'`.
Write the intended message directly, not encoded with shell escape sequences.
The shell parses the path; git-spice reads the file bytes literally.

Treat all external values as shell data, including user, service, repository,
and generated remote, branch, ref, commit, path, and PR selectors.
Prefer structured argument arrays when supported.
In shell commands, single-quote each value.
Represent an embedded apostrophe as in `'it'\''s'`.
Never interpolate external values into executable shell text.
Use this quoting for PR titles and bodies;
git-spice's title and body flags have no file-backed forms.

## Load the matching guidance before acting

| Work | Required guidance |
| --- | --- |
| Create, name, rename, track, or position branches; create, amend, or fix up commits | [Branch and commit workflows](references/branch-and-commit-workflows.md) |
| Restack or continue after conflicts | [Restacking and continuation](references/restacking-and-conflict-continuation.md) |
| Commit messages | `writing-commit-messages` |
| Draft, revise, review, create, or edit PR titles, descriptions, templates, or metadata | `writing-commit-messages` and [PR submission](references/pull-request-submission.md) |
| Update existing PR branches, push, or publish | [PR submission](references/pull-request-submission.md) |
| Merge pull requests | [PR merges](references/pull-request-merges.md) |
| Split commits or perform raw history surgery; use `branch onto`, `upstack onto`, `branch split`, or `branch fold` | [History surgery](references/history-surgery.md) |
| Plan multiple branches for one outcome or split work into review branches | [Designing stacks](references/designing-stacks.md) |
| Plan parallel implementation with worktrees and subagents, or assemble temporary development branches into review units | [Parallel development](references/parallel-development.md) |
| Recover from raw Git operations or stale metadata | [Recovery](references/recovery.md) |
| Import existing GitHub PR branches or stacks | [GitHub import](references/import-github-stacks.md) |
| Diagnose internal git-spice metadata | [Internals](references/internals.md) |

## Permissions and orientation

Request escalated filesystem privileges before every mutating git-spice command,
including changes to local refs or stack metadata.
Treat `git-spice ls` as mutating: auto-healing can write `refs/spice/data`.
A suitable justification is "Allow git-spice to update Git refs and stack metadata?"

Use raw Git inspection when needed.
`git branch --show-current` returns nothing for detached HEAD;
`git-spice branch current` does not exist.
Inspect stacks with:

```bash
git-spice ls --no-prompt
```

Run it first when tracked state may be stale after raw Git;
untracked imported branches follow the import tracking order instead.
Load Recovery if raw Git performed an operation owned by git-spice.

When updating repository trunk, including `main` or `master`, start with:

```bash
git-spice repo sync --no-prompt
```

Do not substitute raw fetches, including narrow fetches of trunk or remote refs.
After sync, use the recognized local trunk for `branch onto` or `upstack onto`;
these accept local branches, not `origin/main` or `origin/master`.
If sync fails for authentication or shared-metadata permissions,
stop and handle that failure rather than improvising a raw fetch.
