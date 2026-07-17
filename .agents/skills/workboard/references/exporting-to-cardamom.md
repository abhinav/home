# Exporting Workboards to Cardamom

Use this procedure when the user asks to preserve a file-based Workboard in
Cardamom.
Import the surviving files through normal `card` commands
into a disposable source store,
then copy the validated board into an existing destination store.
Do not modify the source Workboard or write directly to Cardamom's database.

The goal is data preservation,
not reconstruction of the conversations or execution history that produced the
files.
Import source text and relationships on a best-effort basis.
Do not invent missing plan revisions, actors, timestamps, decisions,
claim history, or acceptance stories.

## Rehearse outside the destination

Import the complete Workboard into a disposable source store.
Inspect the imported projection there
before copying the validated board to the selected destination store.

Keep temporary payload files and scripts outside the source Workboard.
Use explicit `--store` and `--actor` values on every command.
After initialization returns the board ID,
use explicit `--board` selection on every board-scoped command.
Use one stable migration actor such as `legacy-import`
when the source does not identify an author.

The replay is not generally idempotent.
Producer keys prevent duplicate issue creation,
but replaying a successful Log post creates another entry.

## Map source directories to issues

Every legacy directory that owns a `plan.md`, a `log.md`, or both becomes one
Cardamom issue.
Use the directory basename as the issue's exact producer key:

```bash
legacy_id=001-branch-search-ordering

issue_id=$(
  card --store "$source_store" --board "$source_board_id" \
    --actor legacy-import \
    create --type workstream --key "$legacy_id" \
    --summary "$(cat "$payload_dir/$legacy_id-summary.md")" \
    --details "$(cat "$payload_dir/$legacy_id-details.md")" \
    "$title"
)
```

For a standalone Workboard,
the root directory becomes one top-level workstream issue.
Use the Workboard directory basename as its key.

For a Workboard with nested workstream directories,
the root directory becomes the containing workstream issue
and each nested directory becomes a descendant.
Use each nested directory's basename as its key.
Set containment from the surviving directory structure:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  edit "$child_id" --parent "$parent_id"
```

When an archived root contains only `plan.md` and `log.md`,
do not create additional issues from names mentioned only in tables or prose.
Those names remain preserved in the imported plan and Log.

Use `card show --key` to resolve an issue from its legacy identity:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  show --key "$legacy_id"
```

## Map the surviving records

Preserve source wording where practical.
Light mechanical reorganization is enough;
do not rewrite the material into a new narrative.

| Workboard source | Cardamom destination |
| --- | --- |
| Plan heading | Issue title |
| Purpose, outcome, mission, and completion boundary | Issue Summary |
| Remaining stable plan content | Issue Details |
| Current recovery section for unfinished work | Issue State |
| Established next action for unfinished work | State `--next` |
| Completed outcome and evidence | Issue Result |
| Logical `log.md` entry | Timestamped Log post |
| Workstream dependency | Issue dependency |
| Nested workstream directory | Containment parent |
| Evergreen operating contract | Routine |
| Completed workstream | Closed issue |
| Explicitly archived, abandoned, or superseded workstream | Cancelled issue |

Keep Summary concise enough to serve as inherited context.
Details may retain the fuller plan,
including constraints, rationale, decisions, evidence,
and recovery information that remains useful.

Do not duplicate fields already represented by Cardamom merely to produce
polished prose.
It is acceptable for Details to preserve an old board table,
branch name, next action, or other historical text as source data.

For completed work,
use an explicit outcome or completion-evidence section as Result when one
survives.
Result is optional;
do not manufacture one merely because the issue will be closed.
When a terminal plan's section is still named `Current State`
but describes the finished outcome,
it may supply Result rather than live State.

For unfinished work,
set State only when the source has a recognizable current recovery position.
Use `--next` only when the source establishes one concrete next action:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  state set "$issue_id" \
  "$(cat "$payload_dir/$legacy_id-state.md")" \
  --next "$(cat "$payload_dir/$legacy_id-next.md")"
```

Do not recreate historical claims, releases, worker assignments,
or root acceptance churn.
Leave unfinished issues unclaimed.

## Preserve Log entries

Split each `log.md` into its existing logical entries.
A dated Markdown section is normally one entry.
Preserve its body rather than summarizing or expanding it.

Use the source timestamp when it survives.
Set `CARDAMOM_NOW` on that command only:

```bash
CARDAMOM_NOW=2026-06-23T12:00:00Z \
  card --store "$source_store" --board "$source_board_id" \
    --actor legacy-import \
  log post "$issue_id" - \
  < "$payload_dir/$legacy_id-log-01.md"
```

`CARDAMOM_NOW` accepts an RFC 3339 timestamp.
When the source gives only a date,
use UTC and choose whole-second timestamps on that date that preserve source
order.
When individual entries are undated but the plan, Log preamble,
or Workboard directory name establishes one source date,
use that date for the entries.
Use import time only when no source date survives.
Do not claim finer precision.

Use the source author as `--actor` only when the file identifies one clearly.
Otherwise use the stable migration actor.
Do not infer an author from repository ownership or surrounding prose.

Keep source entries even when they contain superseded plans,
coordination mechanics, or verbose implementation history.
The migration preserves surviving data;
it does not edit the historical Log into ideal Cardamom guidance.
Keep a preamble before the first entry by prepending it to that entry.
Keep the source entry heading with its body.
Do not add migration provenance, lifecycle rationale,
or command receipts to the issue Log.

## Recreate relationships and lifecycle

Resolve dependencies after all referenced issues exist.
Use the producer-key lookup to build a temporary
`legacy key -> Cardamom issue ID` mapping,
then add each surviving prerequisite:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  edit "$issue_id" --depends-on "$prerequisite_id"
```

Use dependencies only for prerequisites.
Use containment for nested workstreams and inherited context.

Project only the final lifecycle supported by the surviving files:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  result set "$issue_id" - \
  < "$payload_dir/$legacy_id-result.md"

card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  close "$issue_id"
```

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  cancel "$issue_id"
```

Close children before their containing workstream.
Cancellation may affect dependents,
so inspect the graph before cancelling archived work.
The surrounding `~/work/archive` collection is storage history,
not a lifecycle signal.
Use an explicit source workstream state or plan disposition;
close completed work even when its board is stored in that collection.
When the surviving source is ambiguous,
leave the issue open and record the uncertainty in Details.

Map a legacy evergreen workstream to a routine only when it contains a reusable
operating contract.
Put the contract in Summary and Details,
the current cursor or recovery position in State,
and completed runs in Log posts.
Scheduling remains outside Cardamom.

## Create the disposable source

Initialize one project and board in the disposable source store:

```bash
source_store=/tmp/cardamom-workboard-import
board_name="$(sed -n '1s/^# //p' "$source/plan.md")"

receipt=$(
  card --store "$source_store" --actor legacy-import --json \
    init --board-name "$board_name"
)
source_board_id=$(jq -r '.board_id' <<<"$receipt")
test -n "$source_board_id" && test "$source_board_id" != null
```

Set a concise board description only when the root plan contains shared context
that should apply outside the imported root issue:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  board edit --description - \
  < "$payload_dir/board-description.md"
```

## Validate the rehearsal

Inspect the imported projection through Cardamom:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  list --status ready,blocked,in_progress,waiting,closed,cancelled --limit 0

card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  show --key "$legacy_id" --context

card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import --json \
  log show "$issue_id" --oldest-first --limit 0
```

Compare the rehearsal with the source files:

- one issue for every imported source directory;
- exact producer keys from directory basenames;
- titles, Summary, Details, State, Result, and final lifecycle;
- oldest-first Log bodies, timestamps, authors, and ordering;
- containment and dependencies; and
- board description when shared context was extracted.

Correct the extraction or replay inputs,
discard the disposable source store,
and rehearse again when the projection is wrong.

## Copy the validated board

Use `card board copy` to create the destination board
in an existing Cardamom store.
The source store and board remain unchanged.
When the destination store contains multiple projects,
select the intended project with `--to-project`.

```bash
destination_store=/path/to/existing-cardamom-store

copy_receipt=$(
  card --store "$source_store" --board "$source_board_id" \
    --actor legacy-import --json \
    board copy --to-store "$destination_store"
)
destination_board_id=$(jq -r '.destination_board_id' <<<"$copy_receipt")
test -n "$destination_board_id" && test "$destination_board_id" != null
```

## Verify the destination copy

Run the same projection checks against the copied board.
Resolve destination issue IDs from their retained producer keys
because issue IDs may change during the copy.

```bash
card --store "$destination_store" --board "$destination_board_id" \
  --actor legacy-import \
  list --status ready,blocked,in_progress,waiting,closed,cancelled --limit 0

destination_issue_id=$(
  card --store "$destination_store" --board "$destination_board_id" \
    --actor legacy-import --json \
    show --key "$legacy_id" \
  | jq -r '.id'
)

card --store "$destination_store" --board "$destination_board_id" \
  --actor legacy-import \
  show --key "$legacy_id" --context

card --store "$destination_store" --board "$destination_board_id" \
  --actor legacy-import --json \
  log show "$destination_issue_id" --oldest-first --limit 0
```

Compare the destination records, relationships, lifecycle,
and oldest-first Log output with the validated source board.
