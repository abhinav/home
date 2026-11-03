# Collections and iteration

## Collection operations

Copy before mutating a result that must not affect its input:

```go
mapCopy := maps.Clone(original)
sliceCopy := slices.Clone(input)
maps.Copy(destination, overrides)
names := slices.Compact(slices.Clone(sortedNames))
```

`maps.Copy` overwrites matching keys in an initialized destination.
`slices.Compact` mutates its slice and removes only consecutive duplicates.
Clones preserve nil and copy keys or elements by assignment, not recursively;
clone nested mutable values separately when independence is required.
Use [maps](https://pkg.go.dev/maps) and [slices](https://pkg.go.dev/slices)
for deletion and equality; slices also supplies membership and sorting.

## Iteration and streaming

`iter.Seq[V]` yields one value at a time; `iter.Seq2[K, V]` yields pairs,
such as a key and value or a value and error.

### Memory and storage

Read, transform, and consume incrementally, retaining current values and necessary state.
Filtering, counting, or writing can stay bounded as input grows,
but bounds depend on record sizes, source buffers, batches, and consumer retention.
Aggregation may grow, such as a count per distinct key.
Keep the whole pipeline incremental: loading everything before yielding retains everything.
`slices.Values`, `slices.All`, `maps.Keys`, `maps.Values`, and `maps.All`
avoid another collection but keep source storage alive.
Use them at sequence API boundaries.
Local slices and maps already support direct ranging.

Materialize at the boundary needing stored results: random access, owned snapshots,
repeated passes over single-use sources,
or sorting unsorted data, using `slices.Collect`, `maps.Collect`, or `maps.Insert`.
Use bounded batches and bound any outstanding batches retained by the receiving API.
`slices.Sorted(maps.Keys(m))` collects and sorts keys;
range over maps directly when order is irrelevant, since their order is unspecified.

### Producing and consuming values

Return sequences for traversal or transformation so consumers can filter, transform,
count, write, or stop without first collecting.
Keep reads and transformations inside the iterator.
Stop immediately when `yield` returns false, including through nested loops and adapters:

```go
func Active(records iter.Seq[Record]) iter.Seq[Record] {
	return func(yield func(Record) bool) {
		for record := range records {
			if record.Active && !yield(record) {
				return
			}
		}
	}
}

for record := range Active(store.Records()) {
	if err := writeRecord(w, record); err != nil {
		return fmt.Errorf("write record: %w", err)
	}
}
```

Breaking or returning from the consumer loop stops upstream.
For fallible producers use `iter.Seq2[Record, error]`; check each error and
apply [Wrapping errors](errors-and-diagnostics.md#wrapping-errors) as at ordinary calls.
Yield terminal read errors once, then end.
Acquire owned resources inside the iterator and defer cleanup there,
so early consumer exits release them.
Document repeatability; streams that cannot rewind are single-use.

### Pulling values

Use `iter.Pull` or `iter.Pull2` when consumers control advancement, such as pairing streams:

```go
next, stop := iter.Pull(seq)
defer stop()
value, ok := next()
```

They return `next` and `stop`; `Pull2`'s `next` yields two values plus `ok`.
Defer `stop()` immediately for early-exit cleanup; ordinary range does not need Pull.
See [iter](https://pkg.go.dev/iter) for contracts.

## Strings and bytes

Use `strings.Cut` or `bytes.Cut` for the first separator, `CutLast` for the last.
They return pieces and `found`, avoiding manual index arithmetic.
`strings.Lines`, `strings.FieldsSeq`, and `strings.SplitSeq` have corresponding
bytes functions, yielding parts without first collecting a slice.
`Lines` retains terminating newlines.
`Lines` and `SplitSeq` are single-use; call again for another pass.
Use `Split` or `Fields` when the desired result is a slice.
