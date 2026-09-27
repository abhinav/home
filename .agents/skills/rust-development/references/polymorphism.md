# Polymorphism and bounds

## Choose the representation of supported variation

Keep a concrete collaborator when its existing API is the useful contract.
Introduce a trait for substitution, a generic algorithm, or a supported extension
point; prefer an existing standard trait when its semantics fit.
A trait for every concrete type adds obligations without necessarily hiding
implementation knowledge.

When a proposed generic collaborator supplies facts for each invocation,
use [Construction](construction.md#required-inputs)
to settle their lifetime and owner before choosing dispatch.

Once variation has a purpose, choose its Rust representation:

```rust
/// Decodes from a caller-selected reader using static dispatch.
fn decode(reader: impl std::io::Read) -> Result<Document, DecodeError> {
    // Decoding omitted.
    todo!()
}

/// Decodes through a reader borrowed from a caller using type erasure.
fn decode_erased(reader: &mut dyn std::io::Read) -> Result<Document, DecodeError> {
    // Decoding omitted.
    todo!()
}

/// Storage alternatives owned by this application.
enum Storage {
    /// Storage on the local filesystem.
    Local(
        /// Store used for local reads and writes.
        LocalStore,
    ),
    /// Storage supplied by the configured remote service.
    Remote(
        /// Store used for remote reads and writes.
        RemoteStore,
    ),
}
// Supporting types omitted; the functions illustrate alternative interfaces.
```

Use generics for caller-selected implementations when each instantiation uses
one concrete type.
Argument `impl Trait` is convenient when naming the type expresses no additional
relationship; name `T` when inputs, outputs, or stored state must share that type.
Use return `impl Trait` when the producer promises a trait and selects one hidden
implementation, especially for iterators and closures.
Keep a useful concrete domain result concrete.
Return `impl Trait` does not erase different implementation types from branches.

Use `dyn Trait` when heterogeneous storage, runtime replacement, or containing
generic propagation makes erasure useful.
Do not require a benchmark failure before allowing it.
`&dyn Trait` borrows without requiring an allocation;
`Box<dyn Trait>` adds ownership and `Arc<dyn Trait>` adds shared ownership.
Use an enum when the application owns a finite meaningful set of alternatives.
Runtime configuration alone does not imply an open implementation set.

Place bounds on the method or `impl` that needs them,
rather than restricting the entire type for one operation.
Retain type-level bounds when the declaration itself requires them,
such as naming an associated type.
Apply this to `Send`, `Sync`, and `'static` too: require them where consumers do.
Keep dyn compatibility when actual callers require it;
do not distort an otherwise useful trait for hypothetical trait objects.
Generic methods, native `async fn`, and opaque returns need attention when
designing that surface.
For publishing trait and opaque-return contracts, read
[API surface and evolution](api-surface-and-evolution.md).

## Use closures for a single supplied operation

```rust
impl<T> Cache<T> {
    /// Initializes an empty cache; otherwise returns the existing value.
    fn get_or_init(&mut self, make: impl FnOnce() -> T) -> &mut T {
        // Cache access omitted.
        todo!()
    }
}
// Cache representation omitted.
```

Accept `FnOnce` when the algorithm may invoke its callback only once,
`FnMut` when repeated invocation can mutate captured state,
and `Fn` when invocation through a shared reference is required.
The trait bound does not establish the invocation count or ordering;
document those when they matter to callers.
Do not require a named strategy trait for one supplied operation.

## Give optional optimizations a valid fallback

```rust
/// Writes records in order; a failure can leave an accepted prefix.
trait RecordSink {
    /// Writes one record, reporting any failure.
    fn write_record(&mut self, record: &Record) -> Result<(), WriteError>;

    /// Writes until the first failure; this is not an atomic transaction.
    fn write_batch(&mut self, records: &[Record]) -> Result<(), WriteError> {
        for record in records {
            self.write_record(record)?;
        }
        Ok(())
    }
}
// Record and WriteError omitted.
```

Use a provided method when implementations should optimize an operation while
preserving its contract.
Use a helper or concrete wrapper when customization is unnecessary.
An atomic batch cannot use the loop above as a fallback:
atomicity requires an additional capability.
Wrappers that forward only `write_record` inherit the default batch method;
forward the inner override when preserving it is part of the wrapper's behavior.
`Read::read_vectored` illustrates an overridable fallback in the standard library.

Rust does not discover an unrelated extra trait through a trait object.
When runtime capability discovery is required,
represent it explicitly in the contract.
Supertrait upcasting follows existing trait relationships;
`Any` downcasts to concrete types and requires its `'static` bound.

Before adding a blanket implementation, consider the more specific implementations
it would overlap and prevent.
A local trait can adapt an external type;
an external trait and external type generally need a local adapter.
Keep required methods narrow, with lifecycle authority on the resource owner
rather than every consumer of an operational trait.
