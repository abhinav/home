# Documentation

## Cover every authored named item

Document crates, modules, types, traits, functions, methods, fields, variants,
constants, statics, and macros, including private items.
Document the contract at a depth proportional to the reader's task,
while retaining coverage for every authored item.
Use `//!` for crate/module orientation and `///` for item contracts.
Private visibility does not turn an item's callable contract into
an implementation comment inside its body.
Generated declarations follow their source of truth rather than manual edits.

Give a simple item a brief orientation;
give a meaningful contract the detail needed to use it without reading its body.
Keep this coverage obligation even when the name is clear,
without inventing guarantees or filling empty template sections.
For a trait implementation, inherit or link the trait's existing contract
and document implementation-specific choices where needed instead of copying it.

At module scope, establish responsibility, entry points,
and what callers still own.
At type scope, explain represented concepts and relationships among fields.
At each field, variant, or constant, give its individual meaning,
including units, range, ordering, or sentinel behavior when relevant.
Tuple-struct fields and enum variant payloads are fields too.
Use a short field comment even for a simple wrapper:

```rust
/// Identifies a document within one archive.
struct DocumentId(
    /// Identifier assigned by that archive.
    String,
);
```
Do not make a reader reconstruct a whole-value invariant from separate getters.

## State the consequences that affect use

Document success, rejected inputs, and the state left after partial failure
when these change the caller's choices.
Use `# Errors`, `# Panics`, and `# Safety` when applicable,
with conditions and obligations rather than a list of type names.
For example, an abbreviated method implementation:

```rust
/// Replaces the label, reusing its buffer when possible.
///
/// # Errors
///
/// Returns [`InvalidLabel`] if `text` is empty or contains a line break.
/// The existing label is unchanged on error.
fn set_label(&mut self, text: &str) -> Result<(), InvalidLabel> {
    validate_label(text)?;
    text.clone_into(&mut self.label);
    Ok(())
}
```

That contract requires validation to enforce the stated restrictions
before mutation.
The signature already presents parameter and result types;
explain their relationship and consequences instead of restating them.

State material ownership and cost behavior:
whether a view retains a borrow, a conversion copies storage,
or cloning shares a handle rather than duplicating its contents.
Document cancellation, abandonment, and completion obligations
when resource effects can outlive the call.
Claim allocation, complexity, atomicity, or compatibility guarantees only
when supported by the intended contract and implementation.

Keep implementation rationale beside the invariant it explains using `//`.
For unsafe operations, follow the distinct caller and implementation
contracts in [Unsafe abstractions](unsafe.md#separate-caller-obligations-from-local-justification).

## Make examples teach supported use

Use intra-doc links such as ``[`Message::as_view`]``
instead of hard-coded rendered HTML paths.
Write public examples through the intended public API;
a link to a private helper cannot supply an external caller's contract.
Fix that explanation without widening visibility.

Add examples that teach a meaningful use or decision,
not a separate example for every trivial getter.
Keep error propagation and essential lifecycle obligations visible;
hide only incidental setup.
Make examples runnable by default.
Use `no_run` when execution needs an unavailable environment
or inappropriate side effects, while preserving compilation coverage.
Use `compile_fail` for an intentional rejected use,
and verify the intended restriction causes the failure.
Use `ignore` only for a useful intentionally untested fragment
with its reason visible, not to conceal a broken example.

Before returning code, check the declarations and their fields for coverage,
then check that each comment, changed link, and example supports its claim.
Missing-documentation and link diagnostics assist that review;
they do not establish contract truth or explanatory quality.
