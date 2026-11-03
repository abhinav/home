# Map and boolean APIs

## Map-shaped APIs

Avoid maps for named domain data at API boundaries;
generic or nested maps obscure the meaning of keys and values.
Accept or return slices of named records for materialized data,
or `iter.Seq` or `iter.Seq2` for streaming traversal.
Read [Iteration and streaming](collections-and-iteration.md#iteration-and-streaming)
for sequence choice and consumption.
Internal maps can provide lookup, grouping, and uniqueness checks.

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

Scrutinize nested maps: they often indicate a useful small domain type.

## Avoid boolean API knobs

Avoid exported boolean parameters when their values change behavior:

```go
// BAD: the meaning of true is hidden at the call site.
renderPage(page, true)
```

Prefer a named option, or a small enum when choosing among several behaviors:

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

Zero should preserve default behavior.
Validate unsupported modes or conflicting options at construction or the API boundary.
Booleans are valid stable binary domain facts or local control flow;
scrutinize exported parameters, configuration fields, and interface methods more closely.
