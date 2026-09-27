# Rust development scenarios

## 01 Application parameters and documentation

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Sketch Rust 2024 code for a private report operation in one application.
All callers ship together.
Callers choose account, reporting period, output path, currency, and report kind.
Page size and compression are optional settings.
Show the API and one call, with types and in-code documentation for maintainers.
Omit the report implementation.
Do not modify files.

### Quality bar

Judgment: a cohesive required record can be passed directly to the operation.
Every required choice remains explicit; adding a required field identifies the
call sites that need an update.
Use the visibility actual callers need.
Document authored types, fields, variants, and functions, including private ones.

### Unacceptable behavior

- Builder or typestate machinery without a caller benefit beyond named inputs.
- Defaults or optional setters that conceal genuinely required choices.
- Omitted private documentation or mechanical paragraphs inventing guarantees.

### Adjacent variant prompt

Use the skill at `{GUIDANCE_PATH}`.
Design a reusable connection API with a required address and credential provider.
Callers assemble several optional headers and transport settings before moving
a non-Clone credential provider into one connection.
Show construction signatures and a chained call.
Do not modify files.

### Adjacent expectations

A consuming builder is appropriate; required construction inputs enter upfront.
No resource clone is needed to preserve the builder.
Value and resource validation can remain fallible.

## 02 Owned and borrowed representations

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Design a Rust library's owned Document with a String title and Vec<u8> contents,
and a borrowed counterpart for parsers that have independently borrowed slices.
Show useful accessors, conversions, and a call that retains a detached copy.
Include library documentation.
Explain how AsRef, Borrow, ToOwned, and Cow fit the representation.
Do not modify files.

### Quality bar

Judgment: borrowing does not copy payloads, and detachment produces independent
storage.
Conversion names communicate cost and ownership without promising that
consumption prevents allocation.
A small borrowed record is returned by value; its Clone/ToOwned copy retains
borrows.
AsRef and Borrow cannot return a reference to a temporary view record.
Cow's owned form must obey the Borrow relationship.
Fields remain private unless a caller contract justifies their exposure.
All authored items have proportionate documentation.

### Adjacent variant prompt

Use the skill at `{GUIDANCE_PATH}`.
All callers of a local inspection helper already own a Document.
Choose its argument type and show one call.
Do not modify files.

### Adjacent expectations

A plain borrow of Document is sufficient; no separate view type is required.

## 03 API growth and hidden commitments

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
A library is preparing its first release.
It has private implementation modules, an options record with public fields and
Default, an enum of application-owned alternatives, and a trait whose
implementations will all be supplied by the library.
Propose which parts callers should see or construct and show usage syntax.
Future optional settings are expected; new required settings are not yet known.
Also explain what to review when a private field changes from Arc to Rc.
Do not modify files.

### Quality bar

Judgment: module paths may serve callers directly; re-exports need a caller benefit.
Default alone does not preserve full-literal compatibility.
If choosing non_exhaustive, show downstream construction through a constructor
or default plus mutation, not update syntax.
Do not decorate a closed enum without a reason.
Sealing can preserve a library-owned implementation set at introduction.
Private changes can alter Send/Sync commitments.
No construction pattern makes a genuinely new required value optional.

## 04 Validation and standard trait laws

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Review these proposed capabilities: a validated nonempty Name(String) with
Default, Deserialize, and DerefMut; a case-insensitive key exposing Borrow<str>;
and a Handle<T>(Arc<T>) deriving Clone that must work for non-Clone T.
Suggest the smallest appropriate Rust shapes and explain their contracts.
Do not modify files.

### Quality bar

Judgment: all creation and mutation routes preserve validation.
Use checked deserialization where needed.
Borrow's equality/hash law rules out ordinary str lookup for the stated key.
A manual Clone implementation can avoid an unnecessary T: Clone bound.
Do not ban useful derives or valid Borrow implementations categorically.

## 05 Traversal and failures

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Design a file scanner whose callers may stop after the first matching record.
Opening can fail, as can decoding a later record.
A second caller requires validation of the whole input before publishing records.
Show appropriate API shapes for each contract and discuss callbacks if decoding
uses one reusable scratch buffer.
Do not modify files.

### Quality bar

Judgment: lazy traversal retains deferred failures in its item contract.
A completed batch serves validation before effects; collect is not rollback.
Do not discard errors with Result flattening or success-only filtering.
A normal Iterator cannot lend its own reusable mutable buffer across next calls;
a visitor or suitable lending API can express that lifetime.
Do not force callback-based APIs for ordinary independent values.

## 06 Blocking work, cancellation, and completion

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
A Tokio request handler parses a large uploaded document with a synchronous
parser, using a semaphore and spawn_blocking.
Requests may be cancelled while parsing, and shutdown must observe all admitted
jobs before reporting completion.
Show the ownership of the permit and job, and describe the shutdown contract.
Do not modify files.

### Quality bar

Judgment: admission happens before unbounded task creation;
the permit remains with work that can outlive its awaiter.
Started blocking work is not stopped by dropping or aborting its handle.
A supervisor surviving request cancellation observes required completion.
A timeout on waiting is not evidence that work stopped.

## 07 Fallible completion and error reporting

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
An export writes buffered output, then main prints success.
Write errors have operation context and preserve a source error.
Explain where finishing, error propagation, cleanup, and reporting belong,
and show a small signature or control-flow shape.
Do not modify files.

### Quality bar

Judgment: required flush/finish occurs in the success path and can return errors.
Drop remains fallback cleanup, not success evidence.
Durability is claimed only when required and established.
Render useful causes once at the reporting owner; keep established diagnostics.
No process exit buried in reusable work skips required cleanup.

## 08 Test and data boundaries

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Review a parallel Rust test that changes the process current directory and
an environment variable, launches a child to read a temporary directory,
drops that directory before waiting, and sleeps to wait for a Tokio timer.
Suggest a reliable shape.
The child accepts a user-supplied path that must stay beneath an allowed root;
the current implementation joins the strings after rejecting absolute paths.
Do not modify files.

### Quality bar

Judgment: configure the child through Command; keep resources and child lifetime
owned through completion and failure paths.
Use readiness and completion observations, with paused Tokio time when relevant.
A join plus a lexical check does not establish filesystem confinement.
Preserve native paths and select operations that enforce the required guarantee.

## 09 Catalog selection

### Prompt

Available skills:

- rust-development: {GUIDANCE_DESCRIPTION}
- architecture-guide: Domain ownership, boundaries, contracts, and representation.
- test-guide: Evidence needed for behavior changes and test design.
- text-guide: Formatting durable prose artifacts.

For each request, list which skills you would load and briefly explain:

1. Review a Rust API that clones each payload when returning an iterator.
2. Change a Rust enum and its callers to represent a new domain state.
3. Rewrap a Markdown paragraph mentioning that a tool is written in Rust.
4. Explain why a Rust borrowed view cannot implement the proposed ToOwned trait.
5. Design a deterministic test for a Rust asynchronous shutdown path.

Do not open skill files or modify files.

### Quality bar

Conformance: select Rust guidance for 1, 2, 4, and 5, with applicable general
skills; do not select it merely for the incidental mention in 3.

## 10 Application organization, parsed types, and resource ownership

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
A small Rust application reads worker settings, performs jobs, and reports
status. Propose its module/file organization and caller paths.
Settings select either immediate execution or scheduled execution with a
positive interval and a parsed destination address.
Show how parsed settings reach the executor.
The project has no error dependencies; suggest production error types and
fallible test signatures. Explain ownership of temporary files and locks
across early returns. Keep the proposal concise and do not modify files.

### Quality bar

Judgment: use cohesive file-backed modules and direct paths without imposing
re-export plumbing. Parsed settings retain typed addresses and positive counts;
enums carry the fields appropriate to each alternative.
Avoid repeated parsing or validating a raw value and then passing it unchecked.
Use standard or handwritten production errors without adding dependencies,
and lightweight test errors rather than a custom test hierarchy.
Resource guards own cleanup across scope exit and early returns;
explicit fallible completion remains separate from automatic release.

### Adjacent variant prompt

Use the skill at `{GUIDANCE_PATH}`.
An application already uses thiserror for production errors and anyhow
in its test support. Recommend result types for a reusable loader,
application orchestration, and fallible tests.
A small inline child module holds tests for one implementation file.
Assess whether that module needs extracting.
Do not modify files.

### Adjacent expectations

Continue the established libraries and allow a small inline test module.
Do not introduce manual error boilerplate merely to avoid an existing dependency,
or require one file per declaration.

## 11 Error-library selection

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Choose error representations for a reusable configuration loader,
application orchestration, and fallible tests in each of these projects:
a project with no error libraries; one using both thiserror and anyhow;
one using only thiserror; one using only anyhow; and one whose existing
error library has its own reporting type and test convention.
Show representative result signatures and explain dependency choices briefly.
Do not modify files.

### Quality bar

Conformance: no error dependency is introduced by default.
With both libraries, concrete reusable errors use thiserror and application
propagation and generic test results use anyhow.
With only anyhow, tests use anyhow and needed concrete errors are handwritten.
With only thiserror, use derived production errors and lightweight
standard-library results for generic test failures.
With neither library or equivalent, use standard or handwritten production
errors and lightweight generic test errors.
Other libraries follow established project usage.
Keep typed distinctions until retry/recovery decisions are complete;
a reusable module within a binary can still need a concrete error contract.

## 12 Reference selection at nearby boundaries

### Prompt

Read only the entrypoint at `{GUIDANCE_PATH}`.
For each task below, identify the reference pages it directs you to read.
Do not open those references or perform the tasks.

1. Explain who should own a production child process and its temporary directory
   while a request is processed and during shutdown.
2. Review a Rust test fixture that launches a child using a temporary directory.
3. Explain whether a payload length should use a numeric cast or a checked
   conversion for a protocol field.
4. Decide where a generic container should require a bound needed by one method.
5. Review item names and imports for a new internal Rust API.

### Quality bar

Conformance: task 1 reaches resources without selecting testing merely for
its temporary directory or child process.
Task 2 reaches both testing and resources.
Spawning a synchronous child alone does not require async-task guidance.
Task 3 reaches types and standard traits; task 4 reaches polymorphism and bounds.
Task 5 reaches API surface and evolution as well as documentation.
Allow other references when the runner identifies an applicable task condition.
This checks interpretation of the routing text, not observed pointer reach.
Actual pointer reach still requires an independent tool-access trace.

## 13 Item names and module context

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Review names and imports for a new internal Rust API before implementation.
The `transport` module defines `TransportChannel`, `SendError`, and
`ReceiveError`; the `deadline` module defines `DeadlinePolicy`.
A worker imports all four types directly.
Sending and receiving have separate failure handling.
Recommend the declarations, imports, and type spellings the worker should use.
You may keep or change names; there are no downstream compatibility obligations.
Explain briefly and do not modify files.

### Quality bar

Judgment: choose item names and import style together so the caller sees the
module's domain and the item's role without unnecessary repetition.
Names such as `transport::Channel` and `deadline::Policy` express both.
Preserve the distinction between send and receive failures.
Accept other names that preserve the same meanings and context.

### Unacceptable behavior

- Preserve redundant domain prefixes solely to keep direct type imports.
- Import short names directly when doing so loses their domain context.
- Collapse operation-specific errors because the module already names a domain.

### Adjacent variant prompt

Use the skill at `{GUIDANCE_PATH}`.
An identity module defines `AccountId` and `TenantId`.
Both appear together throughout business operations that import them directly.
A new application module for document search has a `SearchIndex` type,
with distinct `BuildError` and `QueryError` types.
Review the type names and caller imports for these two APIs.
Neither API has downstream compatibility obligations.
Explain briefly and do not modify files.

### Adjacent expectations

Keep `AccountId` and `TenantId` descriptive and permit their direct imports;
the identity module alone does not distinguish the two concepts.
Use the search module's context when naming and importing its index.
Keep build and query failures distinct.
Do not impose qualified imports on every type or shorten every domain name.


## 14 Carry constructor guarantees into operations

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Do not modify files or inspect tests.

Review this unpublished Rust API and propose the smallest coherent correction,
with key signatures.
Client construction is supported only through new;
fields are private, with no setters, Default, or deserialization.
A destination label must be nonempty;
the client has a reusable transport that connects only during send.
CLI wants errors before connecting, and library callers send directly.

```rust
pub struct Client { label: String, transport: Transport }
impl Client {
    pub fn new(label: String, transport: Transport) -> Self {
        Self { label, transport }
    }
    pub fn validate(&self) -> Result<(), Error> { self.check() }
    fn check(&self) -> Result<(), Error> {
        if self.label.is_empty() { return Err(Error::EmptyLabel); }
        Ok(())
    }
    pub fn send(&self, payload: &[u8]) -> Result<(), Error> {
        self.check()?;
        self.transport.send(&self.label, payload)
    }
}
```

A maintainer suggests preserving validate for CLI preflight and check in send
because library callers can skip the CLI,
and deriving Clone to make passing clients convenient.
Evaluate that suggestion and settle the API.
Transport can fail at send time.

### Quality bar

Judgment: supported construction establishes the nonempty-label invariant;
CLI and library callers both receive that guarantee.
Ownership semantics follow the operation and transport lifecycle.

### Expectations

- A guidance-access trace shows selection of `code-design` by name
  and retrieval of its domain representation guidance through its own router.
  The prompt supplies no cross-skill reference path.
- Make new return Result<Self, Error> and reject the empty label there.
- Remove validate/check and send-time revalidation of the label.
- Keep transport failures at send time.
- Borrow with &self for reusable sending; no speculative Clone, Box, or Arc.
- Preserve Rust ownership transfer when a consuming operation is requested;
  do not translate Go pointer defaults into Rust heap allocation.

### Adjacent valid case

The documented RawSettings type instead has public mutable fields and accepts
incomplete decoded forms.
A settings editor requests validation feedback,
then passes the settings through TryFrom into a private Client.
Client also supports deserialization via this checked conversion.

- Permit validation feedback for the supported raw representation.
- Check inputs again during conversion because callers can edit RawSettings.
- Preserve the invariant through deserialization and later supported mutations.
- Ordinary operations on Client rely on its established local invariants.

## 15 Borrow through a local async helper

### Prompt

Use the skill at `{GUIDANCE_PATH}` and references that apply as you work.

Update this notification worker to display the notice's title, or "Notice"
when the title is absent. An empty present title stays empty.
Keep the notice available until write_notice finishes.
The worker awaits the write inline and then returns its result.
The delivery API is fixed; the worker and its helper are private and may change.
Give the complete updated worker and helper, with a brief rationale.
Do not modify files.

```rust
/// A notice waiting to be displayed.
struct Notice {
    /// Optional display title; absence uses the worker's fallback.
    title: Option<String>,
    /// Contents displayed below the title.
    body: String,
}

/// Writes the next notice to its destination.
async fn process_notice(sink: &Sink, notice: Notice) -> Result<(), Error> {
    write_notice(sink, notice, "Notice").await
}

/// Displays a notice under the selected title.
async fn write_notice(
    sink: &Sink,
    notice: Notice,
    title: &str,
) -> Result<(), Error> {
    sink.write(title, &notice.body).await
}

// Sink::write(&self, title: &str, body: &str) -> Result<(), Error>
// is async and borrows its arguments until completion without spawning.
// Sink and Error are supplied by the existing delivery library.
```

### Quality bar

Judgment: select a borrowed title and let the private helper borrow its input.
The owning notice remains alive through completion of the inline awaited call.
Preserve the absent-versus-empty distinction and propagate the write result.
Equivalent signatures that borrow the body directly are also valid.

### Unacceptable behavior

- Clone the title, body, or whole notice to preserve a consuming helper.
- Add shared ownership, a task spawn, unsafe code, or a leaked allocation.
- Require a benchmark before choosing ordinary borrowing.
- Introduce generic ownership machinery where a plain borrow suffices.

### Pressure variant

#### Runner prompt addition

The release is today. A working draft already copies the title into a String.
Its author prefers keeping the helper signature to minimize the patch,
and the smoke test passes. There is no performance profile.
Settle the implementation now; all private signatures and callers may change.

#### Expected behavior

Use ordinary borrowing without a payload copy.
The existing signature, passing smoke test, and missing profile
do not establish an ownership need.

## 16 Transfer storage and preserve required ownership

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
Choose ownership and show small Rust code shapes for these independent cases.
Do not modify files.

1. A function receives an owned Vec<String> and appends every string to an
   existing Vec<String>. The input has no further use.
2. A caller retains its Vec<String> while an editor needs a detached copy
   that it can mutate independently. Keep the representation unchanged.
3. A spawned task and its caller both need to retain an existing Arc<Client>.
   Client is not Clone; task completion is supervised by the caller.
4. An async sender accepts an owned String label. The label is in a Mutex<State>
   alongside a large Vec<u8> payload. State must remain available and mutable
   to other threads during the send; the label must reflect the protected read.
   The mutex and sender APIs are fixed for this task.

### Quality bar

Judgment: distinguish transfer, independent duplication, and shared ownership.
Preserve each operation's lifetime and mutation contract with ordinary code.

### Expectations

- Move strings from the consumed batch through append, extend, or into_iter;
  no payload clones or intermediate owned copies.
- Permit the detached vector copy and its independent strings.
- Clone the Arc handle for the second owner, without requiring Client: Clone
  or duplicating Client. Preserve task supervision.
- Copy only the label while holding the mutex and drop the guard before awaiting
  the send. Do not copy State or its unrelated payload, hold the guard through
  I/O, move the label out of retained state, or change the fixed APIs.

## 17 Evolve a coordinated operation from a prototype

### Prompt

Use the skill at `{GUIDANCE_PATH}`.

We have an experimental deterministic replay branch for an internal media
service. Break the useful support out into small independently landable APIs.
Propose the media index opening API first; implementation waits for approval.
Preserve native behavior and keep the initial integration incremental.

Current workspace:

- media_index has publish = false and is built with the service and CLI crates.
- Index::open(root: PathBuf) creates a NativeReader internally.
- Reader is an existing trait implemented by NativeReader and RecordedReader.
- Production and CLI code contain 31 calls to Index::open(root).
- No parameter record or builder exists for Index.
- NativeReader has initialization state specific to each opened index.

The experiment has already demonstrated replay with this prototype:

```rust
impl Index {
    pub fn open(root: PathBuf) -> Result<Self> {
        Self::open_with_reader(root, Arc::new(NativeReader::new()))
    }
    pub fn open_with_reader(root: PathBuf, reader: Arc<dyn Reader>) -> Result<Self> {
        // Index implementation unchanged apart from reading through reader.
    }
}
```

The experiment also includes a recording adapter and a replay runner. Those
will land later; this proposal should expose only the capability each needs.
The prototype passes its focused tests, and the review budget favors a small
first PR. Show the public API you recommend, production and replay call shapes,
landing steps, and the relevant validation boundary. Do not implement changes.

### Quality bar

Judgment: change the original opening operation to accept the reader and update
coordinated callers. Production supplies a fresh native reader for each index;
replay supplies its implementation through the same operation.
Preserve meaningful ownership choices without requiring a particular pointer.

### Unacceptable behavior

- Keeping native opening plus a second injection operation solely because native
  behavior is a useful default, the prototype works, or updating callers costs
  review effort.
- Treating the experimental surface as an established compatibility contract.
- Changing native reader initialization or sharing while claiming preservation.

### Pressure variant

#### Runner prompt addition

The release is today and a reviewer wants to keep all 31 existing call sites
unchanged because the prototype already passes its tests. Choose the API now.

#### Expected behavior

- Preserves native behavior through the revised operation and updates callers.
- Separates a review-cost preference from a supported compatibility obligation.

## 18 Extend the existing construction record

### Prompt

Use the skill at `{GUIDANCE_PATH}`.

A workspace-owned media processor has Processor::open(settings: Settings) and
Processor::open_read_only(settings: Settings). Both take the same passive Rust
record, which is assembled at the application composition layer:

```rust
pub struct Settings {
    pub source: PathBuf,
    pub concurrency: usize,
}
```

Settings is not serialized and has no equality requirement. All its users ship
together. The processor now needs a required Arc<dyn PermitSource> for admission
decisions. Production will supply NativePermits; a replay tool will supply
RecordedPermits. Both opening modes need the same provider for their lifetime.
There are 24 existing settings literals and two new replay callers. Keep the
change mechanical and preserve production admission behavior.

Choose the API shape and caller-update plan. Show only the relevant field,
constructor and call fragments, and explain your choice. Do not implement or
modify shared files.

### Quality bar

Judgment: add the required provider to Settings and keep both opening methods
using that shared record. Update existing literals with NativePermits and
replay callers with RecordedPermits, preserving initialization and sharing.

### Unacceptable behavior

- Adding a separate provider argument or parallel constructor despite the
  existing record owning the input's responsibility and lifetime.
- Making the required dependency optional or adding a fallback to avoid edits.
- Honoring the provider in only one opening mode.

## 19 Stage substantial dependency plumbing

### Prompt

Use the skill at `{GUIDANCE_PATH}`.

An internal image-processing application needs to route resource admission
through a supplied Arc<dyn PermitSource>. Production uses NativePermits and
tests can supply recorded decisions. All callers are owned by the application.
Today 70 functions pass source, destination, concurrency and codec separately.
They are spread over four modules; the values represent the same job request.
Most functions choose NativePermits internally. No cohesive request or
dependency record exists. The accepted destination is for every processing
path to use the provider selected at composition, with no processing layer
selecting one itself.

The team wants separately reviewable, buildable changes and permits partial
plumbing between them. Propose the API evolution and landing sequence. Show
the relevant intermediate and final shapes, explain any temporary fallback,
and define when the work is complete. Do not implement changes.

### Quality bar

Judgment: consider a cohesive request refactor separately from provider
plumbing. Buildable stages preserve supported behavior. Temporary native
selection or absence has defined semantics and a recorded remaining scope.
Either an appropriate record field or narrow dependency argument is acceptable.

Completion requires every processing path to use the provider from composition
and removal of temporary fallbacks. A completed contract that requires the
provider represents it as required.

### Unacceptable behavior

- Treating partial plumbing as full coverage or indefinite optionality.
- Multiplying permanent operations for each added dependency.
- Requiring unrelated architectural work before any useful stage can land.

## 20 Preserve independently released interfaces

### Prompt

Use the skill at `{GUIDANCE_PATH}`.

A published Rust library has a supported Fetcher::new(endpoint: Url) operation
that creates a fresh NativeTransport. Downstream applications release
independently. The next release is a minor update that must preserve existing
source compatibility and ordinary native behavior. Several downstream users
need to supply an Arc<dyn Transport> for requests; Transport already exists.
There is no existing configuration record or builder.

Settle the API and caller contract for this release. Show native and supplied
transport construction, and explain the compatibility tradeoff. Do not implement
changes or modify shared files.

### Quality bar

Judgment: preserve the supported native constructor's source and behavior
contract for the minor release and offer a usable supplied-transport path.
A separate constructor or another justified additive construction interface is
acceptable. Share implementation where the behavior is the same.

### Unacceptable behavior

- Requiring downstream users to update the existing constructor in this release.
- Treating coordinated application evolution as a ban on compatibility APIs.
- Claiming an optional setter preserves behavior while newly failing ordinary
  construction when the transport is omitted.

## 21 Preserve distinct operations and semantic optionality

### Prompt

Use the skill at `{GUIDANCE_PATH}`.

An internal application's SegmentStore has create(path), which fails when data
already exists, and open_read_only(path), which fails when no store exists and
does not permit writes. Both must now use a required Arc<dyn BlockAllocator>.
All callers ship together. No configuration record or builder exists.
NativeAllocator preserves current allocation policy. An optional compression
setting on write operations continues to have a documented disabled behavior
when omitted.

Settle the construction API and caller updates. Show relevant signatures and
calls, and explain how the two operations and optional compression should evolve.
Do not implement changes or modify shared files.

### Quality bar

Judgment: retain the distinct creation and read-only opening operations,
adding the required allocator through their existing construction interfaces.
Update native callers to supply NativeAllocator and preserve both operations'
preconditions and capabilities. Compression remains semantically optional.

### Unacceptable behavior

- Collapsing operations with different supported preconditions or capabilities.
- Adding a second version of each operation only to supply the allocator.
- Making documented optional compression mandatory because dependencies can be
  required or temporary plumbing must eventually finish.

## Property selection during ordinary work

### Prompt

Use applicable installed guidance.
This is a hypothetical Rust library change; do not edit shared files.
The crate exposes pub fn lower_bound(xs: &[i32], key: i32) -> usize.
For sorted input it returns the first position whose value is at least key, or
xs.len().
A binary-search optimization is being added.
Existing tests cover empty input, a hit in [1,3,5], and a miss above that slice.
Inputs may contain duplicate and negative values.
The crate uses stable Rust, edition 2024, and cargo test in CI.
Dev dependencies are permitted; none is established yet.
Propose the additional tests you would actually add, show concrete Rust code for
the most useful addition and any manifest change, and give the command that
exercises it.
Explain what a plausible defect would make fail.
Keep this a focused answer; inspect guidance and public documentation as needed,
but do not inspect unrelated task artifacts or other agents' work.

### Expected behavior

- Chooses property-based testing without a technique cue alongside targeted examples.
- Uses independent boundary predicates or a simple scan rather than a copied binary search.
- Allows duplicates and empty vectors, sorted input construction, useful size bound.
- Selected integration and supplied command actually run generated cases on stable Rust.
- Uses real API, correct manifest and informative assertions.
- No claim that proposed code was executed.
- Reads the property/fuzzing reference after recognizing the testing decision.
- A suitable existing framework remains a valid choice.

### Adjacent valid case

#### Runner prompt addition

Instead, the change only renames a private helper for a four-value enum display.
Every supported enum value already has its specified output asserted.

#### Expected behavior

- Keeps adequate existing evidence; adds no property library for this change.

## Hegel application

### Prompt

Use applicable installed guidance.
A Rust library exposes `lower_bound(xs: &[i32], key: i32) -> usize` for sorted input.
It returns the first index whose value is at least key, or the slice length.
The team has selected Hegel for a small demonstration.
Show the test, dependency change, and local/CI test requirements for
Apple Silicon macOS and Linux amd64.
The ordinary CI command is `cargo test`.
Do not modify shared files; inspect public documentation as needed.

### Expected behavior

- Uses `hegeltest` as a dev dependency and `hegel` as the import name.
- Uses a supported API, an independent oracle, and valid sorted inputs.
- Checks native-engine build/load requirements for local and CI tests.
- Does not invent a Python server requirement for current releases.
- Recognizes that ordinary `cargo test` invokes Hegel generation.

## Existing cargo-fuzz target

### Prompt

Use applicable installed guidance.
A Rust crate already has a cargo-fuzz target that accepts an `Arbitrary` command
sequence and compares the public store API with a small map model.
The nightly fuzz job runs daily, while pull requests run stable `cargo test`.
A maintainer wants a bounded search in that existing fuzz job and asks whether
structured input forces a migration to Proptest.
Give the smallest justified plan and describe the evidence supplied by each job.
Do not modify files or change the default toolchain.

### Expected behavior

- Keeps the valid typed cargo-fuzz integration and semantic model.
- Uses an explicit nightly invocation and a bounded campaign.
- Does not claim stable `cargo test` runs the fuzz target or replays its corpus.
- Treats structured input as compatible with fuzzing through `Arbitrary`.
- Explains when fresh generation during stable ordinary tests could separately
  justify a property runner; does not impose a migration.

## Property selection for a different contract

### Prompt

Use applicable installed guidance.
This is a hypothetical Rust crate with Registry::new(), set(&mut self, key: u8,
value: i32), get(&self, key: u8) -> Option<i32>, and remove(&mut self, key: u8).
Setting overwrites, removing an absent key is a no-op, and keys are independent.
A storage refactor changes internal indexing.
Existing examples cover setting and reading one key and then removing it.
CI runs cargo test on stable Rust; dev dependencies are permitted.
What additional tests would you add?
Show the most useful test in concrete Rust and the manifest change and command
to exercise it.
Explain what evidence it supplies.
Do not modify shared files or inspect unrelated task artifacts or other agents'
work.

### Expected behavior

- Selects generated operation histories without a technique cue.
- Uses an independent simple association model and observes public API.
- Reuses keys and permits overwrites, absent removals, and interactions between
  keys.
- Starts each generated case from fresh state and recomputes model during each
  replay.
- Provides supported language integration that generates cases during cargo
  test.
- Keeps useful named regressions and bounds histories; no concurrency claim.

## rstest selection for existing tests

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable references.
A stable Rust crate already uses rstest in its test suite.
Extend this test with the upper u16 boundary and leading zeroes.
Keep the test readable for a maintainer encountering this code alone.
Show the resulting Rust code and explain your choice briefly.
Do not modify shared files or inspect behavioral tests or other agents' results.

```rust
/// Checks successful decimal conversions.
#[test]
fn decimal_values() {
    for (input, expected) in [("0", 0), ("17", 17)] {
        assert_eq!(input.parse::<u16>().unwrap(), expected, "input: {input:?}");
    }
}
```

### Expected behavior

- Uses rstest for the related input cases because the project already uses it.
- Preserves the existing cases and adds both requested boundaries.
- Uses descriptive case names, visible expected values, and one assertion shape.
- Does not require additional justification or approval to select rstest.

### Explicit request variant

#### Runner prompt addition

Replace the project-library sentence:
the crate has no test libraries, and the user requests rstest for this test.
Include the development dependency needed for the code.

#### Expected behavior

- Uses rstest and a compatible development dependency.
- Preserves the case readability and coverage of the base scenario.

### Adjacent valid case

#### Runner prompt addition

Replace the project-library sentence:
the crate has no test libraries, and no testing library has been requested.

#### Expected behavior

- An ordinary test with a small loop and case diagnostics is sufficient.
- Does not require a new dependency merely to cover these inputs.

## Test attributes follow the features used

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable references.
A stable Rust crate already uses rstest for parameterized parser tests
and Tokio for async tests.
Add two regression tests:
a synchronous test creates a fresh Vec, pushes one item, clears it,
and checks that it is empty;
an async test creates a Tokio oneshot channel in its body, drops the sender,
awaits the receiver, and checks that it returns an error.
Both tests construct their own state in their bodies
and each covers this one behavior.
Choose the imports, test attributes, and function signatures for these tests,
and explain your choice briefly.
You may elide the bodies; do not invent additional scenarios or setup abstractions.
Do not modify files or inspect behavioral test files or other agents' results.

### Expected behavior

- Uses `#[test]` for the synchronous test and `#[tokio::test]` for the async test.
- Omits `#[rstest]` and its import because neither test uses an rstest feature.
- Keeps each scenario self-contained without introducing case data or injected
  fixtures solely to justify a macro.

### Existing declaration variant

#### Runner prompt addition

Review these tests as an existing draft instead of adding them.
The synchronous declaration currently has `#[rstest]`;
the async declaration has both `#[rstest]` and `#[tokio::test]`.
The module imports `rstest::rstest` solely for these two tests.
Show the declarations and imports you would keep.

#### Expected behavior

- Replaces the synchronous macro with `#[test]`.
- Keeps the async runtime attribute and removes the unused rstest import.
- Does not retain redundant attributes merely for consistency with other tests.

## rstest features without case rows

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable references.
A Rust crate already uses rstest and Tokio.
Choose the imports, test attributes, and signatures for two tests:

- A synchronous test receives `scratch: tempfile::TempDir` from an existing
  rstest fixture named `scratch` and checks one file round trip in that directory.
- An async test constructs all state locally and awaits a notification.
  Its contract includes a two-second rstest timeout,
  supported by the crate's rstest version and enabled features.

Each test covers one scenario with no case rows.
Keep the existing fixture interface and timeout behavior.
You may elide the bodies and the existing fixture definition.
Explain your choices briefly.
Do not modify files or inspect behavioral test files or other agents' results.

### Expected behavior

- Retains `#[rstest]` for the injected `scratch` fixture without adding cases.
- Uses `#[rstest]` with `#[timeout(Duration::from_secs(2))]`
  and the Tokio runtime attribute for the async test.
- Keeps the fixture owner alive throughout the synchronous test.
- Selects attributes from the features used, rather than case count alone.

## Expected values and distinct operations

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable references.
This Rust crate already uses rstest.
Write tests for these contracts and examples:

- `str::parse::<u16>()`: "24" gives 24, "0024" gives 24, "" fails with
  `IntErrorKind::Empty`, and "65536" fails with `IntErrorKind::PosOverflow`.
- `str::is_ascii()`: "elm" and "" return true; "café" returns false.
- `str::split_once(':')`: "host:80" gives ("host", "80") and
  ":9000" gives ("", "9000"). Check both resulting fields.
- For a map containing ("key", 7), replacing that entry with 9 returns 7
  and stores 9; removing the entry returns 7 and leaves it absent.

Choose the test grouping and show concrete Rust code.
Describe how adding an invalid-digit parser case would affect that grouping.
Do not modify shared files or inspect behavioral tests or other agents' results.

### Expected behavior

- Uses rstest for the related input cases,
  keeping each case understandable from nearby code.
- Expresses complete parser outcomes as data or uses separate coherent groups;
  does not introduce flags that selectively enable error assertions.
- Allows the predicate's expected boolean and both split-result fields.
- Keeps map replacement and removal as visible, distinct actions;
  does not merge them through an operation-selecting flag or callback table.
- Adding an error category does not require a new expectation flag in every row.
- Makes no unsupported claim that generated code was run.

## Combinations and file corpora

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable references.
A Rust crate already uses rstest and needs these tests:

- For each word in ["oak", "pine"] and each delimiter in [' ', '\t'],
  padding both ends and then applying `trim_matches(delimiter)` recovers the word.
- `u16::from_str_radix("ff", 16)` gives 255 and
  `u16::from_str_radix("11", 2)` gives 3.
- Every file in `tests/data/accepted/*.txt` is a valid decimal u16;
  every file in `tests/data/rejected/*.txt` is invalid.
  Trim surrounding whitespace before parsing each file.

Show concrete test declarations and bodies.
State how many cases the first two groups generate and how the corpus is grouped.
Do not modify shared files or inspect behavioral tests or other agents' results.

### Expected behavior

- Uses a meaningful four-case product for words and delimiters.
- Keeps each radix conversion's related input and expected output together
  in two case rows rather than a filtered product.
- Every generated case exercises an assertion; there are no skipped combinations.
- Gives each corpus group a uniform parse-and-check contract.
- Keeps scenario selection out of filename-dependent assertion branches.
- Uses syntax supported by the selected rstest version.

## Fixture state and completion

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable references.
A Rust crate uses rstest, tempfile, and Tokio.
A file test receives a generic `directory: TempDir` fixture,
then writes "new" to `settings.txt` and reads it back.
The fixture currently seeds that file with "old contents".
The test should cover replacing existing content with shorter and empty content.
A maintainer proposes putting `#[once]` on the directory fixture to reduce setup.
Show the test structure you would keep and explain the fixture lifetime.

Another test uses `#[rstest]` with `#[tokio::test(start_paused = true)]`.
Its worker waits for a retry timer, and the test currently sleeps in wall time
before checking a shared counter.
Give the smallest reliable observation and completion plan.
Do not modify shared files or inspect behavioral tests or other agents' results.

### Expected behavior

- Keeps the initial and replacement contents visible in each case or test body.
- Uses the fixture for incidental directory construction and retains its owner.
- Recognizes that an rstest once fixture is shared and never dropped;
  rejects it for a TempDir whose destructor owns cleanup.
- Preserves the Tokio runtime attribute and paused clock.
- Uses readiness and completion observations, with a timer timestamp or another
  observation that can detect early as well as late retry.
- Retains worker termination and joining; does not treat timeout as cleanup.

## Unit-test file ownership

### Prompt

Use the skill at `{GUIDANCE_PATH}` and its applicable references.

A Rust crate contains `src/storage.rs` with `mod eviction;` and a
`#[cfg(test)] mod test_support;`.
The eviction implementation lives in `src/storage/eviction.rs`.
A patch adds 300 lines of focused tests for eviction's supported internal
behavior in `src/storage/eviction_tests.rs` and registers
`#[cfg(test)] mod eviction_tests;` in `storage.rs`.
Tests import `super::eviction` and `super::test_support`;
all tested functions already have `pub(super)` visibility for other storage
callers, so the patch changes no production visibility.
It compiles and passes.
There is no project-specific test layout requirement.
Assess the organization and show the final file paths and module declarations
you recommend.
Keep the tests in a separate source file and preserve existing visibility
and behavior.
Do not review test assertions, propose unrelated cleanup, or modify files.

### Quality bar

Conformance: focused unit tests belong to the implementation module.
Compilation and existing internal visibility do not settle that ownership.

### Expectations

- Places the tests at `src/storage/eviction/tests.rs`.
- Declares `#[cfg(test)] mod tests;` inside `eviction.rs`.
- Removes the sibling declaration and updates imports for the new ancestry.
- Preserves production visibility and shared support in its existing home.
- Uses ordinary module resolution without a `#[path]` override.

## Extract an inline unit-test module

### Prompt

Use the skill at `{GUIDANCE_PATH}` and its applicable references.

A Rust 2024 library has `src/lib.rs` declaring `mod codec;`.
The private `decode_tag` helper in `src/codec.rs` has 450 lines of unit tests
in an inline `#[cfg(test)] mod tests { use super::*; /* tests */ }` at the end.
A draft extraction moves that body to `src/codec_tests.rs`
and replaces it in `codec.rs` with:

```rust
#[cfg(test)]
#[path = "codec_tests.rs"]
mod tests;
```

The patch compiles, every test passes, and production visibility is unchanged.
The maintainer wants the implementation and its tests in separate source files.
Assess the proposed organization and settle the layout and module declarations
to retain.
Briefly explain your choice.
Do not change files, test bodies, or unrelated modules.

### Expectations

- Uses `src/codec/tests.rs` and ordinary `#[cfg(test)] mod tests;` in `codec.rs`.
- Keeps the test module's contents directly in the new file,
  preserving `codec::tests` and access to private items.
- Does not introduce a second enclosing `mod tests` or widen visibility.

### Adjacent variant prompt

Use the skill at `{GUIDANCE_PATH}` and its applicable references.

A library has three small tests for a private helper in `src/metadata.rs`,
all in an inline `#[cfg(test)] mod tests` that remains easy to read.
Its crate-root unit tests in `src/lib.rs` have grown large enough that the
maintainer wants those tests in a separate source file.
It also has `tests/public_contract.rs` exercising only its published API
as an external consumer.
Recommend the layout and declarations for these three groups.
Explain which groups need to move and preserve production visibility.
Do not modify files.

### Adjacent expectations

- Keeps the small inline metadata test module.
- Places crate-root unit tests in `src/tests.rs`,
  declared by `#[cfg(test)] mod tests;` in `src/lib.rs`.
- Keeps the integration tests at `tests/public_contract.rs`
  with external access through the public API.

## Keep cohesive unit tests inline

### Prompt

Use the skill at `{GUIDANCE_PATH}` and its applicable references.

A Rust module in `src/record.rs` has a cohesive inline `#[cfg(test)] mod tests`
with several hundred lines of cases for its private parser.
The source remains easy to navigate, and the maintainer is adding one ordinary
parser case without requesting a file reorganization.
Does the skill require moving the tests into another file?
State what you would change and why.
Do not modify files.

### Expectations

- Keeps the cohesive test module inline and adds the case there.
- Treats separate test files as optional, with no extraction threshold by size.
- Applies the child-module file layout only if extraction is chosen.
