# Callbacks

Choose by what the callee needs: successive values, resource lifetime,
or caller-supplied behavior have different API shapes.

## Iteration

Prefer `iter.Seq[V]` when a repeated callback
controls the producer only by deciding whether it is invoked again;
use `iter.Seq2[K, V]` for pairs.
Callers retain ordinary `for range`, `continue`, `break`, and `return`.
Read [Collections and iteration](collections-and-iteration.md#producing-and-consuming-values)
for production, early stopping, errors, and cleanup.

## Resource management

Always prefer explicit acquisition and deferred cleanup over `WithFoo(func(Foo))`.
Keep caller work and early returns in caller control flow.
Read [Resource acquisition and cleanup](signatures-and-construction.md#resource-acquisition-and-cleanup)
for results, cleanup operations, and owning scope.

## Caller-supplied behavior

Keep callbacks for behavior the callee uses to perform its operation,
such as `func(a, b T) int` comparisons or `func(T) U` transformations.
Repeated invocation is not inherently iteration: comparison results determine order,
not merely whether to call again.
For a public strategy needing additional optional capabilities,
consider a small interface:

```go
type Formatter interface {
	Format(Entry) string
}
```

Discover extra methods through [Optional capabilities](interfaces.md#optional-capabilities);
`func(Entry) string` parameters expose none.
Keep callbacks when one operation suffices; do not add interfaces for hypothetical growth.
