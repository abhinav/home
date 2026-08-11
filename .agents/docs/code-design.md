# Code design

Apply these principles when designing new code or refactoring.

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

## Start from the change and the caller

Begin with the outcome the caller needs,
not the classes, functions, or framework pieces already available.
Sketch representative use before choosing the implementation shape.
State the operation's inputs, result, ownership, and failure behavior,
then check that contract against real call sites.

Use current requirements, callers, and repository history
as evidence about likely change.
Do not add options, extension points, or indirection
only because something could change someday.
Stable public boundaries deserve more caution:
their names, inputs, outputs, mutation behavior, ordering,
and partial-failure behavior can all become compatibility commitments.
Expose only the operations callers need,
and make observable behavior deliberate.

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

Translate across a boundary when ownership, representation,
or contract actually changes.
Do not create duplicate types merely to make every package look isolated.
A canonical generated or shared type can be the domain type
when the domain truly owns its meaning and compatibility.

## Let representations carry the model

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

Language-specific API mechanisms and conventions belong in their language
guides.
For Go code, read `~/.agents/docs/go.md`
before choosing concrete public API shapes.

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
Use `~/.agents/docs/code-readability.md`
for control flow, naming, and local helper decisions.
Escalate to a design change when the local complexity exists
because ownership or policy is split across the system.

## Improve without inventing a migration

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

## Apply the model

Before settling on a design:

1. Describe the caller's useful outcome and observable contract.
2. Identify the decision, invariant, state, and external knowledge involved.
3. Assign each one to the concept whose behavior it determines.
4. Match dependencies and values to their real lifetime.
5. Trace a representative future change through callers and owners.
6. Remove boundaries that add navigation without replacing knowledge.
7. Check public behavior and repository scope before expanding the surface.

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
