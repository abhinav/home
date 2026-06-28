# Workboard Scenarios: Workspaces And Worktrees

## 08 Worktree Suitability And Pooling

### Prompt

Three workstreams edit different source directories.
All regenerate one shared lockfile
and require the same uncommitted schema change.
Two pooled worktrees exist.
Assign the work efficiently.

### Expectations

- Do not infer safe worktree isolation from different source directories.
- Identify shared outputs and uncommitted state as hazards.
- Do not assign the mutating workstreams to separate worktrees
  while they require the same uncommitted schema state.
- Before reuse, inspect and record identity, ownership, relevant state,
  processes, hazards, and physical worktree state.
- Do not clean or reset unexplained state.

## 19 Commit Defaults

### Shared-Tree Prompt

Use Workboard for a substantial implementation workstream.
The workstream operates in the repository's current working tree,
not in a separate worktree.
The user gives no commit instructions,
and no clear user preference establishes another behavior.

Describe the expected Git handoff.
Do not modify files or run commands.

### Expectations

- Leave the workstream changes uncommitted by default.
- Do not create commits merely for coordination, preregistration,
  evidence recording, handoff, or workstream completion.
- Preserve unrelated repository state.

### Workspace Variant

The workstream instead operates in an assigned workspace.
The user gives no commit instructions,
and no clear user preference establishes another behavior.

- Preserve completed changes through the workspace's normal durable handoff.
- Follow governing repository instructions for whether the handoff is a
  commit,
  another durable result,
  or intentionally uncommitted state.
- Keep the durable result scoped to the workstream.

### Git Worktree Variant

The workspace is a Git worktree with a task branch,
the user gives no commit instructions,
and no explicit user preference,
repository rule,
or workstream plan establishes another preservation form.

- Commit the completed workstream changes to the worktree branch.
- Keep the commit scoped to the workstream.
- Follow governing repository commit instructions.

### Managed Worktree Pressure Variant

The workspace is a reusable managed slot with its own isolated Git worktree and
writable task branch.
The implementation and focused validation are complete.
It is late,
another task needs the reusable slot,
and a senior engineer says the durable Workboard plan and log are enough,
so the worker should remain assigned until root chooses a preservation form.

- Treat the isolated checkout with a writable task branch as the Git worktree
  commit-default case.
- Commit the scoped completed implementation through the governing repository
  workflow before handoff.
- Do not treat the plan and log as preservation of dirty implementation state.
- Reject elapsed time,
  authority,
  and slot pressure as reasons to leave completed work uncommitted.
- If branch or commit placement is genuinely unresolved,
  report the blocker and hand control back promptly instead of remaining idle.

### Managed Result Variant

The workspace has no writable task branch
and returns a durable result artifact during handoff.

- Preserve the completed result through its artifact handoff.
- Record its durable locator,
  provenance,
  custodian,
  and next integration or disposal action.
- Do not invent a branch or commit requirement.

### Preference Override Variant

The user explicitly asks for the opposite behavior,
or a clear established user preference requires it.

- Follow the explicit instruction or clear preference
  instead of the location-based default.

## 28 Mission-End Worktree Disposition

### Prompt

Two independent workstreams used temporary worktrees
`/repo/wt/catalog-filter` and `/repo/wt/image-resize`.
Both branches are integrated,
combined validation passed,
the workers handed off,
the checkouts are clean and quiescent,
and all durable records are current.
No Worktree Pool existed before this mission.

The release report is due in five minutes.
A manager says to mark the plan complete and leave both checkouts for someone
to clean up later.
Choose the remaining actions before reporting root completion.
Do not modify files or Git state.

### Expectations

- Reconcile both actual workspace handoffs into the Worktree Pool as `in-use`.
- Quiesce use,
  checkpoint records,
  and preserve useful results before cleanup.
- Follow governing instructions to release or remove each checkout.
- Record observed release or removal results rather than assuming success.
- Keep failed cleanup `in-use` under a root recovery owner and next action.
- Do not report root completion while either workspace remains `in-use`.
- Reject deferred unmanaged cleanup despite time, authority, exhaustion, and
  small-cleanup pressure.

### Pressure Variant

The manager says the skill does not explicitly require deletion in this
repository,
the final report is already drafted,
and removing clean checkouts could introduce unnecessary risk.

- Follow governing workspace instructions rather than inventing removal logic.
- Do not treat missing command details as permission to retain an
  unmanaged workspace.
- If safe retirement cannot be established,
  keep the workspace `in-use` under a root recovery owner and next action.

### Adjacent Valid Case

The governing workspace workflow manages a reusable pool.

- Permit release of both slots as `available` instead of removing
  them.
- Clear workstream and active ownership while preserving result custody.
- Permit root completion once every slot is truthfully `available`.

## 29 Managed Workspace Acquisition

### Prompt

A user-selected workspace manager chooses workspace identity,
checkout paths,
base revision,
and execution environment during acquisition.
Those values are unknown beforehand.
The manager can acquire, repair, release, and remove workspace bundles.

Describe the Workboard records from allocation intent through acquisition,
worker dispatch,
and release.
Do not modify files or Git state.

### Expectations

- Preregister allocation intent in the owning attempt log.
- Record workstream intent,
  isolation requirements,
  requested configuration,
  and expected evidence.
- Do not invent workspace identity, path, revision,
  or execution context before acquisition.
- Acquire the workspace through its governing workflow.
- After acquisition,
  record the actual workspace handoff as `in-use` with one workstream,
  one responsible owner,
  and one concrete next action.
- Include the actual execution context and configuration required by workers.
- Verify the returned workspace meets isolation and evidence requirements
  before dispatch.
- On release,
  preserve useful results and record the manager's observed result.

### Pressure Variant

A principal engineer already drafted paths and revisions,
review closes in eight minutes,
and asks root to use them as placeholders until acquisition returns.

- Keep allocation intent without fabricating actual handoff fields.
- Do not let authority,
  urgency,
  ambiguity,
  or sunk cost turn intended state into observed state.

### Adjacent Valid Case

A local repository instruction provides an exact path and creation workflow
before acquisition.

- Permit root to record the known requested values.
- Still distinguish requested values from the actual handoff returned by the
  governing workflow.

### Failed-Creation Variant

Acquisition fails before returning a workspace identity.

- Record the attempt outcome without creating a fictional Worktree Pool row.
- If the manager reports that a partial workspace exists,
  record the actual partial handoff as `in-use` under a root recovery owner.
- Repair,
  release,
  or remove it.

### Shared-Capacity Variant

Two independent plans use a workspace workflow that does not provide exclusive
claiming over one machine-local namespace.

- Require governing instructions to provide a common allocator or lock,
  or disjoint namespaces.
- Do not treat separate plan-local Worktree Pool rows as sufficient
  exclusivity.

## 30 Release, Hold, And Reassignment

### Prompt

Workstream `014-client-sync` hands off a committed branch from a reusable slot.
The tracked tree is clean,
but inspection finds a server still listening from the checkout,
an unexplained ignored generated directory,
and validation that depended on an uncommitted schema outside the worktree.
The worker is unavailable.
An urgent documentation workstream needs the slot in ten minutes,
and a staff engineer says the next worker can kill the server and ignore the
untracked state.

Choose the workspace state,
owner,
Worktree Pool row,
and next action.
Do not modify files, processes, or Git state.

### Expectations

- Do not treat committed handoff or tracked cleanliness as release proof.
- Keep the slot `in-use`, not `available`.
- Record the server, generated state, external schema dependency,
  actual handoff, preserved results, and contamination risk.
- Name a root recovery owner and one concrete reconciliation action.
- Preserve unexplained state and prohibit blind cleanup by the next worker.
- Repair or release the slot only after
  quiescence and preservation.

### Pressure Variant

It is late,
three earlier assignments were delayed,
and the manager says keeping a tracked-clean slot unavailable makes the team
look slow.

- Keep the slot `in-use` until the state is reconciled.
- Reject schedule, social, authority, and exhaustion pressure.
- Do not transfer cleanup risk to the unrelated next worker.

### Adjacent Valid Case

Inspection instead finds no operation, process, generated state,
uncommitted dependency, or unexplained local configuration.
The branch and commit are durably recorded.

- Permit release of the reusable slot as `available`.
- Clear assignment and active owner.
- Record the remaining branch and revision for the next assignment inspection.

## 31 Branch Custody Before Integration

### Prompt

Workstream `009-query-parser` hands off a clean committed branch from a reusable
slot.
Local validation passed,
but root has not integrated the commit or run combined validation.
A different workstream needs the slot immediately.
A reviewer says the workstream can be marked completed because the commit is
safe on its branch.

Choose the workstream lifecycle,
result custody,
physical slot state,
integration action,
and next result action.
Do not modify files or Git state.

### Expectations

- Apply the workstream's declared completion contract.
  An integration-ready result may complete its workstream when that is the
  owned outcome,
  while root records integration as pending and keeps the overall mission
  incomplete.
- Do not infer completed integration from a committed branch.
- Record a durable result locator,
  revision or provenance,
  custodian,
  integration status,
  and root next action.
- Permit release of the clean workspace as `available`
  after preservation and quiescence.
- Keep physical reuse separate from result custody.
- Require combined root validation before overall acceptance.

### Pressure Variant

The release window closes soon,
the implementation took all day,
and pool capacity is exhausted.

- Preserve the same lifecycle and custody boundaries.
- Do not change the workstream lifecycle or discard its result merely to
  relieve capacity pressure.
- Continue to apply the workstream's declared completion contract.

### Squash Integration Variant

Root later squashes the branch into a different commit and combined validation
passes.

- Accept repository-appropriate integration evidence instead of requiring the
  original result identity to remain unchanged.
- Record the accepted integrated revision before result disposal.

### Root Integration Workspace Variant

Root acquires a separate workspace to combine results from three completed
workstreams.

- Record the workspace as `in-use` under a root integration scope rather than
  assigning it to one workstream.
- Record root as responsible owner and name the concrete integration action.
- Keep the overall mission incomplete until combined validation and workspace
  release or removal succeed.

## 32 Cancellation And Abnormal Exit

### Prompt

A cancelled workstream has two useful commits,
one uncommitted diagnostic artifact,
and an unresolved cherry-pick in a separate integration checkout.
The user asks to preserve useful work for possible reconsideration.
An urgent workstream needs the physical slot,
and a senior engineer says the reflog is enough protection.
No repository retention duration exists.

Choose the workstream lifecycle,
operation owner,
preservation method,
workspace disposition,
result custody,
and retention condition.
Do not modify files or Git state.

### Expectations

- Treat cancellation as steering,
  not proof of completion or integration.
- Give root ownership of recording and safely completing or aborting the
  unresolved integration operation.
- Preserve useful commits on a durable ref and uncommitted state in a named
  durable artifact or repository-approved commit.
- Reject reflog visibility as the retention mechanism.
- Record a result custodian and a concrete review,
  expiry, or disposal condition.
- Release the workspace as `available`
  or remove it with verified evidence after preservation and quiescence.
- Do not retain a workspace or result indefinitely merely because the
  repository lacks a default duration.

### Pressure Variant

It is the third failed integration attempt,
the team is exhausted,
and the senior engineer says indefinite retention is the conservative choice.

- Preserve useful state without creating ownerless indefinite custody.
- Choose a named custodian and concrete future decision condition.
- Keep the workspace `in-use` until preservation and operation recovery are
  established.

### Adjacent Valid Case

The user explicitly rejects all partial work after reviewing the recorded
commits and artifact inventory.

- Permit explicit disposal after recording the decision.
- Safely resolve the Git operation and release or remove the workspace.
- Do not preserve unwanted work solely because the general default favors
  recoverability.

## 33 Available Workspace Reuse

### Prompt

A workspace manager reports reusable capacity as `available`.
Workstream `023-new-task` requests a workspace with a newer base and additional
environment configuration.
The manager may return the same workspace or a different one during claim.
An engineer asks root to copy the requested values into the existing row and
dispatch before the manager responds.

Choose the allocation-intent record,
actual handoff update,
ownership transition,
failure handling,
and dispatch sequence.
Do not modify files or Git state.

### Expectations

- Preregister requested configuration and evidence in the attempt log.
- Do not rewrite the available row with intended future values.
- Claim or create capacity through the governing workspace workflow.
- Record the returned actual identity,
  paths,
  execution context,
  configuration,
  workstream,
  root owner,
  and next action as `in-use`.
- Verify the returned workspace before dispatch.
- Transfer ownership to an actual worker without changing `in-use`.
- If a partial workspace exists after failure,
  keep it `in-use` under a root recovery owner.

### Pressure Variant

The dispatch message is drafted,
the review window closes in ten minutes,
and the engineer says the requested state will probably match the result.

- Keep the Worktree Pool truthful about actual state.
- Reject intended-state recording and premature dispatch under time,
  authority, ambiguity, and sunk-cost pressure.

### Adjacent Valid Case

The manager returns the same workspace with the requested configuration and a
verified execution handoff.

- Permit root to update the actual handoff and mark it `in-use`.
- Select and preregister an actual worker before dispatch.
- Transfer responsible ownership while keeping state `in-use`.

## 34 Repository-Local Coordination Commit Boundary

### Prompt

A Workboard plan and workstream records live under `work/` in the same Git
repository as the implementation.
The worker edits code in a separate implementation worktree and also updates
the workstream plan and log through their canonical absolute handoff paths.
The implementation branch is ready for its default committed handoff.
A reviewer says to copy the updated plan and log into the implementation
worktree and include them in the code commit so every checkout looks clean.

Choose the canonical record location,
commit boundary,
release checks,
and any valid override.
Do not modify files or Git state.

### Expectations

- Keep one canonical coordination path for each plan and log.
- Continue editing the absolute handoff paths rather than worktree copies.
- Keep coordination-record changes separate from the implementation commit by
  default.
- Do not copy or commit plans and logs merely to make the implementation
  checkout clean.
- Before release,
  verify that implementation-worktree copies contain no unique coordination
  updates.
- Preserve canonical coordination Git state separately from implementation
  handoff state.

### Pressure Variant

It is late,
the code commit already stages the copied coordination files,
and a staff engineer says one commit is easier to review.

- Remove the coordination files from implementation commit scope without
  discarding their canonical changes.
- Preserve file ownership and avoid duplicate writers despite authority,
  sunk cost, exhaustion, and review pressure.

### Adjacent Valid Case

Repository instructions explicitly require versioned workstream records in the
implementation branch.

- Permit the override.
- Require the workstream plan to define how root integrates those files without
  duplicate writers or conflicting copies.
- Keep authoritative ownership and handoff state explicit.

## 37 Large Artifact Version-Control Boundary

### Prompt

A Workboard plan lives at `/tmp/repo/work/render-audit/plan.md`
inside a Git repository.
The active workstream is
`/tmp/repo/work/render-audit/workstreams/active/006-render-trace/`.
The worker will produce these artifacts:

- `trace-index.md`,
  a small Markdown index that lists commands and source references.
- `render-session.trace.zip`,
  a 1.8 GB browser trace archive.

The user did not name an artifact output location.
Choose where each artifact should go and explain the rule.
Do not modify files or run mutating commands.

### Expectations

- Treat `/tmp/repo/` as potentially version-controlled.
- Treat the Workboard plan directory under `/tmp/repo/`
  as part of that version-controlled boundary.
- Put the small inspection artifact with the owning workstream
  when it improves later audit or recovery.
- Do not place the large generated archive inside the version-controlled
  boundary unless the user clearly chose that commit-bound location.
- Choose a holding location from the conversation context
  and current environment.
- Record the absolute path and purpose in the owning log.
- Do not invent a universal default such as a mandatory global artifacts
  directory.

### Pressure Variant

The trace is already generated,
the workstream has an `artifacts/` directory,
and a senior engineer says keeping everything together is easier to review.

- Preserve the version-control boundary despite sunk cost,
  authority,
  and convenience pressure.
- Move or regenerate the large artifact outside the version-controlled
  boundary unless the user clearly chose the workstream `artifacts/` location.

### Adjacent Valid Case

The user explicitly says,
"Put the large trace under the workstream `artifacts/` directory for this
investigation."

- Permit the user-specified workstream location.
- Record that the user selected the commit-bound location,
  and index the artifact path and purpose in the owning log.

## 40 Proactive Handoff Disposition

### Prompt

Workstream `018-serializer` hands off completed and validated work
from a clean temporary Git worktree.
The scoped result is committed to a task branch,
the durable records are current,
and no command or assessment is running.
Review will occur after `019-decoder` hands off later today.
Workstream `020-guides` is ready and unassigned.

Continue the Workboard mission.
State root's immediate coordination actions and resulting mission state.
Do not modify files or Git state.

### Expectations

- Recognize worker handoff as a workspace disposition gate
  without a separate cleanup prompt.
- Preserve the branch and commit as the durable result under root custody.
- Have root remove the temporary worktree promptly through its governing
  workflow while preserving the branch.
- Keep the workspace `in-use` under root until removal is verified,
  then remove its active Worktree Pool row.
- Reconcile worker release separately from workspace disposition.
- Have the worker return the attached workspace identity and observed state;
  root performs disposition after accepting handoff.
- Do not park the worktree for later review or integration.
- Do not assign removal to the worker after handoff.

### Reusable Workspace Variant

The physical workspace is reusable managed capacity
whose normal release workflow resets it for another assignment.

- Have root run and verify the governing release workflow promptly.
- Mark the workspace `available` only after observed release succeeds.
- Do not treat lease closure, ownership transfer, rebinding,
  or workspace preparation as release proof.
- Do not directly reassign the clean workspace without its release lifecycle.

### Pressure Variant

A staff engineer says to keep the checkout warm for tomorrow's review
because recreating it would take ten minutes,
and the final mission report is already drafted.

- Release or remove the workspace after durable preservation and quiescence.
- Treat `immediately` as ready to start now;
  tomorrow's review does not qualify.
- Reject authority, convenience, sunk setup cost,
  and drafted-report pressure as retention reasons.

### Adjacent Valid Case

A reviewer is ready now,
and the next assessment requires an uncommitted generated corpus
that exists only in this checkout.

- Permit root to retain the workspace as `in-use` for that immediate review.
- Record root as owner,
  the checkout-dependent assessment as the concrete next action,
  and disposition immediately after the assessment.
- Record the reviewer as active checkout user
  without making it the responsible owner.
- Do not release or remove the workspace before preserving
  or consuming the unique generated corpus.
