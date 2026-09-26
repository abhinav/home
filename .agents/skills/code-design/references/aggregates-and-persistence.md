# Aggregates and persistence

Choose the state boundary from the rule a change must preserve.
First state what must hold when the change completes,
which facts determine that rule, and who can change those facts.
Distinguish rules that must hold together from relationships that can be
reconciled later under an explicit business requirement.

## Group state by the rules it protects

An aggregate groups domain state whose invariants need coordinated protection.
Its root controls changes to that state so callers cannot bypass those rules
by updating a child independently.
An aggregate is not every object reachable through a database relationship,
nor every field convenient for a response.
Too broad a boundary makes independent changes contend;
too narrow a boundary leaves a rule dependent on coordination outside its owner.

For an order constrained by an approved spending limit,
every line edit must obey that limit, including imports and jobs.
Sharing a customer does not put all that customer's orders in one aggregate.
If a rule also constrains several orders together,
identify an owner and enforcement mechanism for that larger decision.
Renaming a collection of objects does not supply either.

## Make the persistence contract uphold the rule

A repository gives callers access to domain state while owning retrieval
and mapping mechanics.
For aggregate mutations, shape access around the root and meaningful changes,
rather than independently exposing each table's CRUD operations.
Use a custom repository only when it supplies a useful domain contract;
an existing persistence facility may already provide the needed abstraction.

Loading must obtain sufficient, coherent state to make the decision.
Several independent reads may combine facts that never held together.
Choose a supported snapshot, locking, or version-validation mechanism
when the rule depends on consistency across those reads.
Loading the entire reachable object graph is not inherently necessary:
targeted retrieval or a storage operation may enforce the same rule more directly.

Two edits can each satisfy a limit against old state and violate it together.
One possible contract:

```text
order, revision = orders.load(order_id)  # coherent decision state
order.add_line(line)                    # enforces total <= approved limit
result = orders.save(order, expected_revision=revision)
on result:
    Saved    -> all required changes committed
    Conflict -> reload and reconsider; never retag stale state
    Unknown  -> reconcile the commit or use a proven safe retry
```

Save checks the revision and persists all changes atomically or applies none;
`Unknown` leaves which outcome occurred unresolved.
Locks or other mechanisms can also work; all writers must participate.
Verify storage isolation against the rule: an ordinary transaction or private
object method alone does not establish concurrency protection.
A unit of work coordinates persistence changes sharing one commit boundary.

Define loading existing state separately from creating a new domain object.
Reconstitution restores identity and lifecycle without replaying creation effects.
Account for old or invalid persisted state through an explicit compatibility
or repair decision; do not silently invent valid business facts during mapping.
Keeping mapping outside domain behavior does not make storage interchangeable:
transaction capabilities, constraints, and query costs still bound the design.

## Let reads serve their callers

Reporting and search may combine several aggregates into a useful projection
without granting that projection authority to mutate them.
Use direct queries or dedicated read representations when they suit the caller.
Keep authorization and the meaning of calculated values deliberate.
Establish whether the caller needs a consistent snapshot or can accept stale data.

Separating read and update models is the useful core of CQRS
(command query responsibility segregation).
It can use one database and synchronous calls.
Separate databases, asynchronous delivery, and event sourcing are independent
choices with their own requirements and maintenance costs.
Keep one representation when it serves both jobs well.

A local transaction spanning aggregates can be justified by a requirement
and supported storage; eventual consistency requires an acceptable intermediate
state and a way to finish or recover.
Choose from those conditions rather than prescribing one transaction policy
for every application.
The external-boundary guidance owns coordination with independently controlled
systems; a local aggregate cannot extend its transaction into them.

Before settling the design, trace each writer, the facts loaded for a decision,
and the commit condition that protects it.
Use concurrent and interrupted executions to identify evidence needed from
the actual storage boundary; isolated object tests cannot establish those guarantees.
