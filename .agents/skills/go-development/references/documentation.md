# Documentation

Use GoDoc style for exported functions, types, variables, and fields,
beginning with the exported name.

```go
// StartDispatcher runs workers until ctx is canceled.
// It blocks until every worker has stopped.
func StartDispatcher(ctx context.Context) { ... }
```

When adding or changing struct fields, check both struct and field documentation.
Put field documentation directly above its declaration inside the struct;
put whole-value meaning and field relationships above `type`.
Separate each documented field from its predecessor with an empty line.

```go
// ByteWindow selects a portion of a payload. Start must not exceed End.
type ByteWindow struct {
    // Start is the inclusive offset in bytes from the payload start.
    Start int64

    // End is the exclusive offset in bytes from the payload start.
    End int64
}
```
