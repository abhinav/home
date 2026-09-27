# Types and standard traits

## Parse into the representation consumers need

Parse external strings, bytes, and raw records into values that retain what
was learned: identifiers, addresses, units, constrained numbers, or domain states.
Prefer `parse(raw) -> Result<Parsed, Error>` followed by operations accepting
`Parsed` over `validate(&raw) -> Result<(), Error>` followed by passing raw data.
The latter discards the useful guarantee and invites repeated interpretation.

Use an existing parsed type when its semantics fit.
Wrap it in a domain newtype when that adds a distinct identity or invariant;
keep the parsed representation inside, rather than storing the original string
and parsing it again at each use.
For example, an endpoint can retain `SocketAddr` after parsing:

```rust
/// Address of the service accepting job submissions.
struct JobEndpoint {
    /// Parsed network destination.
    address: std::net::SocketAddr,
}

impl std::str::FromStr for JobEndpoint {
    type Err = std::net::AddrParseError;

    /// Parses an IP address and port for later connection attempts.
    fn from_str(raw: &str) -> Result<Self, Self::Err> {
        Ok(Self { address: raw.parse()? })
    }
}
```

Let consumers accept `JobEndpoint` when they need that domain meaning.
Keep raw text separately only when preserving spelling or round trips matters.
Parsing cannot guarantee that a resource still exists or a remote service is
reachable; check changing external facts at the operation that relies on them.

## Preserve identity across boundaries

Before sharing an identifier, establish who assigns it, what it identifies,
whether it survives renaming or relocation, and who resolves it.
Public names, durable identities, and provider addresses can have different
contracts even when their current strings happen to match.
Use distinct types where those meanings differ;
let the configured adapter own provider selection and routing translation.
Consumers should request the capability without reconstructing that routing.
Keep canonical shared types when the meanings truly coincide.
Captured display or profile metadata should not alter stable identity equality;
keep it alongside identity when its separate lifetime warrants a separate value.

## Make invalid states unrepresentable when inexpensive

Prefer a representation that excludes invalid combinations with ordinary Rust
constructs: enums for alternatives, variant fields for state-specific data,
`NonZeroUsize` for positive counts, and private fields with checked construction
for relationships among values.

```rust
/// Retry behavior selected for an operation.
enum RetryPolicy {
    /// Make one attempt without retrying.
    Disabled,
    /// Retry within the supplied attempt budget.
    Enabled {
        /// Maximum attempts, including the initial attempt.
        max_attempts: std::num::NonZeroUsize,
        /// Wait between attempts; zero requests immediate retry.
        delay: std::time::Duration,
    },
}
```

This avoids a boolean plus unrelated optional settings whose combinations
must be checked throughout the program.
For relationships such as `start <= end`, a private record and fallible
constructor are often sufficient.
Use these inexpensive guarantees directly; reserve elaborate typestate,
const generics, or lifetime machinery for requirements that justify their cost.
Raw input can contain invalid states so parsing can report useful errors;
the successfully parsed domain value should carry the established guarantees.

Distinguish alternatives from facts that can vary independently.
An accepted policy and the readiness of work derived from it have different
lifetimes: finishing that work need not change the policy accepted earlier.
Model policy alternatives with an enum and readiness separately when independent.
Do not turn their cross-product into one large lifecycle enum merely to avoid
booleans, or treat old missing data as evidence of a newly introduced policy.
Private construction must still enforce relationships across fields and versions;
an enum alone cannot prove them or guarantee that external facts remain current.

## Preserve invariants through every creation path

Keep a validated value's representation private and make its construction,
deserialization, defaults, and mutation preserve the same invariant.
A rejecting constructor does not constrain a separately derived `Deserialize`.
For a project using Serde, route deserialization through checked construction:

```rust
/// A nonempty name as supplied by the caller.
#[derive(serde::Deserialize)]
#[serde(try_from = "String")]
pub struct Name {
    /// The validated, nonempty text.
    value: String,
}

impl TryFrom<String> for Name {
    type Error = InvalidName;

    /// Rejects empty text without changing accepted names.
    fn try_from(value: String) -> Result<Self, Self::Error> {
        if value.is_empty() {
            return Err(InvalidName);
        }
        Ok(Self { value })
    }
}
// InvalidName and accessors omitted.
```

The Serde conversion attribute
uses the specified `TryFrom` implementation after decoding its input type.
Use a raw record and a fallible conversion when validation relates several fields.
Keep the raw record separate from the type that promises validation.

Implement `Default` only when it produces a meaningful valid state.
Do not manufacture a sentinel to make required data defaultable.
An unrestricted mutable accessor or `DerefMut` to storage can bypass validation;
offer mutations that maintain the invariant instead.
Use `Deref` for a pointer-like relationship callers should use implicitly,
not to inherit an inner type's API through a domain wrapper.
`Deref` adds implicit conversions and exposes the target's methods.

## Derive capabilities deliberately

Prefer derives when their field-wise semantics are the intended contract.
Each added trait gives callers another operation; a maximal derive list is not
a completeness requirement.
Deriving equality over cached or incidental fields can accidentally make them
part of domain identity.
When implementing comparison manually, keep `PartialEq`, `Eq`, `PartialOrd`,
`Ord`, and `Hash` consistent: equal values must hash alike,
and ordering must agree with equality.
Cloning must preserve equality for values that compare equal to themselves.

Inspect generated generic bounds when a derive rejects a valid caller.
Cloning a shared handle should not require cloning its payload:

```rust
/// A shared owner of a service value.
struct Handle<T> {
    /// The service shared by all clones of this handle.
    value: std::sync::Arc<T>,
}

impl<T> Clone for Handle<T> {
    /// Shares the service without cloning its value.
    fn clone(&self) -> Self {
        Self { value: std::sync::Arc::clone(&self.value) }
    }
}
```

Here a derived implementation would unnecessarily require `T: Clone`.
Use a manual implementation to express the supported capability;
do not add a bound to every caller to accommodate generated code.

For placement of generic bounds, use
[Polymorphism and bounds](polymorphism.md#choose-the-representation-of-supported-variation).
For `Borrow`, borrowed views, and conversion naming,
read [Ownership and conversions](ownership-and-conversions.md).
For public trait and `Copy` commitments,
read [API surface and evolution](api-surface-and-evolution.md).

## Make conversion failures and closed choices visible

Implement `From` for an infallible, value-preserving conversion with one natural
meaning; use `TryFrom` when supported input can be rejected.
Implementing `From` also supplies `Into`, so prefer that direction.
Use checked numeric conversions at representation boundaries:

```rust
let payload_length = u32::try_from(payload.len())?;
```

Use truncation, wrapping, or saturation when the contract calls for that behavior,
not to silence a conversion error.
A numeric `as` cast can silently change the value.

Match owned, closed enums exhaustively where a new variant should force a new
decision:

```rust
let may_resume = match state {
    RunState::Queued => true,
    RunState::Running => false,
    RunState::Finished => false,
};
```

Keep a wildcard when all remaining and future cases intentionally share behavior,
or an external non-exhaustive enum requires it.
Do not hide a missing domain decision behind `_ => false`.
