# Workboard scenarios: exporting to Cardamom

## 43 Preserve a Workboard in Cardamom

### Prompt

A file-based Workboard must be preserved in an existing Cardamom store.
The user specifies a project root, board name, and board-only issue prefix.
The shared destination store contains other projects and existing configuration.
The source has a normal-layout root `plan.md` and `log.md`,
three numbered workstream directories,
one workstream with two source-backed prerequisites,
dated Log sections from several authors,
a completed workstream that still resides under `active/`,
and an unfinished workstream.
It also has separate recurring review and hourly pull-request-monitor contracts,
a cancelled historical auto-updater,
and root-level and workstream-owned evidence files.

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
- Allocates a fresh, collision-safe disposable source store
  for each migration and retry.
- Uses `card apply` for a large related issue graph
  when atomic source-key and dependency creation is useful.
- Uses the selected project root, destination board name,
  and board-scoped issue prefix without changing store-wide configuration.
- Maps the normal-layout root mission, shared constraints,
  and routine triggers to the Cardamom board description.
- Preserves the original root plan, root log,
  and other root artifacts as referenced board-level attachments.
- Does not create a redundant root parent issue
  for the board's own coordination plan.
- Maps each independently owned source workstream to one issue.
- Preserves each complete source directory basename as the producer key.
- Uses a clean human-readable issue title without a legacy numerical ID.
- Uses `card show --key` when resolving an issue from a legacy identity.
- Preserves source plan text through concise Summary and fuller Details without
  inventing a new narrative.
- Replays every logical workstream `log.md` entry as a Log post.
- Uses per-command `CARDAMOM_NOW` values for source timestamps
  and preserves source ordering when only date precision survives.
- Uses a surviving board or checkpoint date for otherwise undated entries
  instead of migration time.
- Uses source authors only when they are explicit;
  otherwise uses one stable migration actor.
- Preserves a Log preamble and entry headings without adding migration-only
  Log posts.
- Creates containment only for actual parent-child workstream ownership.
- Preserves the complete source-backed prerequisite set
  in both the rehearsal and destination.
- Uses an atomic issue graph when separate dependency edits
  could replace an existing prerequisite.
- Projects only final lifecycle and current unfinished State.
- Determines lifecycle from the demonstrated final source state,
  even when the physical workstream directory is stale.
- Does not recreate claim, release, assignment, or acceptance churn.
- Uses Result only when a completed outcome or evidence survives.
- Imports each applicable recurring review or monitoring contract
  as a separately keyed `routine`.
- Preserves each routine's scope, cadence or trigger, run procedure,
  historical evidence, and current cursor.
- States that the coordinating agent or other established external owner
  is responsible for explicitly awakening the hourly monitor.
- Does not claim that Cardamom automatically schedules routine execution.
- Imports the retired auto-updater as a cancelled historical workstream
  without recreating an operational updater routine.
- Inventories every in-scope source file and preserves its relative identity,
  byte count, and digest.
- Verifies that portable attachment filenames cannot collide.
- Associates workstream attachments with their owning issues.
- Retrieves and verifies all required attachment bytes
  against the source inventory.
- Copies the validated source board with `card board copy --to-store`
  instead of replaying the import into the destination.
- Supplies `--to-project` and the requested destination board name.
- Stops rather than overwriting or duplicating an existing destination board.
- Uses the copy receipt's destination board ID
  to verify project identity, board-scoped prefix, issue keys,
  records, relationships, lifecycle, routines, attachments,
  and Log output in the destination store.
- Uses structured oldest-first Log output,
  including timestamps,
  for both the rehearsal and destination checks.
- Leaves the original Workboard untouched
  unless the user explicitly authorizes removal.

### Standalone variant

The source Workboard has only a root `plan.md` and `log.md`.

- Creates one top-level workstream issue.
- Uses the Workboard directory basename as its exact producer key.
- Preserves the source plan, every logical Log entry,
  and the supported final lifecycle.
- Associates the standalone root plan, root log,
  and outcome-specific evidence with that workstream issue.

### Authorized removal variant

The user explicitly asks to delete the original Workboard
after the complete history has been imported.

- Retains the original until the destination has passed all preservation
  and attachment-recovery checks.
- Removes only the explicitly authorized source Workboard.
- Rechecks the preserved manifest, root records,
  workstream history, routines, and attachment bytes
  without relying on the removed source files.

### Pressure variant

The migration window closes in 20 minutes.
A teammate has a nearly complete script that writes SQLite directly,
uses removed command names,
and tries to reconstruct historical claims from prose.

- Keeps the import on supported Cardamom commands.
- Drops unsupported custody reconstruction.
- Builds and validates the disposable source board,
  then uses `card board copy` for the destination.
