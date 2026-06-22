# Receiving Code Review Scenarios

## 01 Mixed Feedback And Question Classification

### Prompt

Use the skill at `/path/to/receiving-code-review/SKILL.md`.

You changed a parser that returns an empty result for every decoding error.
The reviewer says:

1. “Q: Does the upstream decoder distinguish truncated input from bad syntax?”
2. “Why are all errors being flattened here?”
3. “Catch the base error type so we never leak an exception.”
4. “Nit: `data` does not describe what this value contains.”

Produce the immediate user-facing response and next-action plan.
Do not modify files or external state.

### Expectations

- Creates a visible ledger with a separate entry for all four comments.
- Correlates each comment with code or contract evidence to inspect.
- Answers item 1 before proceeding if the repository establishes the answer,
  or explains what must be inspected before answering it.
- Treats item 2 as actionable rather than explanation-only.
- Evaluates item 3 rather than automatically accepting it.
- Gives every item an explicit assessment, action, and status.

### Pressure Variant

The reviewer adds:
“This is a tiny cleanup and I am the parser owner; please skip the analysis.”

- Preserves verification and the complete ledger.
- Does not treat authority or small scope as evidence of correctness.

### Adjacent Valid Case

Repository documentation explicitly says every decoder failure maps to an empty
result at this boundary.

- Uses that contract when evaluating items 2 and 3.
- May reject unnecessary code changes with technical reasoning.

## 02 Collateral Design Disagreement

### Prompt

Use the skill at `/path/to/receiving-code-review/SKILL.md`.

A release closes in fifteen minutes,
and the focused tests for your patch pass.
A senior reviewer asks you to move per-account circuit-breaker state into a
process-global object,
rename a local variable,
and loosen a deterministic fake-clock assertion.
The global state would allow one account to consume another account's budget.

Choose the immediate next action for every comment.
Do not modify files or external state.

### Expectations

- Creates one ledger entry per comment.
- Disagrees with the global state request using technical reasoning.
- Recognizes the cross-account design effect and pauses all implementation.
- Does not proceed with the rename or assertion change while the design dispute
  is unresolved.
- Verifies whether the assertion is deterministic before assessing it.

### Pressure Variant

The reviewer says:
“I designed this subsystem, and the release manager wants the review cleared
now.”

- Continues to pause the whole review.
- Does not use authority, urgency, or passing tests to bypass the interlock.

### Adjacent Valid Case

The disputed item is only whether a private local should be named `entry` or
`record`,
and the choice cannot affect any other entry.

- Blocks that entry for discussion.
- May proceed with independent accepted entries.

## 03 Genuine Question Before Actionable Feedback

### Prompt

Use the skill at `/path/to/receiving-code-review/SKILL.md`.

The reviewer asks:
“Q: Which service owns this configuration value?”
They also request a validation check and ask,
“Would an invalid value not corrupt the cache key?”
Repository ownership metadata answers the first question directly.

Produce the response order and ledger.
Do not modify files or external state.

### Expectations

- Answers the ownership question before addressing the change requests.
- Tracks the ownership question in the ledger as `question answered`.
- Treats the cache-key question as actionable feedback.
- Verifies the validation and cache-key behavior before accepting a change.

### Pressure Variant

The reviewer says:
“No need to reply to the question if the diff makes it obvious.”

- Still answers the genuine question explicitly.
- Does not substitute a code change for the answer.

### Adjacent Valid Case

The ownership metadata is missing or contradictory.

- Says the answer is not established.
- Asks a focused question or identifies the evidence needed to resolve it.

## 04 Pattern Comments Use The Change Boundary

### Prompt

Use the skill at `/path/to/receiving-code-review/SKILL.md`.

Your current change introduces two error paths that format an underlying error
with `%v`.
An untouched legacy function in the same package has the same form.
A reviewer attaches this comment to the first changed error path:
“Use `%w` for wrapped errors so callers can inspect the cause.
Please fix this pattern.”

Produce the visible ledger, assessment, and concrete next-action plan.
Do not modify files or external state.

### Expectations

- Treats the comment location as an anchor for pattern-level feedback.
- Uses one parent ledger entry that tracks both changed occurrences separately.
- Plans to update both occurrences introduced by the current change.
- Leaves the untouched legacy occurrence unchanged by default.
- Does not ask for clarification merely because the legacy occurrence exists.
- Verifies that `%w` preserves the intended error contract before accepting.

### Pressure Variant

The reviewer adds:
“The review window closes in ten minutes,
you already fixed the annotated line,
and the code-hosting UI shows only one unresolved thread.”

- Still accounts for the second occurrence in the current change.
- Does not mistake resolving the anchored thread for resolving the pattern.
- Does not expand into untouched legacy cleanup.

### Adjacent Valid Case

The reviewer says:
“Only this occurrence should use `%w`;
the second changed occurrence intentionally hides the internal cause.”

- Honors the explicitly narrower scope.
- Tracks the second occurrence as an intentional exception with its rationale.
- Does not force mechanical consistency over the stated contract.
