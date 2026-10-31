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

## Decide what to record

Release notes describe what changes for users since the previous release,
not each development step toward that release.
Choose the changelog action from that released baseline
and the pending entries' coverage of the final outcome.

1. Determine whether the change has a user-facing effect.
   Features, behavior changes, visible bug fixes, deprecations, removals,
   and security fixes need coverage.
   Internal refactors, test-only changes, CI or tooling changes,
   and code movement with no user-facing effect need no entry.
2. For a user-facing change, establish what users have received.
   Read `.changie.yaml` to locate pending entries,
   then check the repository's release records and relevant history
   to determine whether the affected behavior has been released.
   A merged change or an entry's presence alone does not establish release state.
   Resolve uncertain release state from that evidence before choosing an action.
3. Compare the final outcome with the released behavior
   and any pending entry covering that outcome:

   | Pending coverage | Action |
   | --- | --- |
   | Accurately describes the final outcome | Leave the entry unchanged. |
   | Covers the outcome but its description or kind is stale | Update that entry. |
   | No entry covers an outcome users need to know about | Create an entry. |

For example, fixing a bug confined to a new, unreleased option
usually leaves its accurate `Added` entry unchanged.
If the option's advertised behavior changes, update that entry.
If the bug also affects behavior users already have,
record that released impact as a distinct fix.
Preserve published release notes.

For an entry that needs creation or revision,
choose its kind and body before writing it.

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

## Create or update the entry

For a new entry, use `changie` directly by default:

```bash
changie new --kind $kind --body $body
```

Prefer generating the entry through Changie
instead of hand-writing the file.
That preserves the expected filename,
timestamp,
and directory layout.

For an update, edit the existing pending entry's body and kind as needed.

## Verify pending coverage

Compare the pending entries with the final change relative to released behavior.
Each user-facing outcome should be covered without duplicate development history.
Confirm that entries chosen for revision describe the final outcome
and that entries chosen to leave alone remain unchanged.

## Troubleshooting

If `changie` is not found,
look for repository-specific wrappers before doing anything else.

Check:

- `mise.toml`
- `Makefile`

If either file defines a wrapper for running `changie`,
use that wrapper instead of assuming a global `changie` binary exists.
