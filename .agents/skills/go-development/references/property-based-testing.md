# Property-based tests and fuzzing

Use `code-testing` to choose the missing evidence, domain, and independent oracle.
Keep a suitable existing integration; a useful new property does not justify
replacing the project's test framework.
For a new integration, match the input model and run mode:

- [Rapid](https://pkg.go.dev/pgregory.net/rapid) supplies typed generators,
  shrinking, and replay within ordinary `go test` runs.
  It is a compact choice for structured values and operation histories.
- [Hegel](https://pkg.go.dev/hegel.dev/go/hegel) also generates and shrinks cases
  during ordinary tests, using the Hegel engine shared across language bindings.
  Consider it when that engine or an existing Hegel convention is useful.
- [Go fuzzing](https://go.dev/doc/security/fuzz/) supplies coverage-guided search
  and a persistent corpus without another testing engine dependency.
  Its target parameters are bytes, strings, and supported scalar types;
  structured domains need an adapter.

Choose dependency versions compatible with the module's supported Go version.
Use the package documentation for that selected release.
The examples below are alternatives for `LowerBound(xs []int, key int) int`,
which accepts sorted input and returns the first index with value at least key,
or the slice length.
Counting smaller values checks this contract independently of binary search.
Small value ranges encourage duplicates; length caps bound test work.
Keep fixed examples for important boundaries and broader integer limits.

## Rapid

Add `pgregory.net/rapid` through the normal module workflow.
In a `_test.go` file, import `slices`, `testing`, `pgregory.net/rapid`,
and `github.com/stretchr/testify/assert` under the usual assertion convention.

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

Run with `go test ./...` (`-count=1` forces a new run when Go could reuse a result).
Use the callback's `*rapid.T` for draws, assertions, and case cleanup;
reporting through the enclosing `*testing.T` bypasses the property runner.
[Rapid's `MakeFuzz`](https://pkg.go.dev/pgregory.net/rapid#MakeFuzz)
can adapt the same generator-based property to `f.Fuzz` when coverage-guided
search is useful; it still needs a fuzzing invocation to search fresh inputs.

## Hegel

Add `hegel.dev/go/hegel` and import it as `hegel`.
The current binding runs a native engine in the test process,
with supported binaries bundled in the module and loaded through the user cache.
Check the selected release's [test setup](https://github.com/hegeldev/hegel-go#installation)
and [compatibility](https://hegel.dev/compatibility)
against local and CI platforms before choosing it.
Hegel is currently in beta, so verify APIs against the selected release.

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

Run with `go test ./...`.
Report failures through the callback's `*hegel.T` so shrinking and replay
remain under Hegel's control.

## Go native fuzzing

A semantic assertion works inside a native fuzz target too.
This adapter explores at most 100 signed-byte values;
it covers a useful subset of the integer contract, not every integer input.
Use a richer adapter or typed generator when that restriction misses the risk.

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

`go test ./...` replays seeds, including committed files in
`testdata/fuzz/FuzzLowerBound`; it does not start mutation.
From this package, run a bounded campaign with:

```sh
go test -fuzz='^FuzzLowerBound$' -fuzztime=10s .
```

Keep minimized failures as durable regressions.
Use a property runner in the ordinary suite when fresh structured generation
is needed there and a separate fuzzing campaign would not run.
