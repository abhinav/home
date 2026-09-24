---
name: code-design
description: >
  Use when designing, changing, or evaluating code ownership, boundaries,
  contracts, representations, dependency lifetimes, domain adapters, public API
  shapes, or where policy and state live, including while adding code or
  refactoring. Do not use for a local readability-only edit that changes none
  of those design decisions.
---

# Code design

Use this skill when designing new code or refactoring.

Design decides where knowledge, state, and decisions live.
A good design gives each domain decision an owner
and lets callers depend on a stable contract
without coordinating the owner's implementation details.
The goal is not more packages, interfaces, objects, or helpers.
The goal is to make a meaningful change require understanding
and editing the smallest coherent part of the system.

Judge a design from the perspective of the next maintainer.
Imagine a likely change to the behavior,
then trace what that maintainer would need to discover and modify.
If one decision requires synchronized edits across unrelated callers,
the design has probably leaked knowledge.
If a boundary merely moves the same coordination behind another name,
the boundary has not reduced the load.

## Design from the outside in

Begin with the outcome the caller needs,
not the classes, functions, or framework pieces already available.
Design the public or inter-component surface from the calling code inward.
Sketch representative calls before choosing the implementation shape.
From those calls, draft the smallest useful boundary:
name its operations and define their inputs, results, ownership,
failure behavior, mutation, and ordering.
Check that contract against real call sites and representative examples
before implementing the production boundary.

Treat implementation mechanisms as candidates for satisfying the contract,
not as the source of the caller-facing design.
A selected library, framework, schema, protocol, or existing helper
should not leak into the boundary merely because implementation starts there.
When feasibility is uncertain, use a private spike to test the mechanism,
then revise either the contract or the implementation from what the spike proves.
Do not let exploratory implementation become the public contract by accident.

Outside-in design does not require freezing an early guess.
When the domain or workflow is still uncertain,
keep the initial structure easy to change
and use working implementations to learn its shape.
Do not stabilize an abstraction before representative behavior
and real callers reveal a cohesive responsibility and narrow contract.
Refactor toward that boundary when the evidence appears.

Use current requirements, callers, and repository history
as evidence about likely change.
When a boundary wraps, extends, or replaces existing behavior,
establish the supported behavior, constraints,
and compatibility commitments before stabilizing its contract.
Inspect callers, tests, repository history, and operational evidence.
Preserve supported behavior rather than accidental implementation structure,
but do not infer that an incumbent mechanism has no purpose
merely because its purpose is not immediately visible.
Do not add options, extension points, or indirection
only because something could change someday.
Stable public boundaries deserve more caution:
their names, inputs, outputs, mutation behavior, ordering,
and partial-failure behavior can all become compatibility commitments.
Expose only the operations callers need,
and make observable behavior deliberate.
Make the representative operation direct.
When demonstrated callers need materially different levels of control,
provide an advanced contract without forcing common callers
to coordinate its additional concepts.
Do not add parallel API layers for hypothetical callers.

A boundary earns its place when its contract replaces knowledge:
callers can ask for a useful outcome
without knowing the representation, policy, or sequence behind it.
Prefer complete domain operations over implementation stages
when the ordering and coordination belong to the domain.
Preserve composable stages when callers genuinely own their selection,
ordering, or reuse.

For example, if every invoice caller must load an invoice,
price it, send it, apply the same retry policy,
and record the same audit event,
the billing boundary should usually own `SendInvoice`.
If media callers intentionally choose and reorder decoding,
transformation, and encoding stages,
those stages are part of the useful contract and should remain available.

The same test applies at every scale.
A helper, type, object, module, package, or service is useful
when it names a real concept, protects an invariant,
owns a cohesive operation, or centralizes genuine shared policy.
It is shallow when readers still have to inspect both sides
and reconstruct the same decision or control flow.

## Put knowledge with its owner

Related state, invariants, dependencies, and operations
should live with the concept whose behavior they determine.
Physical organization should make that ownership visible.
Keep a domain's concepts, policy, state, and workflows together
within the boundary that owns them.
Split a file or module only when one part has an independently explainable
responsibility, lifecycle, invariant set, dependency boundary, or contract.
A declaration kind, framework layer, or size target
does not create such a boundary.

Trace representative workflows through the proposed layout.
Repeated crossings between files or modules
to complete one operation or change one policy
are evidence that the decision has been fragmented.
At the system root,
retain only coordination whose scope is genuinely global;
let cohesive components own the state and behavior they govern.

Ownership can be nested.
An owner may divide a larger responsibility
into cohesive sub-responsibilities owned by private components.
The outer owner retains the larger outcome,
but supplies each sub-owner with the required inputs and capabilities
and depends on its result
without coordinating its internal policy or sequence.
If that knowledge remains on both sides,
the new boundary is a helper, not an owner.

Place each value where its lifetime and rate of change match the abstraction.
Application-wide or object-wide values usually belong at construction.
Per-operation values belong on the operation.
Data that can change between operations should remain behind a provider
or be supplied for each operation;
do not freeze dynamic state merely to simplify a signature.

Read environment variables, flags, configuration files,
framework requests, database rows, and other external state
at a composition or adapter boundary.
Translate them into domain values or capabilities,
then give each component only what it needs.
This keeps process and infrastructure knowledge out of domain behavior
and makes dependencies visible.

Stateful collaborators and replaceable policy should be visible
at a construction or operation boundary.
A mutable global, default client, registry, or service locator
has process-wide reachability but no meaningful owner.
A process-wide declaration with one clear owner is acceptable only when
neither it nor anything transitively reachable from it
exposes writable shared state.
Global addressability is not itself the problem;
hidden mutation, replaceable policy, or lifecycle is.

Do not replace visible dependencies with one unrelated application context.
A broad bag couples every consumer to the shape of the whole application
and obscures which capabilities each operation needs.
A cohesive context is different:
when its fields share one domain meaning and lifecycle,
such as a job execution or transaction,
the context can be the domain concept rather than a convenience bag.

Evaluate a stable choice at the boundary where it becomes stable
and select the corresponding implementation once.
Re-evaluate choices whose source can legitimately change.
The design follows the lifetime of the decision,
not a blanket preference for either construction-time
or call-time selection.

Keep each policy or declaration authoritative in one place.
Derive reverse lookups, indexes, transport views,
and other mechanical projections from that source.
Keep similar-looking values separate when they represent independent facts;
deduplication is useful only when the values must change together.

## Keep domain boundaries meaningful

When adapting an external system, translating across a domain boundary,
or choosing a process or network boundary,
read [External boundaries](references/external-boundaries.md)
for domain adapters, translation, and distribution decisions.

## Let representations carry the model

When parsing inputs, establishing invariants, or choosing domain data shapes,
read [Domain representations](references/domain-representations.md)
for validated values, modes, records, and configuration contracts.

## Use change locality as the diagnostic

Trace a representative change through the candidate design.
Ask which code owns the decision,
which callers must know it,
and which declarations must move together.
A strong boundary lets internal representation and policy evolve
without unrelated callers changing.
Callers should need edits when the operation they request
or the contract they rely on changes,
not whenever its implementation changes.

When one domain change requires mechanical edits across many callers,
look for the representation, sequence, condition, or policy
those callers all know.
Move that knowledge to its natural owner.
When a proposed abstraction adds navigation
but the same facts remain live on both sides,
remove or deepen the abstraction instead.

Local readability and system design meet at this boundary.
Use `$code-readability`
for control flow, naming, and local helper decisions.
Escalate to a design change when the local complexity exists
because ownership or policy is split across the system.

## Improve without inventing a migration

When a proposed local improvement differs from repository precedent,
or could require expanding the change into a migration,
read [Scoped evolution](references/scoped-evolution.md).

## Apply the model

Before implementing or settling on a design:

1. Describe the caller's useful outcome and sketch representative calls.
2. Establish any supported existing behavior and compatibility commitments.
3. Draft the observable contract and validate it against real callers.
4. Identify the decision, invariant, state, and external knowledge involved.
5. Assign each one to the concept whose behavior it determines.
6. Match dependencies and values to their real lifetime.
7. Probe implementation feasibility without exposing the mechanism.
8. Revise and stabilize the contract from caller and feasibility evidence.
9. Trace a representative future change through callers and owners.
10. Remove boundaries that add navigation without replacing knowledge.
11. Check public behavior and repository scope before expanding the surface.

Prefer the simplest coherent design
that gives the important decisions a clear owner.
Judge simplicity in the resulting ownership model,
not by the size of the patch.
When a governing boundary is wrong,
repair and integrate that boundary
instead of adding a local exception that creates another owner.
Complex domains remain complex;
good design keeps that complexity cohesive
instead of making every caller carry a fragment of it.
