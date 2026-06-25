# Pull Request Scenarios

## 01 Preserve Metadata When Publication Is A Side Task

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A configuration-migration investigation is complete.
The branch has one commit and no open pull request.
The repository has no PR template.
The user asks for a terse chat handoff plus a draft PR as a final side task.

The commit is:

````text
Preserve cache namespaces during migration.

Version 2.3 dropped the tenant namespace during legacy migration.
For example, this source configuration:

```toml
[cache]
namespace = "tenant-blue"
```

could become:

```toml
[cache]
namespace = "default"
```

Import, startup migration, manual repair, and rollback recovery used the same
normalization path.
Route all four paths through `PreservedNamespace`.
Rollback recovery continues to restore entries in reverse write order.

A migration probe covered import, startup migration, and rollback recovery.
Manual repair is supported by code inspection only.
````

Produce the PR metadata,
exact proposed submit command,
and concise handoff without running commands.

### Expectations

- Treat PR metadata as distinct from the concise handoff.
- Copy the single-commit subject exactly.
- Preserve the complete commit body and its high-value structure.
- Do not invent replacement Summary, Problem, Behavior, or Validation sections.
- Use `git-spice branch submit --draft --no-prompt`
  with explicit title and body.

### Pressure Variant

A senior engineer says the commit already has the details
and the review window closes in ten minutes.

- Keep the handoff terse without shortening or regenerating the PR body.

### Adjacent Valid Case

The repository requires `Impact` and `Verification` headings.

- Preserve configuration blocks and paths.
  Also preserve guarantee, ordering, and evidence distinctions.

## 02 Submit A Whole Stack From Commit Metadata

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A three-branch stack has one polished commit per branch.
Each commit is ready to become that branch's PR metadata.
None of the branches has an open pull request.
Publish the whole stack as drafts without running the command.

### Expectations

- Use `git-spice stack submit --fill --draft --no-prompt`.
- Use `--fill` because each branch has exactly one commit intended as its pull
  request metadata.
- Do not use repeated branch submission or raw push commands.

### Pressure Variant

Replace the one-commit-per-branch fact:
branch B has two implementation commits whose messages are separate review
steps rather than one intended pull request body.

- Do not use `stack submit --fill` or `upstack submit --fill`.
- Prepare explicit metadata for each branch.
- Submit the branches from the bottom-most branch to the topmost branch so
  every remote base exists before its child is submitted.
- Submit each branch with
  `git-spice branch submit --branch '<branch>' --draft`
  plus explicit title and body.

## 03 Update An Existing Pull Request And Its Metadata

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The current branch already has PR 314.
The branch commits need updates.
After those changes, the PR title must be `Preserve cache namespace metadata`
and its body must be `Keep imported tenant namespaces intact.`
Give the exact operation order without running commands.

### Expectations

- Update the branch first with `git-spice branch submit --no-prompt`.
- Then use:

  ```bash
  gh pr edit '314' --title 'Preserve cache namespace metadata' \
    --body 'Keep imported tenant namespaces intact.'
  ```

- Do not use `gh pr create` or raw `git push`.

## 04 Detect An Existing Pull Request

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

Determine whether the current branch already has a pull request.
Give the exact inspection command and interpretation without running it.

### Expectations

- Use `git-spice ls --no-prompt`.
- Read the pull request number shown beside the branch name.
- Do not add `--cr-status` merely to detect pull request association.
