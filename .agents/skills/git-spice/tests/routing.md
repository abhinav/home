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
