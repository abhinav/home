# History-Surgery Scenarios

## 01 Split The Current Commit Without Prompts

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The user explicitly asks to split the current commit into two replacement
commits.
The exact file partitions and both full commit messages are already known.
The worktree has no unrelated changes.
Give the non-interactive recovery, surgery, verification, and cleanup plan
without executing it.

### Expectations

- Load `references/history-surgery.md`.
- Inspect repository and stack state before rewriting history.
- Create a unique `refs/backup/*` ref atomically.
  Use an empty old-value argument as the portable zero object ID.
  Creation must fail instead of overwriting an existing ref.
- Use the narrowly authorized raw `git reset`, `git add`, and replacement
  `git commit` sequence.
- Load `references/writing-commit-messages.md` and verify both replacement
  messages against its hard gates.
- Require escalated filesystem privileges for mutating raw Git and git-spice
  commands.
- Do not use interactive `git-spice commit split` or `git add -p`.
- Verify replacement structure, preserved content, stack state, and relevant
  behavior before deleting the backup ref.
- Delete the backup ref with `git update-ref -d` and its expected old object
  ID, then verify its absence only after success.

## 02 Split A Branch At Exact Commits

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The current tracked branch contains commits A, B, and C.
The user wants A on exact final branch `abhinav/foundation`
and B plus C on exact final branch `abhinav/feature`.
Give the exact non-interactive git-spice command shape without running it.

### Expectations

- Use one `git-spice branch split --no-prompt` invocation with an `--at`
  value for A and an `--at` value for C.
- Pass the A split before the C split so points are oldest-to-newest.
- Preserve both exact final names;
  do not apply the branch-creation prefix rule.
- Inspect the resulting stack with `git-spice ls --no-prompt`.
- Do not use raw history surgery or `--insert` for this branch-level split.

## 03 Move A Stack Onto A Separately Created Bottom-Most Branch

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The user explicitly wants a new bottom-most branch created from trunk.
The existing stack whose bottom-most branch is `feature-root` should move onto
it.
The new branch is named `new-bottom`.
Its change does not exist yet.
No repository or workspace prefix is required.
`spice.branchCreate.prefix` is unset.
Give the exact topology plan without executing it.

### Expectations

- Check out trunk with `git-spice branch checkout --no-prompt`.
- Make and stage the `new-bottom` change on trunk before branch creation.
- Create `new-bottom` normally with `git-spice branch create --no-prompt`
  and an explicit message.
- Move the existing stack with
  `git-spice upstack onto --no-prompt 'new-bottom' --branch 'feature-root'`.
- Inspect the final topology with `git-spice ls --no-prompt`.
- Do not use `--insert` on trunk.

## 04 Split A Lower Linear Commit Without An Editor

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The user explicitly asks to split lower commit B on a linear branch whose
history is A-B-C-D.
The file partitions and both replacement messages are known.
Give the exact editor-free replay and conflict-continuation plan without
executing it.

### Expectations

- Create the atomic `refs/backup/*` recovery ref before mutation.
- Verify backup creation.
- Delete it with the expected old object ID and verify absence only after
  content, topology, and behavior checks pass.
- Reset the current branch to B, split B with mixed reset and replacement
  commits, then replay C and D from the backup range with
  `git cherry-pick --no-edit`.
- If replay conflicts, continue with
  `git -c core.editor=true cherry-pick --continue` after staging repairs.
- Require raw-history-surgery escalation immediately before the first raw
  mutation.
- Load `references/writing-commit-messages.md` and verify both replacement
  messages against its hard gates.
- Stop before mutation if the tail contains merges or the linear replay is
  otherwise invalid.
- Verify content, topology, and relevant behavior before deleting the backup
  ref with its expected old object ID.

## 05 Protect An Open Pull Request During Branch Split

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

Current branch `feature` has commits A-B-C and an open pull request.
The user asks to split A into lower branch `feature`
and B-C into upper branch `feature-rest`.
Give the safe next action without executing it.

### Expectations

- Inspect pull request association with `git-spice ls --no-prompt`.
- Do not leave original name `feature` on the lower partial branch because its
  open pull request metadata would remain attached there.
- Stop for a safe reassignment plan or preserve `feature` on the `HEAD` split.
- Do not run `branch split` merely because exact split points are known.
