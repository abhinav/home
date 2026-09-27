# Async execution and synchronization

## Own spawned work through completion

Identify the owner that observes each spawned task's outcome
and the contract for stopping or intentionally detaching it.
Dropping a Tokio `JoinHandle` detaches the task.
Awaiting it exposes both the join failure and the operation's own result;
retain both failure layers.

```rust
let mut worker = tokio::spawn(run_worker());
let observed = tokio::time::timeout(limit, &mut worker).await;
// The owner still holds worker if the wait times out.
```

Passing the handle by value to the timeout can instead detach the task
when the timeout drops it.
After a timeout, choose cancellation, continued supervision, or detachment
according to the operation's contract.
An abort or cancellation request does not establish that work has stopped;
observe completion when that matters.
Use a service owner when work must outlive a request.

## Preserve state across cancellation

At a suspension point, distinguish discarded private work
from progress or effects that later code must reconcile.
Losing branches of `tokio::select!` are dropped.
When a loop recreates a future after interruption,
keep resumable progress outside that future.

Operations such as `read_exact` and `write_all`
can have partially progressed before cancellation.
Recreating them can lose the progress needed to continue the same stream.
Retain the offset and buffer with their owner,
or use an operation whose cancellation contract fits the surrounding loop.
Discarding a connection can make abandoned progress acceptable;
resuming that connection changes the requirement.

## Bound and place the work that consumes resources

Use the existing async API for I/O.
Move necessary blocking calls or substantial CPU computation off async workers;
`async fn` and `tokio::spawn` do not move synchronous work to a blocking pool.
Keep short bounded computation inline.

Use `spawn_blocking` for synchronous work that finishes,
a suitable CPU pool for sustained parallel computation,
and a dedicated thread for a persistent blocking loop.
Acquire capacity before submission when the bound includes waiting tasks,
and retain the permit with the work:

```rust
let permit = slots.acquire_owned().await?;
let job = tokio::task::spawn_blocking(move || {
    let _permit = permit;
    parse_document(&bytes)
});
let document = job.await??;
```

This fragment bounds admitted jobs.
It leaves result supervision and shutdown to the enclosing owner.
A started blocking job can survive cancellation of its awaiter,
so a permit held only by that awaiter would release capacity too early.
Supervision that must survive request cancellation needs a longer-lived owner.

Tokio cannot abort a started `spawn_blocking` job.
A shutdown timeout stops waiting without terminating it.
Use the underlying operation's deadline or cooperative cancellation
when stopping its effects matters.

Name the resource being bounded:
active operations, queued tasks, messages, bytes, or retained results.
A permit acquired inside every newly spawned task can leave waiting tasks
unbounded; bounded message count does not bound arbitrary payload sizes.
Keep bounds proportional to the supported workload,
rather than imposing a pool on a small fixed set of tasks.

## Keep guard lifetimes visible

Prefer an ordinary mutex for short, lightly contended critical sections
that finish before suspension.
Use an async mutex when the protected operation legitimately spans an await,
or give an I/O resource an owning task when that simplifies its operation.

```rust
let snapshot = {
    let state = shared
        .lock()
        .expect("state owner must not panic while holding its lock");
    state.snapshot()
};
send(snapshot).await?;
```

This shape makes the guard's lifetime visible.
The poisoning policy must be justified by the actual invariant.
Keep guards out of unrelated I/O and callbacks,
but do not split an atomic decision into read/unlock/await/write
if that admits stale decisions.
An async mutex permits suspension; it does not repair a split invariant.

In projects using `tracing`, instrument the future
instead of holding a span's entered guard across suspension:

```rust
use tracing::Instrument;

run_request().instrument(span).await?;
```

Instrumentation associates the span with polling that future,
rather than unrelated work executed while it is suspended.
