# Go

- [Viewing dependency source](#viewing-dependency-source)
- [Context usage](#context-usage)
- [Program exits](#program-exits)
- [Error handling](#error-handling)
  - [Formatting variable values](#formatting-variable-values)
  - [Wrapping errors](#wrapping-errors)
- [Interface compliance checks](#interface-compliance-checks)
- [Symbol ordering](#symbol-ordering)
- [Parameter and result objects](#parameter-and-result-objects)
- [Accept interfaces, return structs](#accept-interfaces-return-structs)
- [Map-shaped APIs](#map-shaped-apis)
- [Parse, don't repeatedly validate](#parse-dont-repeatedly-validate)
- [Avoid boolean API knobs](#avoid-boolean-api-knobs)
- [Testing](#testing)
  - [Context](#context)
  - [Assertions](#assertions)
  - [Resource cleanup](#resource-cleanup)
  - [Naming](#naming)
  - [File ordering](#file-ordering)
  - [Inline single-use variables](#inline-single-use-variables)
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
Choose field types so the zero value preserves existing behavior
or maps to a clear default.

## Accept interfaces, return structs

Prefer accepting interfaces
and returning concrete structs.

When a function consumes a dependency,
accept the smallest interface that describes what it needs.
This lets callers provide real implementations,
test doubles,
or wrappers without forcing a specific concrete type.

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
