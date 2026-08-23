---
name: adr
description: >
  Create, revise, review, or decide whether to create Architecture Decision
  Records (ADRs) and decision logs. Use when a significant technical decision
  needs durable rationale for future maintainers or agents, or when an existing
  ADR must inform a current design choice. Do not use merely because work
  touches architecture, or for implementation plans and system descriptions
  that do not record a decision.
---

# Architecture decision records

An ADR preserves a decision made under a particular set of conditions.
Write it so a future human or agent can decide whether the decision still
applies without blindly preserving or reversing it.

The reader does not share the original conversation, investigation,
or project history.
Include every prerequisite, baseline, force, constraint,
and scope distinction the reader needs to understand and evaluate the decision.
Omit only background that cannot change that evaluation.
Do not satisfy a length limit by removing necessary context.

An ADR is not a complete architecture description,
an implementation plan, a discussion transcript, or an enforcement mechanism.
Code and current configuration establish what the system does now.
An ADR establishes what was decided and why.

The collection of ADRs is the decision log.
Its titles give readers a scannable map of the project's strategic choices;
each record supplies the context and rationale behind one choice.

## Choose the disposition

Choose the disposition from user intent, repository practice,
the decision's consequences, and the value of durable rationale.
None of those signals is a universal gate.
A project can deliberately keep a broad decision log;
follow that practice instead of imposing a narrower significance threshold.

Choose depth from the same context,
the complexity of the decision, and the available evidence.
Compact and detailed ADRs are both normal outcomes.
Do not make compactness or omission the default.

Choose the action that preserves useful decision history:

| Condition | Action |
| --- | --- |
| A current significant decision needs durable rationale | Create an ADR. |
| A proposed decision is still being clarified | Revise the proposed ADR. |
| An implemented accepted decision changes | Create a new ADR that supersedes it. |
| Only lifecycle metadata changes | Update status and cross-links. |
| An existing ADR already governs the decision | Keep and reference it. |
| Neither durable rationale nor repository practice supports a record | Omit the ADR. |
| Writing an ADR is useful but not authorized | Propose it without creating it. |
| Past rationale cannot be established | Do not backfill or invent it. |

When repository practice does not settle the disposition, ask:

> Will a future reader need the decision-time rationale
> to evaluate or safely change this part of the system?

Signals include costly reversal, system structure, quality attributes,
dependencies and coupling, interfaces and published contracts,
construction techniques such as libraries, frameworks, tools, and processes,
external constraints, non-obvious deviations, recurring debate,
or consequences that code cannot explain.
These signals guide judgment; they are not a checklist that every ADR must
satisfy.

Without a broader repository practice,
routine local choices, established patterns, and cheaply reversible changes
usually belong in code, tests, or implementation documentation.

## Establish the reader context

Before choosing a format or drafting prose,
inventory the supplied and inspected concepts that the decision relies on.
For each prerequisite, choose one disposition:

- Define it before the ADR reasons from it.
- Link a stable source that defines it for the same audience and scope.
- Omit it only when it cannot change how the reader evaluates the decision.

Account for every system boundary, actor, baseline, invariant,
force, constraint, and scope distinction used by the decision.
A supplied project-specific definition is necessary when it establishes a
material actor, boundary, state, invariant, scope, or causal relationship.
Do not rely on ordinary-language inference when the supplied definition carries
one of those distinctions.
Current-team familiarity and a requested length limit do not make a prerequisite
optional.
Compress necessary context when useful; do not delete it.
Do not draft until each prerequisite has one disposition.

## Establish the repository convention

Before choosing a path or format, inspect `.adr-dir` first.
When it names a decision-log directory,
use that configured location unless governing repository instructions conflict.
Otherwise inspect repository instructions, existing decision records,
related indexes, and these common locations:

```text
adr/
design/
notes/
docs/adr/
doc/adr/
```

Existing evidence governs location, filename pattern, ordering, headings,
status vocabulary, and markup.

If evidence conflicts, report the conflict instead of introducing another
convention.
If no convention exists, use:

```text
design/YYYY-MM-DD-slug.md
```

Use the decision date.
Use a short lowercase slug that identifies the decision.
If existing records use `NNNN-slug.md`, increment the highest established
number and never reuse a number.

Create a directory only when the first record is needed.
Do not create an index, bootstrap ADR, or supporting infrastructure unless the
user requests it or repository convention requires it.
When creating or restructuring an ADR,
read [the format variants](references/format-variants.md)
for repository precedence, the fallback default, compact records,
and optional sections.

## Preserve the decision-time model

Record one decision and the forces that materially shaped it.
A useful ADR lets the reader recover:

1. What was decided?
2. What facts and constraints made the decision necessary?
3. Why did this choice fit those conditions?
4. What became possible, difficult, costly, or constrained?
5. Is the decision still active?

Keep observed facts, supported inferences, and recommendations distinct.
Do not invent alternatives, motives, consensus, confidence, lifecycle state,
consequences, or historical conditions to make a record look complete.
If evidence is missing, state the material gap or omit the unsupported claim.

For a current proposal, describe future behavior as proposed.
For an existing implementation, do not present current code as proof of the
original rationale.
Generally, capture decisions from now onward instead of reconstructing old
ones.
If the user explicitly requests a retrospective record,
record only evidence-backed history and label later hypotheses as hypotheses.

## Preserve lifecycle history

Write the ADR while the decision is being made,
when its context, drivers, and alternatives are still available.
Usually start with a Proposed ADR before implementation.
If documentation starts later, write the current evidence-backed decision now
instead of waiting for a better historical record.

A proposed ADR can change while the decision is under review.
After a decision is accepted or rejected,
preserve its decision and rationale as historical evidence.

When the direction changes:

1. Create a new ADR that states the new context and decision.
2. Link the new ADR to the old ADR.
3. After the new decision is accepted,
   mark the old ADR as superseded and link it to the new ADR.

Do not rewrite an implemented accepted ADR to make the new direction appear to
have been the original decision.
Authority, urgency, documentation churn, and a preference for one file do not
change this historical boundary.

Corrections can repair wording without changing the historical claim.
Status and supersession links can change as the lifecycle advances.
Add later observations only when they are clearly dated and local convention
supports them.

## Write for an unfamiliar future reader

Lead with the decision or its practical effect.
Introduce each prerequisite before reasoning from it.
Use stable project names and define unfamiliar terms.
Identify actors, boundaries, conditions, causes, and consequences explicitly.
State a nearby unchanged path when that distinction affects the decision.

State the decision with modality that matches its lifecycle and authority.
Describe a proposal as proposed.
State an accepted choice or constraint as an unambiguous declaration.
Do not use `should` when the reader could mistake a binding decision for advice.

Use ASD-STE100 Simplified Technical English by default:

- Use active voice unless the actor is unknown.
- Prefer descriptive sentences of no more than 25 words.
- Give each paragraph one topic and no more than six sentences.
- Use simple verb forms and one meaning for each recurring term.
- Do not use contractions, idioms, metaphors, or rhetorical flourish.
- Use vertical lists for complex sets.
- Replace an ambiguous pronoun with the noun it represents.

Preserve exact technical meaning when a language rule would make the claim less
accurate.
Do not claim formal ASD-STE100 compliance unless the text was validated against
the current official standard and controlled dictionary.

## Show structure directly

Use code and plain-text diagrams when they materially reduce the reader's work.
They are part of the explanation, not decoration or an implementation plan.

When a named code entity is material and established syntax exposes a relevant
relationship, lead with the smallest faithful code shape.
Preserve evidence-backed names, spelling, types, and ownership boundaries.
Visibly elide unrelated parts with a language-native comment.
Label proposed or illustrative code as proposed or illustrative.
In this case, prose alone is incomplete; use prose to explain the rationale,
constraints, and consequences that syntax does not express.

Use a small plain-text diagram when ownership, flow, state transitions,
or actor handoffs would be harder to understand in linear prose.
Use a table when the reader must compare repeated fields across alternatives.
Keep names and boundaries consistent with the surrounding text,
and explain what the representation establishes.

Do not include low-level mechanisms merely because code exists.
Include them only when the reader must understand, evaluate,
or safely change that detail.

## Review the result

An ADR is complete when the future reader can:

- identify the decision and its scope;
- understand the decision-time facts, forces, and rationale;
- understand each prerequisite before the ADR relies on it;
- distinguish current status from superseded or rejected history;
- identify material positive, negative, and neutral consequences;
- distinguish established evidence from inference;
- understand each retained code shape, diagram, or comparison; and
- evaluate whether changed conditions justify a new decision.

Remove content that does not help those outcomes.
Do not mistake template completion for reader completeness.

When consulting ADRs during other work,
read relevant records fully and follow status and supersession links.
Treat a conflict between an active ADR and current code as a finding.
Do not silently change either side,
and do not treat rejected or superseded decisions as current constraints.

## Tests

When changing this guidance,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
