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

Before starting a goroutine, identify its owner, termination condition,
and how the owner will observe completion.
For work scoped to a call, wait for completion before returning.
For background work, give its lifecycle owner a way to stop it and wait for it.
Requesting cancellation does not establish that the goroutine has stopped;
blocking operations must also be able to finish or observe cancellation.

Bound concurrency when input size determines the amount of work.
Use a bounded worker pool or another explicit concurrency limit
instead of starting an unrestricted goroutine for every input item.

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

## One-time notifications

For a permanent state transition without a payload,
close a `chan struct{}` instead of sending a sentinel value.
A single send is consumed by one receiver;
closure lets every current and future observer proceed.
Give one owner responsibility for closing the channel,
and expose only the receive direction to observers:

```go
ready := make(chan struct{})
go func() {
	initialize()
	close(ready)
}()
observeReady((<-chan struct{})(ready))
```

Close the channel only when the state it promises has been established.
Define how observers learn about failure or cancellation before that state.
Keep sends for transferring values or representing repeatable events;
a closed notification channel cannot be reset or carry a result.
