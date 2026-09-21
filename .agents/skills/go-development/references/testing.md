# Testing

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
