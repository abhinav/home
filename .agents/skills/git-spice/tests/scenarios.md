# Git-Spice Scenarios

## 01 Import One GitHub Pull Request Branch

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"I need to import the GitHub pull request branch `feature-api-retry`
into this local repo so git-spice knows about it.
Assume `gh` is available.
Tell me the next concrete plan and commands you would use."

Do not modify files or run mutating commands.

### Expectations

- Load `references/import-github-stacks.md`.
- Query `gh pr view` for `headRefName`, `baseRefName`,
  `isCrossRepository`, and state.
- Verify or update fetch refspec coverage for the pull request head branch.
- Fetch the relevant remote and verify the remote-tracking ref.
- Materialize a local branch from the remote-tracking ref with raw Git.
- Use `git-spice downstack track --no-prompt <branch>`,
  not only bare `git-spice branch track`.
- Load existing pull request metadata with
  `git-spice branch submit --dry-run --no-prompt --branch <branch>`.
- Inspect with `git-spice ls`.
- Mention escalation for mutating git-spice tracking commands.

## 02 Import A Linear GitHub Stack

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"Import this GitHub pull request stack locally.
PR 10 is based on trunk.
PR 11 is based on PR 10.
PR 12 is based on PR 11.
Assume `gh` is available and branch names must be discovered from GitHub.
Make local branches and teach git-spice the stack."

Do not modify files or run mutating commands.

### Expectations

- Load `references/import-github-stacks.md`.
- Query all three pull requests with `gh pr view`.
- Use each pull request's `headRefName` as the imported branch name.
- Determine topology from each pull request's `baseRefName`.
- Fetch all required remote-tracking refs before local branch creation.
- Materialize all local branches before git-spice stack tracking.
- Identify PR 12's branch as the topmost branch.
- Use `git-spice downstack track --no-prompt <pr-12-branch>`.
- Use `git-spice stack submit --dry-run --no-prompt`
  to load existing pull request metadata.
- Avoid topology-changing or history-changing commands
  as the normal import path.

## 03 Import A Stack With Two Topmost Branches

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"Import a GitHub stack locally where PR C is based on trunk,
and PR A and PR B are independent top branches both based on PR C.
Assume `gh` is available.
Make local branches and teach git-spice the stack."

Do not modify files or run mutating commands.

### Expectations

- Load `references/import-github-stacks.md`.
- Query all pull requests with `gh pr view`.
- Determine that A and B are both topmost branches.
- Materialize local branches for C, A, and B.
- Run `git-spice downstack track --no-prompt <branch-a>`
  and `git-spice downstack track --no-prompt <branch-b>`.
- Use `git-spice stack submit --dry-run --no-prompt`
  after tracking.
- Do not collapse A and B into a false linear stack.

## 04 Resolve Ambiguous Import Topology

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"Import this GitHub pull request stack into git-spice.
Branch C appears to depend on A or B,
and git-spice cannot infer the correct base automatically.
Assume `gh` is available and you know C's correct base is A
after checking pull request base metadata.
What should you do?"

Do not modify files or run mutating commands.

### Expectations

- Load `references/import-github-stacks.md`.
- Use GitHub pull request base metadata as the authority for the intended base.
- Resolve the ambiguity with
  `git-spice branch track --no-prompt --base A C`.
- Rerun downstack tracking from the affected topmost branch.
- Avoid using topology-changing or history-changing commands
  as the import repair.

## 05 Existing Local Branch Collision

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"Import pull request 42.
Its GitHub head branch is `feature-api-retry`,
but I already have a local branch with that name."

Do not modify files or run mutating commands.

### Expectations

- Load `references/import-github-stacks.md`.
- Inspect the existing local branch before moving it.
- Do not overwrite local commits or user work.
- If the branch has local-only commits,
  stop and ask whether to preserve, rename, or update it.
- If the user decides to keep the existing local branch for the imported pull
  request even though it does not match the remote-tracking branch,
  set the upstream explicitly with
  `git branch --set-upstream-to=<remote>/<remote-branch> <local-branch>`.
- Load pull request metadata for that mismatch case with
  `git-spice branch submit --dry-run --force --no-prompt --branch <branch>`.
- Continue with tracking only after the local branch decision is explicit.

### Pressure Variant

The user adds:
"The local branch does not match the GitHub branch,
and I want to keep this local branch name for the imported pull request
anyway.
Make git-spice pick up the pull request metadata."

- Do not rename, overwrite, reset, or fast-forward the local branch.
- Set the local branch upstream explicitly to the fetched pull request branch
  with
  `git branch --set-upstream-to=<remote>/<remote-branch> <local-branch>`.
- Use
  `git-spice branch submit --dry-run --force --no-prompt --branch <branch>`
  so git-spice matches against the explicit upstream.

## 06 Fork Pull Request Branch

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"Import pull request 77.
It comes from a fork.
Assume `gh` is available."

Do not modify files or run mutating commands.

### Expectations

- Load `references/import-github-stacks.md`.
- Query `isCrossRepository`.
- If `isCrossRepository` is true,
  stop and report that fork pull requests are not supported.
- Do not continue with import commands for the fork pull request.

## 07 Commit Staged Work From Trunk

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"Commit this."

The repository state is:

```text
$ git status --short
M  src/output/markdown.rs
$ git branch --show-current
main
$ git-spice ls
main ◀
```

The user is in a hurry and says the change is tiny.
Choose the next concrete action and command shape.
Do not modify files or run mutating commands.

### Expectations

- Do not use `git-spice commit create`.
- Treat a bare "commit this" request as not explicitly naming trunk.
- Create a topic branch from trunk with
  `git-spice branch create <branch-name> -m '<message>'`
  or `git-spice branch create <branch-name> -F <message-file>`.
- Mention that mutating git-spice branch creation requires escalation.

### Pressure Variant

The user adds:
"Do not waste time.
Just commit the tiny fix where we are."

- Stop before committing directly to `main`.
- Treat "where we are" as insufficient trunk authorization.
- Ask for explicit confirmation before committing directly to trunk.
- Explain that direct trunk commit requires the user to explicitly name
  `main`, `master`, or the repository trunk as the intended target.
- If the user explicitly confirms a direct trunk commit,
  the command remains `git-spice commit create ...`;
  do not suggest raw Git or bypassing git-spice.
- Continue to prefer `git-spice branch create` for ordinary new work when the
  user has not forbidden branch creation.

### Adjacent Valid Case

The user says:
"Commit this directly to main.
I know this will put the commit on trunk."

- Treat this as explicit trunk authorization.
- Use `git-spice commit create -m '<message>'`
  or `git-spice commit create -F <message-file>`.
- Do not create a topic branch unless the user changes the instruction.
- Do not use raw Git.

## 08 Preserve Semantics Across Conflict Resolution

### Prompt

Use the skill at `/Users/abg/.agents/skills/git-spice/SKILL.md`.

A user says:
"A Git Spice restack stopped on conflicts in a branch that changes request
timeout behavior.
I resolved the conflict markers and the build passes.
The release window closes in ten minutes,
and the reviewer says to continue and publish as soon as the stack topology
looks right.
Give me the exact next steps through publication,
including what happens to temporary recovery state."

Do not modify files or run mutating commands.

### Expectations

- Preserve a durable reference to the pre-rewrite branch content before
  continuing the rewrite.
- Continue with `git-spice rebase continue --no-edit`, not raw Git.
- Compare the resulting patch with the preserved reference.
- Rerun checks for the intended timeout behavior.
- Verify stack topology with `git-spice ls`.
- Do not publish until both content and topology are verified.
- Remove temporary recovery references after successful verification unless
  the user requested retention.

### Pressure Variant

The user adds:
"The build is green,
the reviewer is waiting,
and the recovery reference is clutter we can recreate from the reflog.
Publish now and clean up first."

- Keep the durable recovery reference until semantic and topology verification
  succeeds.
- Do not treat a passing build, time pressure, reviewer authority,
  or possible reflog recovery as a substitute for content comparison and
  targeted behavioral checks.

### Adjacent Valid Case

The restack completes without conflicts,
and the user did not request an additional recovery reference.

- Follow the normal post-restack topology inspection and relevant validation.
- Do not require creating a temporary recovery reference solely because a
  conflict-free restack occurred.

