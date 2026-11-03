# Designing reviewable stacks

Read before planning multiple branches for one outcome or splitting review units.
Distinguish development branches from the review and merge stack these criteria govern.
When worktrees and subagents are available, read
[Parallel development](parallel-development.md) before choosing how to develop
independent parts against a shared contract and assemble review branches.

## Keep every merged prefix deployable

Default to bottom-up merges with deployment after each.
Every merged prefix must leave trunk healthy and passing required checks,
even if nothing above it lands.
Branches may depend on downstack, never on upstack to build, pass checks, or operate.

Establish each merge's release state alongside its review outcome.
Check compatibility with coexisting rollout code, configuration, and persisted data.
Land compatible support before activation; retire old behavior only after consumers
no longer need it.
Record deployment prerequisites and the evidence needed to satisfy them.
Reorder, provide a compatible transition, or combine inseparable changes
when a boundary would leave an unhealthy intermediate state.

## Establish review boundaries before creation

Each branch delivers one coherent engineering outcome;
its incremental parent diff must be understandable and testable with downstack dependencies.
Follow outcomes and dependencies, not implementation chronology or file organization.
For each proposed branch, establish:

- Its outcome and required downstack outcomes.
- Validation of its behavior.
- The independent review decision lost by folding it into an adjacent branch.
- The deployable state after merge, compatibility requirements, and health evidence.

That decision must justify another branch's review and coordination cost;
line count alone neither establishes nor disqualifies a branch.
Keep implementation, tests, and necessary documentation together for the same outcome.
Revise contents or boundaries if separation deprives a unit of implementation,
context, or validation needed for review.
Use stack position to express dependencies between established units.

Give substantial behavior-preserving refactors their own branch:
below behavior when it improves inspection, above when existing structure makes
the behavior easier to inspect.
Validate equivalence against the refactor's parent, including behavior introduced below.
Small necessary structural edits can stay with behavior when changed decisions remain visible.
If separation creates contrived intermediates or an incomplete change,
keep necessary edits together and explain their relationship.

## Recheck the resulting stack

As work changes, keep each diff self-contained and each release state healthy,
with implementation, context, and validation in their outcome's unit.
Change existing boundaries through appropriate amend or fixup workflows,
then restack affected upstack.
Newly distinct outcomes may remain separate under the same review and release criteria.

Before handoff, inspect each branch against its parent:

- One coherent story, understandable with downstack dependencies.
- Implementation, context, and validation sufficient for that unit's review.
- Tests establish its introduced behavior; its commit message describes its own outcome.
- Relevant checks pass without upstack, and release conditions cover deployment between merges.
- Separate refactors preserve parent behavior; retained structural edits leave decisions visible.

Revise contents or boundaries before handoff if any check fails.
