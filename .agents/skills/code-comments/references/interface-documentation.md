# Document interface contracts

Resolve material uncertainty so a caller can predict or decide without reading
the implementation.
Names, signatures, types, and nearby module documentation are already available.

## Connect conditions to outcomes

Describe the supported transitions that affect use:

- Input/precondition to success or failure, including recognizable errors and
  unchanged state.
- Success to what the returned value represents and which effects become visible.
- Ownership, mutation, lifetime, ordering, concurrency, units, valid values,
  and limits where they change the caller's choices.

Keep each condition with its consequence.
Name relationships callers rely on, such as the atomic unit.
When supported by evidence:

```go
// SaveOrder commits the order and dispatch record together.
```

Under space limits, retain conditions/outcomes, returned and committed results,
and failure/errors/unchanged state.
Drop obvious summaries or implementation details first.
Do not substitute shorthand with a different scope; use more space if needed.
If repository policy requires every exported symbol to be documented,
a self-explanatory boundary can have a short orienting comment without an
invented contract.
An operation summary is insufficient when material behavior exists.

Document a private orchestration method, callback, or normalized type when users
must preserve its behavior, state, or invariants.
Mechanical forwarding methods and plainly represented records need no invented prose.

## Packages and modules

Write for a reader entering at that boundary.
Establish its responsibility and system role, how dependencies participate,
what belongs to callers or neighbors, enforced contracts/invariants,
and how callers enter the abstraction.
Supply context that makes its symbols one coherent interface,
without assuming sibling-module or change-history knowledge or restating every export.

## Concepts and fields

Document a concept's meaning, behavior, or constraints not carried by its name,
structure, and immediately visible use.
Include the needed purpose, what it represents, source or representation boundary,
controlled behavior, and material limits.
Private types may need this model when they normalize another shape,
protect a representation boundary, or own a whole-value invariant;
mechanical types do not need explanations invented for their names.

Inspect each field for meaning not established by its name and type.
Document that meaning with the field; a type comment does not replace it.
This can include units, source, valid values, ordering, and ownership.
Omit a field comment when name and type establish its complete meaning.
Put cross-field relationships at type scope and repeat field details there only
when establishing a whole-value relationship.

For external-specification conformance, link the authoritative source at that
boundary and state the locally relevant contract.
The link supports verification; it does not replace the needed local explanation.
