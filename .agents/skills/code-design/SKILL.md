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
Establish what the operation means to the people or systems affected by it:
which facts matter, which decisions change them,
and which rules must remain true.
Use concrete successful, rejected, and interrupted cases
to discover missing concepts and ambiguous terms.
Treat the model as an explanation to refine with domain evidence;
record unresolved business rules instead of filling them with familiar defaults.
When discovering domain concepts or reconciling different meanings of a concept,
read [Domain modeling](references/domain-modeling.md)
for scenarios, shared language, and the scope of a model.

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

```text
billing.send_invoice(invoice_id)  # billing owns load, price, send, retry, audit

frames = decode(source)           # media caller owns stage selection and order
frames = crop(frames, region)
encode(frames, format)
```

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

Distinguish the decision from its execution.
Domain behavior determines whether a change is allowed and what it means.
Application coordination obtains facts, invokes that behavior,
arranges persistence and effects, and reports the outcome.
Adapters translate between that model and external mechanisms.
A rule about eligibility, ordering, or required follow-up remains domain policy
even when executing it requires several steps or collaborators.
Application coordination can execute policy defined by a different domain owner.
For each required sequence across collaborators, identify who defines the rule,
who executes the effects, and who enforces each local transition.
Justify policy ownership from the invariant
and the component's supported contract.
Existing control flow establishes execution;
policy ownership needs its own evidence.
Retain a coordinator when its contract owns the domain workflow.
When only execution is established, identify the missing contract evidence
before approving or relocating the policy.
Trace a change to the rule through its owner, callers, and collaborators.
Give a meaningful operation that fits no single object its own domain owner.
Objects, functions over validated values, and private modules can all express
these responsibilities; a fixed layer count or inheritance tree is unnecessary.

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

Match values to their owner's lifetime and rate of change.
Translate external state at composition or adapters.

```text
# Composition owns process settings and stable dependencies.
reporter = Reporter(client, parse_timeout(env["REPORT_TIMEOUT"]))
authorizer = Authorizer(plan_provider)  # retain the provider, not a plan snapshot

# Operations receive changing inputs; authorization obtains the current plan.
reporter.send(report)
authorizer.authorize(tenant_id, action)
```

Bind behavior where its choice becomes stable;
re-evaluate choices whose source can change, or supply them per operation.
Keep environment, request, and storage formats outside domain behavior.

Stateful collaborators and replaceable policy should be visible
at a construction or operation boundary.
A mutable global, default client, registry, or service locator
has process-wide reachability but no meaningful owner.
A process-wide declaration with one clear owner is acceptable only when
neither it nor anything transitively reachable from it
exposes writable shared state.
Global addressability is not itself the problem;
hidden mutation, replaceable policy, or lifecycle is.

An unrelated application bag hides dependencies and couples consumers to its shape.
Pass narrow collaborators; keep contexts that share a domain meaning and lifetime.

```text
handler = InvoiceHandler(billing, logger)
run_job(JobContext(job_id, attempt, deadline, cancellation, logger))
```

Keep each policy or declaration authoritative in one place.
Derive reverse lookups, indexes, transport views,
and other mechanical projections from that source.
Keep similar-looking values separate when they represent independent facts;
deduplication is useful only when the values must change together.

## Keep domain boundaries meaningful

When adapting an external system, translating across a domain boundary,
coordinating external effects, or choosing a process or network boundary,
read [External boundaries](references/external-boundaries.md)
for capability contracts, translation, completion, and distribution decisions.

## Let representations carry the model

When parsing inputs, establishing invariants, or choosing domain data shapes,
read [Domain representations](references/domain-representations.md)
for identity, lifecycle, validated values, modes, and configuration contracts.

## Preserve rules through persistence

When grouping state for mutation, designing load/save contracts,
or separating reporting from state changes,
read [Aggregates and persistence](references/aggregates-and-persistence.md)
for consistency boundaries, concurrency, and read models.
When that work also involves an external system,
read External boundaries for the limits of remote authority and completion.

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

1. Establish the operation's meaning through concrete cases,
   then describe the caller's outcome and sketch representative calls.
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
