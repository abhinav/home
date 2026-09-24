# Table tests

Table test case names use GoCase
starting with uppercase.
Keep them descriptive but concise — not sentences.

```go
// BAD
{name: "it should fail when input is empty"}

// GOOD
{name: "EmptyInput"}
```

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
