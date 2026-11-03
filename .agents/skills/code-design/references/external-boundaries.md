# External boundaries

## Describe the needed capability

Domain code uses domain concepts; adapters know external representations
and translate where the external mechanism is owned.
Keep transport requests, rows, vendor clients, generic command runners,
and framework lifecycles from spreading through business logic.
For external processes, adapters own command syntax, working directory,
environment, parsing, exit status, and tool-specific failures.
The domain requests an operation without reconstructing its protocol.
Do not create a service boundary for a small local probe
whose result and mechanism have no domain policy;
remove real knowledge rather than anticipating reuse.

A gateway expresses the capability in consumer terms.
It may combine calls, normalize units, or translate errors;
it need not mirror the provider's entire API.
Dependency injection supplies collaborators; dependency inversion lets the
consumer contract govern implementation dependencies.
Injecting a vendor client still exposes its model.
Supply a purposeful capability when that translation removes knowledge
from business logic, and implement it at the adapter boundary.

## Preserve meaning across models

Translate where ownership, representation, or contract changes,
not merely to duplicate types across packages.
A canonical generated or shared type can serve as the domain type
when the domain owns its meaning and compatibility.
Translate different external assumptions as well as data shape;
this anti-corruption layer protects meaning.
Its translation role does not absorb local eligibility or workflow policy
from domain owners.

## Respect external authority

Combining external responses establishes neither a coherent snapshot nor an aggregate.
Identify each fact's source, required consistency, and provider capability.
Expose freshness or revisions when they change caller actions.
If the provider cannot meet the requirement, narrow the operation or resolve
the capability gap rather than imply a guarantee through a return type.

Remote aggregate access grants only its owner's mutation and consistency contracts.
Several remote writes behind one save remain separate unless the provider
supplies the required atomic operation.
Local transactions cannot roll back unrelated external effects.
Expose conflicts, partial completion, cancellation, and uncertainty
when callers must respond differently.

A timed-out shipment booking may have succeeded.
Report it pending instead of rejected or submitting a new booking.
With supported lookup, reconcile the same operation.
Illustrative pseudocode:

```text
book_shipment(shipment, operation_id):
    try: return carrier.book(shipment, operation_id)
    catch Timeout: return Pending(operation_id)

reconcile(operation_id):
    status = carrier.lookup(operation_id)
    return Pending(operation_id) if status.is_unknown else status
```

Confirmed booking or rejection resolves pending; inconclusive lookup does not.
Rely only on supported lookup and retry contracts:
absence need not prove nonexecution, and correlation IDs establish neither
deduplication nor safe resubmission.
Establish retention, retry, and lookup guarantees before using them.

## Define completion across effects

Commands request actions and can be rejected; events record facts that happened.
Domain events can expose consequences for coordination code to execute
without requiring brokers or asynchronous calls.
Publish facts to another system only after their state is committed;
integration events carry consumer contracts and compatibility obligations.

Define whether success establishes local acceptance, durable pending work,
or completion by the external owner.
Trace failures between stages, including lost acknowledgments of completion.
Choose recovery from required outcomes and actual provider guarantees:
partial progress or best effort may suffice, or the workflow may need retry,
reconciliation, compensation, or pending states.
Compensation is a further business action that can also fail.

When required follow-up must survive crashes, store it atomically with the change.
For messages this is a transactional outbox; existing durable jobs may suffice.
Illustrative pseudocode:

```text
transaction tx:
    tx.save(order)
    tx.enqueue(OrderSubmitted(order.id))

# Worker after commit; a crash between these calls can repeat delivery.
publish(event)
mark_delivered(event.id)
```

Operation identity and duplicate handling must cover the business effect,
concurrent attempts, and crashes; an initial "already processed" check
is not proof of idempotency.
When durability is unnecessary, direct calls with deliberate failure behavior
may suffice.

## Choose deployment boundaries separately

Establish cohesive ownership before a process or network boundary.
Distribution adds latency, partial failure, versioning, observability,
deployment, and operational ownership; it does not create domain meaning.
Require demonstrated needs such as independent lifecycle, scaling, security,
or failure isolation to justify those costs.

An API gateway routes traffic, may combine responses, and can own common
network concerns; it is distinct from a domain-facing gateway or aggregate.
Keep business rules with their owners despite one traffic entry.

Substitute the dependency in a representative operation:
domain decisions should remain understandable without its protocol.
Identify adapter and real-system evidence for mapping, failure,
and consistency guarantees; a fake cannot verify the provider contract.
