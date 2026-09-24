# Domain representations

Parse less-structured input into a representation
that carries what the program has learned.
Validation that returns only success
while continuing to pass the original string, map, or external object
leaves every later reader dependent on an invisible earlier check.
A parsed domain value should make valid structure and invariants available
without repeating the proof.
Retain raw input only when diagnostics, audit, or round-tripping requires it.

Establish an invariant at the first boundary
where every downstream path requires it.
When only one selected path needs a stronger representation,
parse after selection;
otherwise the shared boundary would claim a constraint
the other paths do not have.

Choose data shapes that express domain meaning
and make invalid or ambiguous states difficult to construct.
Primitive values and generic containers are useful at external edges,
but repeated checks and conventions around them
usually reveal a missing domain concept.

A boolean is appropriate for a stable binary fact or local predicate.
It is a poor boundary when it means an unnamed mode,
especially when later modes or combinations are credible.
Name the choice and place it at the scope where it varies.

A finite, system-known choice should remain inspectable data.
Use a callback, strategy, or other behavior-bearing contract
only when the caller genuinely supplies open-ended behavior;
do not disguise a closed set of modes as opaque behavior injection.

A map is appropriate when key-to-value lookup and key uniqueness
are part of the domain contract.
It is a poor boundary when it merely encodes a collection of records
or exposes an accidental uniqueness policy.
In that case, use named records at the boundary
and keep lookup maps inside the owner that needs them.

Introduce a cohesive request, result, or configuration concept
when it is meaningful to callers,
when several values change together,
or when demonstrated evolution at a stable boundary
would otherwise force mechanical changes across callers.
The configuration concept owns the meaning of omission, defaults,
supported choices, and invalid combinations.
Normalize and validate those surface states
at construction or the nearest API boundary,
then give downstream code a validated representation
whose meaning it does not have to reinterpret.
When adding an optional choice to a stable boundary,
preserve established behavior when that choice is omitted,
defaulted, or zero-valued where applicable,
unless the contract deliberately changes.
Reject unsupported or conflicting choices there
instead of letting an accidental fallback select behavior
or making every consumer reinterpret the configuration.
Do not wrap a small internal signature in a vague object
only to reserve space for imagined growth.

Language-specific API mechanisms and conventions govern concrete public API
shapes.
Apply them after the domain contract is clear.
