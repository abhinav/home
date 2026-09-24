# Signatures and construction

## Parameter and result objects

Use parameter objects when a Go function has several inputs
or when optional inputs are likely to grow.
Use result objects when a function has several outputs
or when optional outputs are likely to grow.

Do not count `context.Context` when deciding
whether a function has too many parameters.
Do not count `error` when deciding
whether a function has too many return values.

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

When adding fields to an existing parameter or result object,
make new fields optional whenever possible.
Prefer field types whose zero values preserve existing behavior
or select a documented default.
When omission must be distinguished from the type's zero value,
a pointer, nullable representation, or required field may be clearer.

Adding a required field to an established input object can invalidate existing
callers even when their code still compiles.
Preserve their construction behavior through an optional field and default,
or treat the new requirement as a deliberate contract change.

When returning a result alongside an error, normally return the result's zero value.
Return a partial result only when the operation deliberately supports one;
document which parts remain usable on failure.
Preserve existing partial-result contracts, such as the count from `io.Writer.Write`.

## Constructors and required dependencies

Use a constructor when creating a value requires behavior:
validation, normalization, implementation selection, resource acquisition,
or other work that establishes an invariant.

Use one of these constructor shapes.

A configuration struct may contain both required and optional fields:

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

Use a configuration struct when construction has several required inputs
or when the input set is likely to grow.
Mark required configuration fields with an inline `// required` comment.

A constructor may instead accept up to two required positional arguments
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

If a type is named `Options`, every field must be optional.
A nil options pointer means that all options use their defaults.
When a constructor needs more than two required inputs,
use a configuration struct rather than adding more positional arguments.

Do not add a constructor that only copies dependencies into fields.
When no construction logic is required,
export the dependency fields directly:

```go
type Recorder struct {
    Store RecordStore  // required
    Log   *slog.Logger // required

    BatchSize int
}
```

Required fields in either a configuration struct or a directly initialized
value use the same marker.
Place `// required` on the same line as the field declaration.
Do not put the marker on the line above the field.
The [requiredfield](https://pkg.go.dev/go.abhg.dev/requiredfield) linter
uses the inline marker to enforce initialization of required fields.

Prefer useful zero-value behavior for optional fields.
Document defaults, deferred initialization, or cases where omission must be
distinguished from the field type's zero value.

## Resource acquisition and cleanup

Return the acquired resource with a cleanup method or cleanup function,
and have the caller defer cleanup immediately after successful acquisition.
This keeps the resource's lifetime visible beside its use
and lets the caller use ordinary control flow and error returns.

For example, with a cleanup function that cannot fail:

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

Choose the owning function's scope to match the required resource lifetime;
`defer` runs when that function returns, not when a block or loop iteration ends.
See [Defer](https://go.dev/doc/effective_go#defer) for the language behavior.

## Exported members on unexported types

Unexported concrete types can still have exported members.

Use exported methods or fields when another component is expected
to call, set, read, or rely on that member as part of the type's contract.
The type name may be package-local,
but the member is still a selector surface for its callers.
Document exported members with the same care you would use on an exported type.

Keep members unexported when they are implementation details
owned by the type's own methods or tightly local construction code.

Do not use lowercase methods or fields
merely because the concrete type is unexported.
Lowercase names signal implementation ownership.
If another component must know about the member to do its job,
the member is part of the collaboration boundary.

```go
type reportWriter struct {
    Output io.Writer // required
}

// WriteSummary writes the summary section to the configured output.
func (w *reportWriter) WriteSummary(ctx context.Context, report Report) error {
    ...
}
```

In this example, `reportWriter` is package-local.
`Output` and `WriteSummary` are exported because another package component
constructs the writer and asks it to write a summary.
