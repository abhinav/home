# Go

- [Viewing dependency source](#viewing-dependency-source)
- [Context usage](#context-usage)
- [Import aliases](#import-aliases)
- [Program exits](#program-exits)
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
- [Parse, don't repeatedly validate](#parse-dont-repeatedly-validate)
- [Enums](#enums)
- [Pointers and values](#pointers-and-values)
- [Avoid boolean API knobs](#avoid-boolean-api-knobs)
- [Testing](#testing)
  - [Context](#context)
  - [Assertions](#assertions)
  - [Resource cleanup](#resource-cleanup)
  - [Naming](#naming)
  - [File ordering](#file-ordering)
  - [Inline single-use variables](#inline-single-use-variables)
  - [Async tests](#async-tests)
  - [Test-only API surface](#test-only-api-surface)
  - [Table tests](#table-tests)

## Viewing dependency source

To see source files from a Go dependency,
or to answer questions about a dependency,
run `go mod download -json MODULE`
and use the returned `Dir` path to read the files.

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

Add compile-time assertions
to verify that a type implements an interface:

```go
var _ InterfaceName = (*TypeName)(nil)
```

Skip this when the type or the interface
can't be imported into the same file.

```go
// BAD: no compile-time check.
// A method signature typo won't be caught
// until the value is used as the interface.
type Handler struct{}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {}

// GOOD: the compiler rejects this immediately
// if *Handler doesn't satisfy http.Handler.
var _ http.Handler = (*Handler)(nil)

type Handler struct{}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {}
```

## Symbol ordering

Order Go symbols by narrative dependency,
not by declaration kind.

A reader should encounter a symbol close to the code
that first makes it useful.
Avoid collecting all constants,
variables,
types,
interfaces,
or helper functions at the top of the file
unless they are genuinely file-wide concepts.

Use this order of preference:

1. Package-wide constants and variables
   that configure the whole file
   may appear near the top.
2. Type blocks should stay intact:
   declaration,
   constructors,
   then methods.
   A type block may move close to the behavior it supports,
   but do not split the declaration from its constructors or methods.
3. Types,
   interfaces,
   and helper constants used by one function
   should be placed near that function.
   If the type is a request,
   result,
   or other function-boundary concept,
   place the type block immediately before the function.
   If the type is helper machinery used inside the function,
   place the type block immediately after the function.
4. Types,
   interfaces,
   and helper constants used by a cohesive group of functions
   should be placed near that group.
   Put boundary concepts before the first function in the group.
   Put helper machinery after the last function in the group.
5. Helper functions should usually appear after the function that calls them,
   unless moving them earlier substantially improves readability.
6. In tests,
   helper functions and helper types should appear after the test
   that uses them.
   If a helper is shared by multiple tests,
   place it after the last test that uses it.
7. Exported package concepts should appear before the exported functions
   that introduce or operate on them,
   but they still do not need to be grouped at the top by kind.

Do not split a function's request/result structs,
small enums,
private interfaces,
or helper types into a top-of-file type block
unless they are used throughout the file.
Keep each type block intact.
Move the whole block to the narrowest useful location:
boundary types before the function or group they describe,
helper types after the function or group they support.

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
type ExportRequest struct {
    Path   string
    Format ExportFormat
}

type ExportResult struct {
    BytesWritten int64
    Warnings     []string
}

func Export(ctx context.Context, req ExportRequest) (ExportResult, error) {
    ...
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
type IndexerConfig struct {
    Store IndexStore   // required
    Log   *slog.Logger // required

    BatchSize int
}

func NewIndexer(cfg IndexerConfig) *Indexer {
    ...
}
```

Use a configuration struct when construction has several required inputs
or when the input set is likely to grow.
Mark required configuration fields with an inline `// required` comment.

A constructor may instead accept up to two required positional arguments
followed by an options struct containing only optional fields:

```go
type PublisherOptions struct {
    BatchSize int
}

func NewPublisher(
    store PublishStore,
    log *slog.Logger,
    opts *PublisherOptions,
) *Publisher {
    ...
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

Prefer a named struct
and accept or return a slice of those structs.
Use a map inside the function
when you need fast lookup, grouping, or uniqueness checks.

```go
// BAD: the two strings have no visible meaning at the call boundary.
func SyncEndpoints(endpoints map[string]string) error { ... }

// GOOD: the boundary names the data being passed.
type EndpointSync struct {
    Source string
    Target string
}

func SyncEndpoints(endpoints []EndpointSync) error { ... }
```

Nested maps deserve extra scrutiny.
They often indicate that a small domain type
would make the code easier to understand and safer to change.

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

## Testing

### Context

Use `t.Context()` instead of `context.Background()`.
It returns a context that is canceled when the test ends,
which catches code that outlives the test.

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
Use a time-based check only when no deterministic signal is practical.

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
