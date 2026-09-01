---
name: receiving-code-review
description: >-
  Use when receiving or addressing code review feedback about changes you made,
  including pasted reviewer comments, inline PR comments, requested changes,
  review summaries, questions, nits,
  or direct user critique that may require replies or revisions.
---

# Receiving code review

Treat review as technical collaboration.
Account for every comment,
but do not assume every suggestion is correct or should be implemented.
Reviewers may not know the user's conversation,
accepted non-goals,
or the system's supported operating context.

## Build the feedback ledger

Before editing code:

1. Read the complete feedback without acting on individual comments.
2. Establish the reviewed diff and authorized outcome.
   Identify its base and inspect the files and hunks it changed,
   or record the explicit boundary supplied by the user.
3. Give every raw comment a stable ID,
   including questions, nits, and repeated-looking comments.
4. Correlate each comment with the referenced code and any surrounding symbol,
   caller, test, contract, or history needed to assess it.
5. Record a visible ledger in chat with these fields:
   `ID | feedback | context and scope | assessment | action | status | evidence`.

Keep comments as separate entries even when one change may address several.
Use `pending`, `in progress`, `blocked`, or `done` for status.

Classify questions from their context,
not only punctuation or a `Q:` prefix.
Answer a genuine request for information before actionable feedback,
and record it as `question answered`.
Treat a rhetorical question as a technical claim to assess.
If the intent is unclear,
ask whether the reviewer wants an explanation, a change, or both.
Do not substitute a patch for an answer.

The current change is the default scope.
The user or reviewer may explicitly narrow the relevant feedback scope.
Only the user or authorized operator may approve materially broader work.

### When feedback describes a pattern

Treat the comment location as an anchor,
then inventory every semantically equivalent occurrence introduced or modified
by the current change.
Do not modify matching occurrences in untouched pre-existing code without
explicit authorization,
and do not treat a textual match as proof of semantic equivalence.

Under each applicable pattern entry,
give every verified in-scope occurrence one disposition:

- change required
- already compliant
- intentional exception or semantic nonmatch,
  with the scope or semantic reason

Record plausible candidates that required inspection before exclusion.
Evaluate an occurrence under every applicable pattern entry,
even when another entry already accounts for that location.
Before marking the entry done,
repeat its scope discovery against the edited change
and reconcile the final inventory and dispositions.

## Assess every entry

Verify each claim against the repository and relevant external contract.
When the claim depends on inputs, actors, trust boundaries, concurrency,
lifecycle, failure modes, or safeguards,
establish those parts of the supported execution and risk models from user
direction, local architecture, actual callers, deployment,
and other authoritative evidence.
Investigate credible or uncertain correctness and security concerns,
including premises used to exclude a finding.

For each entry:

1. Restate the technical claim precisely.
2. Separate technical possibility,
   reachability under the supported model,
   actual impact,
   and whether the proposed remedy fits the authorized design.
3. Record one assessment:
   `accept`, `inapplicable`, `disagree`, `unclear`, or `question answered`.
4. Record the next action and supporting evidence.

Reserve `inapplicable` for a failure premise excluded by the verified model.
An applicable concern remains applicable when its proposed remedy violates an
existing contract,
adds unnecessary architecture,
or has a smaller supported fix.
Evaluate the concern separately from the proposed remedy.

Tests, mocks, and the review comment are evidence,
not automatically the intended behavior.
Check the real boundary before changing external behavior.

## Apply the disagreement interlock

An evidence-backed `inapplicable` assessment does not reopen the user's
established scope.
Explain the verified boundary and continue independent accepted work.

When the intended contract, applicable risk, or authorized scope remains
contested,
discuss the disagreement with the user before acting on that entry.
Do not implement the suggestion,
an alternative fix for the same concern,
or a design decision that would prejudge the discussion.

Classify the disagreement by blast radius:

- For an isolated minor item,
  mark the entry `blocked`, explain the disagreement,
  and continue independent accepted entries.
- For unresolved collateral effects involving an API contract, data model,
  architecture, security boundary, concurrency model,
  or other ledger entries,
  pause all implementation and ask for the user's direction.

When an action is unclear,
mark it `blocked` and ask a focused question before editing it.
Treat uncertainty about blast radius as a reason to pause the whole review.

## Implement and reconcile

If no whole-review interlock is active:

1. Implement only accepted, sufficiently clear entries and their verified
   in-scope pattern occurrences.
   Remove unnecessary review-introduced mechanisms when that resolves their
   derivative findings without changing required behavior.
2. Update each entry's status as work progresses.
3. Add or update regression coverage for each confirmed bug.
   A bug fix is not complete unless the regression test fails without the fix
   and passes with it,
   or the reason a regression test cannot be written is explained.
4. Run focused validation and any broader checks justified by the change.
5. Compare the cumulative result with the authorized outcome,
   then repeat every pattern entry's occurrence sweep.
6. Re-read the raw feedback and reconcile it with the ledger.
   Verify that every comment has one entry,
   every pattern entry has a complete occurrence inventory,
   and every occurrence has a final disposition and status.
7. Report the final disposition and evidence for every entry.

“Addressed all feedback” means every comment was correlated,
evaluated, answered,
and either completed or left with an explicit blocker or decision.
It does not mean every suggestion was implemented.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
