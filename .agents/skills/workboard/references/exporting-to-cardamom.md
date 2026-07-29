# Exporting Workboards to Cardamom

Use this procedure when the user asks to preserve a file-based Workboard in
Cardamom.
Import the surviving files through normal `card` commands
into a disposable source store,
then copy the validated board into an existing destination store.
Do not modify the source Workboard or write directly to Cardamom's database.

The goal is to preserve the source records and restore useful coordination
in Cardamom's native board, issue, and routine model.
Inventory the surviving plans, logs, artifacts, source identities,
dependencies, lifecycle evidence, and recurring operating contracts first.
Preserve established facts without inventing missing plan revisions,
actors, timestamps, decisions, claim history, or acceptance stories.

Load the Cardamom skill and its workflow references for board selection,
planning, routines, attachments, and multi-issue graph application
when those operations are needed.

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

Use the user-selected project root, destination store, board name,
and issue prefix.
When an issue prefix is specific to the imported board,
set `issue.id.prefix` at board scope before creating issues:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  config set --scope board issue.id.prefix "$issue_prefix"
```

Keep store-wide configuration and unrelated projects or boards unchanged.
When project initialization is explicitly authorized,
run it from the selected project root.
Set `CARDAMOM_NO_GITIGNORE=1` when initialization must not change
the repository's Git exclude file.

The replay is not generally idempotent.
Producer keys prevent duplicate issue creation,
but replaying a successful Log post creates another entry.
When migrating many related workstreams,
use `card apply` to create their source-keyed issue and dependency graph
in one supported transaction before importing histories and attachments.

## Map the root plan to the board

For a normal Workboard with independently owned workstream directories,
the Cardamom board replaces the root coordination plan.
Put the mission, shared operating boundaries, acceptance rules,
integration policy, routine triggers, and other still-applicable root context
in the board description.
Preserve the original root plan and root log as board-level attachments,
and reference those attachments from the board description.
Preserve other root-level artifacts the same way.

Create issues for actual independently owned workstreams,
not for the board-level coordination plan.
Create a parent issue only when the source establishes a real containing
workstream with its own independently owned outcome.

For a standalone Workboard,
the root plan owns one executable outcome rather than a board of workstreams.
Create one top-level workstream issue for that outcome,
and use the Workboard directory basename as its producer key.
Associate the original root plan, root log, and outcome-specific evidence
with that issue.
Replay the root log as the issue's historical Log,
and preserve the outcome's supported lifecycle on the issue.

## Map workstream directories to issues

Each actual workstream directory that owns a `plan.md`, a `log.md`,
or both becomes one Cardamom issue.
Use the directory basename as the issue's unchanged producer key.
Use a clean, human-readable workstream title from the plan heading;
remove a leading Workboard directory ID from the displayed title
while retaining the complete original ID in `--key`.
When no useful heading survives,
derive a readable title from the slug without its numeric ID.
Preserve source-specific capitalization and terminology when established.
Report producer-key collisions instead of silently merging workstreams.

```bash
legacy_id=001-branch-search-ordering
title='Branch search ordering'

issue_id=$(
  card --store "$source_store" --board "$source_board_id" \
    --actor legacy-import \
    create --type workstream --key "$legacy_id" \
    --summary "$(cat "$payload_dir/$legacy_id-summary.md")" \
    --details "$(cat "$payload_dir/$legacy_id-details.md")" \
    "$title"
)
```

Use containment only for actual nested workstream ownership,
not because workstreams were stored beneath a root coordination directory.
Set a parent when the source establishes an independently meaningful
parent-child workstream:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  edit "$child_id" --parent "$parent_id"
```

Do not invent additional workstreams from names mentioned only in a table,
prose, or an archived root.
Keep that source evidence in its original attached plan or log.

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
| Normal-layout root mission and operating rules | Board description |
| Original normal-layout root plan, log, and root artifacts | Board-level attachments |
| Workstream plan heading without its directory ID | Issue title |
| Complete workstream directory basename | Producer key |
| Purpose, outcome, mission, and completion boundary | Issue Summary |
| Remaining stable plan content | Issue Details |
| Current recovery section for unfinished work | Issue State |
| Established next action for unfinished work | State `--next` |
| Completed outcome and evidence | Issue Result |
| Logical workstream `log.md` entry | Timestamped Log post |
| Original workstream plan, log, and evidence files | Issue-associated attachments |
| Workstream dependency | Issue dependency |
| Actual nested workstream ownership | Containment parent |
| Active reusable evergreen operating contract | Routine |
| Demonstrably completed workstream | Closed issue |
| Demonstrably abandoned, retired, or superseded workstream | Cancelled issue |

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

## Preserve source files

Build a source inventory before importing.
Include every root plan and log,
each workstream plan and log,
and every additional artifact required by the requested preservation scope.
Record each source-relative path, byte count, and content digest.
When preserving the full Workboard,
include every surviving regular file and attach the inventory itself.

For a normal-layout Workboard,
store root-level coordination records as board-level attachments.
For a standalone Workboard,
associate the root plan, root log, and outcome-specific evidence
with the single owning workstream issue.
Store workstream records and artifacts as attachments associated with
their owning issue.
Choose portable attachment filenames that preserve the source-relative
identity and distinguish repeated names such as `plan.md` and `log.md`.
Verify that the chosen filename transformation is collision-free:

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import --json \
  attachment add --name root__plan.md "$source/plan.md"

card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import --json \
  attachment add --issue "$issue_id" \
    --name workstreams__active__001-branch-search-ordering__log.md \
    "$source/workstreams/active/001-branch-search-ordering/log.md"
```

Reference normal-layout root attachments from the board description
and material workstream attachments from the owning issue's records.
Keep the meaning of an attachment in the surrounding record.
Validate attachment counts, source-relative identities, metadata,
and retrieved content digests against the source inventory.

## Preserve Log entries

Split each workstream `log.md` into its existing logical entries.
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
When one workstream has multiple prerequisites,
preserve the complete dependency set together;
use `card apply` when repeated edits could replace prior edges.

Project the final lifecycle supported by the root board,
the workstream plan and log,
and any source-backed completion or retirement evidence.
A directory named `active`, `completed`, or `archive` is supporting evidence,
not authority to contradict a demonstrated final outcome.
Close a workstream when surviving evidence establishes completion,
even when the directory was not moved.
Cancel a workstream only when surviving evidence establishes retirement,
abandonment, or supersession.
Leave unresolved or materially conflicting cases open and unclaimed,
and preserve the uncertainty in Details.

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

## Preserve recurring operating contracts

Create one `routine` for each source-backed, still-applicable recurring
operating contract.
Preserve its historical producer key,
human-readable title,
operating scope,
trigger or cadence,
run procedure,
retirement condition,
current targets or cursor,
and surviving run history.
Review lanes and pull-request or CI monitoring may become separate routines
when they represent separate continuing contracts.

```bash
card --store "$source_store" --board "$source_board_id" \
  --actor legacy-import \
  create --type routine --key 013-pr-monitor \
    --summary "$(cat "$payload_dir/013-pr-monitor-summary.md")" \
    --details "$(cat "$payload_dir/013-pr-monitor-details.md")" \
    'Pull request and CI monitoring'
```

Record the trigger in the board description and the routine's records.
Specify who is responsible for awakening the routine.
When the coordinating agent owns an hourly or event-triggered monitor,
state that the agent must explicitly awaken and run it when the trigger occurs.
Cardamom persists the routine;
it does not schedule a worker, run background jobs,
or automatically execute an hourly contract.

Import a retired or cancelled evergreen as a cancelled historical workstream
when its operating contract must not continue.
Preserve its history and disposition without creating a reusable active routine
or reviving its trigger.

## Create the disposable source

Initialize one project and board in the disposable source store:

```bash
source_store=$(
  mktemp -d "${TMPDIR:-/tmp}/cardamom-workboard-import.XXXXXXXX"
)
board_name='user-selected-board-name'

receipt=$(
  CARDAMOM_NO_GITIGNORE=1 \
  card --store "$source_store" --actor legacy-import --json \
    init --board-name "$board_name"
)
source_board_id=$(jq -r '.board_id' <<<"$receipt")
test -n "$source_board_id" && test "$source_board_id" != null
```

Allocate a new disposable store for each migration and each failed retry.
Never reuse a conventional temporary path or a previous rehearsal's database.

For a normal-layout Workboard,
set the board description from the root mission and current shared rules.
Include board-level source-attachment references and routine triggers:

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

Compare the rehearsal with the source inventory:

- the intended project, board name, and board-scoped issue prefix;
- board-level root context and references to the preserved root records;
- one issue per actual independently owned source workstream;
- unchanged directory-basename producer keys and readable issue titles;
- workstream and routine types, summaries, details, states, results,
  and demonstrated final lifecycles;
- oldest-first workstream Log bodies, timestamps, authors, and ordering;
- only source-backed workstream containment and prerequisite edges;
- every source attachment's identity, byte count, and content digest; and
- routine contracts, triggers, wake ownership, and retired-workstream status.

Resolve routines directly by their producer keys.
Routines do not appear in automatic ready or blocked pools.

Correct the extraction or replay inputs,
discard the disposable source store,
and rehearse again when the projection is wrong.

## Copy the validated board

Use `card board copy` to create the destination board
in an existing Cardamom store.
The source store and board remain unchanged.
When the destination store contains multiple projects,
select the intended project with `--to-project`.
Use `--name` when the user specifies a destination board name.
Board copy creates a new board;
it does not reconcile into an existing destination board.
When the requested board already exists,
stop and ask for a supported reconciliation decision
instead of creating a duplicate or overwriting its records.

```bash
destination_store=/path/to/existing-cardamom-store
destination_project=user-selected-project

copy_receipt=$(
  card --store "$source_store" --board "$source_board_id" \
    --actor legacy-import --json \
    board copy --to-store "$destination_store" \
      --to-project "$destination_project" --name "$board_name"
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

Compare the destination project, board, configuration, records,
relationships, lifecycle, and oldest-first Log output
with the validated source board.
Download and digest-check every required destination attachment;
metadata alone does not establish that source bytes can be recovered.
Verify that unrelated store-wide configuration remains unchanged.

Keep the original Workboard unless the user explicitly authorizes its removal.
When removal is authorized,
delete the source only after destination identity,
all workstreams and routines,
historical Log bodies,
dependencies,
and every required attachment have passed verification.
After removal,
verify that the destination can recover the preserved source manifest,
root records, workstream history, and attachment bytes independently.
