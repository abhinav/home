---
name: adr
description: >
  Create, revise, review, or consult Architecture Decision Records (ADRs) and
  decision logs, or decide whether a technical choice needs durable rationale.
  Do not use merely for architecture work, system descriptions, or
  implementation plans that do not record a decision.
---

# Architecture decision records

Preserve one decision and its conditions so an unfamiliar future human or agent
can judge whether it still applies.
ADRs establish what was decided and why; code and configuration establish
current behavior.
An ADR is not a complete architecture description, implementation plan,
transcript, or enforcement mechanism.
Decision-log titles should form a scannable map of the project's choices.

## Choose disposition and depth

Use user intent, repository practice, consequences, and the value of durable
rationale; none is a universal gate.
Follow broad decision-log practice without imposing a significance threshold.
Choose depth from those factors, complexity, and evidence.
Both compact and detailed records are normal; do not default to compactness or omission.

| Condition | Action |
| --- | --- |
| A current significant decision needs durable rationale | Create an ADR. |
| A proposal is still being clarified | Revise the proposed ADR. |
| An implemented accepted decision changes | Create a superseding ADR. |
| Only lifecycle metadata changes | Update status and cross-links. |
| An existing ADR already governs | Keep and reference it. |
| Neither durable rationale nor repository practice supports a record | Omit it. |
| A useful ADR is not authorized | Propose it without creating it. |
| Past rationale cannot be established | Do not backfill it. |

If practice does not settle the choice, ask whether a future reader needs the
decision-time rationale to evaluate or safely change the system.
Signals include reversal cost, structure, quality attributes, dependencies,
interfaces, published contracts, libraries, tools, processes, external constraints,
deviations, recurring debate, and consequences code cannot explain.
These are signals, not required checklist items.
Without broader log practice, routine local choices, established patterns,
and cheaply reversible changes usually belong in code, tests, or implementation
documentation.

## Establish context and convention

Before choosing a format or drafting, account for every prerequisite the reasoning uses:
actors, system boundaries, baseline, states, invariants, forces, constraints,
scope, and causal relationships.
For each, define it before use, link a stable source for the same audience and
scope, or omit it only if it cannot affect evaluation.
Preserve supplied project-specific definitions that carry these distinctions.
Team familiarity and length limits do not make necessary context optional.

Inspect `.adr-dir` first; use its directory unless governing instructions conflict.
Otherwise inspect repository instructions, records, indexes, and common locations:

```text
adr/  design/  notes/  docs/adr/  doc/adr/
```

Repository evidence governs location, filenames, order, headings, status vocabulary,
and markup.
Report conflicting evidence instead of adding another convention.
Without precedent, use `design/YYYY-MM-DD-slug.md`: decision date and a short,
lowercase decision slug.
For existing `NNNN-slug.md` records, use the highest number plus one; never reuse one.
Create the directory with the first needed record.
Add indexes, bootstrap records, or infrastructure only when requested or required
by repository convention.

When creating or restructuring a record, read
[Format variants](references/format-variants.md)
for fallback structure, compact records, optional sections, and lifecycle metadata.

## Preserve evidence and history

Establish the decision, facts and constraints, rationale, material consequences,
and whether the decision remains active.
Separate observations, supported inferences, and recommendations.
State material evidence gaps or omit unsupported claims; do not invent alternatives,
motives, consensus, confidence, status, consequences, or historical conditions.
Label proposed behavior as proposed.
Current code does not prove original rationale.
Generally capture decisions from now onward; write a retrospective only when
requested, using evidenced history and labeling later hypotheses.

Write while the decision is being made, usually Proposed before implementation.
If documentation begins later, record the current evidenced decision now.
Proposals may change; accepted and rejected decisions and rationale are history.

When direction changes:

1. Create a new ADR with the new context and decision; link to the old record.
2. Once the new decision is accepted, mark the old record Superseded and link back.

Preserve an implemented accepted record's historical claim despite urgency,
authority, churn, or a preference for one file.
Wording corrections may preserve that claim; status and links may advance.
Add later observations only when dated and supported by local convention.

## Make the decision readable

Lead with the decision or practical effect.
Use stable names, define unfamiliar terms, and state actors, conditions, causes,
scope, and material unchanged paths.
Match modality to lifecycle and authority: label proposals and state accepted
choices or constraints unambiguously.
Avoid `should` when it could make a binding decision sound like advice.

Use ASD-STE100 Simplified Technical English by default:

- Active voice unless the actor is unknown; simple verbs and consistent meanings.
- Descriptive sentences preferably at most 25 words; one topic and at most six
  sentences per paragraph.
- No contractions, idioms, metaphors, or rhetorical flourish.
- Vertical lists for complex sets; named nouns instead of ambiguous pronouns.

Preserve technical meaning over a language rule that would distort it.
Claim formal compliance only after validation against the current official
standard and controlled dictionary.

| Reader needs to inspect | Use |
| --- | --- |
| A material named code entity whose syntax shows a relevant relationship | The smallest faithful code shape, followed by semantics and rationale. |
| Ownership, flow, states, or handoffs harder to follow in prose | A small plain-text diagram. |
| Repeated fields across alternatives | A comparison table. |

Preserve established names, spelling, types, and ownership; elide unrelated code
with a language-native comment and label proposed or illustrative code.
Keep representations consistent with the prose and explain what they establish.
Include low-level mechanisms only when needed to understand, evaluate, or safely
change that detail.

## Check or consult a record

Read as an unfamiliar future maintainer: can the reader find the decision and scope,
understand prerequisites before the reasoning, distinguish evidence from inference
and active decisions from history, see material benefits, costs, and neutral effects,
understand retained representations, and judge changed conditions?
Remove irrelevant content; template completion does not establish reader completeness.

When consulting ADRs, read relevant records fully and follow lifecycle links.
Report conflicts between an active ADR and current code without silently changing
either; rejected and superseded decisions are not current constraints.
