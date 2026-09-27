# Collections and iteration

## Let the caller choose materialization

Return an iterator for traversal or incremental transformation
when callers should choose whether to filter, count, consume a prefix, or collect.
Return `Vec<T>` for a completed batch, a detached snapshot,
or a result that needs sorting or indexed access.
Borrow an existing batch as `&[T]` when retaining the owner's borrow is intended.

These signature sketches express different promises:

```rust
/// Visits active records while retaining a borrow of their storage.
fn active(records: &[Record]) -> impl Iterator<Item = &Record> { /* ... */ }

/// Loads and validates the complete batch before returning it.
fn load_records(path: &Path) -> Result<Vec<Record>, ReadError> { /* ... */ }
```

Returning `vec.into_iter()` can offer a useful consuming interface,
but does not make production incremental.
Inspect the full pipeline before claiming bounded memory:
retained input, unbounded batches, and aggregation maps still consume storage.
A snapshot can simplify ownership when callers need to mutate or release
the source before processing its results.

## Accept the sequence capability the operation needs

Use `&[T]` for borrowed batches requiring length, indexing, or repeated traversal.
For a reusable consumer that processes a sequence once,
accept `IntoIterator` with the element ownership the operation needs:

```rust
/// Takes ownership of each record for insertion.
fn ingest(records: impl IntoIterator<Item = Record>) -> Result<(), WriteError> {
    /* ... */
}

/// Totals sizes without retaining the records.
fn total<'a>(records: impl IntoIterator<Item = &'a Record>) -> u64 { /* ... */ }
```

This avoids forcing callers to collect a pipeline into an intermediate vector.
Keep a small local helper accepting a slice when its callers already have slices
and generic composition adds no useful capability.

## Preserve failures and visible control flow

When advancing can fail, expose the failure in `Item = Result<T, E>`.
An initial successful open does not guarantee successful traversal;
`read_dir` has both opening and per-entry errors.
Collect and validate before exposing a batch when no record may be acted on
until the complete input has been validated.

Use `collect::<Result<Vec<_>, _>>()` to propagate the first failure.
It does not undo effects already performed during iteration.
Do not silently discard failures with `filter_map(Result::ok)`, `flatten`,
or default values unless omission is the intended, documented policy.
Prefer a loop when an adapter chain hides mutation, effects, or early exits.

Use borrowed map lookup and standard collection operations before allocating
temporary keys or repeating searches.
Use `entry` for a combined lookup and update when its owned-key requirement fits;
do not allocate a key merely to force a hit-only lookup through `entry`.
Collect into a map only when duplicate-key replacement and lost sequence order
match the contract.

## Keep callbacks where borrowing or policy requires them

Prefer ordinary iterators for independently usable successive values.
Keep callbacks for algorithm policy, such as a comparator,
or for access to a reusable buffer that must be released before advancing:

```rust
/// Visits each chunk before its backing buffer is reused.
fn visit_chunks(
    reader: &mut ChunkReader,
    visit: impl FnMut(&[u8]) -> ControlFlow<()>,
) -> io::Result<ControlFlow<()>> { /* ... */ }
```

Propagate the visitor's stop request separately from I/O failure.
An explicit cursor can serve the same borrowing need.
Ordinary `Iterator::Item` cannot borrow the iterator's changing scratch storage
for each `next` call;
references into independent stable storage are fine.
When advancing itself waits asynchronously, use the project's stream or async
cursor abstraction; an `async fn` returning a synchronous iterator does not
make its `next` asynchronous.
