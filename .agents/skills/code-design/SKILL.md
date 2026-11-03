---
name: code-design
description: >
  Design, change, or evaluate code ownership, boundaries, contracts,
  representations, dependency lifetimes, domain adapters, public API shapes,
  or where policy and state live, including new code and refactoring.
  Do not use for a local readability-only edit that changes none of these decisions.
---

# Code design

Give each domain decision an owner and callers a stable contract
that hides the owner's implementation coordination.
Aim to make a meaningful change require understanding and editing
the smallest coherent part of the system, not to add abstractions.

## Design from the caller's outcome

Establish what the operation means to affected people and systems:
the relevant facts, decisions, and rules.
Use successful, rejected, and interrupted cases to expose missing concepts
and ambiguous terms; record unresolved business rules instead of inventing defaults.
When discovering domain concepts or reconciling different meanings,
read [Domain modeling](references/domain-modeling.md)
for scenarios, shared language, and model scope.

Sketch representative calls before choosing implementation structure.
Define operations, inputs, results, ownership, failure behavior, mutation,
and ordering; check this contract against real call sites and examples
before implementing the production boundary.
Libraries, frameworks, schemas, protocols, and existing helpers are candidates
for satisfying the contract, not reasons to expose their mechanisms to callers.
If feasibility is uncertain, use a private spike and revise the contract or
implementation from its evidence; do not expose exploration as an accidental contract.

Evaluate the whole candidate through normal use, failure, and recovery,
including caller and operator coordination.
For each added component, state, or step, identify its requirement and obligations.
Obligations introduced by a mechanism are costs, not proof that it is needed.
When a choice needs more machinery to support its consequences,
compare changing that choice.
Prefer designs satisfying the contract with fewer concepts and interactions
across implementation and operation;
keep necessary complexity with the requirement's owner.
For an uncertain material constraint, identify evidence that distinguishes
alternatives before committing to structure that depends on it.

When the domain or workflow is uncertain, keep early structure changeable
and learn from working implementations.
Stabilize an abstraction only when representative behavior and real callers
reveal a cohesive responsibility and narrow contract; refactor toward it then.

For a boundary wrapping, extending, or replacing existing behavior,
establish supported behavior, constraints, and compatibility commitments
from callers, tests, repository history, and operational evidence.
Preserve behavior rather than accidental structure,
but do not dismiss an incumbent mechanism because its purpose is unclear.
Use current requirements, callers, and history to assess likely change;
omit options, extension points, and indirection for hypothetical needs.

Treat stable public names, inputs, outputs, mutation, ordering,
and partial-failure behavior cautiously: they can become compatibility commitments.
Expose only needed operations and make observable behavior deliberate.
Keep representative use direct.
When demonstrated callers need materially different control,
provide an advanced contract without imposing its concepts on common callers;
do not add parallel API layers for hypothetical callers.

A boundary earns its place when its contract replaces knowledge of
representation, policy, or sequence.
Prefer complete domain operations when the domain owns coordination;
retain composable stages when callers own their selection, ordering, or reuse.
Illustrative calls:

```text
billing.send_invoice(invoice_id)  # billing owns load, price, send, retry, audit

frames = decode(source)           # media caller owns stage selection and order
frames = crop(frames, region)
encode(frames, format)
```

Helpers, types, objects, modules, packages, and services can name a real concept,
protect an invariant, own a cohesive operation, or centralize shared policy.
A boundary is shallow if callers must still reconstruct its decision or sequence.
Private methods can organize an owner's implementation without adding owners;
use `$code-readability` to judge that decomposition across the whole operation.

## Put knowledge with its owner

Keep related concepts, state, invariants, dependencies, policy, and workflows
with the concept whose behavior they determine; make ownership visible physically.
Split a file or module for an independently explainable responsibility,
lifecycle, invariant set, dependency boundary, or contract,
not declaration kind, framework layer, or size.

Distinguish who decides from who executes:

- Domain behavior defines whether a change is allowed and what it means.
- Application coordination obtains facts, invokes behavior, arranges persistence
  and effects, and reports outcomes.
- Adapters translate between the model and external mechanisms.

Eligibility, ordering, and required follow-up remain domain policy
when execution needs several steps or collaborators.
Coordination may execute another domain owner's policy.
For each required sequence, identify who defines the rule, executes effects,
and enforces local transitions.
Establish policy ownership from invariants and supported contracts;
existing control flow proves execution, not policy ownership.
Retain a coordinator whose contract owns the domain workflow.
If only execution is established, identify missing contract evidence
before approving or relocating policy.
Trace rule changes through the owner, callers, and collaborators.
Give meaningful operations fitting no single object their own domain owner.
Objects, functions over validated values, and private modules are all options;
no fixed layer count or inheritance tree is required.

Keep only genuinely global coordination at the system root.
Ownership can be nested: an outer owner retains the larger outcome,
supplies private sub-owners with inputs and capabilities, and uses their results
without coordinating their internal policy or sequence.
Knowledge remaining on both sides makes the new boundary a helper, not an owner.

When substantial phases share working state and one lifetime,
consider a private type for one execution, owning state, ordering, and outcome.
Keep values used only within a phase local to it;
use parameters and results for clear dependencies.
Illustrative pseudocode; `?` propagates failure:

```text
parse(source):
    return Parser(source).run()

private Parser:
    source, cursor, symbols, diagnostics

    run():
        readHeader()?
        records = readRecords()?
        resolveReferences(records)?
        return finish(records)

    # Phase implementations remain within this owner.
```

This parser lasts for one parse;
it need not be a persistent entity or reusable service.
Do not merely bundle arguments while leaving sequencing with callers.
Keep a local sequence when already clear, or separate functions when their inputs
and results express relationships without scattering ownership.

Match values and dependencies to their owner's lifetime and rate of change.
Translate external state at composition or adapters; keep environment, request,
and storage formats outside domain behavior.
Illustrative pseudocode:

```text
# Composition owns process settings and stable dependencies.
reporter = Reporter(client, parse_timeout(env["REPORT_TIMEOUT"]))
authorizer = Authorizer(plan_provider)  # retain the provider, not a plan snapshot

# Operations receive changing inputs; authorization obtains the current plan.
reporter.send(report)
authorizer.authorize(tenant_id, action)
```

Bind behavior where its choice becomes stable;
re-evaluate choices whose source can change or supply them per operation.
Expose stateful collaborators and replaceable policy at construction or operations.
A mutable global, default client, registry, or service locator has process-wide
reachability without a meaningful owner.
A process-wide declaration with one clear owner is acceptable only when
neither it nor anything transitively reachable from it
exposes writable shared state.
Global addressability itself is acceptable;
hidden mutation, replaceable policy, or lifecycle is the concern.

Pass narrow collaborators rather than an unrelated application bag;
keep contexts sharing domain meaning and lifetime.
Illustrative calls:

```text
handler = InvoiceHandler(billing, logger)
run_job(JobContext(job_id, attempt, deadline, cancellation, logger))
```

Keep each policy or declaration authoritative in one place.
Derive reverse lookups, indexes, transport views, and other mechanical projections.
Keep similar-looking values separate when they are independent facts;
deduplicate only when they must change together.

## Read the reference for the decision

- When adapting an external system, translating across domains, coordinating
  external effects, or choosing a process or network boundary,
  read [External boundaries](references/external-boundaries.md)
  for capability contracts, translation, authority, completion, and distribution.
- When designing constructors or validation, parsing inputs, establishing
  invariants, or choosing domain data shapes,
  read [Domain representations](references/domain-representations.md)
  for construction paths, identity, lifecycle, and configuration contracts.
- When grouping state for mutation, designing load/save contracts,
  or separating reporting from state changes,
  read [Aggregates and persistence](references/aggregates-and-persistence.md)
  for consistency, concurrency, and read models.
  Also read External boundaries when an external system is involved.
- When a local improvement differs from repository precedent,
  could expand into migration, or implements an accepted migration,
  read [Scoped evolution](references/scoped-evolution.md)
  for scope and transition obligations.

## Check change locality

Trace representative workflows and a likely change through the complete design.
Identify the decision's owner, what callers must know, and declarations changing together.
Repeated crossings to complete one operation or change one policy suggest fragmentation.
Callers should change for a different requested operation or relied-on contract,
not an internal representation or implementation change.
If one domain change requires mechanical edits across callers,
move their shared knowledge to its natural owner.
Remove or deepen abstractions that add navigation while leaving the same facts
live on both sides.

Use `$code-readability` for control flow, naming, and local helpers;
make a design change when local complexity comes from split ownership or policy.
Choose the simplest coherent ownership model, not the smallest patch.
Repair and integrate a wrong governing boundary instead of adding an exception
that creates another owner; keep necessary domain complexity cohesive.
