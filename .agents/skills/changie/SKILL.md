---
name: changie
description: Use when deciding whether a repository change needs a changelog entry, creating or updating Changie unreleased entries, choosing the correct changelog kind, or writing user-facing changelog body text in repositories that use `.changie.yaml`.
---

# Changie

## Overview

Use this skill only if the repository has a `.changie.yaml` file.
If `.changie.yaml` is absent,
this skill does not apply.

This skill covers how to use `changie` directly,
choose the correct kind from `.changie.yaml`,
and write changelog body text.

## Decide whether a changelog entry is needed

Add a changelog entry when the change is user-facing.
Typical examples include:

- New features
- Changes to existing behavior
- Bug fixes with visible user impact
- Deprecations
- Removals
- Security fixes

Do not add a changelog entry for work
that has no user-facing effect.
Typical examples include:

- Internal refactors
- Test-only changes
- CI or tooling changes
- Code movement with no behavior change

## Create a new entry

Use `changie` directly by default:

```bash
changie new --kind $kind --body $body
```

Prefer generating the entry through Changie
instead of hand-writing the file.
That preserves the expected filename,
timestamp,
and directory layout.

## Choose the kind

Read the allowed kinds from `.changie.yaml`.
Common kinds include:

- `Added`
- `Changed`
- `Deprecated`
- `Removed`
- `Fixed`
- `Security`

Choose the kind based on the user-visible outcome,
not the implementation detail.

Examples:

- A new capability is usually `Added`.
- A behavior adjustment is usually `Changed`.
- A bug resolution is usually `Fixed`.
- A newly discouraged capability is usually `Deprecated`.
- A deleted capability is usually `Removed`.

If `.changie.yaml` defines custom kinds,
use those instead of generic assumptions.

## Write the body

The body should describe the user-facing effect.

- Write about the outcome,
  not the internal refactor.
- Keep the wording specific.
- Match any body expectations implied by `.changie.yaml`.

Good bodies usually answer:
"What changed for the user?"

Weak bodies usually describe only internal work,
for example:

- `refactor API client`
- `cleanup`
- `move code into helper`

Those are engineering notes,
not release notes.

## Troubleshooting

If `changie` is not found,
look for repository-specific wrappers before doing anything else.

Check:

- `mise.toml`
- `Makefile`

If either file defines a wrapper for running `changie`,
use that wrapper instead of assuming a global `changie` binary exists.
