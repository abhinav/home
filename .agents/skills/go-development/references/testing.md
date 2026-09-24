# Testing

## Context

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

## Assertions

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

## Resource cleanup

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

## Naming

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

## Executable examples

Use `Example...` functions when a self-contained demonstration helps callers
and the setup stays small enough that the operation remains clear.
This is typically a good fit for self-contained packages.
Prefer ordinary tests when a standalone example would need substantial fixtures,
external services, or setup that obscures the lesson.
Do not add examples merely to duplicate existing test coverage.

Put examples in a `_test.go` file, usually in the external `package name_test`,
so they demonstrate the public API available to callers.
Name them for the documented package, function, type, or method:

```go
func ExampleClient_Get() {
	// Demonstrate a self-contained use of Client.Get.
}
```

An example without an output comment is compiled but not run.
Add `// Output:` and the expected output when deterministic output
makes the demonstration a useful executable check.
Run `go test` to check the example alongside the package's tests.
See [Examples](https://pkg.go.dev/testing#hdr-Examples) for naming and output rules.

## File ordering

1. `TestMain`, if present.
2. Test functions,
   grouped by the symbol they cover.
3. New tests go below existing ones
   in the same group.
4. Helpers and types, always at the bottom.

## Inline single-use variables

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

## Test-only API surface

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
