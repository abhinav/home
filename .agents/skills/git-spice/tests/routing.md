# Wrapper-Routing Scenarios

## 01 Route A Commit Request

### Prompt

Use the `commit` skill.

The user asks to commit a staged behavior change from `main`
but has not explicitly authorized committing to trunk.
The commit needs a new message.
Give the next action and identify every skill or reference that governs it.
Do not run commands.

### Expectations

- Route through the git-spice skill rather than using raw Git.
- Load `writing-commit-messages` before drafting the message.
- Stop for explicit trunk authorization or create a topic branch with
  git-spice.
- Do not treat the thin commit wrapper as the complete workflow.

## 02 Route A Pull Request Side Task

### Prompt

Use the `pull-request` skill.

The implementation task is complete.
As a side task, the user asks to publish a new draft PR from a branch with one
polished commit.
State which skills and references govern the operation and the required
submission shape.
Do not run commands.

### Expectations

- Route through the git-spice skill.
- Load `references/pull-request-submission.md` before generating metadata.
- Preserve the polished commit message as the default PR title and body.
- Use a git-spice branch submission with `--draft`, `--no-prompt`,
  `--title`, and `--body`.
- Do not use raw push or `gh pr create`.
## Route commit-message review without repository mutation

### Prompt

Available skills include:

- `writing-commit-messages` for commit-message content;
- `commit` as a shortcut for commit-message work and commit operations;
- `git-spice` for repository workflow; and
- prose guidance for general durable writing.

A user provides an existing commit title and body.
They ask you to evaluate its accuracy,
remove stale claims,
and return the complete revised message.
They do not ask you to amend a commit
or change repository, branch, or stack state.

Choose the skills and references to load.
Explain the responsibility of each selection.
Do not revise the message or run commands.

### Expectations

- Select `writing-commit-messages` because the artifact is a commit message.
- Treat `writing-commit-messages` as the authority for message content.
- The `commit` shortcut may also be selected,
  but it must not displace `writing-commit-messages`
  or cause `git-spice` to load when no repository operation is requested.
- Do not infer authority to mutate repository state.

### Pressure variant

The user adds:
"This is only copyediting.
Do not use any Git workflow."

- Keep `writing-commit-messages` selected.
- The `commit` shortcut remains optional.
- Preserve the distinction between commit-message content
  and Git repository workflow.
- Do not treat the absence of a Git operation
  as a reason to route the message through generic prose alone.

### Adjacent valid case

The user instead asks to evaluate and revise a release-note paragraph.
No commit message or repository operation is involved.

- Select the applicable prose guidance.
- Do not select `writing-commit-messages`, `commit`, or `git-spice`.

## Route a non-executed commit command

### Prompt

Use the `commit` skill.

The user asks for the exact non-interactive command that would commit staged
changes on an already chosen topic branch.
They explicitly say not to execute it.
The command must include a newly drafted message.

Give the command only.
Do not run it.

### Expectations

- Load the git-spice skill because the requested artifact is a commit command,
  even though execution is forbidden.
- Load `writing-commit-messages` because the command supplies a new message.
- Use `git-spice commit create --no-prompt -F -`
  with a single-quoted heredoc.
- Do not use raw Git or inline `-m`.
