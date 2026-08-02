# Designing reviewable stacks

Use this reference before planning multiple branches for one requested outcome,
or splitting existing work into review branches.

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

A branch is warranted when its incremental diff is coherent and testable
and folding it into an adjacent branch would hide a material review decision.
When separation would leave a diff without the implementation, context,
or validation needed to evaluate it,
revise the branch contents or boundaries so each review unit is self-contained.

Use stack position to express dependencies between established review units.

## Maintain self-contained review units

As work evolves,
re-evaluate whether each incremental diff remains self-contained.
Keep the implementation, context, and validation together
in the review unit whose outcome they establish.

When revised boundaries change existing branches,
use the appropriate git-spice amend or fixup workflow
and restack the affected upstack.

A newly distinct outcome may remain separate
when its incremental diff forms a self-contained review unit.

## Inspect the incremental diffs

Before handoff, inspect each branch against its parent and verify that:

- The diff tells one coherent story.
- The branch's outcome is understandable with its downstack dependencies.
- Its tests establish the behavior introduced by that review unit.
- Its commit message describes the branch's own outcome.
- Its incremental diff contains the implementation, context, and validation
  needed for review.

If a branch fails this inspection,
revise its contents or the branch boundaries before handoff.
