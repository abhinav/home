# Go

Use current Go language and standard library facilities for new code.
Follow an explicit project requirement to support an older Go version.

- [Viewing dependency source](#viewing-dependency-source)
- [Tool dependencies](#tool-dependencies)
- [Context usage](#context-usage)
- [Import aliases](#import-aliases)
- [Program exits](#program-exits)
- [Structured logging](#structured-logging)
- [Error handling](#error-handling)
  - [Formatting variable values](#formatting-variable-values)
  - [Wrapping errors](#wrapping-errors)
  - [Error variables](#error-variables)
- [Interface compliance checks](#interface-compliance-checks)
- [Symbol ordering](#symbol-ordering)
- [File organization](#file-organization)
- [Parameter and result objects](#parameter-and-result-objects)
- [Constructors and required dependencies](#constructors-and-required-dependencies)
- [Exported members on unexported types](#exported-members-on-unexported-types)
- [Accept interfaces, return structs](#accept-interfaces-return-structs)
- [Map-shaped APIs](#map-shaped-apis)
- [Collection operations](#collection-operations)
- [Iteration and streaming](#iteration-and-streaming)
  - [Memory and storage](#memory-and-storage)
  - [Producing and consuming values](#producing-and-consuming-values)
  - [Pulling values](#pulling-values)
- [Strings and bytes](#strings-and-bytes)
- [Parse, don't repeatedly validate](#parse-dont-repeatedly-validate)
- [JSON](#json)
- [Identifiers and random text](#identifiers-and-random-text)
- [Filesystem boundaries](#filesystem-boundaries)
- [HTTP routing](#http-routing)
- [Enums](#enums)
- [Pointers and values](#pointers-and-values)
- [Avoid boolean API knobs](#avoid-boolean-api-knobs)
- [Goroutines](#goroutines)
- [Testing](#testing)
  - [Context](#context)
  - [Assertions](#assertions)
  - [Resource cleanup](#resource-cleanup)
  - [Naming](#naming)
  - [File ordering](#file-ordering)
  - [Inline single-use variables](#inline-single-use-variables)
  - [Async tests](#async-tests)
  - [HTTP tests](#http-tests)
  - [Benchmarks](#benchmarks)
  - [Test-only API surface](#test-only-api-surface)
  - [Table tests](#table-tests)
- [Tests](#tests)

## Viewing dependency source

To see source files from a Go dependency,
or to answer questions about a dependency,
run `go mod download -json MODULE`
and use the returned `Dir` path to read the files.

## Tool dependencies

Declare Go command dependencies with a `tool` directive in `go.mod`.
This keeps generators and linters in the module graph
without a blank-import `tools.go` file.
Use `go get -tool PACKAGE@VERSION` to add one,
then run it with `go tool NAME`.
Use the full package path if the short name is ambiguous.
The module's `require` directive records the selected version.

See [Go tool dependencies](https://go.dev/doc/modules/managing-dependencies#tools)
for the module syntax and command behavior.

## Context usage

Always pass a non-nil `context.Context`.
Use `context.TODO()` only as a temporary placeholder
you intend to replace immediately.

```go
// BAD: nil context.
client.Do(nil, req)

// GOOD: explicit background context.
client.Do(context.Background(), req)
```

## Import aliases

Avoid import aliases unless Go requires them
or the local project already uses an alias for that package.
Do not invent an alias merely to describe the package's directory,
layer,
transport,
owner,
or relationship to the current package.

```go
// BAD: the alias only labels a package whose natural selector is usable.
import remoteconfig "example.com/project/config"

// GOOD: the imported package name is still usable as the selector.
import "example.com/project/config"
```

The current file's package name is also not a conflict
with an imported package selector.

```go
package ledger

// BAD: this file's package name does not require an alias.
import ledgerdb "example.com/project/storage/ledger"

// GOOD: the imported package selector is still usable.
import "example.com/project/storage/ledger"
```

Use an alias only for a real naming constraint:
two imported packages with the same package name in one file,
an imported package whose declared name differs from its path,
or an established local convention such as generated protobuf packages.

## Program exits

Never call `log.Fatal`, `os.Exit`,
or similar hard-exit functions outside `main()`.
Return errors and let the caller decide.

```go
// BAD: hard exit buried in a helper.
func connect(addr string) net.Conn {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	return conn
}

// GOOD: return the error.
func connect(addr string) (net.Conn, error) {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		return nil, fmt.Errorf("dial %q: %w", addr, err)
	}
	return conn, nil
}
```

## Structured logging

One `slog.Logger` can send records to several handlers:

```go
logger := slog.New(slog.NewMultiHandler(jsonHandler, diagnosticHandler))
```

Each handler retains its own level filtering,
and `WithAttrs` and `WithGroup` propagate to both.
Keep filtering that differs between destinations on the child handlers;
an outer filter can suppress a record wanted by either destination.

## Error handling

### Formatting variable values

Use `%q` (not `"%s"`) when interpolating variable strings
into error messages.
`%q` makes empty strings, whitespace,
and special characters visible in the output.

```go
// BAD: empty name produces a confusing message —
//   "open config : no such file"
return fmt.Errorf("open config %s: %w", name, err)

// GOOD: empty name is obvious —
//   "open config \"\": no such file"
return fmt.Errorf("open config %q: %w", name, err)
```

### Wrapping errors

Add context with `fmt.Errorf` and `%w`
instead of bare `return err`.
Context should describe the immediate sub-operation being performed
without "failed to" or "error doing" prefixes.
Do not repeat the surrounding function's responsibility.
Each caller may add its own context,
so repeating outer context creates noisy error chains.

```go
func LoadSettings(path string) (*Settings, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		// GOOD: this return site failed while reading.
		return nil, fmt.Errorf("read %q: %w", path, err)
	}

	var settings Settings
	if err := yaml.Unmarshal(data, &settings); err != nil {
		// GOOD: this return site failed while decoding YAML.
		return nil, fmt.Errorf("unmarshal YAML: %w", err)
	}

	if settings.Name == "" {
		// GOOD: this return site failed while validating one field.
		return nil, errors.New("name is required")
	}

	return &settings, nil
}
```

Avoid wrapping with the current function's name
or broad operation:

```go
// BAD: duplicates LoadSettings' responsibility.
return nil, fmt.Errorf("load settings %q: read: %w", path, err)

// BAD: duplicates LoadSettings' responsibility.
return nil, fmt.Errorf("load settings %q: unmarshal YAML: %w", path, err)
```

For loops,
describe the item-specific child operation,
not the whole loop:

```go
for _, target := range targets {
	if err := build(target); err != nil {
		// GOOD: the failed sub-operation is building this target.
		return fmt.Errorf("build %q: %w", target.Label, err)
	}
}
```

### Error variables

Use `err` for operation errors.
Reuse it for sequential operations,
and shadow it in a narrower scope
when no earlier error must remain available there.

Introduce separately named error variables only when multiple errors
must remain independently readable at the same time.
An error that is immediately combined with `err`
does not require another variable.

```go
responseBody, err := io.ReadAll(res.Body)
err = errors.Join(err, res.Body.Close())
if err != nil {
	return fmt.Errorf("read response: %w", err)
}
```

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

## Symbol ordering

Go package declarations can generally refer to declarations
that appear later in the package.
A type named by a function, method, or interface
is therefore not a source-order prerequisite.
Apply the reader-order rule in `~/.agents/docs/code-readability.md`.
Place an interface before the request and result types used by its methods.
Place request and result types immediately before a function or method
when its body would otherwise force the reader
to scroll past the implementation to reach those records.
When the implementation and records remain visible together,
place the function or method first
and the request and result types after it in first-need order.

Keep declarations for one cohesive type or operation together.
When a type is the primary abstraction, keep its declarations in one cluster:
the type declaration, its constructors, then its methods.
Order constructors and methods for readability within their part of the cluster.
Request and result types may appear immediately before the method they frame
inside that receiver's cluster.
Methods on one receiver share its state and invariants.
Keeping those methods together lets the reader retain that mental model.
Do not interleave methods from different receiver types
unless the reader's task genuinely treats those types as one operation
and separate clusters would make that operation harder to understand.

## File organization

Organize files within a package by domain responsibility,
not by declaration kind.
A file should contain a concept and the behavior that makes the concept useful.
Keep a type near its constructors,
methods,
private interfaces,
and closely related helpers.

Avoid package layouts that collect every type,
service,
constant,
or command implementation into a declaration-kind file.
Such files separate concepts from their behavior
and make readers reconstruct relationships across the package.
Apply the same rule to adapter and command packages;
they are not exempt because their code sits near an entry point.

Create a shared file only when its contents are genuinely package-wide.
Dependencies or helpers used by one abstraction belong with that abstraction.
When splitting a file,
choose boundaries that let each resulting file explain a coherent part of the
package rather than targeting a particular line count.

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
See [Iteration and streaming](#iteration-and-streaming)
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

## Collection operations

Copy a map or slice before changing a result that must not affect its input.
The standard helpers also make merges clear:

```go
mapCopy := maps.Clone(original)
sliceCopy := slices.Clone(input)
maps.Copy(destination, overrides)
names := slices.Compact(slices.Clone(sortedNames))
```

`maps.Copy` merges into an initialized destination map
and overwrites matching keys.
`slices.Compact` changes its slice and removes consecutive duplicates only.
`maps.Clone` and `slices.Clone` preserve nil inputs
and copy keys or elements by assignment, not recursively.
Clone nested mutable values separately when they must be independent.

Use [maps](https://pkg.go.dev/maps) and [slices](https://pkg.go.dev/slices)
for ordinary deletion and equality;
`slices` also covers membership and sorting.

## Iteration and streaming

`iter.Seq[V]` yields one value at a time;
`iter.Seq2[K, V]` yields a pair, such as a key and value or a value and error.

### Memory and storage

Streaming lets producers and consumers process data incrementally
without holding the entire input or intermediate results in memory.
Read, transform, and consume values as they arrive,
retaining only the current values and the state the operation needs.
For filtering, counting, or writing, memory can stay bounded as input grows.
That bound depends on record sizes, source buffers, batches,
and anything the consumer retains.
Aggregation may need growing state, such as one count per distinct key.

Preserve incremental processing throughout the pipeline:
a producer that loads the whole input before yielding still retains that input.
Likewise, `slices.Values`, `slices.All`, `maps.Keys`, `maps.Values`,
and `maps.All` expose sequences over existing collections;
they avoid an additional collection while keeping the source storage alive.
Use them at sequence API boundaries.
A slice or map already supports direct ranging in local code.

Materialize at the boundary that needs stored results:
random access, an owned snapshot, repeated passes over a single-use source,
or sorting unsorted data.
Use `slices.Collect`, `maps.Collect`, or `maps.Insert` for those boundaries.
Feed an API that supports batching with bounded batches,
and bound any outstanding batches it retains.
For sorted map keys, `slices.Sorted(maps.Keys(m))` collects and sorts them;
range over the map directly when order does not matter.
Map iteration order is unspecified.

### Producing and consuming values

Return a sequence from a traversal or transformation
so callers can filter, transform, count, write, or stop after enough results
without collecting the values first.
Keep reads and transformations inside the iterator function.
The producer must stop as soon as `yield` returns false,
including through nested loops and adapters:

```go
func Active(records iter.Seq[Record]) iter.Seq[Record] {
	return func(yield func(Record) bool) {
		for record := range records {
			if record.Active && !yield(record) {
				return
			}
		}
	}
}

for record := range Active(store.Records()) {
	if err := writeRecord(w, record); err != nil {
		return fmt.Errorf("write record: %w", err)
	}
}
```

Breaking or returning from the consumer loop stops the upstream sequence.

For a fallible producer, `iter.Seq2[Record, error]` carries values and errors.
Check each yielded error
and apply [Wrapping errors](#wrapping-errors) at the consumer
as at an ordinary call site.
Yield a terminal read error once, then end the sequence.
An iterator that owns a resource should acquire it inside the iterator function
and defer cleanup there, so an early `break` or `return` also releases it.
Document whether a sequence can be traversed again;
streams that cannot be rewound are single-use.

### Pulling values

Use `iter.Pull` or `iter.Pull2` when the consumer must control
when to advance a sequence, such as when pairing two streams.
They return `next` and `stop` functions:

```go
next, stop := iter.Pull(seq)
defer stop()
value, ok := next()
```

`Pull2` returns two values and `ok` from `next`.
Defer `stop()` immediately so early exits release the producer.
Ordinary `for range` consumption does not need `Pull`.
See [iter](https://pkg.go.dev/iter) for the sequence and pull contracts.

## Strings and bytes

Use `strings.Cut` or `bytes.Cut` to split around the first separator,
and `CutLast` to split around the last separator.
These return the pieces and a `found` boolean,
avoiding index arithmetic and a separate missing-separator branch.

For line-, field-, or separator-delimited iteration,
`strings.Lines`, `strings.FieldsSeq`, and `strings.SplitSeq`
have corresponding `bytes` functions.
They yield one part at a time without collecting a slice first.
`Lines` keeps each line's terminating newline.
`Lines` and `SplitSeq` return single-use iterators;
call the function again for another pass.
Use `Split` or `Fields` when a slice is the desired result.

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

## JSON

Use `encoding/json/v2` for new JSON code.
Its `Marshal` and `Unmarshal` functions accept options,
and `MarshalWrite` and `UnmarshalRead` work directly with writers and readers.
The v2 defaults reject duplicate object names and invalid UTF-8.
They also encode nil maps and slices as empty objects and arrays,
so preserve an existing wire contract deliberately when changing established code.

```go
import "encoding/json/v2"

data, err := json.Marshal(record)
if err != nil {
	return fmt.Errorf("marshal record: %w", err)
}
if err := json.Unmarshal(data, &decoded); err != nil {
	return fmt.Errorf("unmarshal record: %w", err)
}
```

For a field whose zero value should be absent from JSON,
use `omitzero` instead of a custom marshaler or `omitempty`.
Unlike `omitempty`, it omits a zero `time.Time`:

```go
type Event struct {
	At time.Time `json:"at,omitzero"`
}
```

See [JSON v2](https://pkg.go.dev/encoding/json/v2)
for options and representation details.

## Identifiers and random text

Use the standard `uuid` package to generate and parse UUIDs.
`uuid.New()` selects a suitable default algorithm;
use `uuid.NewV4()` or `uuid.NewV7()` when the UUID version is part of a contract.
`uuid.Parse` validates an incoming UUID string.
An existing third-party UUID type may still be required by an established API.

Use `crypto/rand.Text()` for an opaque secret string or token
when its base32 alphabet and variable length fit the contract.
It supplies at least 128 bits of randomness.
Do not substitute it for a UUID or a token with a required format.

## Filesystem boundaries

`os.OpenRoot` opens a directory for operations confined to it.
Use its `os.Root` methods for paths supplied from outside the trust boundary;
they reject paths that escape the root through `..` or symbolic links.
String prefix checks on cleaned paths do not provide that guarantee.

```go
root, err := os.OpenRoot(baseDir)
if err != nil {
	return fmt.Errorf("open root %q: %w", baseDir, err)
}
defer root.Close()

file, err := root.Open(name)
if err != nil {
	return fmt.Errorf("open %q: %w", name, err)
}
defer file.Close()
```

## HTTP routing

`http.ServeMux` accepts method and path-wildcard patterns.
Read a matched segment with `r.PathValue`:

```go
mux.HandleFunc("GET /items/{id}", func(w http.ResponseWriter, r *http.Request) {
	serveItem(w, r, r.PathValue("id"))
})
```

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

Give each type one sharing model.
Use pointers for objects with identity,
owned resources or state,
or values that should not be freely copied.
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

## Goroutines

`sync.WaitGroup.Go` starts a goroutine and accounts for its completion:

```go
var group sync.WaitGroup
group.Go(work)
group.Wait()
```

This replaces the usual `Add(1)`, `go`, and deferred `Done` sequence.
The function passed to `Go` must not panic.
It does not return errors; use an error-aware group when failures
must be collected or cancel sibling work.

## Testing

### Context

Use `t.Context()` instead of `context.Background()`.
It is canceled just before `t.Cleanup` runs,
so cleanup can wait for background work that observes cancellation.

```go
// BAD
ctx := context.Background()
client := newClient(ctx)

// GOOD
ctx := t.Context()
client := newClient(ctx)
```

### Assertions

Prefer `github.com/stretchr/testify/assert`
and `github.com/stretchr/testify/require`
unless the project already uses a different library.

Use `require` when a failure
makes subsequent checks meaningless —
typically nil-checks on errors or returned values.
Use `assert` for everything else
so the test reports as many failures as possible
in one run.

Always call the top-level package functions.
Never create assertion objects with `require.New`
or `assert.New`;
they obscure which assertion triggered a fatal stop.

```go
// BAD
assert := require.New(t)
assert.NoError(err)
assert.Equal("alice", user.Name)

// GOOD
require.NoError(t, err)
assert.Equal(t, "alice", user.Name)
```

### Resource cleanup

Register teardown with `t.Cleanup`
instead of deferring in the test body.
Use `t.TempDir()` instead of `os.MkdirTemp`;
the directory is removed automatically
when the test ends.

```go
// BAD
dir, err := os.MkdirTemp("", "data")
require.NoError(t, err)
defer os.RemoveAll(dir)

// GOOD
dir := t.TempDir()
```

### Naming

Top-level symbols use `Test{Name}`:

```go
func TestNewUser(t *testing.T)
```

Methods use `Test{Type}_{Method}`:

```go
func TestUser_IsValid(t *testing.T)
```

Scenarios append a lowercase description
after an underscore:

```go
func TestNewUser_emptyInput(t *testing.T)
func TestUser_IsValid_emptyUsername(t *testing.T)
```

Table test case names use GoCase
starting with uppercase.
Keep them descriptive but concise — not sentences.

```go
// BAD
{name: "it should fail when input is empty"}

// GOOD
{name: "EmptyInput"}
```

### File ordering

1. `TestMain`, if present.
2. Test functions,
   grouped by the symbol they cover.
3. New tests go below existing ones
   in the same group.
4. Helpers and types, always at the bottom.

### Inline single-use variables

Inline a variable that is used only once.
If inlining makes the expression
too long or hard to read,
keep a well-named variable instead.

```go
// BAD
wantName := "alice"
assert.Equal(t, wantName, user.Name)

// GOOD
assert.Equal(t, "alice", user.Name)
```

### Async tests

When testing asynchronous behavior,
prefer deterministic synchronization,
explicit signals,
or direct state assertions over unconditional waiting.
Avoid assertions such as `require.Never`
when their main effect is to make the test sleep.

This applies to concurrency tests,
event-delivery tests,
absence-of-event tests,
and background-worker tests.
Use a real-time check only when no deterministic signal
or virtual-time test is practical.

For behavior driven by timers or deadlines,
`testing/synctest.Test` provides a bubble with virtual time.
Create the timers and goroutines inside the bubble;
`synctest.Wait` lets their activity settle before an assertion.
`synctest.Sleep(d)` advances virtual time by `d`
and then waits for activity at that time to settle.
This is suitable for boundary assertions without real sleeping:

```go
func TestReadyAfterDelay(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		var ready atomic.Bool
		time.AfterFunc(10*time.Second, func() { ready.Store(true) })

		synctest.Sleep(10*time.Second - time.Nanosecond)
		assert.False(t, ready.Load())
		synctest.Sleep(time.Nanosecond)
		assert.True(t, ready.Load())
	})
}
```

The bubble cannot make external I/O or unrelated goroutines deterministic.
Use explicit signals for those boundaries.

### HTTP tests

`httptest.NewTestServer(t, handler)` serves requests on an in-memory network
and registers server cleanup with the test.
Its `server.Client()` routes requests to that server without a TCP port,
including requests made inside a `synctest` bubble.
Call `Start` only when a real loopback listener is needed.

### Benchmarks

Use `for b.Loop() { ... }` for benchmark iterations.
It keeps call arguments and results in the measured body alive,
so the compiler cannot eliminate the operation being measured.
Put reusable setup before the loop and cleanup after it.

### Test-only API surface

When adding tests,
exercise realistic production behavior before adding test-only API surface.
Do not export methods or add public-looking helpers solely for tests
unless the seam protects a production invariant
and the code documents why that seam exists.

Prefer tests that drive the same behavior a real caller uses.
If a test needs a seam,
keep the seam minimal,
name it honestly,
and make the production reason visible to future maintainers.

### Table tests

Use table tests when every case follows the same logic
with no complex branching, setup, or teardown.

Name the slice `tests`.
Each entry has a `name` field in GoCase.
Name input fields `give` (or `giveFoo`, `giveBar`),
and output fields `want` (or `wantFoo`, `wantBar`).
If data does not map to inputs or outputs,
name fields after what they represent.
Never use `inputFoo`, `expectedBar`, or similar.

Iterate with `for _, tt := range tests`
and call `t.Run(tt.name, ...)`.

```go
// BAD
tests := []struct {
	name      string
	inputName string
	expected  string
}{
	{name: "valid", inputName: "alice", expected: "ALICE"},
}

// GOOD
tests := []struct {
	name string
	give string
	want string
}{
	{name: "Valid", give: "alice", want: "ALICE"},
}
for _, tt := range tests {
	t.Run(tt.name, func(t *testing.T) {
		got := strings.ToUpper(tt.give)
		assert.Equal(t, tt.want, got)
	})
}
```

Never put function fields like `setupMocks`,
`runTest`, or `assertResult` in the test struct.
Function fields hide control flow
and make tables harder to read.

When cases need different setup, teardown,
or assertion logic,
use explicit `t.Run` subtests instead of a table.
Tables are for uniform structure only.

```go
// BAD — function field in table
tests := []struct {
	name  string
	setup func()
}{...}

// GOOD — separate subtests for divergent logic
t.Run("WithCache", func(t *testing.T) {
	cache := newCache(t)
	// ...
})
t.Run("WithoutCache", func(t *testing.T) {
	// ...
})
```

## Tests

When changing this guidance,
read [tests/README.md](tests/README.md).
Run the relevant [Go scenarios](tests/scenarios/go.md)
with fresh subagents that have empty context windows.
