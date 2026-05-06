---
name: pull-request
description: Use when creating pull requests, updating pull request branches, pushing or publishing work for review, editing pull request metadata, or submitting stacked branches. Load and follow the git-spice skill for the workflow.
---

# Pull Request Command

Use the `git-spice` skill to create,
submit,
update,
or manage pull requests exactly as described there.

For any pull-request task,
first load and follow:

```text
~/.agents/skills/git-spice/SKILL.md
```

That skill is the authoritative manual for:

- Creating pull requests
- Creating draft pull requests
- Updating pull request branches
- Publishing or pushing work for review
- Submitting stacked branches
- Requesting reviewers
- Editing existing pull request title or body metadata
- Avoiding raw `git push` and `gh pr create`

Do not invent a separate pull-request workflow here.
Load `git-spice`,
then perform the pull-request operation exactly as that skill describes.
