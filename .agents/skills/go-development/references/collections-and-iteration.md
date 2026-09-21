# Collections and iteration

## Collection operations

Copy a map or slice before changing a result that must not affect its input.
The standard helpers also make merges clear:

```go
mapCopy := maps.Clone(original)
sliceCopy := slices.Clone(input)
maps.Copy(destination, overrides)
names := slices.Compact(slices.Clone(sortedNames))
```

`maps.Copy` merges into an initialized destination map
and overwrites matching keys.
`slices.Compact` changes its slice and removes consecutive duplicates only.
`maps.Clone` and `slices.Clone` preserve nil inputs
and copy keys or elements by assignment, not recursively.
Clone nested mutable values separately when they must be independent.

Use [maps](https://pkg.go.dev/maps) and [slices](https://pkg.go.dev/slices)
for ordinary deletion and equality;
`slices` also covers membership and sorting.

## Iteration and streaming

`iter.Seq[V]` yields one value at a time;
`iter.Seq2[K, V]` yields a pair, such as a key and value or a value and error.

### Memory and storage

Streaming lets producers and consumers process data incrementally
without holding the entire input or intermediate results in memory.
Read, transform, and consume values as they arrive,
retaining only the current values and the state the operation needs.
For filtering, counting, or writing, memory can stay bounded as input grows.
That bound depends on record sizes, source buffers, batches,
and anything the consumer retains.
Aggregation may need growing state, such as one count per distinct key.

Preserve incremental processing throughout the pipeline:
a producer that loads the whole input before yielding still retains that input.
Likewise, `slices.Values`, `slices.All`, `maps.Keys`, `maps.Values`,
and `maps.All` expose sequences over existing collections;
they avoid an additional collection while keeping the source storage alive.
Use them at sequence API boundaries.
A slice or map already supports direct ranging in local code.

Materialize at the boundary that needs stored results:
random access, an owned snapshot, repeated passes over a single-use source,
or sorting unsorted data.
Use `slices.Collect`, `maps.Collect`, or `maps.Insert` for those boundaries.
Feed an API that supports batching with bounded batches,
and bound any outstanding batches it retains.
For sorted map keys, `slices.Sorted(maps.Keys(m))` collects and sorts them;
range over the map directly when order does not matter.
Map iteration order is unspecified.

### Producing and consuming values

Return a sequence from a traversal or transformation
so callers can filter, transform, count, write, or stop after enough results
without collecting the values first.
Keep reads and transformations inside the iterator function.
The producer must stop as soon as `yield` returns false,
including through nested loops and adapters:

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

Breaking or returning from the consumer loop stops the upstream sequence.

For a fallible producer, `iter.Seq2[Record, error]` carries values and errors.
Check each yielded error
and apply [Wrapping errors](errors-and-diagnostics.md#wrapping-errors) at the consumer
as at an ordinary call site.
Yield a terminal read error once, then end the sequence.
An iterator that owns a resource should acquire it inside the iterator function
and defer cleanup there, so an early `break` or `return` also releases it.
Document whether a sequence can be traversed again;
streams that cannot be rewound are single-use.

### Pulling values

Use `iter.Pull` or `iter.Pull2` when the consumer must control
when to advance a sequence, such as when pairing two streams.
They return `next` and `stop` functions:

```go
next, stop := iter.Pull(seq)
defer stop()
value, ok := next()
```

`Pull2` returns two values and `ok` from `next`.
Defer `stop()` immediately so early exits release the producer.
Ordinary `for range` consumption does not need `Pull`.
See [iter](https://pkg.go.dev/iter) for the sequence and pull contracts.

## Strings and bytes

Use `strings.Cut` or `bytes.Cut` to split around the first separator,
and `CutLast` to split around the last separator.
These return the pieces and a `found` boolean,
avoiding index arithmetic and a separate missing-separator branch.

For line-, field-, or separator-delimited iteration,
`strings.Lines`, `strings.FieldsSeq`, and `strings.SplitSeq`
have corresponding `bytes` functions.
They yield one part at a time without collecting a slice first.
`Lines` keeps each line's terminating newline.
`Lines` and `SplitSeq` return single-use iterators;
call the function again for another pass.
Use `Split` or `Fields` when a slice is the desired result.
