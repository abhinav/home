---
name: receiving-code-review
description: >-
  Use when receiving or addressing code review feedback about changes you made,
  including pasted reviewer comments, inline PR comments, requested changes,
  review summaries, questions, nits,
  or direct user critique that may require replies or revisions.
---

# Receiving Code Review

Treat review as technical collaboration.
Account for every comment,
but do not assume every suggestion is correct or should be implemented.

## Build The Feedback Ledger

Before editing code:

1. Read the complete feedback without acting on individual comments.
2. Give every comment a stable number,
   including questions, nits, and repeated-looking comments.
3. Correlate each comment with its code-level context.
   Inspect the referenced lines, surrounding symbol, callers, tests,
   relevant contracts, and history when they affect the claim.
4. Determine the scope of each comment.
   A comment's location is an anchor,
   not necessarily the full scope of the feedback.
   When a comment describes a pattern, rule, or invariant,
   identify every semantically equivalent occurrence introduced or modified by
   the current change.
5. Record a visible ledger in chat that preserves each comment's stable ID,
   feedback, code context, scope, assessment, action, and status.

Every raw comment must map to one ledger entry.
Keep comments separate even when one change may address several.
For pattern feedback,
the entry must account separately for every verified in-scope occurrence.
Choose a representation that keeps comments, occurrences,
and their statuses unambiguous.

The current change is the default scope.
An explicitly narrower or broader scope from the reviewer or user overrides the
default.
Do not modify matching occurrences in untouched pre-existing code unless the
reviewer or user explicitly expands the scope.
Do not use a textual match alone as proof that two occurrences are equivalent;
inspect their behavior and note intentional exceptions.
Ask for clarification only when the requested scope conflicts with this default
or the change boundary cannot be established.

## Classify Questions Before Review Actions

Determine whether each question is genuine or rhetorical from its context,
not only its punctuation or a `Q:` prefix.

- A genuine question asks for information and does not imply a code or comment
  change.
  Inspect enough context to answer it,
  then answer it before addressing the actionable feedback.
- A rhetorical question indicates a concern or proposed improvement.
  Track it as actionable feedback and state the code, comment,
  or test change that would resolve the concern.
- If the intent is unclear,
  ask whether the reviewer wants an explanation, a change, or both.

Do not silently translate a genuine question into a patch.
Do not dismiss a rhetorical question with an explanation alone.

## Verify And Evaluate Every Item

For each ledger entry:

1. Restate the technical claim precisely.
2. Verify the claim against the repository and relevant external contract.
3. Evaluate correctness, soundness, and compatibility with the design.
4. Record one assessment:
   `accept`, `disagree`, `unclear`, or `question answered`.
5. Respond with assent and a reason when accepting,
   or technical reasoning when disagreeing.

Tests, mocks, and the comment itself are evidence,
not automatically the intended behavior.
Check the real boundary when the proposed change would alter external behavior.

## Use The Disagreement Interlock

Discuss every disagreement with the user before acting on that item.
Do not implement the suggestion,
an alternative fix for the same concern,
or a design decision that would prejudge the discussion.

Classify the disagreement by blast radius:

- For an isolated minor item,
  mark the entry `blocked on discussion`, explain the reasoning,
  and wait on that entry.
  Independent accepted items may proceed.
- For an item with collateral effects,
  such as an API contract, data model, architecture, security boundary,
  concurrency model, or changes spanning other ledger entries,
  pause all implementation.
  Explain the affected decisions and wait for the user's direction.

When an action is unclear,
mark it `needs clarification` and ask a focused question before editing it.
Treat uncertainty about blast radius as a reason to pause the whole review.

## Implement From The Ledger

If no whole-review interlock is active:

1. Implement only accepted, sufficiently clear items and their verified
   in-scope pattern occurrences.
2. Update each entry as work progresses:
   `pending`, `in progress`, `blocked`, or `done`.
3. Add or update regression coverage for each confirmed bug.
   A bug fix is not complete unless the regression test fails without the fix
   and passes with it,
   or the reason a regression test cannot be written is explained.
4. Run focused validation and any broader checks justified by the change.
5. Re-read the raw feedback and reconcile it against the ledger.
6. Report the final disposition and evidence for every entry.

Do not use “addressed all feedback” to mean “implemented every suggestion.”
It means every comment was correlated, evaluated, answered,
and either completed or left with an explicit blocker or decision.

## Red Flags

Stop and repair the process when you notice any of these thoughts:

- “The reviewer asked for it, so I should just implement it.”
- “This is only a nit; it does not need a ledger entry.”
- “The question is probably rhetorical.”
- “The patch answers the question, so no written answer is needed.”
- “I can make the undisputed edits while the design disagreement waits.”
- “These two comments look similar, so one ledger entry is enough.”
- “The comment is attached to one line, so only that line counts.”
- “The pattern also exists in untouched code, so this review must clean it up.”

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
