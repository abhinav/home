# Context and concurrency

## Context usage

Always pass non-nil contexts; `context.TODO()` is only a temporary placeholder
intended for immediate replacement.

```go
// BAD: nil context.
client.Do(nil, req)

// GOOD: explicit background context.
client.Do(context.Background(), req)
```

## Cancellation

Wire cancellation to the operation that blocks or keeps working.
Pass context into supporting HTTP requests, database calls, or `exec.CommandContext`,
and handle their errors.
Select on `ctx.Done()` alongside channel sends or receives.
When blocking APIs lack context support, use a supported abort, close, or deadline mechanism;
define ownership and cleanup so interruption is safe.
A `ctx.Err()` check before blocking cannot interrupt the call.

Keep explicit checks uncommon: add checkpoints only when cancellation would otherwise
remain unobserved too long, such as long CPU work or substantial work between cancellable calls.
Choose frequency from required latency.
Short local work and loops already governed by cancellable operations normally need
no entry, per-item, or final `ctx.Err()` check.

Cancellation error identity follows the API contract;
accepting context alone does not promise every related process or transport failure
matches `context.Canceled`.
When required, implement context-specific errors at the operation boundary,
preserving unrelated errors; scattered polling does not establish that guarantee.
Verify cancellation while blocked, including termination and resource cleanup.
Assert a specific cancellation error only when contractual.

## Goroutines

Before starting, identify owner, termination condition, and completion observation.
Wait before returning from call-scoped work;
give background work's lifecycle owner stop and wait operations.
Cancellation requests do not prove completion; blocked work must finish or observe cancellation.
Bound input-driven concurrency with a worker pool or another explicit limit,
not unrestricted goroutines per item.
`sync.WaitGroup.Go` replaces the usual `Add(1)`, `go`, and deferred `Done` sequence:

```go
var group sync.WaitGroup
group.Go(work)
group.Wait()
```

Its function must not panic and returns no errors;
use an error-aware group to collect failures or cancel siblings when required.

## One-time notifications

For a permanent transition without payload, close `chan struct{}` rather than send a sentinel.
One send wakes one receiver; closure releases current and future observers.
Give one owner closing responsibility and observers receive-only access:

```go
ready := make(chan struct{})
go func() {
	initialize()
	close(ready)
}()
observeReady((<-chan struct{})(ready))
```

Close only after the promised state is established;
define how observers learn of failure or cancellation before it.
Send values for transfers or repeatable events;
a closed notification channel cannot reset or carry a result.
