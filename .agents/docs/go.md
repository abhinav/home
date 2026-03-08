# Go

- [Viewing dependency source](#viewing-dependency-source)
- [Context usage](#context-usage)
- [Program exits](#program-exits)
- [Error handling](#error-handling)
  - [Formatting variable values](#formatting-variable-values)
  - [Wrapping errors](#wrapping-errors)
- [Interface compliance checks](#interface-compliance-checks)
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
Context should describe the action being performed
without "failed to" or "error doing" prefixes.
Each return site adds only its own local context,
not the overall function's operation.

```go
func ParseFile(path string) error {
	data, err := os.ReadFile(path)
	if err != nil {
		// BAD: duplicates the function's operation.
		return fmt.Errorf("parse file %q: read file: %w", path, err)

		// GOOD: describes only this call site's action.
		return fmt.Errorf("read file %q: %w", path, err)
	}

	if err := json.Unmarshal(data, &cfg); err != nil {
		return fmt.Errorf("unmarshal config: %w", err)
	}

	return nil
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
