---
name: commit
description: >
  Use when drafting, revising, evaluating, reviewing, or applying a commit
  message; or when committing work, amending commits, creating fixup commits,
  creating branches as part of committing work, stacking work, inserting
  prerequisite work below the current branch, or recovering after raw Git
  commands. Do not use for general prose or code review that involves neither
  a commit message nor a commit operation.
---

# Commit work and messages

Commit operations and commit-message content have separate authorities.

Classify the task before acting and load every matching authority.

## Commit-message content

For drafting, revising, evaluating, reviewing,
or applying commit-message content, load and follow:

```text
../git-spice/references/writing-commit-messages.md
```

Load the commit-message reference before assessing existing content
or producing a draft or revision.
It owns message content and overrides generic or default commit-message guidance;
higher-priority system and user instructions still govern.

Message-only work does not load repository workflow merely because its artifact
is a commit message.

## Repository workflow

For committing, amending, creating a fixup or branch,
changing a stack, inserting prerequisite work,
or recovering from raw Git commands, load and follow:

```text
../git-spice/SKILL.md
```

The git-spice skill owns repository workflow and operational safety.
When an operation creates or changes a commit message,
load both authorities and apply each at its boundary.
