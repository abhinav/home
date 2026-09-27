# Ownership and conversions

## Establish why another owned value is needed

A payload clone can allocate and copy all of its contents;
[`Clone`](https://doc.rust-lang.org/std/clone/trait.Clone.html)
promises duplication, not low cost.
Trace what still needs the original value and how long the consumer needs it.
An owned parameter in a local helper is a design choice:
when the helper only inspects the value, let it borrow.
An inline awaited future can borrow from an owner that remains alive until
completion; spawning work with an independent lifetime is a different contract.

Resolve local borrow conflicts through shorter borrows, disjoint field access,
or narrower helper parameters when those express the operation's real needs.
Transfer existing storage when the original owner no longer needs it.
Apply the same reasoning to `to_owned`, `to_vec`, `to_string`, and `cloned`;
changing the spelling does not remove the work.

Copy when independent state or a required lifetime needs another owned value,
and copy only the data that must cross that boundary.
Use a local copy when avoiding it would impose substantial lifetime or
representation complexity on supported callers;
identify that constraint instead of inferring it from a compiler error.
The [Performance](performance.md) guidance governs the cost tradeoff when
removing the copy would require that additional machinery.

## Make signatures reflect the work

For inspection, accept useful borrowed types such as `&str`, `&Path`, and `&[T]`.
Accept `&String` or `&Vec<T>` only when the owner's capabilities matter.
Keep a domain type when its validated meaning is part of the contract.
Pass small `Copy` values by value; `Copy` alone does not imply small size.

Take ownership when retained state can adopt the supplied allocation:

```rust
impl Label {
    /// Adopts the supplied text as the label.
    fn new(text: String) -> Self {
        Self { text }
    }

    /// Replaces the label from borrowed text, reusing storage when possible.
    fn set_text(&mut self, text: &str) {
        text.clone_into(&mut self.text);
    }
    // Type definition and other operations omitted.
}
```

An already owned replacement can be moved directly.
When a copy is needed, use `clone_from` or `clone_into`
if copying into existing storage can reuse it.
Parsing into a different representation does not justify requiring an owned
input that the parser cannot adopt.

Use `impl Into<T>` when conversion convenience serves supported callers;
it is not a reason to make every local helper generic.
Use `Cow` when both a borrowed path and an owned path survive usefully.
Immediately calling `into_owned()` usually removes its benefit.

Accept `Arc<T>` when the operation retains shared ownership,
`&T` for ordinary inspection,
and `&Arc<T>` only when the shared handle itself matters.
`Arc::clone(&value)` makes handle sharing visible; it does not copy the payload,
but does update shared ownership state.
Shared ownership is a lifecycle choice, not a generic cure for borrowing errors.

## Name conversions by ownership and work

| Shape | Promise |
| --- | --- |
| `fn as_bytes(&self) -> &[u8]` | A cheap borrowed view; no material conversion work. |
| `fn to_bytes(&self) -> Vec<u8>` | Produces a representation while preserving the receiver; may copy or allocate. |
| `fn into_bytes(self) -> Vec<u8>` | Consumes the receiver and can transfer storage; cost depends on the conversion. |

`to_*` can also return a borrow after meaningful work, such as UTF-8 validation
in `Path::to_str`, or convert a small `Copy` value by value.
`into_*` does not promise allocation-free or infallible conversion.
Document material copying, allocation, flushing, and discarded state.
Do not call a parsing or allocation operation `as_*` just because it borrows
its input.

For ordinary field access use names such as `body()` and `body_mut()`;
reserve conversion names for changing the view or representation.
For homogeneous collections, `iter`, `iter_mut`, and `into_iter` communicate
borrowed, mutable, and consuming traversal respectively.
Do not add every possible accessor or conversion without a caller need.

## Let callers borrow or transfer existing data

```rust
impl Entry {
    /// Borrows the entry body without copying it.
    pub fn body(&self) -> &[u8] {
        &self.body
    }

    /// Transfers the name and body buffers to the caller.
    pub fn into_parts(self) -> (String, Vec<u8>) {
        (self.name, self.body)
    }
    // Type definition and other operations omitted.
}
```

Return borrowed access for inspection and consuming extraction when callers can
surrender ownership.
A detached snapshot, transformation, or value that must outlive a lock guard
can legitimately require an owned copy.
Do not hold a lock longer merely to avoid the copy.

`mem::take` transfers storage out and leaves a default value;
it does not retain the old allocation for reuse by the original owner.
Use it only when that replacement state satisfies the owner's contract.
For extraction from buffered or stateful resources, also apply
[Resources and completion](resources-and-completion.md).

## Add borrowed counterparts for independent input storage

Use `&Entry` when callers already have an `Entry`.
A separate view earns its place when callers also have independently borrowed
components, such as slices into a parse buffer:

```rust
/// An entry with independent owned storage.
pub struct Entry {
    /// Name identifying this entry.
    name: String,
    /// Encoded entry contents.
    body: Vec<u8>,
}

/// An entry view borrowing its name and contents.
#[derive(Clone, Copy)]
pub struct EntryRef<'a> {
    /// Name in the source storage.
    name: &'a str,
    /// Contents in the source storage.
    body: &'a [u8],
}

impl Entry {
    /// Borrows the fields without copying their buffers.
    pub fn as_ref(&self) -> EntryRef<'_> {
        EntryRef { name: &self.name, body: &self.body }
    }
}

impl<'a> EntryRef<'a> {
    /// Views an entry whose components may come from separate buffers.
    pub fn new(name: &'a str, body: &'a [u8]) -> Self {
        Self { name, body }
    }
}

impl From<EntryRef<'_>> for Entry {
    /// Copies both components into independent owned storage.
    fn from(view: EntryRef<'_>) -> Self {
        Self { name: view.name.to_owned(), body: view.body.to_vec() }
    }
}

// The consumer accepts EntryRef by value.
write_entry(stored.as_ref());
write_entry(EntryRef::new(parsed_name, input_chunk));
let detached = Entry::from(stored.as_ref());
```

This example has no additional validation invariant.
When one exists, every view constructor must preserve the promise its consumers
rely on; raw slices are not automatically validated domain values.
Implement shared inspection on the view where useful,
and keep mutation and capacity management on the owner.
Do not duplicate the entire API across both types.

The inherent `as_ref` above returns a small view value.
It is not an implementation of `AsRef`, which returns `&Target`.
Likewise, `Borrow` cannot return a reference to a freshly assembled temporary
view.
Unsized pairs such as `String`/`str` and `PathBuf`/`Path` have a different
representation; they do not justify unsafe casts for an ordinary view record.

`Borrow` also requires compatible equality, ordering, and hashing.
A case-insensitive name can expose `AsRef<str>` without satisfying `Borrow<str>`.

`ToOwned::Owned` must implement `Borrow<Self>`.
Moreover, a `Clone` type already has a blanket `ToOwned` implementation:
for `EntryRef`, it copies the view, retaining the borrowed buffers.
Consequently `Cow<EntryRef>` does not supply the independent owned `Entry` form.
Use an explicit owning conversion such as `Entry::from(view)` when the
representations do not support the standard owned/borrowed trait relationship.
