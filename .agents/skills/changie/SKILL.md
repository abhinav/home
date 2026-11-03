---
name: changie
description: >
  Create or update Changie unreleased entries, or decide whether a change needs
  one, in repositories with `.changie.yaml`.
---

# Changie

Apply this skill only when `.changie.yaml` exists.
Release notes describe the final difference from the previous release,
not each development step.

## Choose the entry action

Cover user-facing features, behavior changes, visible fixes, deprecations,
removals, and security fixes.
When they have no user-facing effect, omit entries for internal refactors,
test-only changes, CI/tooling, and code movement.

For a user-facing change, read `.changie.yaml` to locate pending entries.
Establish what users have received from release records and relevant history;
neither a merge nor a pending entry proves release state.
Resolve uncertainty before choosing an action.

Compare the final outcome with released behavior and pending coverage:

| Pending coverage | Action |
| --- | --- |
| Accurately describes the final outcome | Leave the entry unchanged. |
| Covers the outcome, but its body or kind is stale | Update that entry. |
| No entry covers an outcome users need to know about | Create an entry. |

A fix confined to an unreleased option usually keeps its accurate `Added` entry.
Update it if the advertised behavior changes.
If the fix also affects released behavior, record that impact as a separate fix.
Preserve published release notes.

## Choose the kind and body

Before writing, choose an allowed kind and a specific user-facing body
using `.changie.yaml`, including custom kinds and body expectations.
Choose by the outcome for users, not the implementation work.

## Write and check

Create new entries through Changie by default:

```sh
changie new --kind "$kind" --body "$body"
```

Prefer this over hand-writing files to preserve filenames, timestamps, and layout.
For updates, edit the existing pending entry's body and kind as needed.
If `changie` is unavailable, first check `mise.toml` and `Makefile`;
use a repository wrapper when defined.

Check pending coverage against the final change relative to released behavior:
cover each user-facing outcome without duplicate development history,
confirm revised entries describe the final outcome,
and verify entries selected to remain unchanged still are.
