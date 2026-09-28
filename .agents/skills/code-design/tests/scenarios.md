# Code design behavioral tests

## Select code-design for ownership and representation decisions

### Prompt

Available skills:

- `code-design`: `{GUIDANCE_DESCRIPTION}`
- `code-readability`: Use when writing, changing, organizing,
  or reviewing non-generated code.
- `code-comments`: Use when deciding whether code comments are needed.

A user asks you to refactor a service so retry policy moves from several
callers into the component that owns the operation.
The refactor introduces a validated domain representation at the external
boundary and keeps public behavior unchanged.

Choose the skill or skills you would load before acting.
Explain the responsibility of each selection.
Do not design the refactor or modify files.

### Expected behavior

- Select `code-design` for ownership, policy, boundary, and representation
  decisions.
- Select `code-readability` because the task changes non-generated code.
- Do not select `code-comments` unless the work reaches a comment decision.

### Adjacent valid case

#### Prompt addition

Instead, the user asks only to rename one local variable for clarity.
The rename changes no ownership, boundary, contract, or representation.

#### Expected behavior

- Select `code-readability`.
- Do not select `code-design` for a local readability-only edit.

## Match ownership to lifetime

### Prompt

Use the `code-design` skill.
Do not modify files.

Recommend the dependency and configuration shape for each case:

1. A reusable reporting package reads `REPORT_TIMEOUT`
   and constructs a default HTTP client inside every `Send` call.
   The timeout and client do not change during a process run.
2. A tenant's plan can change while the process is running,
   and the next authorization request must observe the new plan.
3. Request handlers receive an `AppContext` containing the database,
   logger, metrics, authentication, billing, mail, and feature flags,
   although each handler uses only two or three fields.
4. A `JobContext` contains the job ID, attempt, deadline,
   cancellation signal, and job-scoped logger.
   These values share one job-execution lifetime and meaning.
5. A package-level mutable cache is initialized automatically
   and shared by every client, tenant, and test,
   although cache contents should be isolated per client.
6. A package-level immutable table defines the wire names
   of a fixed protocol enumeration.

Explain the ownership and lifetime behind each recommendation.

### Expectations

- Read process configuration at the composition boundary,
  construct the reporting dependency once,
  and inject the stable values or capability.
- Keep the dynamic tenant plan behind a provider
  or supply it per operation; do not freeze it at process startup.
- Replace the unrelated application bag with narrow dependencies
  owned by each handler or cohesive service.
- Preserve the cohesive job context because it represents a real lifecycle,
  rather than exploding it into unrelated parameters.
- Move the mutable cache into the client that owns its lifetime;
  do not hide it behind package reachability or a default singleton.
- Permit the immutable protocol table to remain process-wide
  when it has one owner and no hidden mutable behavior.
- Base the decisions on meaning and lifetime,
  not one universal preference for construction or parameters.

### Pressure variant

#### Prompt addition

A framework makes one process-global context convenient to pass everywhere,
and a reviewer says consistency is more important than explicit dependencies.

#### Expected behavior

- Do not let framework convenience determine domain ownership.
- Preserve genuinely process-global coordination at the composition boundary.

### Adjacent valid case

#### Prompt addition

A build invocation receives one cohesive `BuildContext`
with a workspace, target graph, cancellation signal,
and invocation-scoped event sink.

#### Expected behavior

- Permit the context when the values share the build lifecycle and contract.
- Do not reject every multi-field context as a super-config.

## Design public behavior deliberately

### Prompt

Use the `code-design` skill.
For Go-specific API choices,
also apply the `go-development` skill.
Do not modify files.

A Go library is preparing its first stable release.

- It exports twelve conversion helpers added for hypothetical future callers,
  while all current callers use `DecodeInto`.
- `ListWidgets` builds a slice by iterating an internal cache map.
  The slice elements point to mutable cached widgets.
  Callers sort and annotate returned widgets
  without intending to mutate the cache.
  Existing tests snapshot one observed iteration order,
  but no caller requirement establishes ordering.
- `ParseDocument` sometimes returns a populated document with an error.
  No caller consumes the partial document,
  and the package does not define what parts are valid.
- A new stable constructor is gaining several related inputs
  and repository history shows that the input set has grown repeatedly.

Recommend the stable contract and API direction.
Distinguish language-neutral design decisions
from Go-specific API mechanics.

### Expectations

- Remove the speculative conversion surface and retain the demonstrated
  conversion operation.
- Return caller-owned collection data,
  including non-aliased mutable elements,
  and deliberately specify ordering or its absence;
  do not let map storage or snapshots define the contract accidentally.
- Return no usable partial result on parse failure
  unless a caller need and valid-part contract are established.
- Recognize the demonstrated evolution pressure around related inputs,
  then use the `go-development` skill for the concrete Go API shape.
- Treat exported shapes and observable outputs as compatibility commitments.

### Pressure variant

#### Prompt addition

The release is due today,
and removing helpers or correcting order-sensitive snapshots
would create review work.

#### Expected behavior

- Do not make accidental or hypothetical behavior permanent
  solely to avoid pre-release work.
- Do not invent new semantics without caller or contract evidence.

### Adjacent valid case

#### Prompt addition

An internal helper takes two integers,
has one caller,
and has no observed or credible growth pressure.

#### Expected behavior

- Keep the direct signature when a new request object
  would add a name without a useful concept or compatibility benefit.

## Make representations express the domain

### Prompt

Use the `code-design` skill.
Do not modify files.

Assess these proposed API shapes:

1. `BulkRegister(map[string]string)` uses email as the key
   and login as the value.
   One registration per email is an implementation convenience,
   not a domain rule.
2. `SetCategories` receives category records with `name` and `color`.
   Names must be unique, and duplicate input must produce an error.
   Callers assemble records; the owner later looks them up by name.
3. `Render(path, omitTrailingSlash bool)` receives the same boolean
   on every call because the choice is site-wide,
   and a third path style is planned.
4. `Node.HasChildren` records a stable binary fact.
5. `ValidateRoutes([]RouteInput) error` checks non-empty service names
   and uniqueness,
   then later functions continue to accept the unchecked input slice.
6. A template evaluator accepts variable bindings.
   Callers assign text to variable names, replace a binding by name,
   and reuse the bindings across templates; binding order has no meaning.

Recommend the representation and explain what knowledge it should carry.

### Expectations

- Replace the accidental email map boundary with named registration records;
  keep any lookup map inside its owner.
- Accept named category records in a list or equivalent domain collection;
  validate unique names before constructing any private lookup index.
  Do not make callers construct a map merely because the owner needs lookup,
  or lose duplicate input before it can be rejected.
- Permit a map for template bindings because callers manipulate the associations
  themselves; do not turn the preference for records into a categorical map ban.
- Replace the slash boolean with a named path-style concept
  stored at site scope.
- Bind the corresponding behavior when the site is constructed
  rather than branching on the stable choice during every render.
- Keep `HasChildren` as a boolean because it is a genuine binary fact.
- Parse routes into a representation that carries validity and uniqueness,
  rather than discarding the proof and passing raw inputs onward.
- Decide from domain meaning and scope,
  not blanket bans on maps, booleans, or primitive inputs.

### Pressure variant

#### Prompt addition

A style review says exported APIs must never contain maps or booleans.

#### Expected behavior

- Reject the categorical rule.
- Preserve representations whose semantics match the domain contract.

### Adjacent valid case

#### Prompt addition

A parser retains the original source spelling beside its parsed value
because diagnostics must quote user input and serialization must round-trip it.

#### Expected behavior

- Permit retaining raw evidence for diagnostics or round-tripping.
- Keep the parsed value as the representation used for domain decisions.

## Establish workflow ownership within application coordination

### Prompt

Use the `code-design` skill.
Do not modify files.

Review an unreleased reminder service before release.
A reminders package defines recipient eligibility, delivery windows,
retry policy, and outcome records, plus renderer and delivery adapter contracts.
The service's `Runtime.send_due` also handles authentication, job admission,
tenant lookup, persistence, and a request timeout.
It selects recipients, checks eligibility, renders messages, delivers them,
and records their observed outcomes in the required order.
A retry worker in the reminders package rechecks eligibility before redelivery.
Delivery may continue after a local timeout.
The adapter interfaces expose multiple operations and opaque intermediate values.
Remote clients already make one `SendDue` request;
this Runtime is the only application integration.

Identify material design issues, if any, and give the smallest supported
recommendation, including a representative call shape when a change is warranted.
Preserve the required ordering and meaningful failure and recovery behavior.
State evidence gaps instead of inventing additional requirements.

### Expected behavior

- Identify the domain rules governing initial delivery and retry,
  separately from execution and enforcement by the collaborators.
- Assess whether Runtime's contract owns those rules or coordinates another
  domain owner's policy; its application duties alone do not settle that question.
- Trace a likely rule change through the policy owner and its consumers.
- Permit retaining Runtime when its supported contract makes it the workflow
  owner, or identify evidence needed to establish a different assignment.
- Preserve useful adapter contracts and uncertain delivery outcomes.
- Do not require a new facade, relocation, fewer methods, or duplicated callers
  as a prerequisite for assessing ownership.

### Adjacent valid case

#### Prompt addition

The supported Runtime contract explicitly owns the reminder workflow:
recipient eligibility, allowed delivery order, outcome recording, and retry.
The reminders package supplies the policy types used by that owner.
The retry worker invokes the same operation on Runtime.
A separate transport adapter performs framing and calls Runtime's complete
operation without using the rendering or delivery interfaces.

#### Expected behavior

- Retain the supported coordinator while preserving its adapter contracts.
- Distinguish ownership of workflow policy from each adapter's own protocol.

## Remove shallow layers without scattering policy

### Prompt

Use the `code-design` skill.
Do not modify files.

An order request passes through `OrderFacade`,
`OrderService`, and `OrderManager`.
Most methods forward the same arguments and result unchanged.
Meanwhile, controllers independently decide whether an order may be cancelled
by checking payment state, fulfillment state, tenant policy, and a deadline.

A separate `FraudPolicy` combines a model score,
regulatory region, and manual-review state.
Orders and payouts both use it;
the policy changes independently and has dedicated tests.

The repository also exposes query transformations
that callers intentionally select and reorder
to build different reports.

A reviewer proposes deleting all of these boundaries
and inlining their behavior into each request handler
so the whole request path is visible in one file.
Recommend the design and trace a likely policy change through it.

### Expectations

- Collapse the pass-through order layers into one meaningful order boundary.
- Give that boundary a complete cancellation operation
  that owns the shared eligibility policy.
- Keep `FraudPolicy` because it owns independent shared policy
  and prevents orders and payouts from reconstructing it.
- Preserve the query transformations
  because their composition belongs to callers.
- Show that a cancellation or fraud-policy change reaches one owner,
  while a report-shape change can remain with the composing caller.
- Judge boundaries by knowledge replaced and change locality,
  not visibility in one file or declaration count.

### Pressure variant

#### Prompt addition

A package-size rule rewards fewer types and methods,
and wholesale inlining scores best.

#### Expected behavior

- Treat the metric as evidence at most,
  not as a substitute for caller workflow and ownership.

### Adjacent valid case

#### Prompt addition

One request handler contains a two-line conversion
used nowhere else and governed by no shared policy.

#### Expected behavior

- Permit the local conversion to remain inline;
  do not preserve every named layer or create a policy owner without policy.

## Keep external mechanisms at their boundary

### Prompt

Use the `code-design` skill.
Do not modify files.

Recommend the boundary for each case:

1. A subscription operation receives an HTTP request
   and a persistence record,
   then extracts account and plan data itself.
2. A generated `CurrencyAmount` type is already the canonical domain
   representation shared by every subscription component.
   A new package proposes an identical local amount type and conversions.
3. Business logic receives a generic RPC client
   and assembles vendor endpoints, headers, status rules,
   and response parsing for a message broker.
4. One health endpoint performs a fixed broker ping
   and reports the result without business policy or reuse.

### Expectations

- Translate HTTP and persistence shapes into a subscription request
  at their adapters.
- Keep the canonical amount type when its ownership and compatibility
  are already domain-level; do not add translation as ceremony.
- Give business logic a broker capability expressed as domain operations,
  with the adapter owning vendor protocol and failures.
- Keep the isolated health probe local;
  do not manufacture a service interface without domain knowledge to hide.
- Add boundaries only when ownership or representation changes
  or the contract replaces meaningful knowledge.

### Pressure variant

#### Prompt addition

A layering rule requires a new DTO and interface at every package boundary.

#### Expected behavior

- Reject duplicate representations and pass-through interfaces
  that do not change ownership or hide knowledge.
- Preserve adapters where an external representation genuinely enters.

### Adjacent valid case

#### Prompt addition

Two vendors implement the same message-delivery capability
with different protocols, outputs, and failure semantics.

#### Expected behavior

- Permit a domain service boundary whose adapters own those differences.

## Improve locally without inventing a migration

### Prompt

Use the `code-design` skill.
Do not modify files.

For each case, choose the scoped design
and state when broader approval is needed:

1. Twenty legacy components read environment variables internally.
   A new isolated component can receive constructed configuration
   without sharing an API or ownership boundary with them.
2. A stable public concept already has one constructor pattern.
   A new feature could use it,
   or introduce an incompatible second pattern for the same concept.
   No migration has been proposed.
3. State names are authored in one list
   and repeated in a reverse lookup that must stay synchronized.
   A user-facing label table happens to contain the same strings today,
   but product owns those labels independently.

### Expectations

- Use the better constructed configuration locally
  and leave unrelated legacy call sites unchanged.
- Avoid introducing ambiguous precedent for the stable public concept;
  use the valid existing pattern
  unless it blocks correctness, safety, or the requested outcome.
- Seek approval before a prerequisite repair materially expands scope
  or before establishing a migration destination.
- Author the state-name relationship once and derive the reverse lookup.
- Keep independently owned user labels separate despite current equality.
- Distinguish local containment, prerequisite repair,
  and an accepted migration rather than treating them as one action.

### Pressure variant

#### Prompt addition

A reviewer argues that any use of a better local pattern
requires converting all twenty legacy components for consistency.

#### Expected behavior

- Decline the unrequested migration when coexistence has a clear boundary.
- Identify concrete ambiguity or duplicate ownership
  before requiring repository-wide change.

### Adjacent valid case

#### Prompt addition

The existing constructor cannot represent a required safety invariant,
and every caller of the new feature would otherwise bypass the invariant.

#### Expected behavior

- Treat repair as possible prerequisite work,
  explain why the smaller route fails,
  and request approval before expanding the task materially.

### Adjacent valid migration case

#### Prompt addition

Maintainers have accepted a constructed-configuration API
as the repository destination,
scheduled movement of the legacy population,
and assigned ownership for compatibility and rollout.

#### Expected behavior

- Put new work on the accepted destination.
- Contain new uses of the retiring environment-reading pattern.
- Permit a narrow check that protects the accepted direction
  without requiring the current task to migrate every legacy caller.

## Route Go API mechanics to Go development

### Prompt

Use the `code-design` and `go-development` skills.
Do not modify files.

A Go library has these pending API decisions:

1. `NewParser` accepts `*os.File`,
   but the parser only calls `Read`.
   Tests and callers want to parse network bodies and in-memory buffers.
2. A new package proposes returning a package-defined `Client` interface
   from its constructor,
   although the package owns the implementation
   and no caller needs alternate implementations of the result.
3. A stable exported `Reporter` interface has third-party implementations.
   A new feature needs `Flush`,
   but most existing reporters do not support it.

Recommend the public API evolution
and identify which decisions come from general design
versus Go-specific compatibility rules.

### Expectations

- Accept the smallest capability the parser consumes,
  such as `io.Reader`, rather than the concrete file mechanism.
- Return the package-owned concrete client
  instead of publishing an unnecessary result interface.
- Do not add `Flush` to the stable interface
  and break existing implementations.
  Use an additive concrete method,
  a separate capability interface at the consumer,
  or an explicit compatibility plan as requirements dictate.
- Attribute caller-outcome, surface-area,
  and compatibility reasoning to general design;
  use `go-development` for interface-direction and language mechanics.
- Do not copy Go-specific API recipes into the code-design guide.

### Pressure variant

#### Prompt addition

A mocking framework generates tests only from exported interfaces,
and a reviewer asks the library to publish interfaces for every result.

#### Expected behavior

- Do not let a test tool force unnecessary provider-owned interfaces.
- Define consumer-side interfaces only where a consumer needs substitution.

### Adjacent valid case

#### Prompt addition

A function accepts a storage dependency
and uses only `Get` and `Put`;
several implementations already exist.

#### Expected behavior

- Permit a narrow input interface owned by the consumer.
- Do not turn `return structs` into a ban on input interfaces.

## Preserve default behavior and reject invalid options at construction

### Prompt

Use the `code-design` skill.
Do not modify files.

A public client accepts this configuration:

```go
type RetryMode int

const (
    RetryDefault RetryMode = iota
    RetryDisabled
    RetryBounded
)

type Config struct {
    RetryMode RetryMode
    RetryLimit int
}

func NewClient(cfg Config) *Client
```

The established zero-value behavior retries transient failures three times.
`RetryBounded` requires a positive limit.
Values outside the declared modes are unsupported.

A patch changes `RetryDefault` to mean no retries
and lets each request path interpret unsupported combinations independently.
The client retains the whole Config object to choose retry behavior on requests.
Recommend the design and identify where each decision belongs.
Show construction and the state the client retains.

### Expectations

- Preserve the established retry behavior for the zero value
  unless the public contract is deliberately changed.
- Resolve `RetryDefault` to the established behavior
  at construction or the nearest configuration boundary.
- Reject unsupported modes and invalid bounded limits at that boundary.
- Do not allow request paths to interpret the same invalid state differently.
- Extract the required configuration values and construct the resolved retry
  policy at the boundary; show the client retaining that policy.
- Prefer a constructor result that can report invalid configuration
  over deferring failure to unrelated work.
- Repair the configuration boundary and its representation
  even when scattered request-path checks would produce a smaller diff.

### Pressure variant

The patch author says only one request path currently uses retries,
changing the constructor signature touches more callers,
and treating zero as disabled makes the implementation shorter.

- Preserve compatibility with the established zero-value contract.
- Keep validation and default resolution at the governing boundary.
- Evaluate simplicity in the resulting design,
  not by the number of lines changed in the patch.

### Adjacent valid case

The product intentionally introduces a new major-version constructor
whose documented contract disables retries by default.
A migration guide identifies the changed behavior,
and callers opt into the new constructor explicitly.

- Permit the deliberate default change at the versioned boundary.
- Keep unsupported choices invalid.
- Do not preserve the old default inside an explicitly breaking contract.

## Distinguish fixed bindings from transitively immutable state

### Prompt

Use the `code-design` skill.
Do not modify files.

A package declares a process-wide registry:

```go
var handlers = map[string]Handler{
    "json": jsonHandler,
    "text": textHandler,
}

func Register(name string, handler Handler) {
    handlers[name] = handler
}

func HandlerFor(name string) (Handler, bool) {
    handler, ok := handlers[name]
    return handler, ok
}
```

A review describes `handlers` as fixed package configuration
because the variable is never rebound.
Concurrent callers can register and look up handlers.

Recommend the final ownership and representation.
Explain whether the process-wide declaration is immutable.

### Expectations

- Treat the map as writable shared state
  because its contents can change even when its binding does not.
- Do not describe the declaration as immutable
  based only on the absence of rebinding.
- Establish one owner for mutation and synchronization,
  or move registration into an explicitly owned registry instance.
- Keep construction, mutation, lookup, and concurrency policy
  at the same governing boundary.
- Prefer the representation whose ownership remains visible to callers
  over preserving the package global with local patches.

### Pressure variant

A reviewer proposes adding a lock only inside `Register`
because that is the smallest patch
and current tests do not perform concurrent lookup.

- Account for every read and write of the shared state.
- Reject a partial synchronization patch
  that leaves lookup racing with registration.
- Repair the ownership boundary rather than optimizing for diff size.

### Adjacent valid case

The supported handlers are compiled into an unexported read-only slice.
No API returns a writable alias,
no runtime path mutates its elements,
and lookup derives results without caching into shared state.

- Permit the process-wide declaration as fixed data.
- Verify immutability transitively through its reachable contents and aliases.
- Do not introduce registry ownership or synchronization
  when no writable shared state exists.

## Derive domain meaning before fixing the contract

### Prompt

Use the `code-design` skill.
Do not modify repository files or external state.

A team is adding membership cancellation to a small monolith.
Support calls a member inactive when login is disabled;
billing calls a member inactive after all contractual obligations end.
Both use the same member ID.
A generated vendor Customer class is shared today.
The product request says 'cancel membership and notify the member'
but doesn't establish whether cancellation ends obligations immediately
or whether notification must survive a process crash.
The service accepts draft membership applications;
they may omit an address required on submission.
Propose the next design work and a provisional ownership model
without inventing product decisions.
Distinguish what can stay simple from what needs more evidence.
Then cite the portions of the supplied guidance that teach the relevant reasoning
to a future agent unfamiliar with these concepts;
state material gaps in that guidance separately from your own design knowledge.

### Expected behavior

- Establish cancellation and notification requirements through concrete cases.
- Preserve distinct access and billing meanings despite the shared identity.
- Permit incomplete drafts and enforce submission requirements on submission.
- Keep domain decisions, coordination, and vendor translation with their owners.
- Keep the monolith and existing simple mechanisms unless requirements demand more.
- Cite teaching that explains the decisions; distinguish extra domain knowledge.

### Unacceptable behavior

- Invent cancellation or notification guarantees absent from the request.
- Force a universal inactive flag or a microservice per model.
- Require all drafts to satisfy submission rules.

## Preserve a rule through concurrent persistence

### Prompt

Use the `code-design` skill.
Do not modify repository files or external state.

A scheduling service stores a room's confirmed reservations as rows.
A room has a capacity of 12,
and simultaneous bookings must never allocate more seats than capacity
for the same session.
Booking edits arrive from the web UI and an import worker.
The current Room object checks capacity in addReservation,
then ReservationRepository saves only the changed row.
There is also a monthly utilization report across rooms.
Propose the smallest coherent design for the write and report paths,
including load/save contracts, failure outcomes, and evidence needed to trust it.
Storage provides ordinary SQL transactions and conditional updates;
do not assume any further product rules.
Return a concise design decision with small API shapes if useful.

After the design, assess which decisions the supplied guidance teaches.
Cite relevant passages and distinguish knowledge supplied from outside it.

### Expected behavior

- Protect capacity across web and import writes, including concurrent operations.
- Derive sufficient coherent loading and an atomic, conflict-aware commit contract.
- Permit row-level storage updates behind the governing consistency boundary.
- Permit a direct reporting projection without forcing mutable room loading.
- Distinguish domain rejection, concurrency conflict, and uncertain commit outcome.
- Identify evidence needed at the real storage boundary.

### Unacceptable behavior

- Treat private mutation methods or an ordinary transaction alone as sufficient.
- Leave a writer able to bypass capacity enforcement.
- Retag stale state with a new revision or blindly retry uncertain effects.
- Require one custom repository for every table or a new reporting database.

## Respect authority behind a gateway

### Prompt

Use the `code-design` skill.
Do not modify repository files or external state.

A deployment application prepares releases from an external artifact service:
GetReleaseMetadata and ListFiles are independent reads,
ListFiles is paginated, and files may change while they are fetched.
The vendor has no common snapshot/revision token spanning those calls.
Publish must deploy only a set of files that matches an approved manifest.
A proposal returns a Release aggregate assembled from both calls and exposes
SaveRelease, implemented by uploading files and then updating release metadata;
the vendor can fail between those writes.
The app has its own SQL database for deployment records
and the vendor accepts a client operation ID for publish,
with status lookup by that ID.
Design the smallest useful domain-facing gateway,
state what a caller can rely on, and explain completion and recovery.
Do not invent vendor guarantees.
Return a concise decision with API shapes if useful.

After the design, assess which decisions the supplied guidance teaches.
Cite relevant passages and distinguish knowledge supplied from outside it.

### Expected behavior

- Distinguish response assembly from a coherent snapshot and mutation aggregate.
- Do not claim the stated provider can atomically publish an approved file set.
- Offer only implementable capabilities and state remaining feasibility questions.
- Retain operation identity and reconcile an uncertain publish outcome.
- Distinguish correlation from guaranteed deduplication and safe resubmission.
- Keep local persistence and remote effects separate in the completion contract.

### Unacceptable behavior

- Claim a save method or SQL transaction makes vendor writes atomic.
- Treat a timeout or temporarily absent status as proof of no remote effect.
- Manufacture publication guarantees by reading the files again.
- Hide partial completion behind ordinary rejection.

## Preserve simpler designs when stronger guarantees are unnecessary

### Prompt

Use the `code-design` skill.
Do not modify files.

Recommend the design for each independent case:

1. An internal catalog editor changes a display label on one record.
   There are no rules spanning records, and overwriting with the latest edit
   is explicitly accepted.
   Reads and writes use the same shape and one database.
2. Two modules use a generated amount type with one domain owner,
   the same units, equality, and compatibility policy.
3. A provider offers an immutable manifest revision, atomic publication of that
   revision, and documented deduplication of a publication ID for seven days.
   Status lookup reports the revision that was published.
   The application recovers pending publications within that retention period.
4. A local command prints an optional progress message.
   Losing that message on a crash is acceptable.

Explain which abstractions and guarantees each case needs.

### Expected behavior

- Permit direct validated CRUD and one representation for the catalog editor.
- Preserve the shared amount type without ceremony at module boundaries.
- Use the provider's real guarantees to offer a coherent publication contract.
- Keep a direct progress effect without adding durable messaging.
- Base each choice on the requirements and capabilities given.

### Unacceptable behavior

- Require aggregates, custom repositories, separate read models, or domain events
  for simple maintenance without a corresponding need.
- Ban shared generated types or remote atomic operations categorically.
- Add an outbox for optional progress output.


## Establish validity through supported construction

### Prompt

Use the `code-design` skill.
Do not modify files.

An unpublished delivery API exposes a `Delivery` object with private fields.
Its only supported creation path is a factory accepting a destination label
and payload description.
There are no supported setters or decoding paths.
The factory currently stores arbitrary inputs;
`Delivery.Validate()` rejects an empty label or an unsupported payload format,
and `Send()` repeats those checks before contacting the destination.
The CLI calls `Validate()` before obtaining a network connection.
Library callers invoke `Send()` directly.
A reviewer wants to preserve both checks because library callers bypass the CLI.

Recommend the smallest coherent API and explain where each failure belongs.
Show the construction and operation contracts.

### Expectations

- Make the factory reject invalid inputs and retain resolved payload information.
- Remove object validation methods and repeated invariant checks from Send.
- Explain how fallible construction serves CLI preflight and library callers.
- Keep delivery failures and changing destination availability at operation time.
- Require no extra preparation wrapper or state hierarchy for these invariants.

### Adjacent valid case

#### Prompt addition

Instead, the documented API supports callers creating and editing a public
`DeliveryInput` record, including incomplete forms and decoded user settings.
An editor wants validation feedback while users correct those fields.
The execution operation accepts this raw input directly for compatibility.

#### Expected behavior

- Permit useful validation on DeliveryInput and preserve supported construction.
- Check current raw inputs at execution because previous feedback can become stale.
- Do not silently require a new constructor-only API or remove editor feedback.
- Keep any internally constructed object valid after the raw-input boundary.

## Apply construction guarantees in Python

### Prompt

Use the `code-design` skill.
Do not modify files.

An unpublished Python Packet class accepts a nonempty label and a borrowed
binary stream in its constructor.
It has no supported setters, subclassing, or decoding path.
Its public validate method delegates to a private validator;
send calls the private validator again before reading the stream.
The CLI validates before connecting; library callers call send directly.
Show the smallest coherent API and explain what happens when callers pass
one Packet to another function.
The caller controls closing the stream and replay is not promised.

### Expected behavior

- Check stable invariants in construction and omit redundant object validators.
- Use ordinary Python methods and object references.
- Preserve shared stream state and the caller's responsibility for closing it.
- Do not introduce copying or ownership-transfer machinery without a caller need.
- Leave changing I/O failures at the operation that uses the stream.
