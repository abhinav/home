# Type semantics

## Parse, don't repeatedly validate

When a string or number represents structured data,
convert it to the structured Go type once
and pass that value around.

Prefer standard library types when they exist:
use `*url.URL` for URLs,
`time.Time` or `time.Duration` for time values,
and parsed templates or syntax trees
instead of repeated string replacement.

For domain-specific values,
define a small type with a parser:

```go
type JobID struct {
    value string
}

func ParseJobID(raw string) (JobID, error) { ... }
```

Code that receives a `JobID`
should not need to re-check
whether it is shaped like a valid job ID.
The type boundary should carry that guarantee.

## Enums

Prefer an integer-backed enum with `iota`
when the package owns a closed set of values.
Choose the zero value deliberately;
reserve it for unknown or unspecified when there is no natural zero value.

Convert external strings at the protocol boundary,
usually with text marshaling and unmarshaling.
Reject unknown text unless the contract requires preserving or round-tripping it.

Use a string-backed enum when the set is open,
unknown values must round-trip,
or the strings themselves are domain values.
Document the reason when it is not apparent.

## Pointers and values

Give each type one sharing model based on what a copy means,
not on whether Go can copy its fields cheaply.
Treat a struct as pointer-oriented unless it was deliberately designed
to behave like a primitive value that callers should freely copy.
Use pointers for objects with identity,
owned resources or state,
or values that should not be freely copied.
A type that owns dependencies and exposes operations through them is an object,
even when its fields are stable and its methods do not assign to them.
Carry that model through parameters, results, and collections.
Pointer semantics do not make `nil` valid.

Use values for types modeled as independent copies,
such as enums, times, colors, coordinates,
or immutable configuration records.

Choose a receiver by what the method operates on,
not by whether the method mutates.
Use a pointer receiver for the original object,
including read-only behavior.
Use a value receiver only when the method operates on an independent copy.
A pointer-oriented type that needs a snapshot should copy explicitly
rather than change receiver semantics for one method.
Do not mix pointer and value semantics without a domain reason.
