# Errors and diagnostics

## Follow the project's error representation

Choose from the error libraries the project already uses:

| Existing usage | Default for new code |
| --- | --- |
| Neither `anyhow` nor `thiserror`, and no equivalent library | Use neither. Use standard-library errors or handwritten `Display` and `Error` implementations. |
| Both `thiserror` and `anyhow` | Use `thiserror` for concrete errors in reusable modules and library code; use `anyhow` for application orchestration, top-level propagation, and generic test errors. |
| Only `thiserror` | Derive concrete production errors with `thiserror`; use lightweight standard-library error results where only propagation is needed. Do not add `anyhow` by default. |
| Only `anyhow` | Use it for application propagation and generic test errors. Handwrite concrete errors where a reusable contract needs typed distinctions; do not add `thiserror` by default. |
| Another error library | Follow how the rest of the project uses that library, including its test conventions. |

Choose typed distinctions from what callers handle, as described below.
Application orchestration often just adds context and propagates failure.
With both libraries, the signatures can look like:

```rust
// Concrete LoadError derives thiserror::Error; definitions and bodies omitted.
fn load(path: &Path) -> Result<Settings, LoadError> { /* ... */ }

// Application code can propagate LoadError with ? and add operation context.
fn run() -> anyhow::Result<()> { /* ... */ }
```

A module inside an application can still have a reusable typed contract.
Choose by the caller's needs, not whether the file belongs to a binary crate.
Do not replace established error libraries with handwritten boilerplate.

## Keep distinctions that callers act on

Return a typed error when callers use its distinctions for retry, fallback,
rejection, or another supported decision.
Keep those distinctions about the operation's contract,
rather than making a public variant for each implementation step.
Retain those distinctions until the handling decision is complete.
Where callers only propagate and report, use the project's established opaque
error type, or a lightweight standard-library result when no such type is in use.
The library choices above apply to both production and test code.

Preserve a cause as an error value when wrapping it.
Add context where the operation or input becomes known,
such as the attempted action and relevant path or identifier.
Converting a cause to a string loses structured inspection and its own sources.
Avoid repeating the same context at each layer.
When no error library is in use, a handwritten wrapper can retain that context:

```rust
/// Failure to load the selected document.
#[derive(Debug)]
struct LoadError {
    /// Document whose contents could not be read.
    path: std::path::PathBuf,
    /// Underlying filesystem failure.
    source: std::io::Error,
}

impl std::fmt::Display for LoadError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "failed to load {}", self.path.display())
    }
}

impl std::error::Error for LoadError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        Some(&self.source)
    }
}
```

The standard trait implementations inherit their trait contracts.
The outer message supplies operation context;
the cause supplies the reason it failed.
The reporting boundary must display both.

## Report useful context once

Choose one owner for reporting an operation's failure.
Lower layers should generally return errors with context,
rather than logging and returning the same failure for another layer to log.
A handled retry or deliberately recovered failure can need its own diagnostic;
that is a separate event with its own purpose.

Inspect the project's reporter before changing error messages or source chains.
Preserving `source()` is insufficient if the final formatter prints only the
outer message.
For an existing `anyhow::Error` reporting boundary:

```rust
eprintln!("{error:#}");
```

Here alternate display includes the cause chain;
ordinary `{}` displays the outer error.
Other error types have different formatting contracts.
Preserve established diagnostic behavior,
and avoid putting a cause in both the outer display and its source chain
when the reporter would then duplicate it.

Use an error's stable fields or variants for program decisions,
rather than parsing its human-facing display text.
Include enough context for a useful report without exposing credentials,
private payloads, or other data outside the intended diagnostic contract.

## Make panics describe broken invariants

Return `Result` for expected input, I/O, and operational failures.
Use a panic for an established invariant violation
when the operation cannot meaningfully continue under its contract.
An internal location does not make externally influenced failure an invariant.

When `expect` expresses an invariant, state why the value must exist:

```rust
let selected = candidates
    .get(selected_index)
    .expect("selection index was produced from this unchanged candidate list");
```

This justification must be established by the surrounding code.
Prefer handling the missing case when ordinary mutation or external input
can invalidate the assumption.
Do not mechanically replace every `unwrap` with a longer message,
or add recovery that hides a broken invariant.

Reusable operations return their result to the owner of the process.
Let that owner finish required cleanup and return its exit status.
Calling `std::process::exit` skips stack destructors,
so it can abandon resource completion even on an otherwise successful path.
