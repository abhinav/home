# Construction

For checked construction and mutation,
read [Types and standard traits](types-and-traits.md).
When changing an existing API, use
[API surface and evolution](api-surface-and-evolution.md#preserve-observable-promises)
for caller and compatibility commitments.

## Required inputs

Before retaining a collaborator, distinguish its behavior from invocation data.
Keep a store, clock, or policy provider when execution needs its behavior.
Pass already resolved facts that vary per call as arguments or a cohesive request,
rather than making the service generic over a provider used only to discover them.
Resolve those facts at the boundary that owns their meaning.
An attributed identity is not a credential or permanent authorization proof:
preserve required credential propagation and checks of current authority.
A changing policy that must be consulted during execution still needs its provider.
Choose dispatch only after settling this lifetime and responsibility.

When adding an input, first inspect the existing construction or operation
boundary.
Extend an existing parameter record or builder when the input belongs to its
responsibility and lifetime.
Keep a few clear required inputs as direct arguments.
For many required inputs, prefer a cohesive named record passed directly to
an operation or constructor.
In application code whose callers change together, a new required field
should identify the call sites that must choose its value.
That compiler feedback is useful maintenance work.

```rust
/// Caller choices for one snapshot export.
struct ExportRequest {
    /// Dataset that owns the snapshot.
    dataset: DatasetId,
    /// Immutable revision to export.
    snapshot: SnapshotId,
    /// File to create for this export.
    destination: PathBuf,
    /// Encoding of the output file.
    format: ExportFormat,
}

/// Writes the selected snapshot using the supplied optional settings.
fn export(request: ExportRequest, options: ExportOptions) -> Result<(), ExportError> {
    // Domain types, options, and implementation omitted.
    todo!()
}

export(
    ExportRequest { dataset, snapshot, destination, format },
    options,
)?;
```

Give the record and its fields the visibility their actual callers need.
Group a real request or dependency set, not unrelated application state.
Required choices stay explicit at the call site.

A dependency can be required while having a native implementation.
Supply that implementation at composition or the updated caller to preserve
native behavior, including its initialization and sharing lifetime.

A record with mutable fields describes input; it does not prove validity.
When turning those inputs into a value that promises an invariant, use
[Types and standard traits](types-and-traits.md#preserve-invariants-through-every-creation-path).

For generated wire records, use
[Data representation](data-representation.md#construct-generated-protocol-records)
to decide whether omitted fields have valid protocol defaults.

## Stage substantial caller changes

When adding and plumbing an input would make one change difficult to review
or land, consider a behavior-preserving construction refactor first,
then add and plumb the dependency through the resulting interface.
Each stage should build and preserve the behavior supported at that stage.
Temporary omission can support incremental plumbing when its fallback behavior
is defined and the remaining callers or layers and follow-up are recorded.
When plumbing is complete, require the dependency wherever the completed
contract needs it and remove the temporary fallback.
Verify that each affected construction path uses its supplied dependency.

Plan review boundaries before movement, extraction, renaming, or representation
changes obscure the behavioral decisions.
Use a separate behavior-preserving review unit when both intermediate contracts
can be supported; separate commits inside one aggregate diff may not help readers.
Place the refactor before or after the behavior according to which makes that
behavior easier to inspect.
Check each review diff against its parent, including behavior introduced below it.
Keep necessary edits together when splitting would require unsupported schemas,
contrived intermediate behavior, or separating effects that must commit together.
Explain that dependency; reducing the visible diff must not weaken atomicity.

## Optional settings and builders

Use an options record when settings are useful as data and assembly is simple.
A setting is optional when omission has a documented behavior;
use `Option<T>` only when absence itself has meaning.
A record remains a good choice for application code with optional settings.

Use a builder when callers benefit from named assembly steps, accumulation,
conversions, or alternative construction paths.
A reusable library with many optional settings often benefits;
parameter count alone does not require one.
Do not provide both records and builders unless callers need both contracts.

For construction of one owner, supply indispensable inputs at entry:

```rust
let client = ClientBuilder::new(endpoint, credentials)
    .timeout(timeout)
    .build()?;
```

Required inputs that vary per operation can instead belong at the terminal call:

```rust
let file = std::fs::OpenOptions::new().read(true).open(path)?;
```

This lets configuration be reused without retaining each operation's input.
Fallible `build` remains appropriate for value checks, combinations,
and resource initialization even when all required inputs are present.

Choose receivers from ownership:

| Construction contract | Setter | Terminal operation |
| --- | --- | --- |
| Transfers owned inputs into one result | `fn timeout(self, value: Duration) -> Self` | `fn build(self) -> Result<Client, Error>` |
| Reusable configuration without consuming inputs | `fn timeout(&mut self, value: Duration) -> &mut Self` | `fn open(&self, path: &Path) -> Result<Handle, Error>` |

Do not clone resources simply to make a consuming construction reusable.
Combining mutable setters with a consuming terminal method obstructs chaining
through the returned mutable reference.
Draining fields in `build(&mut self)` needs a deliberate contract for the
remaining state and repeated calls.

## Other construction choices

For dynamic configuration, a raw record may represent missing input.
Use the domain representation from
[Types and standard traits](types-and-traits.md#parse-into-the-representation-consumers-need)
as the result of fallible construction:

```rust
let job = ExportJob::try_from(raw_config)?;
```

Use staged or typestate construction when meaningful mandatory decisions,
mutually exclusive paths, or ordering justify the additional states.
Independent required fields usually need the simpler record.
Rustls demonstrates useful mandatory choices:

```rust
let config = rustls::ClientConfig::builder()
    .with_root_certificates(roots)
    .with_no_client_auth();
```

Presence at compile time does not validate arbitrary supplied values.
