# Signatures and construction

## Parameter and result objects

Use parameter objects for several inputs or likely growth in optional inputs.
Use result objects for several outputs or likely growth in optional outputs.
Do not count `context.Context` when judging too many parameters,
or `error` when judging too many results.

```go
func Export(ctx context.Context, req ExportRequest) (ExportResult, error) {
    ...
}

type ExportRequest struct {
    Path   string
    Format ExportFormat
}

type ExportResult struct {
    BytesWritten int64
    Warnings     []string
}
```

When adding fields to existing parameter or result objects,
make them optional whenever possible; prefer zero values preserving existing behavior
or selecting documented defaults.
A pointer, nullable representation, or required field may be clearer
when omission must differ from zero.
Required additions can invalidate established callers even if they compile:
preserve construction through an optional field and default,
or treat the new requirement as a deliberate contract change.

With an error, normally return the result's zero value.
Return partial results only when deliberately supported,
and document which parts remain usable on failure.
Preserve existing contracts such as `io.Writer.Write`'s count.

## Constructors and required dependencies

Choose results and receivers with [Type semantics](type-semantics.md).
Use constructors for validation, normalization, implementation selection,
resource acquisition, or other invariant-establishing behavior.
Store dependencies and resolved state needed by methods;
keep independent collaborators in separate fields and cohesive domain values grouped.

Use one of these constructor shapes.
Use configuration structs for several required inputs or likely growth:

```go
func NewIndexer(cfg IndexerConfig) *Indexer {
    ...
}

type IndexerConfig struct {
    Store IndexStore   // required
    Log   *slog.Logger // required

    BatchSize int
}
```

Alternatively, accept up to two required positional inputs
followed by an options struct containing only optional fields:

```go
func NewPublisher(
    store PublishStore,
    log *slog.Logger,
    opts *PublisherOptions,
) *Publisher {
    ...
}

type PublisherOptions struct {
    BatchSize int
}
```

Every field of a type named `Options` must be optional; nil options select all defaults.
More than two required inputs need a configuration struct, not more positional inputs.
Do not add constructors that only copy dependencies;
export dependency fields for direct initialization:

```go
type Recorder struct {
    Store RecordStore  // required
    Log   *slog.Logger // required

    BatchSize int
}
```

Mark required configuration and direct-initialization fields with inline `// required`,
on the declaration line, not above it.
The [requiredfield](https://pkg.go.dev/go.abhg.dev/requiredfield) linter
uses the marker to enforce initialization of required fields.
Prefer useful optional zero values; document defaults, deferred initialization,
or distinctions between omission and zero.

## Resource acquisition and cleanup

Return an acquired resource with a cleanup method or function.
Callers defer cleanup immediately after checking acquisition succeeded,
keeping lifetime beside use and preserving ordinary control flow and early returns.
For cleanup that cannot fail:

```go
foo, cleanup, err := acquireFoo()
if err != nil {
    return err
}
defer cleanup()

if err := useFoo(foo); err != nil {
    return err
}
```

Match owning function scope to resource lifetime:
`defer` runs when that function returns, not when a block or loop iteration ends.
See [Defer](https://go.dev/doc/effective_go#defer).

## Exported members on unexported types

Unexported concrete types may have exported members.
Export methods or fields when other components are expected to call, set, read,
or rely on them as part of the contract; document them as carefully as on exported types.
Keep implementation details owned by methods or tightly local construction unexported.
Do not lowercase members merely because the type is unexported:
lowercase signals implementation ownership, not collaboration contracts.

```go
type reportWriter struct {
    Output io.Writer // required
}

// WriteSummary writes the summary section to the configured output.
func (w *reportWriter) WriteSummary(ctx context.Context, report Report) error {
    ...
}
```
