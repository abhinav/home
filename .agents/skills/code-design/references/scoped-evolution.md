# Scoped evolution

Repository precedent is evidence, not authority.
Existing patterns may encode local constraints,
or they may be historical mistakes.
Judge them against current contracts, ownership,
accepted decisions, and the requested outcome.

Use a better pattern locally when it has a clear boundary
and does not create two owners for the same concept.
Leaving older code unchanged can be the correct scoped choice.
If the new pattern would create ambiguous precedent
for one stable concept,
either follow the current valid pattern
or establish an accepted destination before diverging.

Do not turn ordinary new code into an unrequested migration.
When the current pattern prevents correctness, safety,
or the requested outcome,
repairing it may be prerequisite work;
obtain approval before materially expanding the task.
Otherwise, contain the old pattern without propagating it unnecessarily.

A migration exists only when there is an accepted destination
and an intention to move the existing population.
Then new work should move toward that destination,
new uses of the retiring pattern should be contained,
and a small ratchet may protect the direction.
Before that decision, a local improvement is not repository-wide policy.
