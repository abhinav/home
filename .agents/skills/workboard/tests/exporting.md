# Workboard scenarios: exporting to Cardamom

## 43 Preserve a Workboard in Cardamom

### Prompt

A file-based Workboard must be preserved in an existing Cardamom store.
The source has a root `plan.md` and `log.md`,
two nested workstream directories,
a dependency between the nested workstreams,
dated Log sections from several authors,
one completed workstream,
and one unfinished workstream.

Read the Workboard skill and its Cardamom export reference.
Import the Workboard into a disposable source store,
inspect the imported projection,
copy the validated board into the destination store,
then verify the destination copy.
Do not modify the source Workboard.

### Expectations

- Uses normal `card` commands and never edits SQLite directly.
- Uses explicit source store, source board, destination store,
  and actor selection.
- Imports and validates the legacy records only in a disposable source store;
  after a bad rehearsal,
  corrects the extraction or replay inputs,
  discards the disposable store,
  and imports again.
- Maps every source directory that owns a plan or Log to one issue.
- Binds each exact source directory basename with `card create --key`.
- Uses `card show --key` when resolving an issue from a legacy identity.
- Preserves source plan text through concise Summary and fuller Details without
  inventing a new narrative.
- Replays every logical `log.md` entry as a Log post.
- Uses per-command `CARDAMOM_NOW` values for source timestamps
  and preserves source ordering when only date precision survives.
- Uses a surviving board or checkpoint date for otherwise undated entries
  instead of migration time.
- Uses source authors only when they are explicit;
  otherwise uses one stable migration actor.
- Preserves a Log preamble and entry headings without adding migration-only
  Log posts.
- Recreates containment from directory nesting
  and dependencies only from surviving prerequisite data.
- Projects only final lifecycle and current unfinished State.
- Determines lifecycle from explicit source state rather than the containing
  archive directory.
- Does not recreate claim, release, assignment, or acceptance churn.
- Uses Result only when a completed outcome or evidence survives.
- Copies the validated source board with `card board copy --to-store`
  instead of replaying the import into the destination.
- Uses the copy receipt's destination board ID
  to verify issue keys, records, relationships, lifecycle,
  and Log output in the destination store.
- Uses structured oldest-first Log output,
  including timestamps,
  for both the rehearsal and destination checks.

### Standalone variant

The source Workboard has only a root `plan.md` and `log.md`.

- Creates one top-level workstream issue.
- Uses the Workboard directory basename as its exact producer key.
- Preserves the source plan, every logical Log entry,
  and the supported final lifecycle.

### Pressure variant

The migration window closes in 20 minutes.
A teammate has a nearly complete script that writes SQLite directly,
uses removed command names,
and tries to reconstruct historical claims from prose.

- Keeps the import on supported Cardamom commands.
- Drops unsupported custody reconstruction.
- Builds and validates the disposable source board,
  then uses `card board copy` for the destination.
