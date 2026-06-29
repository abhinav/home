# Worktrees

## State And Ownership

The Worktree Pool records the workspace handed to a worker,
including the checkout,
execution context,
and shared resources required to use it.
Preregister allocation intent in the owning workstream or root coordination
log.
Do not invent workspace identity, paths, revisions, or execution context before
acquisition returns them.

Every extant workspace recorded in the Worktree Pool is one of:

| State | Meaning |
| --- | --- |
| `available` | The workspace is ready for reuse and no workstream or root scope owns it. |
| `in-use` | One declared workstream or root scope and one responsible owner control it. |

Root scope means standalone execution,
an explicitly root-assigned normal-layout task,
or coordination-only setup, recovery, or disposition.
It does not independently authorize meaningful root execution.

Setup, worker execution, integration execution, and recovery are all `in-use`.
Represent those phases through the owner, observed state, risks,
and concrete next action rather than additional lifecycle states.

Keep workstream lifecycle,
workspace ownership,
and custody of useful results separate.
A change in one does not imply a change in the others.
An `in-use` workspace may name an active checkout user
to perform its concrete action.
The responsible owner retains lifecycle and disposition responsibility.

## Invariants

1. **Exclusive ownership.**
   An `in-use` workspace has exactly one declared workstream or root scope,
   one responsible owner,
   an optional active checkout user,
   and one concrete next action.
2. **Observed state.**
   Record actual handoff and operation results,
   not intended future identity or state.
3. **Preservation before release.**
   Useful work has a durable locator,
   custodian,
   and next integration, review, or disposal action before workspace cleanup.
4. **Completion.**
   Root does not complete while any workspace remains `in-use`.
   Every used workspace is released as `available`
   or has verified removal evidence.

Urgency, authority, exhaustion, and convenience do not relax these invariants.

## Workflow

### Acquire And Reuse

Before acquisition,
record the intended workstream or root scope,
isolation requirements,
requested configuration,
and expected evidence.
Acquire the workspace without inventing its eventual handoff.
Acquisition must provide exclusive claiming.
When the normal workflow does not,
governing instructions must provide a common allocator or lock,
or disjoint namespaces for plans sharing capacity.

After acquisition or reuse,
record the actual identity, checkout path or paths,
execution context, configuration, observed state,
scope, owner, and next action.
Verify that the returned workspace satisfies the declared scope's isolation
and evidence requirements before dispatch.

If acquisition fails before a workspace exists,
record the attempt outcome without creating a fictional pool entry.
If a workspace or partial workspace exists,
record it as `in-use` under a root recovery owner until it is repaired,
released,
or removed.

### Transfer And Recovery

Changing from root setup to worker execution
or from integration-worker handoff to root recovery
does not itself change `in-use`.
Worker handoff instead invokes the disposition procedure below.
Only a named checkout-dependent action ready to start now
justifies retaining the workspace for another assigned workstream attempt.
Update the responsible owner, observed state, risks,
and next action together.

Inspect and recover the workspace through its governing workflow.
Do not erase unexplained state or transfer cleanup risk to the next worker.

### Handoff Disposition: Release Or Remove

Release and removal are root-owned coordination operations.
At handoff,
root performs the governing workspace workflow
and verifies its observed result.
Clean or quiescent state, administrative lease closure, ownership transfer,
rebinding, and workspace preparation are not release proof.
Run and verify the governing release or reset workflow before marking reusable
capacity `available` or reassigning it.
When removing a temporary Git worktree,
preserve its durable branch or ref
unless an explicit disposal decision says otherwise.
Root performs the post-handoff operation
even when another workspace workflow normally assigns cleanup
to the former worker.
Retain a temporary workspace after handoff only when the next action is ready
to start now and requires that workspace's current checkout state.
Otherwise,
a durable branch or commit preserves the result independently of the workspace.
Release or remove the workspace right away unless the next assessment
needs workspace-local state that is not preserved in the durable result,
such as uncommitted generated files, local runtime state,
or an active process that the assessment will consume immediately.
A request to inspect or evaluate the durable result in the producing checkout
does not establish that requirement by itself.
The next assessment must identify workspace-local state
that is absent from the durable result.
When the next action qualifies,
preregister and dispatch it under its owning workstream,
record the assigned worker as active checkout user,
then complete disposition after handoff.
Before release or removal:

- quiesce workers, commands, assessments, and processes using the workspace;
- checkpoint durable Workboard records;
- preserve useful work under the preservation invariant; and
- record the expected release or removal result.

A normal release may reset, rebuild, rename,
or otherwise clean managed resources.
That cleanup is valid after preservation;
forceful disposal still requires an explicit disposal decision.

After the operation,
record observed results rather than assuming success.
A successfully released reusable workspace becomes `available`.
A failed release or repair remains `in-use` under a root recovery owner.
For removal,
verify the removal result and any observable checkout or registry
absence required by governing instructions,
then retain the evidence in the root log and remove the active pool row.

## Useful Results

Physical workspace release does not prove integration.
Useful-result custody is independent of physical-workspace custody,
and a durable result remains available after workspace removal.
Record each retained result's durable locator,
provenance or revision,
custodian,
integration status,
and next integration, review, or disposal action.

For cancellation, failed validation, or failed integration,
root owns recovery coordination.
Preserve wanted committed and uncommitted results durably,
then release, repair, or remove the workspace.
Do not rely on transient recovery metadata or indefinite ownerless retention.

## Repository-Local Coordination Files

When coordination files live in the implementation repository,
choose one canonical path for each plan and log.
Workers update those absolute handoff paths,
not copies in implementation workspaces.

Keep coordination changes separate from implementation commits by default.
An explicit user or repository rule may override this only when the workstream
plan defines single-writer ownership and integration of those files.
Before release,
verify that workspace copies contain no unique or unpreserved updates.
