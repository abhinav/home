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
and exercise independent engineering judgment about its claim and remedy.
Reviewers may not know the user's conversation,
accepted non-goals,
or the system's supported operating context.
Requirements and evidence govern the change;
review feedback supplies claims to evaluate, not new product authority.

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
- no change or follow-up, with the relevance and cost rationale

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
Use the smallest check that can resolve uncertainty material to the disposition,
including premises used to exclude a finding.

For each entry:

1. Restate the technical claim precisely.
2. Separate technical possibility,
   reachability under the supported model,
   actual impact,
   and whether the proposed remedy fits the authorized design.
3. Record one assessment:
   `accept`, `inapplicable`, `disagree`, `unclear`, or `question answered`.
4. Separately choose an action: fix, no change, investigate, follow-up,
   or operator decision.
   Record the supporting evidence and status.

An `accept` assessment accepts the technical claim, not necessarily its remedy
or a commitment to change code.

Reserve `inapplicable` for a failure premise excluded by the verified model.
An applicable concern remains applicable when its proposed remedy violates an
existing contract,
adds unnecessary architecture,
or has a smaller supported fix.
Evaluate the concern separately from the proposed remedy.

Tests, mocks, and the review comment are evidence,
not automatically the intended behavior.
Check the real boundary before changing external behavior.

## Choose a proportionate disposition

First establish why the behavior matters to the requested outcome.
Use supported workflows, foreseeable mistakes, actual callers,
and credible adversarial paths to assess the trigger and consequence.
A parser's accepted input domain establishes technical possibility;
the product's requirements and operating context establish what needs support.
An unusual configuration can expose a real limitation without making support
for it a requirement.

For security concerns, identify who controls the trigger,
what capabilities they have, and what protected resource or authority is affected.
An adversary can deliberately choose uncommon inputs;
ordinary input frequency does not bound that risk.
Credible security failures and rare failures with severe consequences warrant
investigation without a prior incident.
Missing evidence about reachability is uncertainty, not proof of rarity or safety.

Assess severity independently of the reviewer's priority label.
When a change is warranted, seek the smallest adequate remedy at the component
that owns the behavior.
Compare its benefit with implementation, validation, rollout, runtime,
and continuing maintenance costs, including added compatibility obligations.
Patch size alone does not establish that a change is useful.
Evaluate the cumulative result, including mechanisms introduced by earlier
review fixes, against the authorized outcome.

Choose and record a disposition:

- Fix confirmed defects that violate requirements or have material consequences
  under supported use or a credible threat model.
  Favor small useful improvements that fit the change.
- Choose no change when the claim is disproven, already satisfied,
  excluded by the verified model, or does not justify work in this change.
  For a real remaining limitation, state its trigger, consequence,
  practical relevance, and why the benefit does not justify the cost.
  Routine trade-offs within the authorized outcome belong to the implementing
  agent; they need neither proof that the trigger is impossible nor a prior
  operator waiver for that individual case.
- Investigate unresolved claims with a check that can change the decision.
  Keep uncertainty visible until the relevant evidence is available.
- Recommend follow-up for worthwhile independent work or broader design.
  State whether this change can safely proceed and the next decision needed,
  without inventing an owner, commitment, or completed follow-up.
- Seek an operator decision when satisfying the concern requires material
  expansion, changing an established promise, or accepting a material risk.
  Explain the requirement, affected callers, smaller supported alternatives,
  durable benefit, and ownership, security, validation, and rollout costs.
  Low likelihood or high cost does not waive a hard requirement.

## Escalate decisions that require authority

Resolve technical disagreement from evidence within the established contract.
Explain a rejected suggestion or a no-change disposition and continue the work.
A reviewer's insistence does not itself create an unresolved product decision.

When authoritative requirements conflict or the intended contract,
applicable risk, or authorized scope needs an operator decision,
ask before implementing that entry or an alternative that would prejudge it.
Name the unresolved decision and identify which other entries depend on it.
Mark those entries `blocked`; continue independent accepted work.
Pause all implementation only when that decision governs the whole change
or its effects cannot be safely isolated.
If independence is unclear, inspect the relevant dependencies before editing
affected code and present the remaining uncertainty with the decision request.

## Implement and reconcile

For entries whose disposition permits implementation:

1. Implement only accepted, sufficiently clear fixes and their verified
   in-scope pattern occurrences.
   Remove unnecessary review-introduced mechanisms when that resolves their
   derivative findings without changing required behavior.
2. Update each entry's status as work progresses.
3. Add or update regression coverage for each bug being fixed.
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
