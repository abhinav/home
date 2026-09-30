# Designing reviewable stacks

Use this reference before planning multiple branches for one requested outcome,
or splitting existing work into review branches.

## Keep every merged prefix deployable

Design for bottom-up merges with deployment after each merge by default.
After any number of branches have merged,
trunk must pass its required checks and remain healthy
even if the rest of the stack never lands.
A branch may depend on changes below it;
it must not need a change above it to build, pass checks, or operate correctly.

Establish the release state produced by each merge alongside its review outcome.
Check compatibility with the code, configuration, and persisted data
that can coexist during the target's rollout.
Land compatible support before activating its use,
and retire old behavior only when its consumers no longer require it.
Record any deployment prerequisite and the evidence needed to satisfy it.
If a proposed boundary leaves an unhealthy intermediate state,
reorder the changes, provide a compatible transition,
or combine inseparable changes into one coherent review unit.

## Treat each branch as a review unit

A stacked branch represents one coherent engineering outcome.
Its incremental diff against its parent is a self-contained review unit.
It gives a reviewer enough implementation, context, and validation
to understand the decision and verify the relevant behavior
with the branch's downstack dependencies.

Review boundaries follow engineering outcomes and dependencies,
rather than implementation chronology or file organization.

## Establish the boundary before creating the branch

For every proposed branch, identify:

1. The outcome the branch delivers.
2. The downstack outcomes it depends on.
3. The validation that establishes its behavior.
4. The independent review decision that would be lost if it were folded
   into an adjacent branch.
5. The state that could be deployed after this merge,
   its compatibility requirements, and the evidence that it remains healthy.

A branch is warranted when its incremental diff is coherent and testable
and folding it into an adjacent branch would hide a material review decision.
That decision must justify another branch's review and coordination cost;
line count alone does not establish or disqualify it.
Keep a feature's implementation, tests, and necessary documentation together
when they establish the same outcome.
When separation would leave a diff without the implementation, context,
or validation needed to evaluate it,
revise the branch contents or boundaries so each review unit is self-contained.

Use stack position to express dependencies between established review units.

## Separate refactors from behavior changes

Give a substantial behavior-preserving refactor its own review branch
so the reviewer can verify equivalence separately from changed behavior.
Put it below the behavior change when it makes that change easier to inspect,
or above when the behavior change is clearer in the existing structure.
Validate equivalence against the refactor's parent,
including any behavior introduced below it.

Small structural edits needed to express the behavior change can stay with it
when the changed decisions remain directly visible.
If separation would require contrived intermediate code
or leave an incomplete change,
keep the necessary edits together and explain their relationship.

## Maintain self-contained review units

As work evolves,
re-evaluate whether each incremental diff remains self-contained
and each resulting release state remains healthy.
Keep the implementation, context, and validation together
in the review unit whose outcome they establish.

When revised boundaries change existing branches,
use the appropriate git-spice amend or fixup workflow
and restack the affected upstack.

A newly distinct outcome may remain separate
when it meets the same review and release criteria.

## Inspect the incremental diffs

Before handoff, inspect each branch against its parent and verify that:

- The diff tells one coherent story.
- The branch's outcome is understandable with its downstack dependencies.
- Its tests establish the behavior introduced by that review unit.
- Its commit message describes the branch's own outcome.
- Its incremental diff contains the implementation, context, and validation
  needed for review.
- Its resulting tree passes the relevant checks without upstack changes,
  and its release conditions account for deployment between merges.
- Each separate refactor preserves its parent's behavior,
  and structural edits retained with behavior leave changed decisions visible.

If a branch fails this inspection,
revise its contents or the branch boundaries before handoff.
