# Property-based tests and fuzzing

Use `code-testing` to choose missing evidence, domain, and independent oracle.
Keep suitable existing integrations; a new property does not justify replacing the framework.
For new integrations, match input model and run mode:

- [Rapid](https://pkg.go.dev/pgregory.net/rapid): typed generation, shrinking,
  and replay in ordinary `go test`; a compact choice for structured values and histories.
- [Hegel](https://pkg.go.dev/hegel.dev/go/hegel): generation and shrinking in ordinary tests
  using the Hegel engine shared across language bindings;
  consider when that engine or convention helps.
- [Go fuzzing](https://go.dev/doc/security/fuzz/): coverage-guided search and persistent
  corpus without another engine dependency.
  Targets take bytes, strings, and supported scalars; structured domains need an adapter.

Choose versions compatible with the module's supported Go version
and read that release's documentation.
These alternatives test `LowerBound(xs []int, key int) int` on sorted inputs:
the first index whose value is at least `key`, or the slice length.
Counting smaller values is independent of binary search.
Small ranges encourage duplicates; length caps bound work.
Keep fixed examples for important boundaries and broader integer limits.

## Rapid

Add `pgregory.net/rapid` through the module workflow.
In `_test.go`, import `slices`, `testing`, `pgregory.net/rapid`, and Testify `assert`
under the usual assertion convention.

```go
func TestLowerBound_rapid(t *testing.T) {
	rapid.Check(t, func(t *rapid.T) {
		xs := rapid.SliceOfN(rapid.IntRange(-20, 20), 0, 100).Draw(t, "xs")
		key := rapid.IntRange(-21, 21).Draw(t, "key")
		slices.Sort(xs)
		want := 0
		for _, x := range xs {
			if x < key {
				want++
			}
		}
		assert.Equal(t, want, LowerBound(xs, key), "xs=%v key=%d", xs, key)
	})
}
```

Run `go test ./...`; `-count=1` forces a new run when caching is possible.
Use callback `*rapid.T` for draws, assertions, and case cleanup;
outer `*testing.T` reporting bypasses the runner.
[MakeFuzz](https://pkg.go.dev/pgregory.net/rapid#MakeFuzz) adapts generator properties
to `f.Fuzz` when coverage-guided search helps; fresh search still needs a fuzzing invocation.

## Hegel

Add `hegel.dev/go/hegel`, imported as `hegel`.
The current binding runs a native engine in-process, with bundled binaries loaded
through the user cache.
Check selected-release [setup](https://github.com/hegeldev/hegel-go#installation)
and [compatibility](https://hegel.dev/compatibility) for local and CI platforms before choosing.
Hegel is currently beta; verify APIs against the selected release.
With the same `slices`, `testing`, and `assert` imports:

```go
func TestLowerBound_hegel(t *testing.T) {
	hegel.Test(t, func(t *hegel.T) {
		xs := hegel.Draw(t, hegel.Lists(hegel.Integers(-20, 20)).MaxSize(100))
		key := hegel.Draw(t, hegel.Integers(-21, 21))
		slices.Sort(xs)
		want := 0
		for _, x := range xs {
			if x < key {
				want++
			}
		}
		assert.Equal(t, want, LowerBound(xs, key), "xs=%v key=%d", xs, key)
	})
}
```

Run `go test ./...`.
Report failures through the callback's `*hegel.T`
so shrinking and replay remain under Hegel's control.

## Go native fuzzing

This semantic adapter covers at most 100 signed-byte values,
a subset of the integer contract.
Choose richer adapters or typed generation if that misses the risk:

```go
func FuzzLowerBound(f *testing.F) {
	f.Add([]byte{255, 0, 0, 1}, int8(0))
	f.Add([]byte{}, int8(0))
	f.Fuzz(func(t *testing.T, data []byte, key int8) {
		xs := make([]int, min(len(data), 100))
		for i := range xs {
			xs[i] = int(int8(data[i]))
		}
		slices.Sort(xs)
		want := 0
		for _, x := range xs {
			if x < int(key) {
				want++
			}
		}
		assert.Equal(t, want, LowerBound(xs, int(key)), "xs=%v key=%d", xs, key)
	})
}
```

`go test ./...` replays seeds, including committed `testdata/fuzz/FuzzLowerBound` files;
it does not start mutation.
Run a bounded campaign from this package:

```sh
go test -fuzz='^FuzzLowerBound$' -fuzztime=10s .
```

Keep minimized failures as durable regressions.
Use an ordinary-suite property runner when fresh structured generation is needed there
and a separate fuzz campaign would not run.
