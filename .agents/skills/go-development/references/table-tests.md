# Table tests

Use descriptive, concise GoCase names beginning uppercase, not sentences:

```go
// BAD
{name: "it should fail when input is empty"}

// GOOD
{name: "EmptyInput"}
```

Use tables only for uniform logic without complex branching, setup, or teardown.
Name the slice `tests` and give each entry a GoCase `name` field.
Iterate with `for _, tt := range tests` and call `t.Run(tt.name, ...)`.
Inputs use `give` or `giveFoo`, `giveBar`; outputs use `want` or `wantFoo`, `wantBar`.
Name other data for its meaning; never use `inputFoo`, `expectedBar`, or similar.

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

Never put function fields such as `setupMocks`, `runTest`, or `assertResult` in cases;
they hide control flow.
Use explicit `t.Run` subtests when setup, teardown, or assertion logic differs:

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
