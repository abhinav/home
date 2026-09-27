# API surface and evolution

## Expose the intended audience

Keep items private until an intended caller needs access.
Use `pub(super)` or `pub(in ancestor)` for a cohesive internal scope,
`pub(crate)` for a crate-wide contract, and `pub` for external callers.
Choose the narrowest audience that supports the operation.
Do not widen visibility to accommodate tests or generated documentation.

Use direct module paths when they provide a clear home for the API.
Keep re-exports for a demonstrated naming or compatibility need;
ordinary application modules need no additional facade.
Visibility and representation protection do not require an export layer.

Review fields, enum payloads, trait implementations, bounds, and re-exports
as capabilities callers can depend on, alongside public functions.
An implementation of a public trait is not made private by its source location.
`#[doc(hidden)]` affects documentation, not accessibility.

Keep dependency types private when they are implementation choices.
Expose canonical shared types when interoperability is the intended contract;
a wrapper that only recreates their API adds little protection.
A type alias or re-export preserves the dependency's type identity.
When choosing a wrapper's implicit operations, use
[Types and standard traits](types-and-traits.md#preserve-invariants-through-every-creation-path).

## Keep modules focused

Give each module a cohesive responsibility.
Keep its types and operations together, but separate independently meaningful
responsibilities instead of accumulating the application's implementation
in one large module or file.
Use file-backed modules for substantive implementations:

```rust
// lib.rs; module documentation lives in the corresponding files.
mod config;
mod jobs;
mod reporting;
```

Callers can use paths such as `crate::jobs::run` directly.
Keep entry files focused on composition and module declarations
when implementation has independent homes.
Small inline modules, including local tests or a sealing helper, are useful;
avoid large inline module trees that place all implementation in one file.
Do not split every type into its own file or fragment one cohesive operation
solely to meet a size target.

## Own complete operations

When several paths must change for the same domain rule,
identify the shared inputs, result, validation, and ordering that establish it.
Put that complete operation in a cohesive module with its private helpers.
Accept the common facts rather than either caller's larger workflow request.
Keep callers' distinct admission, retries, and publication lifecycles with them.
Share a predicate alone when callers genuinely own the remaining sequence;
share the sequence when its ordering is part of the common invariant.
Similar syntax with different policies is not a shared operation.

When reuse requires changing facts to enter another workflow,
then discarding or undoing parts of its result,
extract the transformation that both paths actually need.
Give it truthful inputs and construct each workflow's result directly.
For example, a preview and a sender can share address formatting
without making the preview construct a pretend send request.
Keep workflow-specific validation and effects outside that transformation.
Illustrative independent call paths:

```rust
// Preview: format for display without entering the sending workflow.
let address = format_address(&recipient);
let preview = build_preview(&address);

// Sending: preserve the sender's authorization and delivery contract.
let permitted = authorize_send(&caller, &recipient)?;
let address = format_address(&recipient);
send(permitted, &address)?;
// Supporting types and function implementations omitted.
```

A legitimate detached snapshot or hypothetical model can still require a copy;
the problem is making one operation impersonate another to reach a helper.

Trace a representative rule change through the proposed callers.
A caller should change when its required input, result, or decision changes.
If it only forwards a new field, generic, backend variant, or error arm,
check which representation or policy escaped its owner.
Preserve compiler obligations for genuinely new choices;
do not remove them indiscriminately with defaults or wildcard matches.
Judge the boundary by knowledge removed from callers,
not by the number of files, traits, or lines it introduces.
Use `$code-readability` when arranging declarations within that boundary.
When structural edits obscure behavior, use
[Construction](construction.md#stage-substantial-caller-changes)
to plan supported review units.

## Name items with their module context

Choose an item's name and its callers' imports together.
The name a reader uses includes its module qualification;
let that context supply the domain instead of repeating it in the item name.
Import the module when qualification gives a short item name its meaning:

```rust
use crate::{archive, lease};

/// Resources used while processing an archive.
struct Worker {
    /// Source of archive records.
    records: archive::Reader,
    /// Pool from which processing leases are acquired.
    leases: lease::Pool,
}
```

Keep distinctions that the module does not supply.
For example, `archive::OpenError` and `archive::ReadError`
identify different failed operations within the same module.
Keep independently useful domain names descriptive:
`DocumentId` and `RevisionId` can be imported and used together
without module qualification.
Choose from the concept's use at representative callers,
not a blanket preference for short names or qualified imports.
When reviewing names, inspect the imports and resulting use-site spellings
alongside the declarations.

## Choose what external callers may do

Keep representation fields private for values whose invariants or storage
belong to the implementation.
Public fields are suitable for passive records deliberately constructed or
modified by callers.
For application records changed together, allow required-field additions to
identify callers needing attention, as described in
[Construction](construction.md).

For independently released APIs, choose the construction contract at introduction:

- Private fields with constructors or builders permit internal field growth.
- A public record with `Default` still allows exhaustive literals and patterns;
  adding a field can break them.
- `#[non_exhaustive]` reserves additions to an intentionally open record or enum.
  It is not a blanket decoration for every public type.

For an extensible record with public optional settings, downstream usage is:

```rust
let mut options = ExportOptions::default();
options.compression = compression;
```

A downstream caller cannot construct a `#[non_exhaustive]` struct with
`ExportOptions { compression, ..Default::default() }`.
Provide a usable constructor or semantic default.

Reserve `#[non_exhaustive]` for a contract that permits unanticipated additions;
keep application-owned alternatives closed when callers must handle each one.
For match behavior, use
[Types and standard traits](types-and-traits.md#make-conversion-failures-and-closed-choices-visible).
An open protocol that must preserve unknown data needs an explicit
representation for that data; `#[non_exhaustive]` does not store it.

Leave a trait implementable when downstream implementations are its purpose.
Seal it at introduction only when the crate owns the implementation set:

```rust
/// Bounds whose implementations remain owned by this crate.
mod sealed {
    /// Marks supported encoders.
    pub trait Sealed {}
}

/// Encodes values with a crate-supported implementation.
pub trait Encoder: sealed::Sealed {
    // Operations omitted.
}
```

Do not retrofit sealing onto an established extension point.
New required methods break implementors; provided defaults need real fallback
semantics and can still affect method resolution or dyn compatibility.
See [Polymorphism](polymorphism.md) for extension and delegation choices.

## Preserve observable promises

Before changing an existing API, establish its supported callers and
compatibility commitments.
When callers can change together, evolve the existing operation and update
those callers as part of the change.
Preserve supported behavior by supplying the appropriate values and
implementations through the revised interface.
For independently evolving consumers, preserve the supported interface
according to its release or migration contract.
Additional operations need a distinct supported caller contract or an
established compatibility obligation.
Selecting a dependency's native or alternative implementation is an input
to the same operation.
Use [Construction](construction.md) to place new inputs and stage substantial
caller changes.

A new optional setting must preserve supported behavior when omitted.
A genuinely new required input changes the caller's contract;
account for that change under the compatibility commitments above.
Hiding the requirement in a newly failing `build()` does not preserve it.

Private representation changes can affect `Send`, `Sync`, `Unpin`,
and other observable traits; an opaque return type can expose auto traits too.
Treat `Copy`, supported trait implementations, and borrowing behavior as API
commitments, not consequences callers should ignore.

For Rust 2024 opaque returns, avoid unintentionally retaining an input borrow
when the result is independent:

```rust
/// Returns the stored count without retaining a borrow of the counter.
fn counts(counter: &Counter) -> impl Iterator<Item = usize> + use<> {
    std::iter::once(counter.len())
}
```

Use precise captures only when the implementation supports that independence;
do not copy data or demand `'static` merely to conceal a lifetime relationship.
