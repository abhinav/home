# Document interface contracts

Documentation should let a user treat a symbol as a black box.
Treat the name, signature, and types as information the reader already has.
A useful comment resolves a material uncertainty
so the user can predict or decide something
without opening the implementation.

Describe the evidence-backed transitions that affect use:

- Connect each input or precondition to the success or failure it selects,
  including recognizable errors and unchanged state.
- Connect success to what the returned value represents
  and which effects become visible.
- State how ownership, mutation, lifetime, ordering, concurrency,
  units, valid values, or limits change the caller's choices.

Keep each condition joined to its consequence.
A list of correct facts still leaves the user to reconstruct the contract
when it does not explain which situation produces which outcome.

Relationships often carry the contract.
`SaveOrder atomically saves an order` does not identify the atomic unit.
If the order and its dispatch record are all-or-nothing,
say that they commit together
or that failure of either write leaves neither visible.
The relationship a caller can rely on matters;
the qualifier or implementation mechanism does not.

When space is constrained,
preserve the transitions that change a caller's decision:
conditions and outcomes,
success and committed effects,
failure and recognizable errors or unchanged state.
Drop an obvious operation summary or implementation detail first.
Compress by removing lower-value detail,
not by replacing a precise condition with familiar shorthand
whose meaning is broader or narrower.
If the material contract does not fit clearly,
use more space rather than erase part of it.
When repository policy requires documentation for every exported symbol,
use a short orienting comment for a self-explanatory boundary
rather than inventing a larger contract.
An operation summary is not sufficient when material behavior exists.

Apply the same boundary test to public and private symbols.
Visibility, caller count, and body length do not decide the need.
A private orchestration method, callback, or normalized type needs documentation
when it owns meaningful behavior, state, or invariants
that its users in the internal call graph must preserve.
A mechanical forwarding method or plainly represented record does not.

When a private boundary needs documentation,
an implementation comment inside it
does not replace documentation of its responsibility and contract.
Likewise,
interface documentation does not replace a local comment
when maintainers need an implementation invariant or transition
at the code that enforces it.

## Document packages and modules in isolation

Write package and module documentation for a reader
who begins at that boundary.
Establish:

- the responsibility the package or module owns;
- where it fits in the larger system;
- how its dependencies participate in that responsibility;
- what it leaves to callers or neighboring abstractions;
- the important contracts and invariants it enforces; and
- how callers enter the abstraction.

Do not assume the reader has inspected sibling modules
or seen the change that introduced the abstraction.
Do not restate every exported symbol.
Provide the context that makes those symbols coherent as one interface.

## Document named concepts and fields

Document a named concept when it owns meaning, behavior,
or constraints not carried by its name, structure,
and immediately visible use.
Explain the need it addresses,
what it represents,
its source or representation boundary,
the behavior it controls,
and material limits.
Include only the parts the concept's users need.

Private concepts are not exempt.
A private type often needs documentation when it normalizes another shape,
prevents lower-level representations from leaking,
or carries a whole-value invariant.
A mechanical type does not need prose invented to justify its name.

Inspect each field separately.
A type comment does not replace field-specific meaning,
and a descriptive identifier does not necessarily establish units,
source, valid values, ordering, or ownership.
Document those facts with the field that owns them.
Omit a field comment when the name and type make its complete meaning obvious.

Put a relationship among fields at type scope
and keep each field's individual contract with that field.
Do not repeat field descriptions in the type comment
unless the repetition establishes a whole-value relationship.

When an interface implements an external specification,
link the authoritative source at the conformance boundary
and state the locally relevant contract.
A link should support verification,
not replace the explanation needed to read the code.
