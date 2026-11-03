# Aggregates and persistence

Choose state boundaries from the rule a change must preserve:
what must hold on completion, the determining facts, and who can change them.
Separate rules that must hold together from relationships an explicit business
requirement permits reconciling later.

## Group state by its invariants

An aggregate groups state needing coordinated invariant protection;
its root controls changes so callers cannot bypass rules through child updates.
Database relationships and response convenience do not define the aggregate.
Too broad a boundary makes independent changes contend;
too narrow a boundary leaves rules dependent on outside coordination.

For an order constrained by an approved spending limit,
every line edit, including imports and jobs, must obey that limit.
Sharing a customer does not combine all orders into one aggregate.
For a rule spanning orders, identify its larger decision owner and enforcement;
a new name supplies neither.

## Make persistence uphold the rule

Repositories own retrieval and mapping while exposing domain state.
Shape aggregate mutations around roots and meaningful changes
rather than each table's independent CRUD.
Use a custom repository only for a useful domain contract;
existing persistence may already supply the abstraction.

Load sufficient, coherent decision state.
Independent reads may combine facts that never coexisted;
use supported snapshots, locking, or version validation when consistency matters.
Targeted retrieval or storage operations may enforce rules without loading
an entire reachable graph.

Two edits valid against old state can violate a limit together.
Illustrative contract:

```text
order, revision = orders.load(order_id)  # coherent decision state
order.add_line(line)                    # enforces total <= approved limit
result = orders.save(order, expected_revision=revision)
on result:
    Saved    -> all required changes committed
    Conflict -> reload and reconsider; never retag stale state
    Unknown  -> reconcile the commit or use a proven safe retry
```

Save checks the revision and commits all required changes atomically or none;
`Unknown` leaves the outcome unresolved.
Locks or other mechanisms can also work.
All writers must participate in the chosen protection.
Verify storage isolation against the rule;
a transaction or private method alone does not establish concurrency protection.
A unit of work coordinates persistence sharing one commit boundary.

Separate reconstitution from new-object creation:
restore identity and lifecycle without replaying creation effects.
Handle old or invalid persisted state through explicit compatibility or repair
decisions, not invented valid business facts during mapping.
Keeping mapping outside domain behavior does not make storage interchangeable;
transaction capabilities, constraints, and query costs still govern the design.

## Let reads serve callers

Reporting and search projections can combine aggregates without gaining
mutation authority.
Use direct queries or dedicated read representations when useful;
make authorization and calculated meanings deliberate,
and establish whether the caller needs a consistent snapshot or accepts staleness.

Separating read and update models is CQRS (command query responsibility segregation).
One database and synchronous calls can suffice; keep one representation if it
serves both jobs well.
Separate databases, asynchronous delivery, and event sourcing are independent
choices requiring their own justification and maintenance.

Local cross-aggregate transactions can suit requirements and supported storage.
Eventual consistency needs an acceptable intermediate state and completion or recovery.
Choose by those conditions, not one universal transaction policy.
External-boundary guidance governs independently controlled systems;
a local aggregate cannot extend its transaction into them.

Trace every writer, loaded decision facts, and the protecting commit condition.
Use concurrent and interrupted executions to identify needed real-storage evidence;
isolated object tests cannot establish those guarantees.
