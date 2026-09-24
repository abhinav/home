# Map and boolean APIs

## Map-shaped APIs

Avoid using maps in Go API boundaries
when the map represents named domain data.
Types like `map[string]string`,
`map[string][]string`,
and nested maps make call sites hard to read
because the signature does not explain what each key or value means.

Prefer a named struct for each record.
Accept or return a slice for materialized records,
or an `iter.Seq` / `iter.Seq2` for streaming traversal.
See [Iteration and streaming](collections-and-iteration.md#iteration-and-streaming)
for choosing and consuming sequences.
Use a map inside the function
when you need fast lookup, grouping, or uniqueness checks.

```go
// BAD: the two strings have no visible meaning at the call boundary.
func SyncEndpoints(endpoints map[string]string) error { ... }

// GOOD: the boundary names the data being passed.
func SyncEndpoints(endpoints []EndpointSync) error { ... }

type EndpointSync struct {
    Source string
    Target string
}
```

Nested maps deserve extra scrutiny.
They often indicate that a small domain type
would make the code easier to understand and safer to change.

## Avoid boolean API knobs

Avoid boolean parameters in exported Go APIs
when the value changes behavior at the call site.

```go
// BAD: the meaning of true is hidden at the call site.
renderPage(page, true)
```

Prefer a named option,
or a small enum when the behavior is one choice among several:

```go
type RenderMode int

const (
    RenderModeDefault RenderMode = iota
    RenderModeCompact
    RenderModeExpanded
)

type RenderOptions struct {
    Mode RenderMode
}
```

Choose the zero value to preserve default behavior.
Validate unsupported modes or conflicting options
at construction or at the API boundary.

Boolean values are fine when they represent
a stable binary domain fact,
or when they stay inside local control flow.
They deserve more scrutiny
when they become exported parameters,
configuration fields, or interface methods.
