# Unsafe abstractions

## Prefer safe operations that expose the needed structure

Use slices, iterators, range checks, and standard operations
before replacing indexing with unchecked access.
They can make the bounds visible to both the reader and the optimizer.
Unsafe code introduced only for speed needs a meaningful measured benefit
as well as a soundness argument.

Keep necessary unsafe primitives behind an owner
whose safe interface maintains their invariants.
A small unsafe block makes an operation visible,
but its validity can depend on every safe method that mutates the owner.
Review those methods, panic paths, and partial initialization together.

Safe callers may use `mem::forget`.
An unsafe abstraction must remain memory-safe when a returned owner is leaked;
running its destructor cannot be required for soundness.
Resource leakage and undefined behavior are different failure categories.

## Separate caller obligations from local justification

```rust
/// Reads a counter from foreign storage.
///
/// # Safety
/// `ptr` must be aligned and valid for reading an initialized `u32`.
/// The read must not race with a write to that memory.
unsafe fn read_counter(ptr: *const u32) -> u32 {
    // SAFETY: The caller guarantees pointer validity and read permission.
    unsafe { ptr.read() }
}
```

This illustrates the two contracts, not a reason to wrap ordinary `&u32` reads.
`# Safety` states what an unsafe caller must establish.
The local `SAFETY` comment explains why the particular operation's
preconditions follow from the state available there.
An unsafe trait likewise needs implementor obligations.
Keep explicit unsafe blocks inside unsafe functions.

Read the authoritative primitive's contract for the operation being changed.
Pointer validity includes lifetime, initialization, alignment,
aliasing permissions, provenance, and concurrent access as applicable;
non-nullness and passing tests establish only a fraction of those obligations.
Do not reconstruct unsettled memory-model details from folklore.

For FFI, the wrapper must preserve the foreign API's ownership,
release, thread-access, callback-lifetime, and unwind contracts.
Generated declarations do not establish those promises.
For pinning or partial initialization,
verify the relevant `Pin` or `MaybeUninit` contract,
including panic and destruction paths.

Tests and tools can expose violations;
their success does not replace the invariant and soundness argument.
