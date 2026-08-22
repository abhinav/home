# Code readability behavioral tests

## Order contracts and implementations for reader need

### Prompt

Read the guidance at `~/.agents/AGENTS.md`
and `~/.agents/docs/code-readability.md`.
For the Go case, also read `~/.agents/docs/go.md`.
Do not modify files.

Two new modules each expose the same review operation:

- A Go interface and a Rust trait declare the operation.
- Go and Rust functions implement it with non-trivial bodies in separate files.

Each operation's signature uses `LoadCatalogRequest` and `LoadCatalogResult`.
The Go implementation first creates a private `scanCursor`,
then passes that cursor to a private `scanPages` helper.
The Rust implementation does the same
with private `ScanCursor` and `scan_pages` items.
Both languages permit these declarations to appear after the operation.

The contract files put request and result records before the interface or trait.
The implementation files put the function body before those records.
Recommend the exact top-to-bottom declaration outline for each file
and explain why contracts and implementations use different orders.
State whether that rule changes for another language
that also permits later declarations to be referenced.

### Expectations

- Put the interface or trait first in each contract file.
- Follow the contract with request and result records in first-need order.
- Put request and result records immediately before each implementation.
- Follow each implementation with `scanCursor` and `scanPages` in Go,
  or `ScanCursor` and `scan_pages` in Rust, matching their first need.
- Treat signature references as relationships, not source-order prerequisites.
- Explain that compact contracts can lead without hiding their boundaries,
  while records must precede bodies to avoid scrolling past implementation.
- Apply the same distinction to another language
  with the same declaration-reference behavior.

### Pressure variant

#### Prompt addition

The repository style guide requires one declaration order for every file,
both layouts are already implemented, changing them adds review noise,
and the release branch closes in an hour.

#### Expected behavior

- Preserve contract-first and implementation-boundary-first order.
- Do not convert uniformity, sunk cost, review size, or deadline pressure
  into a reason to erase the distinction.

### Adjacent valid case

#### Prompt addition

A C header exposes `process_request`.
The compiler requires the request and result struct declarations to be visible
before the function prototype,
and no suitable prior declaration already exists.

A separate Go function has a one-line implementation.
Its request and result records remain visible immediately below
without scrolling.

#### Expected behavior

- Put the required struct declarations before the function prototype.
- Limit the exception to the declarations required by the language.
- Do not claim that reader order overrides compilable source order.
- Put the compact Go implementation before its request and result records.
- Do not apply the scrolling exception when no scrolling cost exists.

## Keep Go receiver clusters coherent

### Prompt

Read the guidance at `~/.agents/AGENTS.md`,
`~/.agents/docs/code-readability.md`, and `~/.agents/docs/go.md`.
Do not modify files.

A Go file primarily defines `Client` and secondarily defines `Transport`.
Each type has a constructor and several methods.
`Client.Fetch` has a substantial implementation body
and uses `FetchRequest` and `FetchResult` records.

The current patch orders declarations by runtime call sequence:
both type declarations and both constructors,
then alternating `Client` and `Transport` methods.
Recommend the exact declaration clusters and their top-to-bottom order.

### Expectations

- Put the complete `Client` cluster before the `Transport` cluster.
- Within each cluster, put the type declaration first, constructors second,
  and methods third.
- Order constructors and methods for readability within their part.
- Put `FetchRequest` and `FetchResult`
  immediately before the substantial `Client.Fetch` method.
- Do not interleave methods merely to mirror runtime call sequence.
- Explain that one receiver's methods share state and invariants
  that the reader should retain as one mental model.

### Pressure variant

#### Prompt addition

The reviewer says runtime order is easier to trace,
the interleaving is already implemented, changing it adds review noise,
and the release branch closes in an hour.

#### Expected behavior

- Preserve receiver clusters.
- Do not convert runtime sequence, sunk cost, review size,
  or deadline pressure into a reason to interleave methods.

### Adjacent valid case

#### Prompt addition

A small protocol adapter defines paired methods on `Encoder` and `Decoder`.
Maintainers always compare each pair to verify one handshake transition,
and neither receiver has an independently meaningful lifecycle in this file.

#### Expected behavior

- Permit paired interleaving when the reader's task genuinely treats
  both receiver types as one operation.
- Require concrete reduction in reconstruction or navigation cost.
- Do not generalize the exception to ordinary cooperating types.

## Keep boundaries that replace knowledge

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`
and follow any routed design guidance it makes applicable.
Do not modify files.

A publishing operation currently has this shape:

```go
func Publish(req Request, repo *Repository) error {
    if req.Article == nil || !req.Article.Draft || len(req.Attachments) == 0 {
        return nil
    }

    documents, err := decodeAttachments(req.Attachments)
    if err != nil {
        return err
    }

    return repo.Activate(req.Article.ID, documents)
}

func Preview(files []File) ([]Document, error) {
    documents, err := decodeAttachments(files)
    if err != nil {
        return nil, err
    }
    return renderPreview(documents), nil
}

func decodeAttachments(files []File) ([]Document, error) {
    archive, err := openArchive(files)
    if err != nil {
        return nil, err
    }
    manifest, err := parseManifest(archive)
    if err != nil {
        return nil, err
    }
    return decodeDocuments(archive, manifest)
}

func (r *Repository) Activate(id ArticleID, documents []Document) error {
    tx := r.db.Begin()
    defer tx.Rollback()
    if err := r.articles.ActivateTx(tx, id); err != nil {
        return err
    }
    if err := r.search.ReplaceTx(tx, id, documents); err != nil {
        return err
    }
    if err := r.events.AppendTx(tx, ArticleActivated{ID: id}); err != nil {
        return err
    }
    return tx.Commit()
}
```

A reviewer asks to move the first condition
into a private, single-use `publishable(req)` helper,
then inline `decodeAttachments` and `Repository.Activate`
into `Publish` so maintainers need not navigate to their implementations.

Recommend the resulting code shape.
Preserve behavior and do not invent APIs.

### Expectations

- Keep the simple, single-use prerequisites at the decision point.
- Reject `publishable` because its caller still needs the conditions
  and the helper would add navigation without replacing knowledge.
- Preserve `decodeAttachments` because preview and publish use
  the same archive, manifest, and document-decoding operation.
- Preserve `Repository.Activate` because its transaction makes article,
  search, and event changes succeed or fail together.
- Judge the coherent operation rather than function length or call count.

### Pressure variant

#### Prompt addition

A repository style rule requires every function to stay below eight lines.

#### Expected behavior

- Do not extract shallow helpers solely to meet the size target.
- Explain the readability cost without treating long functions as inherently good.

### Adjacent valid case

#### Prompt addition

Manual start, scheduled start, and retry currently call this operation:

```go
func (q *Quota) MayStart(org Organization, kind JobKind) bool {
    limit := q.limits.For(org.Plan, kind)
    active := q.usage.Active(org.ID, kind)
    pending := q.reservations.Pending(org.ID, kind)
    return active+pending < limit
}
```

A reviewer asks each caller to inline these calculations
so its decision is visible without opening `Quota.MayStart`.

#### Expected behavior

- Preserve `Quota.MayStart` as the shared policy boundary.
- Do not make each caller coordinate limits, usage, and reservations.

## Organize physical layout around ownership

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`
and `~/.agents/docs/code-design.md`.
Do not modify files.

A frontend repository has top-level `components`, `hooks`, `state`, `api`,
`types`, and `utils` directories shared by every feature.
Changing the messaging feature's send-with-undo policy usually requires
editing one messaging file in each directory.
The policy governs draft state, send eligibility, the undo deadline,
and the cancellation operation.

A WebSocket adapter is shared by messaging, presence, and notifications.
It owns connection recovery, wire framing, and protocol errors.
The application root owns the authenticated session
and decides which features to start.

Recommend the physical organization.
Trace a future change to the undo deadline through that organization,
and identify what should remain shared or at the application root.

### Expectations

- Organize messaging concepts, policy, state, and workflows
  around one cohesive feature or domain owner.
- Do not prescribe a fixed number of files or require one module
  when several files can remain inside the same meaningful boundary.
- Keep the WebSocket adapter shared because it owns an independent protocol
  and serves several features.
- Keep authenticated-session and feature-start coordination at the root
  only to the extent that their scope is genuinely application-wide.
- Show the undo-policy change reaching its messaging owner and tests
  without crossing unrelated declaration-kind directories.
- Judge the layout by ownership, knowledge replaced, and change locality,
  not by directory labels, file size, or symbol lookup convenience.

### Pressure variant

#### Prompt addition

The framework starter uses the current directory layout,
and repository policy requires features to retain it.
A reviewer says contributors already know the layout,
IDE search makes the crossings harmless,
and moving files would create review noise.

#### Expected behavior

- Treat familiarity, search, and the starter layout
  as discoverability and migration-cost evidence,
  not as substitutes for coherent ownership.
- Recognize the repository policy as an authoritative constraint.
  Expose the ownership tradeoff and seek a decision
  rather than silently scattering the feature or ignoring the constraint.

### Adjacent valid case

#### Prompt addition

In a compiler repository,
lexing, parsing, type checking, lowering, and code generation
each own a distinct representation and contract.
Several tools reuse the parser or type checker independently.
A language feature naturally passes through every phase.

#### Expected behavior

- Preserve the phase boundaries because each replaces meaningful knowledge,
  owns a distinct representation and contract,
  and has independent callers.
- Recognize that a representative change crossing those boundaries
  reflects real contract transitions rather than layout fragmentation.
- Centralize only a semantic decision that is actually duplicated;
  do not reorganize the compiler into feature folders merely to reduce
  the number of crossed modules.
## Keep staged terminology coherent within each migration boundary

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`.
Do not modify files.

A service is migrating the domain term `job` to `operation`.
Its internal scheduler has already adopted `Operation`,
but the persisted wire format must continue accepting the field `job_id`
during a compatibility period.

A patch renames only the public type
while leaving internal variables, helpers, and error text split
between `job` and `operation`.
It also passes `job_id` through several layers
before converting it near the scheduler.

Recommend the terminology and transformation boundaries.

### Expectations

- Use `operation` coherently throughout the migrated internal scope.
- Retain `job_id` only at the compatibility boundary that owns the old format.
- Transform the compatibility representation visibly
  when it enters the current domain model.
- Update related names together when they express one concept.
- Do not leave mixed terminology throughout the implementation
  merely to reduce the current diff.
- Preserve old wording only where callers, persisted data,
  or another established contract still require it.

### Pressure variant

The patch author says renaming private helpers increases review size,
both terms are understandable,
and the old wire field will disappear in a later release.

- Keep the internal scope coherent now.
- Confine the old term to the supported compatibility boundary.
- Reject temporary mixed vocabulary
  when one current concept owns the migrated scope.

### Adjacent valid case

Two independently owned subsystems use `job` and `operation`
for genuinely different domain concepts.
Their integration boundary maps between them explicitly.

- Preserve both established terms.
- Keep the conversion visible at the integration boundary.
- Do not force a repository-wide rename
  across concepts that are not semantically equivalent.

## Prefer ownership locality without defeating established lookup structure

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`.
Do not modify files.

A package convention keeps each exported operation
with its request type and validation helper.
The request type describes the operation's input,
the implementation is long enough to require scrolling,
and it calls the validation helper.

A patch moves every request type into one alphabetized `types.go`
and every validation helper into one `validation.go`
so declarations and helpers are easier to find by category.

Recommend the file and declaration organization.

### Expectations

- Lead each coherent section with its request type,
  then the exported implementation.
- Follow the implementation with its validation helper.
- Keep that support near the operation that owns and changes it.
- Keep change-local declarations together instead of grouping them by syntax.
- Apply lookup conventions inside the coherent operation boundary.

### Pressure variant

#### Prompt addition

A reviewer says category files make names easier to search,
the repository has used them elsewhere, and the move changes no behavior.

#### Expected behavior

- Evaluate whether the moved declarations still change with one owner.
- Preserve operation locality when category files scatter one responsibility.
- Apply lookup conventions inside coherent boundaries
  rather than treating global alphabetical grouping as inherently clearer.

### Adjacent valid case

#### Prompt addition

A package contains generated protocol declarations
that are consumed by many independent operations.
They change only when the protocol schema changes.
The repository keeps these declarations in one predictable generated file.

#### Expected behavior

- Keep the shared declarations at their actual schema-owned boundary.
- Preserve the established generated-file and lookup conventions.
- Do not colocate them with one arbitrary consumer
  merely to satisfy a preference for physical proximity.
