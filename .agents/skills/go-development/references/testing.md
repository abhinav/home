# Testing

## Context

Use `t.Context()` rather than `context.Background()`.
It is canceled just before registered `t.Cleanup` callbacks run,
so cleanup can wait for background work observing cancellation.

```go
// BAD
ctx := context.Background()
client := newClient(ctx)

// GOOD
ctx := t.Context()
client := newClient(ctx)
```

## Assertions

Prefer `github.com/stretchr/testify/assert` and `github.com/stretchr/testify/require`
unless the project already uses a different library.
Use `require` when failure makes subsequent checks meaningless,
typically nil-checks of errors or returned values.
Use `assert` otherwise to report as many failures as possible.
Always use top-level functions, never `require.New` or `assert.New` objects,
which obscure fatal stops.

```go
// BAD
assert := require.New(t)
assert.NoError(err)
assert.Equal("alice", user.Name)

// GOOD
require.NoError(t, err)
assert.Equal(t, "alice", user.Name)
```

## Resource cleanup

Register teardown with `t.Cleanup`, not test-body defers.
Use automatically removed `t.TempDir()` rather than `os.MkdirTemp`:

```go
// BAD
dir, err := os.MkdirTemp("", "data")
require.NoError(t, err)
defer os.RemoveAll(dir)

// GOOD
dir := t.TempDir()
```

## Naming

Top-level symbols use `Test{Name}`:

```go
func TestNewUser(t *testing.T)
```

Methods use `Test{Type}_{Method}`:

```go
func TestUser_IsValid(t *testing.T)
```

Append lowercase scenarios after an underscore:

```go
func TestNewUser_emptyInput(t *testing.T)
func TestUser_IsValid_emptyUsername(t *testing.T)
```

## Executable examples

Use `Example...` for useful self-contained caller demonstrations with small, clear setup.
Prefer ordinary tests for substantial fixtures, services, or setup obscuring the lesson.
Do not add examples merely to duplicate coverage.
Place them in `_test.go`, usually external `package name_test` for public API usage;
name them for the documented package, function, type, or method:

```go
func ExampleClient_Get() {
	// Demonstrate a self-contained use of Client.Get.
}
```

Without output comments, examples compile but do not run.
Add `// Output:` and expected output when deterministic output makes a useful check.
Run `go test`; see [Examples](https://pkg.go.dev/testing#hdr-Examples) for naming and output rules.

## File ordering

Put `TestMain` first if present, then tests grouped by covered symbol.
Append new tests below existing tests in their group; keep helpers and types always last.

## Inline single-use variables

Inline single-use variables unless the expression becomes too long or hard to read;
keep a well-named variable in that case.

```go
// BAD
wantName := "alice"
assert.Equal(t, wantName, user.Name)

// GOOD
assert.Equal(t, "alice", user.Name)
```

## Test-only API surface

Exercise realistic production behavior before adding test-only API surface.
Do not export methods or add public-looking helpers solely for tests unless the seam
protects a production invariant and code documents why it exists.
Prefer real-caller behavior; necessary seams must be minimal, honestly named,
and expose their production reason to future maintainers.
