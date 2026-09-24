# Go documentation and struct fields

For exported Go functions, types, variables, and fields,
use GoDoc style and begin with the exported name.

```go
// StartDispatcher runs workers until ctx is canceled.
// It blocks until every worker has stopped.
func StartDispatcher(ctx context.Context) { ... }
```

When documenting Go struct fields,
separate each documented field from the previous field with an empty line.
This keeps multi-field structs scannable
and visually attaches each comment to one field.

```go
type Report struct {
    // GeneratedAt records when source collection finished, in UTC.
    GeneratedAt time.Time

    // Format selects the renderer; an empty value uses the account default.
    Format ReportFormat
}
```
