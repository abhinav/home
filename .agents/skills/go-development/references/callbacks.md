# Callbacks

Choose a callback API by what the callee needs from the caller.
A function parameter can deliver successive values, scope access to a resource,
or supply behavior the callee needs to perform its operation.
These roles call for different API shapes.

## Iteration

Prefer `iter.Seq[V]` over an API that repeatedly invokes the same callback
when the callback's only control over the producer
is whether it should invoke the callback again.
Use `iter.Seq2[K, V]` when each step yields a pair.
Callers consume the sequence with `for range`
and retain ordinary `continue`, `break`, and `return` behavior.

Read [Collections and iteration](collections-and-iteration.md#producing-and-consuming-values)
for iterator implementation, early stopping, errors, and resource cleanup.

## Resource management

Always prefer explicit acquisition with deferred cleanup
for resource management over a `WithFoo(func(Foo))` callback API.
The caller should keep its work and early returns in its own control flow.
Read [Resource acquisition and cleanup](signatures-and-construction.md#resource-acquisition-and-cleanup)
for acquisition results, cleanup operations, and the owning function's scope.

## Caller-supplied behavior

Keep a callback when the callee needs behavior chosen by the caller,
such as a comparison `func(a, b T) int` or transformation `func(T) U`.
The callee consumes the result to perform its operation.
Repeated invocation alone does not make a callback an iterator:
a comparison result determines ordering, not merely whether to call again.

For a public strategy that needs additional optional capabilities,
consider a small interface instead of a function parameter:

```go
type Formatter interface {
	Format(Entry) string
}
```

Implementations can expose further methods that callers discover through
[Optional capabilities](interfaces.md#optional-capabilities).
A parameter typed as `func(Entry) string` exposes no additional methods.
Keep a callback when one operation satisfies the caller's needs;
do not introduce a strategy interface solely for hypothetical expansion.
