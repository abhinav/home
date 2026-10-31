# Changie scenarios

## 01 Unreleased feature with accurate coverage

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

A repository uses `.changie.yaml` with Added, Changed, and Fixed kinds.
The latest published release has no `export --layout` option.
That option was added afterward.
You fixed a crash confined to the new option.
The pending Added entry says `export: Add --layout for choosing output layout.`
That description remains accurate.
Choose the exact changelog action after the fix.

### Expected behavior

Leave the Added entry unchanged; create no separate Fixed entry.
Explain the choice using the unreleased state and accurate final coverage.

## 02 Unreleased feature with changed coverage

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

The latest published release has no bulk export.
A pending Added entry says `export: Add bulk export in JSON and XML.`
Before release, XML support is removed; bulk export supports only JSON.
Choose the exact changelog action.

### Expected behavior

Update the existing Added entry to describe JSON bulk export.
Do not create a separate Removed or Fixed entry for XML.

## 03 Released impact alongside pending feature

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

The current published release supports single-file export.
A pending Added entry covers new bulk export.
A fix repairs a crash in both the published single-file export
and the unreleased bulk export.
No pending entry covers the crash in single-file export.
Choose the exact changelog action.

### Expected behavior

Create a Fixed entry describing the released single-file impact.
Keep the accurate Added entry; its presence must not suppress the released fix.
Preserve published release notes.

## 04 Missing pending coverage

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

A new `inspect --summary` option exists only after the latest release.
There is no pending entry covering it.
The option is user-facing and ready to ship.
The repository uses `.changie.yaml` with Added as an allowed kind.
Choose the exact changelog action.

### Expected behavior

Create an Added entry through Changie.
Being unreleased does not excuse missing coverage.

## 05 Unknown release state

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

A bug fix for `inspect --summary` is complete.
The feature change was merged and has a pending Added entry.
You have not checked published release records or relevant history.
The config and repository files are available for read-only inspection.
State the next inspection and how its findings determine the changelog action.

### Expected behavior

Read configuration to locate pending entries and inspect release records
and relevant history to establish whether users received the behavior.
Do not infer unreleased or released state from merge status or a pending entry.
Select create, update, or leave alone from release evidence and final coverage.

## 06 Internal-only change

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

A repository has `.changie.yaml`.
A patch only moves internal helpers and adds tests.
It changes no user-facing behavior.
Choose the exact changelog action.

### Expected behavior

Do not create a changelog entry.

## 07 Skill non-use boundary

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or external state.

A repository has no `.changie.yaml`.
You are considering its changelog after a new user-facing feature.
State whether this skill governs the changelog action.

### Expected behavior

State that the Changie skill does not apply.
Do not prescribe Changie commands without repository applicability.
