---
name: code-comments
description: >
  Use for writing, revising, reviewing, or deciding whether to add or remove
  source comments and documentation; introducing or changing domain concepts,
  non-obvious contracts, invariants, or representation boundaries; or unclear
  local code models. Not review feedback called comments or prose outside code.
---

# Code comments

Comments should reduce work for a concrete reader and task:

| Reader | Available context | Comment's job |
| --- | --- | --- |
| Interface user | Name, signature, types, nearby module documentation | Explain the contract needed to use the boundary without reading implementation. |
| Implementation maintainer | Visible statements | Supply the model otherwise requiring reconstruction, navigation, simulation, or unfamiliar domain knowledge. |

Write from that context, not the author's memory of the change.
Visibility, caller count, namedness, length, and comment volume do not decide need.

## Choose the representation

Minimize net reading cost:

- Prefer names, types, and structure that express meaning locally and reliably.
- Document a named boundary's contract.
- Use implementation comments for the model of a coherent code span.
- Use an external design note or authoritative specification for a full explanation
  spanning implementations; keep needed local summaries and routes.

A comment loses to clearer code when the same model needs no extra navigation
or indirection, and to blank lines or structure providing the same orientation.
Improve locality instead of narrating navigation around unrelated responsibilities.

Visibility in code is not enough: ask whether it presents meaning at the reader's
useful scale.
Keep useful accounts of what code does when they expose hidden state,
group several operations, or teach a needed model.

## Establish evidence and dispatch

Ground documentation and its scope in repository evidence: implementation, types,
callers, tests, specifications, and accepted decisions.
Investigate or report an unsupported useful claim instead of inventing prose.
Names or local observations do not establish broader compatibility, safety,
or lifecycle guarantees.

Before writing, reviewing, or deciding whether to add either form, read its reference:

- [Interface documentation](references/interface-documentation.md) for contracts,
  packages/modules, named concepts, and fields.
- [Implementation comments](references/implementation-comments.md) for context,
  working state, guide comments, and prerequisite teaching.

Both may apply; one does not replace the other reader's explanation.

## Remove comments that add no value

Delete or rewrite narration of obvious statements at the same scale,
labels costing as much as the code without orientation,
and comments duplicating meaning already clear from names, types, or contracts
without a discovery or orientation role.
Also fix stale or inaccurate comments, labels mismatching their full span,
implementation detail in interface documentation, and prose compensating for
reasonably repairable locality or cohesion.
A useful larger-scale account of what happens is not redundant merely because
the statements are individually clear.

## Placement and format

Attach comments to the smallest coherent span they explain and reuse code names.
Standalone comments are complete sentences that start with a capital
and end with a period.
Use short fragments for end-of-line value or state annotations:

```go
// Use an empty deadline so the transport waits indefinitely.
deadline := time.Time{}

deadline := time.Time{} // no deadline
```

Move a multi-line end-of-line comment above the code and use complete sentences.
In languages supporting line comments, use them for multi-line explanations
instead of block-comment prose; follow established repository representation
when it differs.
