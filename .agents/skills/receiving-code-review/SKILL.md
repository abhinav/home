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
Account for every comment and independently assess its claim and remedy.
Requirements and evidence govern the change;
review claims do not supply new product authority.
Reviewers may lack the user's conversation, accepted non-goals,
or supported operating context.

## Build the feedback ledger before editing code

1. Read the complete feedback without acting on individual comments.
2. Establish the reviewed diff and authorized outcome:
   identify its base and inspect changed files and hunks,
   or record the explicit boundary supplied by the user.
3. Give every raw comment a stable ID, including questions, nits,
   and repeated-looking comments.
4. Correlate each with its code and surrounding symbols, callers, tests,
   contracts, or history needed for assessment.
5. Record a visible ledger in chat:
   `ID | feedback | context and scope | assessment | action | status | evidence`.

Keep comments separate even when one change addresses several.
Statuses are `pending`, `in progress`, `blocked`, or `done`.
Classify questions by context, not punctuation or a `Q:` prefix.
Answer genuine information requests before actionable feedback;
record the assessment as `question answered`.
Assess rhetorical questions as technical claims.
If intent is unclear, ask whether the reviewer wants an explanation, a change, or both.
Do not substitute a patch for an answer.

The current change is the default scope;
the user or reviewer may explicitly narrow the relevant feedback scope.
Only the user or authorized operator may approve materially broader work.

### Inventory patterns

Use a pattern comment's location as an anchor.
Inventory every semantically equivalent occurrence introduced or modified
by the current change; textual matches do not establish equivalence.
Do not modify untouched pre-existing matches without explicit authorization.
Under every applicable pattern entry, give each verified in-scope occurrence
a disposition:

- change required;
- already compliant;
- intentional exception or semantic nonmatch, with the scope or semantic reason;
- no change or follow-up, with relevance and cost rationale.

Record plausible candidates inspected before exclusion.
Evaluate each occurrence under every applicable pattern,
even when another entry accounts for its location.
Before marking a pattern entry done, repeat discovery against the edited change
and reconcile its complete inventory, final dispositions, and statuses.

## Evaluate claims and remedies separately

Verify each claim against the repository and relevant external contract.
For claims depending on inputs, actors, trust boundaries, concurrency,
lifecycle, failures, or safeguards, establish the supported execution and risk models
from user direction, local architecture, actual callers, deployment,
and other authoritative evidence.
Use the smallest check that can resolve uncertainty material to disposition,
including premises used to exclude a finding.
Tests, mocks, and comments are evidence, not automatically intended behavior;
check the real boundary before changing external behavior.

For each entry:

1. Restate the technical claim precisely.
2. Distinguish possibility, reachability under the supported model, actual impact,
   and whether the remedy fits the authorized design.
3. Assess as `accept`, `inapplicable`, `disagree`, `unclear`, or `question answered`.
4. Separately choose fix, no change, investigate, follow-up, or operator decision;
   record evidence and status.

`accept` accepts the claim, not necessarily its remedy
or a commitment to change code.
Reserve `inapplicable` for failure premises excluded by the verified model.
An applicable concern remains applicable when its proposed remedy violates a contract,
adds unnecessary architecture, or has a smaller supported fix.

### Establish relevance, risk, and cost

First establish why behavior matters to the requested outcome.
Assess triggers and consequences through supported workflows, foreseeable mistakes,
actual callers, and credible adversarial paths.
Parser-accepted inputs establish possibility;
product requirements and operating context establish required support.
An unusual configuration may expose a real limitation without requiring support.

For security, identify who controls the trigger, their capabilities,
and the protected resource or authority affected.
Adversaries may deliberately choose uncommon inputs;
ordinary frequency does not bound that risk.
Credible security failures and rare severe failures warrant investigation
without a prior incident.
Missing reachability evidence is uncertainty, not proof of rarity or safety.
Assess severity independently of reviewer priority labels.

When change is warranted, seek the smallest adequate remedy
at the component owning the behavior.
Compare benefits with implementation, validation, rollout, runtime,
maintenance, and added compatibility costs; patch size does not establish usefulness.
Evaluate the cumulative result, including mechanisms from earlier review fixes,
against the authorized outcome.

### Choose a disposition

- Fix confirmed defects violating requirements or with material consequences
  under supported use or a credible threat model.
  Favor small useful improvements fitting the change.
- Choose no change for disproven or already-satisfied claims,
  premises excluded by the verified model, or concerns not justifying work here.
  For real remaining limitations, state trigger, consequence, practical relevance,
  and why benefit does not justify cost.
  Routine tradeoffs within the authorized outcome belong to the implementing agent;
  they need neither proof of impossible triggers nor prior operator waivers.
- Investigate unresolved claims with checks that can change the decision;
  keep uncertainty visible until relevant evidence arrives.
- Recommend follow-up for worthwhile independent work or broader design.
  State whether this change can safely proceed and the next decision,
  without inventing ownership, commitments, or completed follow-up.
- Seek an operator decision when satisfying the concern requires material expansion,
  changing an established promise, or accepting material risk.
  Explain the requirement, affected callers, smaller supported alternatives,
  durable benefit, and ownership, security, validation, and rollout costs.
  Low likelihood or high cost cannot waive a hard requirement.

## Resolve authority before dependent implementation

Resolve technical disagreement through evidence within the established contract.
Explain rejected suggestions or no-change dispositions and continue;
reviewer insistence alone does not create an unresolved product decision.

When authoritative requirements conflict, or the intended contract,
applicable risk, or authorized scope requires an operator decision,
ask before implementing that entry or any alternative prejudging it.
Name the decision and dependent entries; mark those entries `blocked`
and continue independent accepted work.
Pause all implementation only if the decision governs the whole change
or effects cannot be safely isolated.
If independence is unclear, inspect dependencies before editing affected code
and present remaining uncertainty with the decision request.

## Implement and reconcile

For entries whose disposition permits implementation:

1. Implement only accepted, sufficiently clear fixes
   and their verified in-scope pattern occurrences.
   Remove unnecessary review-introduced mechanisms when doing so resolves
   derivative findings without changing required behavior.
2. Update entry statuses as work progresses.
3. Add or update regression coverage for each bug fixed.
   Completion requires a test failing without the fix and passing with it,
   or an explanation of why a regression test cannot be written.
4. Run focused validation and broader checks justified by the change.
5. Compare the cumulative result with the authorized outcome,
   then repeat every pattern entry's occurrence sweep.
6. Re-read raw feedback against the ledger:
   every comment needs one entry, every pattern a complete occurrence inventory,
   and every occurrence a final disposition and status.
7. Report each entry's final disposition and evidence.

“Addressed all feedback” means every comment was correlated, evaluated, answered,
and completed or left with an explicit blocker or decision;
it does not mean every suggestion was implemented.
