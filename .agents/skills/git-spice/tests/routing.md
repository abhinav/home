# Wrapper-Routing Scenarios

## 01 Route A Commit Request

### Prompt

Use the commit skill at `<skills-root>/commit/SKILL.md`.

The user asks to commit a staged behavior change from `main`
but has not explicitly authorized committing to trunk.
The commit needs a new message.
Give the next action and identify every skill or reference that governs it.
Do not run commands.

### Expectations

- Route through the git-spice skill rather than using raw Git.
- Load the commit-message reference before drafting the message.
- Stop for explicit trunk authorization or create a topic branch with
  git-spice.
- Do not treat the thin commit wrapper as the complete workflow.

## 02 Route A Pull Request Side Task

### Prompt

Use the pull-request skill at `<skills-root>/pull-request/SKILL.md`.

The implementation task is complete.
As a side task, the user asks to publish a new draft PR from a branch with one
polished commit.
State which skills and references govern the operation and the required
submission shape.
Do not run commands.

### Expectations

- Route through the git-spice skill.
- Load `references/pull-requests.md` before generating metadata.
- Preserve the polished commit message as the default PR title and body.
- Use a git-spice branch submission with `--draft`, `--no-prompt`,
  `--title`, and `--body`.
- Do not use raw push or `gh pr create`.
## Route commit-message review without repository mutation

### Prompt

Available skills include:

- `commit` for commit-message content and commit operations;
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

- Select the `commit` skill because the artifact is a commit message.
- Load the commit-message reference before evaluating or revising the message.
- Treat the reference as the authority for message content.
- Do not load `git-spice` solely because the artifact is commit-related;
  no repository operation is requested.
- Do not infer authority to mutate repository state.

### Pressure variant

The user adds:
"This is only copyediting.
Do not use any Git workflow."

- Keep the `commit` skill and its message reference selected.
- Preserve the distinction between commit-message content
  and Git repository workflow.
- Do not treat the absence of a Git operation
  as a reason to route the message through generic prose alone.

### Adjacent valid case

The user instead asks to evaluate and revise a release-note paragraph.
No commit message or repository operation is involved.

- Select the applicable prose guidance.
- Do not select the `commit` or `git-spice` skill.

## Route a non-executed commit command

### Prompt

Use the commit skill at `<skills-root>/commit/SKILL.md`.

The user asks for the exact non-interactive command that would commit staged
changes on an already chosen topic branch.
They explicitly say not to execute it.
The command must include a newly drafted message.

Give the command only.
Do not run it.

### Expectations

- Load the git-spice skill because the requested artifact is a commit command,
  even though execution is forbidden.
- Load the commit-message reference because the command supplies a new message.
- Use `git-spice commit create --no-prompt -F -`
  with a single-quoted heredoc.
- Do not use raw Git or inline `-m`.
