# Resources and completion

## Bind cleanup to ownership with RAII

Use RAII: let an owning value or guard release its resource when its scope ends.
Prefer existing owners such as files, lock guards, temporary-directory guards,
and permits over manually paired acquire/release calls on every return path.
Ordinary scope exit, early returns through `?`, and panic unwinding then share
the same release path.

```rust
let selected: JobId = {
    let state = shared.lock()?;
    state.selected_job()
}; // The guard releases the lock before further work.
process(selected)?;
```

Keep the owner alive through its final user.
Copying a temporary directory's path does not extend the directory's lifetime.
Use a small custom guard when an acquired resource has a cleanup obligation
that existing owners do not express; install it immediately after acquisition.
Keep ownership singular unless sharing is part of the resource's contract,
and make transfer or deliberate disarming explicit.

Use `Drop` for resource release and fallback cleanup or rollback.
It cannot return a completion error or perform ordinary async work.
Avoid panics during cleanup that can obscure the original failure;
a second panic while unwinding can abort the process.
Destructors are not guaranteed on process abort, forced termination, or `mem::forget`.
When designing an unsafe owner, check memory safety under leaked owners in
[Unsafe abstractions](unsafe.md#prefer-safe-operations-that-expose-the-needed-structure).

## Retain shared resources for the operation

When a real workload produces several results from one acquisition,
let a batch or session own or borrow that resource across incremental pulls.
Keep setup and cleanup behind the operation instead of making every consumer
coordinate repeated acquisition.
Return independently useful results or explicitly borrowed views according to
what the resource permits; copying a path or raw handle does not retain its owner.

Define the batch contract before optimizing it:
required output order, per-item failures, completed prefixes,
aggregate limits across work and retained results, and end-of-batch completion.
State whether cancellation permits resuming the batch or requires abandoning it.
Keep resumable progress with the owner, and retain resources until surviving work
has stopped even if the caller abandons its result.
Use [Collections and iteration](collections-and-iteration.md)
when choosing pull, batch, or borrowed-buffer interfaces,
and [Async execution and synchronization](async-and-synchronization.md)
when pulls suspend or work outlives its awaiter.
For adapters that may optimize the operation, use
[Polymorphism and bounds](polymorphism.md#give-optional-optimizations-a-valid-fallback)
to determine whether a provided default preserves its ordering and failure contract.
Independent one-item calls remain appropriate when there is no shared lifetime.

## Return success after the promised work completes

RAII release does not prove that fallible work completed successfully.
When completion affects the operation's success,
call the explicit `finish`, `commit`, flush, or shutdown operation
and propagate its result.

```rust
use std::io::Write;

/// Writes the complete payload and flushes this writer's buffer.
///
/// Success does not promise that data is durable on the storage device.
fn write_payload(
    mut writer: std::io::BufWriter<std::fs::File>,
    payload: &[u8],
) -> std::io::Result<()> {
    writer.write_all(payload)?;
    writer.flush()
}
```

`BufWriter` attempts to flush on drop but cannot return that error.
The explicit flush makes a buffered write failure observable.
It does not establish persistence after power loss;
use the underlying resource's synchronization contract when durability matters.

Choose the completion method from the promised outcome.
A compressor can require `finish` to emit a trailer,
a transaction can require `commit`,
and a connection or worker can require orderly shutdown.
Do not treat releasing the handle as proof that any of those happened.
Best-effort cleanup is appropriate when that is the operation's intended contract;
document that limit instead of presenting it as confirmed completion.
For async shutdown, use the task ownership and cancellation rules in
[Async execution and synchronization](async-and-synchronization.md).

A consuming completion method is useful when it transfers the resource
to its final state and further use would be meaningless.
Keep a borrowed method when the resource intentionally remains usable.
The shape follows the resource's lifecycle;
do not create a second wrapper merely to make every terminal method consume
`self`.

## Preserve failure and recovery information

If finishing fails, retain the information callers need to decide what happened.
That can include a source error, an uncommitted transaction,
unwritten bytes, or an owner that can be retried.
Do not discard those values only to fit a simpler return type.

Inspect extraction methods before substituting one for another.
For `BufWriter`, `into_inner` attempts to flush its buffer;
`into_parts` extracts the writer and buffered bytes without flushing.
The latter can support recovery,
but extracting the inner writer does not establish successful delivery.

When both the operation and cleanup fail,
preserve the primary failure and communicate cleanup failure when it matters.
Do not replace the original cause with an unrelated cleanup error,
or silently discard evidence that resources remain active.
The existing error and reporting contract determines how to retain both.

## Own child processes through their end

A `std::process::Child` does not wait for or terminate the process on drop.
Give a child process an owner that observes its exit status
and handles the early-return paths after spawning.
If failure requires terminating it, follow termination with waiting;
requesting termination alone does not establish exit or collect its status.

Keep temporary directories, input files, and other resources alive
until their final process user finishes.
Account for pipe ownership too:
a child can wait indefinitely for EOF if the parent retains an input handle.
A wait strategy must also drain output when the child could fill a pipe;
use an appropriate combined output operation or concurrent readers.
