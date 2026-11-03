# Type semantics

## Parse, don't repeatedly validate

Convert structured strings or numbers once and pass the structured value.
Prefer standard types: `*url.URL`, `time.Time`, `time.Duration`, parsed templates,
or syntax trees rather than repeated string replacement.
For domain values, use a small type and parser:

```go
type JobID struct {
    value string
}

func ParseJobID(raw string) (JobID, error) { ... }
```

Receiving `JobID` should carry valid-shape guarantees, not require repeated checks.

## Enums

Prefer integer-backed `iota` enums for package-owned closed sets.
Choose zero deliberately; reserve it for unknown or unspecified when no natural zero exists.
Convert external strings at the protocol boundary, usually through text marshaling and unmarshaling.
Reject unknown text unless preservation or round-tripping is contractual.
Use string-backed enums for open sets, required unknown-value round trips,
or strings that are domain values; document the reason when not apparent.

## Pointers and values

Choose one sharing model by copy meaning, not cheap field copying.
Default structs to pointer-oriented objects unless deliberately designed as
primitive-like values callers freely copy.
Use pointers for identity, owned resources or state,
or values that should not be freely copied.
Owning dependencies and exposing operations makes an object even with stable fields
and methods that never assign them.
Carry its model through parameters, results, and collections; pointers do not make nil valid.

Use values for independent copies such as enums, times, colors, coordinates,
or immutable configuration records.
Choose receivers by original object versus independent copy, not mutation.
Use pointer receivers for the original object, including read-only behavior,
and value receivers only for independent copies.
For object snapshots, copy explicitly rather than switching receiver semantics.
Do not mix models without a domain reason.
