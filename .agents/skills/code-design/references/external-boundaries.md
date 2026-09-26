# External boundaries

## Describe the capability the caller needs

Domain code should speak in domain concepts.
Adapters may know both an external representation and the domain,
but transport requests, database rows, vendor clients,
generic command runners, and framework lifecycles
should not spread through business logic.
Translate at the boundary that owns the external mechanism.

Model an external system in terms of the capability the domain needs.
An adapter for an external process should own command syntax,
working directory, environment, output parsing,
exit status, and tool-specific failures.
The domain should request the operation,
not reconstruct the external protocol.
Do not create a service boundary for a small local probe
whose result and mechanism have no domain policy;
the boundary must remove real knowledge, not anticipate hypothetical reuse.

A gateway presents an external capability in the consumer's terms.
It may combine calls, normalize units, or translate errors;
it need not mirror the provider's entire API.
Dependency injection supplies a collaborator, while dependency inversion lets
the consumer's contract govern the dependency on implementation details.
Injecting a vendor client makes it visible but still exposes the vendor's model.
Supply a purposeful capability when that translation removes knowledge from
business logic.
Keep the implementation of that capability at the adapter boundary.

## Preserve meaning across models

Translate across a boundary when ownership, representation,
or contract actually changes.
Do not create duplicate types merely to make every package look isolated.
A canonical generated or shared type can be the domain type
when the domain truly owns its meaning and compatibility.

When an external model carries different assumptions,
translate their meaning as well as their data shape.
This semantic protection is often called an anti-corruption layer.
Its job is translation; local eligibility and workflow policy retain their
domain owners rather than accumulating in the adapter.

## Respect the external system's authority

A gateway may assemble several records into a useful domain representation.
Combining responses does not make them a coherent snapshot or a domain aggregate.
Determine which source owns each fact,
what consistency the caller's decision requires,
and whether the external system can supply it.
Expose freshness or revision information when it changes the caller's action.
If the capability cannot meet the requirement, narrow the operation or resolve
the missing capability; do not imply a guarantee through a return type.

Access to a remotely owned aggregate supplies only the mutation authority
and consistency guarantees offered by its owner.
Several remote writes hidden behind one save operation are still several writes
unless the provider offers the required atomic operation.
A database transaction cannot roll back an unrelated external effect.
Keep conflicts, partial completion, cancellation,
and uncertain outcomes visible when the caller must act differently on them.

A carrier can book a shipment even if its response never reaches the caller.
A timeout therefore leaves the booking unresolved;
report a pending outcome instead of claiming rejection or submitting a new booking.
When the provider supports status lookup, reconcile the same operation:

```text
book_shipment(shipment, operation_id):
    try: return carrier.book(shipment, operation_id)
    catch Timeout: return Pending(operation_id)

reconcile(operation_id):
    status = carrier.lookup(operation_id)
    return Pending(operation_id) if status.is_unknown else status
```

A confirmed booking or rejection resolves the pending outcome.
An inconclusive lookup leaves it pending.

Use only supported lookup or retry contracts.
An absent result need not prove nonexecution;
a correlation ID alone proves neither deduplication nor safe resubmission.
Establish retention, retry, and lookup guarantees before relying on them.

## Define completion across effects

A command requests an action and can be rejected.
An event records a fact that happened.
Recording a domain event can make consequences explicit while leaving their
execution to coordination code; it does not require a broker or asynchronous calls.
Publish facts to another system only when the state they describe is committed.
Such integration events are contracts with consumers and compatibility obligations.

Define what the caller's success result establishes:
local acceptance, durable pending work, or completion by the external owner.
Trace failures between those stages, including completion whose acknowledgment
is lost.
Choose recovery from the required outcome and actual external guarantees.
Some workflows permit partial progress or a best-effort attempt;
others require retry, reconciliation, compensation, or a pending state.
Compensation is a further business action and may itself fail.

When committed changes require follow-up to survive crashes,
store both atomically (transactional outbox for messages):

```text
transaction tx:
    tx.save(order)
    tx.enqueue(OrderSubmitted(order.id))

# Worker after commit; a crash between these calls can repeat delivery.
publish(event)
mark_delivered(event.id)
```

Existing durable jobs may suffice.
Operation identity and duplicate handling must cover the business effect,
concurrent attempts, and crashes;
a preliminary "already processed" check does not establish idempotency.
When durable follow-up is not required, a direct call with deliberate failure
semantics may be enough.

## Choose deployment boundaries separately

Establish cohesive ownership before introducing a process or network boundary.
Distribution does not create a meaningful domain boundary;
it adds latency, partial failure, versioning, observability,
deployment, and operational ownership.
Introduce it only when demonstrated needs such as independent lifecycle,
scaling, security, or failure isolation justify those costs.

An API gateway routes client traffic, may combine responses,
and can own common network concerns.
It serves a different purpose from a domain-facing gateway or an aggregate.
Keep business rules with their owners even when traffic passes through one entry.

Check a representative operation with the external dependency substituted:
domain decisions should remain understandable without its protocol.
Then identify the adapter and real-system evidence needed to establish mapping,
failure, and consistency guarantees; a fake cannot verify the provider's contract.
