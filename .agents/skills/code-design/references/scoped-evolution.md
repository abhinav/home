# Scoped evolution

Treat repository precedent as evidence of constraints or historical mistakes,
not authority; judge it against current contracts, ownership,
accepted decisions, and the requested outcome.
Use a better local pattern with a clear boundary and no duplicate concept owners;
leaving older code unchanged can be correct.
If divergence creates ambiguous precedent for one stable concept,
follow the valid current pattern or establish an accepted destination first.

Do not turn ordinary new code into an unrequested migration.
If the current pattern blocks correctness, safety, or the requested outcome,
repair may be prerequisite work; obtain approval before materially expanding scope.
Otherwise contain the old pattern without needlessly propagating it.

A migration requires an accepted destination and intent to move the existing population.
Then new work should move toward it,
and new uses of the retiring pattern should be contained.
A small ratchet may protect that direction.
Until then, local improvement is not repository-wide policy.

## Design the transition

For an accepted destination, derive the path from current state
and constraints that must hold during transition.
For each intermediate state, establish what it enables, what remains valid,
and why the next change cannot happen sooner.
Justify order from actual compatibility, ownership, availability,
and recovery commitments; group implementation and operations by those dependencies.
Evaluate the whole path, including temporary mechanisms and removal.
Choose the simplest supported transition rather than accumulating individually
reasonable steps; revise when evidence removes a dependency.
