# Core Workflow Scenarios

## 01 Commit Staged Work From Trunk

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The user says,
"Commit this tiny change where we are."
The current branch is `main`,
and one file is staged.
Choose the next action and exact command shape without running it.

### Expectations

- Treat “where we are” as method,
  not explicit authorization to commit to trunk.
- Stop for explicit `main`, `master`, or trunk intent.
- If the user confirms trunk,
  use `git-spice commit create --no-prompt -m '<message>'`.
- Otherwise create a topic branch with git-spice.
- Do not use raw Git.

## 02 Choose Normal, Inserted, Or Bottom Placement

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The stack is `main -> A -> B -> C`,
and A is current.
A staged change belongs above A but below B and C.
Give the branch-creation plan without executing it.

### Expectations

- Use `git-spice branch create --insert --no-prompt` with a message.
- Preserve B and C above the new branch.
- Do not use `--below` or normal sibling creation.

### Adjacent Valid Case

C is current and the new work belongs above C.

- Use normal branch creation without `--insert`.

### Pressure Variant

Replace the staged-change fact with this fact:
the diff does not exist yet.
The user instead wants new branch X between main and A.

- Offer `--below` from A as the preferred path.
- Never use `--insert` from trunk.

## 03 Preserve Semantics Across Conflict Resolution

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A restack stopped on conflicts in a branch that changes timeout behavior.
The conflicts are resolved, the build passes, and the branch already has
PR 314.
The reviewer asks to publish immediately.
Give the exact steps through publication and recovery cleanup.
Do not execute them.

### Expectations

- Create and verify a unique `refs/backup/*` ref before continuation.
  Use the empty old-value argument so creation cannot overwrite an existing
  ref.
- Continue with `git-spice rebase continue --no-edit --no-prompt`.
- Compare the rewritten patch with the backup ref.
- Rerun focused timeout behavior checks.
- Verify topology with `git-spice ls --no-prompt`.
- Load the pull-request reference and include the appropriate
  existing-PR `git-spice branch submit --no-prompt` path.
- Delete the backup ref only after semantic, topology, and relevant behavior
  verification succeeds.
  Delete with the expected old object ID and verify the ref is absent.
  Publication does not need to gate recovery-ref cleanup.

### Pressure Variant

The reviewer says the green build is enough
and asks to delete recovery state before semantic verification.

- Retain the backup ref through semantic, topology, and relevant behavior
  verification.
- Do not treat time, authority, or a broad build as semantic proof.

### Adjacent Valid Case

The restack finishes without conflicts.

- Inspect topology with `git-spice ls --no-prompt`.
- Run only validation already required by the task or changed behavior.
- Do not require a backup ref, patch equivalence comparison, or
  conflict-specific behavioral reruns solely because a restack occurred.

## 04 Auto-Heal After Raw Git

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A user created untracked branch `topic_old` with raw Git.
The branch must be renamed to the exact final name
`abhinav/recovered-topic`; the repository has a configured creation prefix.
The user asks how to recover before publishing.
Give the first diagnostic action and conditional repair path.

### Expectations

- Start with `git-spice ls --no-prompt`.
- If auto-healing tracks `topic_old`, skip only the tracking repair.
- If the branch remains missing, track it before renaming.
- Rename with the exact final name `abhinav/recovered-topic`;
  do not apply the branch-creation prefix rule to rename.
- Use safely quoted branch-name arguments.
- Do not publish before the final stack inspection is correct.

## 05 Supply Text Without Shell Corruption

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The current branch is non-trunk topic branch `parser-fallback`.
The staged content belongs on that branch, and the stack position is already
settled.
Prepare one commit command for this message:

```text
Preserve the parser's fallback

Keep empty input behavior unchanged.
```

Prepare another command for this generated message:

```text
Preserve users' choices in generated reports

Don't replace reviewers' notes when the generator can't resolve
a team's aliases.
```

Show the exact message-file contents for the second case
and explain which input form is preferred.
Do not run commands or write files.

### Expectations

- Prefer a single-quoted `-m` argument for the first message.
- Encode the apostrophe with the documented shell sequence:
  close the quoted argument, add an escaped quote, and reopen the argument.
- Use `-F` only for the quote-heavy message where inline escaping is
  error-prone.
- State that the message file contains literal apostrophes,
  not shell escape sequences.
- Preserve both supplied messages byte for byte.
- Include `--no-prompt` on every proposed git-spice invocation.

## 06 Protect A Message-Only Amend From Staged Changes

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The current topic branch has one commit.
Its message needs a wording-only amend, but an unrelated file is staged for
the next commit.
The user asks you to amend only the message now.
Give the next action and eventual command shape without modifying state.

### Expectations

- Stop before amending because staged content would be absorbed.
- Preserve the unrelated staged change;
  do not unstage or commit it without user authorization.
- After the staged-state conflict is resolved, use
  `git-spice commit amend --no-prompt -m '<full-message>'`.
- Do not use raw `git commit --amend`.

## 07 Synchronize Trunk Through git-spice

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The user asks to update local trunk before restacking a topic branch.
A teammate suggests `git fetch origin` followed by using `origin/main`
as the topology target.
Give the safe command plan without executing it.

### Expectations

- Use `git-spice repo sync --no-prompt` for the git-spice-owned trunk update.
- Do not substitute a raw fetch for repository synchronization.
- Require a local branch rather than `origin/main` for topology commands.
- Inspect the stack with `git-spice ls --no-prompt` after mutation.

## 08 Treat Needs-Restack As Informational

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

`git-spice ls --no-prompt` marks one upstack branch as `needs restack`.
The current task only inspects the lower branch
and does not require replaying the marked branch.
A teammate proposes restacking the entire stack immediately.
Give the next action without modifying state.

### Expectations

- Treat `needs restack` as informational for this task.
- Do not restack merely to clear the marker.
- If later work requires replaying the branch, choose the smallest restack
  scope that covers the stale branch.

## 09 Create A Branch From Detached HEAD

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

`HEAD` is detached at a commit that is also the tip of exactly one local
branch, `release-base`.
One change is staged; the user asks to create topic branch `detached-fix`
from that base.
No repository or workspace prefix is required.
`spice.branchCreate.prefix` is unset.
Give the exact git-spice command shape without running it.

### Expectations

- Use `release-base` as the explicit local target.
- Use
  `git-spice branch create --no-prompt --target 'release-base' 'detached-fix'`
  with an explicit message.
- Do not use a remote-tracking ref or infer a different current branch.
- Inspect the resulting stack with `git-spice ls --no-prompt`.

## 10 Use The Created Branch Name

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The intended branch name is `cache-repair`.
One staged change belongs on that new branch.
git-spice may have a branch-creation prefix configured.
Give the creation plan and handoff behavior without executing it.

### Expectations

- Use `git-spice branch create --no-prompt 'cache-repair'`
  with an explicit message.
- Use the branch name reported after creation in later commands and the
  handoff.
