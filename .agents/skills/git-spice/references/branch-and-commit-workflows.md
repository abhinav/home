# Branch and commit workflows

## Names and placement

Branch names should be lowercase, descriptive, and hyphen-separated.
Normalize a nonconforming user-provided name and inform the user.
Creation may add a configured prefix: use the reported name thereafter and in handoff.
Rename and the name after `branch split --at`'s colon require the complete final name,
including any required prefix; they do not add the creation prefix.
Import preserves existing names under [GitHub import](import-github-stacks.md).

Before planning multiple branches for one outcome or splitting review units,
read [Designing stacks](designing-stacks.md) and settle review and release boundaries.
Before creating or moving a branch, choose its stack position before choosing
`branch create` versus `commit create`.
An explicit target is a branch named in the user's request,
not a branch inferred from the current readout.

| Intended position | Operation |
| --- | --- |
| Independent work from trunk | Normal creation from trunk. Never `--insert` from trunk. |
| Follow-on work above current, with no upstack branch that should stay above it | Normal creation. |
| New work between current and an existing upstack | `branch create --insert`. |
| Prerequisite below current, before its diff exists | `branch create --below --no-commit`, then edit and commit there. This can create a new bottom-most branch. |
| Direct trunk work | Only when the user explicitly names `main`, `master`, or recognized trunk as the target. |
| Replay on recorded bases without topology changes | [Restacking](restacking-and-conflict-continuation.md). |
| Change a base, split existing commits into branches, or move a stack onto a separately created bottom | [History surgery](history-surgery.md). |

"Commit this", "do not make a branch", and "commit where we are" do not name trunk.
If such method instructions conflict with required topic-branch creation,
stop and ask for an explicit target rather than substituting detected branch identity.

## Create, rename, or track

With staged changes, create and commit together; do not create a bare branch first:

```bash
git-spice branch create '<branch-name>' --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

Use `--target` for a specific stack target or detached HEAD:

```bash
git-spice branch create --target '<base>' '<branch-name>' --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

For detached HEAD choose, in order: the user-named branch; a branch whose head
is the detached commit (inspect `git log -n1` decorations); otherwise local trunk,
usually `main` or `master`.

```bash
git-spice branch rename '<branch-name>' --no-prompt
git-spice ls --no-prompt

git-spice branch track --no-prompt
git-spice ls --no-prompt
```

If the branch exists only on GitHub or the task imports a PR branch or stack,
load [GitHub import](import-github-stacks.md): fetch and materialize heads,
track with `downstack track`, then load PR metadata by dry-run submit.

For prerequisite work, create its position before editing:

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

The original branch remains upstack of the new parent.

## Commit or amend

Load and apply `writing-commit-messages` before supplying new or replacement text.
Commit to the chosen current branch only after settling position and trunk permission.

```bash
git-spice commit create --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

Keep the previous message:

```bash
git-spice commit amend --no-edit --no-prompt
git-spice ls --no-prompt
```

Replace the whole message, including original text when asked to append:

```bash
git-spice commit amend --no-prompt -F - <<'COMMIT_MESSAGE'
component: State the outcome

Explain the durable context on intentionally wrapped physical lines.
COMMIT_MESSAGE
git-spice ls --no-prompt
```

`--message-file` changes input transport, not what gets amended.
Before a message-only amend, inspect `git status --short`.
No staged changes are permitted unless the user explicitly requested content changes too.
If staged changes exist for a message-only request,
stop and ask whether to unstage, preserve, or include them.
Neither message-input form bypasses the index; do not invent `commit amend --only`
or use raw `git commit --amend --only`.
This blockage is not history surgery.

Identify the intended commit below the current commit.
Use a branch name only when its tip is that commit.
Pass the target explicitly when noninteractive or when target identity matters;
git-spice applies staged changes there and restacks the remaining stack:

```bash
git-spice commit fixup '<commit>' --no-prompt
git-spice ls --no-prompt
```
