# Context and concurrency

## Context usage

Always pass a non-nil `context.Context`.
Use `context.TODO()` only as a temporary placeholder
you intend to replace immediately.

```go
// BAD: nil context.
client.Do(nil, req)

// GOOD: explicit background context.
client.Do(context.Background(), req)
```

## Goroutines

`sync.WaitGroup.Go` starts a goroutine and accounts for its completion:

```go
var group sync.WaitGroup
group.Go(work)
group.Wait()
```

This replaces the usual `Add(1)`, `go`, and deferred `Done` sequence.
The function passed to `Go` must not panic.
It does not return errors; use an error-aware group when failures
must be collected or cancel sibling work.
