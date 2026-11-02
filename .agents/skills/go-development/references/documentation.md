# Documentation

For exported Go functions, types, variables, and fields,
use GoDoc style and begin with the exported name.

```go
// StartDispatcher runs workers until ctx is canceled.
// It blocks until every worker has stopped.
func StartDispatcher(ctx context.Context) { ... }
```

When adding or changing struct fields, check the documentation on the struct
and its fields as part of that declaration change.
Attach each field's documentation directly above its declaration inside the struct.
The comment above `type` describes the whole value and relationships among fields.
This lets a caller read a field's contract at the field being set or inspected.
Separate each documented field from the previous field with an empty line.

```go
// ByteWindow selects a portion of a payload. Start must not exceed End.
type ByteWindow struct {
    // Start is the inclusive offset in bytes from the payload start.
    Start int64

    // End is the exclusive offset in bytes from the payload start.
    End int64
}
```
