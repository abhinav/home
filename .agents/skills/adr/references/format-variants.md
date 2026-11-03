# ADR format variants

Repository templates and established records govern section names, ordering,
and detail; do not introduce a competing format.
Without precedent, use the default below.
Use a compact form only when it preserves the same decision-time model unambiguously.

## Default record

```markdown
# <Decision, not just the problem>

## Status

<Established lifecycle state and supersession link, when applicable.>

## Context

<Decision-time facts, forces, constraints, and trigger.>

## Decision

<Chosen response, scope, and material boundaries.>

## Consequences

<Material benefits, costs, risks, and constraints.>
```

Include Status immediately after the title only when request or evidence establishes
it and another source does not make it clear.
Drafting and future tense do not establish status.
For missing necessary Context, Decision, or Consequences content, state the material
evidence gap; do not invent content to fill headings.
Rationale may sit in Context, Decision, or its own useful section.
Remove empty optional headings, placeholders, template commentary, and filler `N/A`.

## Compact record

Use one short passage when it preserves decision, reason, and material consequences:

```markdown
# Use opaque resource identifiers

Public APIs will use opaque identifiers because clients retain identifiers
across data imports.
Database-local sequence numbers can still be used internally.
The public boundary must translate those numbers,
and operators cannot infer creation order from public identifiers.
```

Retain useful code shapes and plain-text diagrams even in a compact record.

## Optional sections

Add a section only when evidenced content helps the reader evaluate or revisit
the decision.

| Section | Use when |
| --- | --- |
| Decision drivers | Several forces need to be distinguished. |
| Alternatives considered | Rejected choices and their tradeoffs could plausibly recur. |
| Rationale | Context and Decision do not make the fit clear. |
| Non-goals | A nearby interpretation would materially expand scope. |
| Acceptance | Observable criteria or evidence show whether the result satisfies the decision. |
| References | Related decisions or evidence are needed to evaluate the record. |

Follow repository ordering; otherwise put analysis before Decision and
Acceptance and References after Consequences.
Implementation tasks, rollout steps, and test procedures belong in their owning
artifact, linked when useful; detail alone does not justify an Implementation Plan.

## Lifecycle and analysis

Use repository status vocabulary, commonly Proposed, Accepted, Rejected,
Deprecated, or Superseded.
Preserve the reason a proposal was rejected.
New evidence belongs in a new proposed ADR linked to the rejected record.
Follow the main skill's supersession procedure without changing historical rationale.
Status tracks decision lifecycle; Acceptance evaluates implementation results.
Changed acceptance evidence alone does not change the decision.

Compare alternatives against the same drivers with fair evidence for each;
omit alternatives that do not help future evaluation.
Consequences describe the context the decision creates, not implementation tasks.
Include positive, negative, and neutral effects when material, without manufacturing
one of each for symmetry.
