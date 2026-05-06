---
name: commit
description: Use when committing work, amending commits, creating fixup commits, creating branches as part of committing work, stacking work, inserting prerequisite work below the current branch, or recovering after raw Git commands. Load and follow the git-spice skill for the workflow.
---

# Commit Command

Use the `git-spice` skill to commit,
amend,
fix up,
branch,
or stack work exactly as described there.

For any commit,
branch-as-part-of-commit,
stacking,
or raw-Git-recovery task,
first load and follow:

```text
~/.agents/skills/git-spice/SKILL.md
```

That skill is the authoritative manual for:

- Creating commits
- Amending commits
- Creating fixup commits
- Creating or stacking branches
- Inserting work below the current branch
- Recovering from raw Git usage
- Applying the commit message reference

For commit message writing,
the canonical reference is:

```text
~/.agents/skills/git-spice/references/writing-commit-messages.md
```

Do not invent a separate commit workflow here.
Load `git-spice`,
then perform the commit operation exactly as that skill describes.
