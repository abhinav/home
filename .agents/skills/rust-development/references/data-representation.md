# Data representation

## Construct generated protocol records

For an extensible generated record, explicitly supply the fields the operation
owns and use `..Default::default()` only when omission has a supported meaning
for every remaining field.
The existence of a generated `Default` implementation does not establish that.
For example, an added optional repeated field can remain empty when the protocol
preserves an existing legacy field's interpretation in that case.
Review that contract when updating the dependency.
Use an adapter constructor when repeated encoding or validation deserves an owner.
Keep required domain choices explicit so new requirements identify their callers.
This is a construction decision, not a guarantee of downstream source compatibility.

## Make decoding preserve the domain contract

Decode a known schema into typed records.
Keep dynamic values for genuinely dynamic or opaque payloads,
including fields passed through without interpretation.
Do not traverse a known JSON structure with string keys and repeated fallback
values when a record can state which inputs are required.

Give an absent value a default only when absence has that meaning in the format.
Choose defaults field by field;
a blanket `#[serde(default)]` can turn a missing required input into success.
Similarly, decide unknown-field handling from who owns the format:
rejecting misspelled fields is useful for configuration the application owns,
while additive fields in an external response may need to remain acceptable.
Serde's container attributes define the mechanics, not the format's policy.

For a new protocol whose variants have overlapping shapes,
prefer an explicit discriminator:

```rust
/// Chooses how the receiver applies the supplied records.
#[derive(serde::Deserialize)]
#[serde(tag = "operation")]
enum Update {
    /// Adds records without removing existing ones.
    Append {
        /// Records to add.
        records: Vec<Record>,
    },
    /// Replaces all existing records with the supplied batch.
    Replace {
        /// The complete replacement batch.
        records: Vec<Record>,
    },
}
```

Do not change an established wire format merely to obtain that shape.
An untagged enum may be appropriate for an existing format,
but Serde selects the first variant that deserializes successfully.
With overlapping variants, declaration order, defaults,
or ignored fields can change which meaning wins.
Keep that ambiguity out of formats the application can design.

When decoding produces a value that promises validation, use
[Types and standard traits](types-and-traits.md#preserve-invariants-through-every-creation-path)
for checked deserialization.
Keep a separate raw record when the external schema evolves independently
of the domain representation.

## Represent independently available data

When operations need different parts of a value, represent availability at the
level where those needs differ.
Require each operation's inputs when entering that operation;
requiring everything at initial construction couples unrelated consumers.
For example, a file browser can show a name before loading the file's contents:

```rust
/// Information available to a file browser.
struct FileView {
    /// Name shown in the directory listing.
    name: String,
    /// Loaded bytes; None means not loaded, while Some(Vec::new()) is empty.
    contents: Option<Vec<u8>>,
}
```

Listing names needs no contents; displaying a preview needs loaded contents.
Do not replace absence with an empty collection when callers distinguish them.
Use `Option<T>` when presence and absence are the only relevant states;
represent loading, failure, or partial results separately when callers act on them.
Keep relationships between available values valid as they change.
An operation that needs several values must still check their joint requirements;
independent availability does not imply that arbitrary combinations are valid.
If correctness depends on mutable external state, check it where the operation
relies on it rather than treating construction as a permanent guarantee.

## Give persisted compatibility an explicit owner

Before storing a version or including it in identity, state what makes two
artifacts interchangeable for their readers and which workers can produce them.
Give that compatibility contract a deliberate version or namespace,
selected by the owner constructing new persisted work.
Preserve the identity and accepted policy of already admitted work when decoding it.
Keep a deployment or tool version out of durable identity when a compatible
implementation change does not alter the promised result.
Enforce worker eligibility from supported contracts, not incidental binary equality.

A contract may permit different byte encodings and reuse the first publication;
a reproducible-build contract may instead require a pinned toolchain and bytes.
Choose identity inputs from that distinction.
A stable version constant alone proves neither compatibility nor reproducibility.
An incompatible format requires an intentional version change and an account of
reader/writer support, old work, and migration or rejection.
Changing an in-memory enum does not change the persisted format's obligations.
