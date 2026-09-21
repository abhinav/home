# API design

## Interface compliance checks

Add compile-time assertions to verify that a type implements an interface:

```go
var _ InterfaceName = (*TypeName)(nil)
```

Skip this when the type or the interface can't be imported into the same file.

```go
// BAD: no compile-time check.
// A method signature typo won't be caught
// until the value is used as the interface.
type Handler struct{}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {}

// GOOD: the compiler rejects this immediately
// if *Handler doesn't satisfy http.Handler.
type Handler struct{}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {}

var _ http.Handler = (*Handler)(nil)
```

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

## Accept interfaces, return structs

Prefer accepting interfaces
and returning concrete structs.

When a type or function consumes behavior that may vary,
define the smallest useful interface at the consumption boundary.
Keep the interface near the consumer that owns the requirement,
not beside the provider merely to mirror the provider's methods.
This lets callers provide real implementations,
test doubles,
or wrappers without coupling the consumer to a larger API.

```go
func Parse(r io.Reader) (*Document, error) { ... }
```

When a package produces an abstraction,
return a concrete exported type by default.
Exported functions and methods must never return unexported types,
including through pointers, containers, or iterator element types.
Their callers must be able to name the result types in their own declarations.
Callers can define their own interfaces
at the point of use if they need one.

```go
type Client struct {
    ...
}

func NewClient(cfg ClientConfig) *Client {
    return &Client{...}
}
```

Avoid returning an interface
just to hide an implementation.
Adding methods to that interface later
will break callers with their own implementations,
including tests and wrappers.

Do not introduce an interface when substituting the dependency
would not improve the consumer's design or tests.
Concrete dependencies are appropriate when their API is already the relevant
contract,
they are cheap to construct or pass,
and callers do not need to replace their behavior.
This commonly includes structured loggers,
immutable configuration values,
standard-library value types,
and small stateless collaborators.
Prefer the concrete dependency in these cases
instead of creating a one-implementation interface for uniformity.

Producer-defined interfaces are still useful
when the package has multiple implementations,
when the interface represents a single operation,
or when callers commonly wrap the abstraction.

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
