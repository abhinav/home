# ADR format variants

Use the repository template and established records when they define an ADR
format.
Preserve their section names, ordering, and level of detail.
Do not introduce a second format merely because this reference uses different
defaults.

When the repository has no established format, use the default record below.
Use a compact record only when it preserves the same decision-time model
without ambiguity.
Add optional sections when they give the reader useful evidence or distinctions.

## Default record

Every ADR must make these parts recoverable:

- **Title:** Identify the decision, not only the problem.
- **Status:** State the lifecycle position when the request or inspected
  evidence establishes it and another source does not make it clear.
- **Context:** State the facts, forces, constraints, and trigger.
- **Decision:** State the chosen response, scope, and material boundaries.
- **Consequences:** State the resulting benefits, costs, risks, and constraints.

When Status applies, put it immediately after the title and before Context.
Do not infer Status from future-tense wording or from the act of drafting an ADR.

```markdown
# <Decision title>

## Status

<Established lifecycle position and supersession link when applicable.>

## Context

<Decision-time facts, forces, constraints, and trigger.>

## Decision

<Chosen response, scope, and material boundaries.>

## Consequences

<Positive, negative, and neutral effects that matter later.>
```

Omit Status when it is unknown or established elsewhere.
Required headings do not authorize inferred content.
When Context, Decision, or Consequences lacks necessary evidence-backed content,
state the material evidence gap in that section.
Do not elaborate the supplied decision merely to fill the template.

Rationale can appear in Context, Decision, or an optional Rationale section.
Use headings only for sections that contain useful content.
Do not emit an empty optional heading, placeholder text, template commentary,
or `N/A` only to preserve a template.

## Compact record

Use a compact record when one short passage can state the decision,
decision-time reason, and material consequences without ambiguity.

```markdown
# Use opaque resource identifiers

Public APIs will use opaque identifiers because clients retain identifiers
across data imports.
Database-local sequence numbers can still be used internally.
The public boundary must translate those numbers,
and operators cannot infer creation order from public identifiers.
```

A compact record can still include a code shape or plain-text diagram.
Do not omit a useful structural aid merely to keep the prose to one paragraph.

## Optional sections

Add an optional section only when its evidence-backed content changes what the
reader can understand, evaluate, or revisit:

- **Decision drivers:** Separate several forces that the decision must balance.
- **Alternatives considered:** Preserve rejected choices and the tradeoffs that
  distinguish them when those choices can plausibly recur.
- **Rationale:** Explain why the decision fits the context when that reasoning
  would be difficult to recover from Context or Decision.
- **Non-goals:** Exclude a nearby interpretation that would materially expand
  the decision's scope.
- **Acceptance:** Give observable criteria or point to the smallest useful
  evidence that shows whether the implemented result satisfies the decision.
- **References:** Link evidence or related decisions needed to evaluate the
  record.

Preserve repository ordering when it exists.
Without an established order, put decision analysis before Decision,
then put Acceptance and References after Consequences.

Do not add an Implementation Plan merely because the ADR is detailed.
Put file changes, task sequencing, rollout steps, and test procedures in the
artifact that owns implementation.
Link that artifact when the connection helps the reader.

## Apply lifecycle metadata

Use the repository's established status vocabulary.
Common states include Proposed, Accepted, Rejected, Deprecated,
and Superseded.

When a proposal is rejected,
preserve the reason that completed the review outcome.
New evidence belongs in a new proposed ADR that links to the rejected record;
it does not make the historical rejection disappear.

A superseding ADR should identify the record it replaces.
After the new ADR is accepted,
the old ADR should identify and link to its replacement.
Keep the old decision and rationale intact.

Status records the decision lifecycle.
Acceptance evaluates the result of applying the decision.
A change to acceptance evidence does not by itself change the decision.

## Write decision analysis

Describe alternatives by the same decision drivers.
Do not give the chosen option detailed evidence while reducing rejected options
to labels or strawmen.
Omit an alternative when it does not help a future reader understand or revisit
the decision.

Consequences describe the context created by the decision.
They are not a disguised task list.
Include positive, negative, and neutral consequences when material.
Do not manufacture one item in each category for symmetry.
