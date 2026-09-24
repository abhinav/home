# Go development scenarios

## Select Go development for Go-specific work

### Prompt

Available skills:

- `go-development`: `{GUIDANCE_DESCRIPTION}`
- `code-design`: Use when changing code ownership, boundaries, contracts,
  or representations.
- `code-readability`: Use when changing or reviewing the representation of
  non-generated code for maintainers.
- `code-testing`: Use when deciding what test evidence a code change needs
  or changing tests.

A user asks you to revise Go code that introduces a package-level worker type,
changes its construction API,
and updates its tests.

Choose the skill or skills you would load before acting.
Explain the responsibility of each selection.
Do not revise code or modify files.

### Expected behavior

- Select `go-development` for the Go-specific language, API, and test choices.
- Select the applicable general code skills for their separate responsibilities.
- Do not treat `go-development` as a substitute for design, readability,
  or testing guidance.

### Adjacent valid case

#### Prompt addition

Instead,
the user asks for an operational incident summary.
The affected service happens to be implemented in Go,
but the task includes no Go code,
compiler behavior,
module decision,
test artifact,
or Go-specific diagnosis.

#### Expected behavior

- Do not select `go-development` merely because Go is incidental context.

## Keep behavioral objects pointer-oriented

### Prompt

Use the `go-development` skill and apply it to the task below.
Do not modify files or external state.

Sketch the public and internal Go API for a package that dispatches messages.
The package needs a `MessageDispatcher` configured with a `Sender`
and an `Encoder`.
It has a `Preview(Message) ([]byte, error)` operation
and a `Dispatch(context.Context, Message) error` operation.
`Dispatch` encodes and sends the message;
`Preview` only returns the encoded bytes.
The type does not need to reassign its configuration after construction.

Show the type, construction API, method signatures,
one representative function that accepts a dispatcher,
and one representative collection of dispatchers.
Omit method bodies.
Briefly explain material API choices.

### Expectations

- Treat `MessageDispatcher` as a pointer-oriented object
  because it owns collaborators and exposes operations through them.
- Use pointer receivers and carry that model through construction,
  concrete parameters, and collection elements.
- Do not infer value semantics from the struct's size,
  stable fields, or mechanically cheap copies of interface values.
- Apply the constructor guidance independently;
  direct initialization remains valid when construction only assigns fields.

### Adjacent valid case

Instead, sketch the API for an `Interval` with `Start` and `End` times.
Callers compare intervals by their contents,
freely copy them,
and expect `Shift(time.Duration) Interval`
to leave the original unchanged.
Also include `Contains(time.Time) bool`,
one function that accepts an interval,
and one collection of intervals.

- Use value receivers, value parameters, value results,
  and value collection elements.
- Preserve value semantics even though the type exposes several methods.
- Do not generalize the pointer default into a ban on rich value types.

## Name declarations for their scope

### Prompt

Use the `go-development` skill and apply it to the task below.
Do not modify files or external state.

Sketch declarations for additions to an established `catalog` package
with more than twenty package-level types.
The additions need:

- an unexported type holding transient state while decoding a supplier feed;
- an unexported type representing the comparison
  between incoming and stored records;
- an unexported type recording why one catalog update failed;
- an unexported worker object that owns a `Store` and `Clock`;
- a package-level metric counter for failed catalog updates; and
- a narrow helper whose locals represent its state and result.

Show representative declarations and signatures,
not complete method bodies.
Name every declaration idiomatically and explain the naming choices briefly.

### Expectations

- Give package-level types enough domain and role context
  to distinguish them from the package's other declarations.
- Give the package-level metric a name that identifies
  the counted event and the metric role.
- Keep narrow local names such as `state` and `result` concise.
- Do not justify a generic package-level name
  merely because its type or surrounding file supplies context.
- Do not add empty qualifiers such as `global`, `private`, or `internal`.

### Adjacent valid case

Instead, sketch a small `scanner` package
with one unexported cursor type and one narrow scanning helper.
The package has four package-level declarations.

- Permit a compact package-level name such as `cursor`
  when it denotes the package's one unambiguous cursor role.
- Permit a small role qualifier such as `scanCursor`
  when it leaves `cursor` available as a natural parameter name.
- Do not require a redundant package-name prefix such as `scannerCursor`.
- Keep narrow locals such as `r` and `result` concise.

## Change modules through Go commands

### Prompt

Use the `go-development` skill.
Do not modify files.

A Go module must change its declared Go version to 1.26,
add `example.com/tools/schema` as a command dependency at `v1.4.0`,
and update `example.com/client` to `v2.3.1`.
The user also wants to inspect the downloaded client source
before deciding whether to retain that version.

Give the command sequence and the validation you would perform.

### Expected behavior

- Use Go commands rather than editing `go.mod` by hand.
- Use `go get go@1.26` for the declared Go version.
- Use `go get -tool example.com/tools/schema@v1.4.0`
  for the command dependency.
- Use `go mod download -json example.com/client@v2.3.1`
  and inspect the returned `Dir` before selecting the version.
- Use `go get example.com/client@v2.3.1` only after the source is accepted.
- Run `go mod tidy`, inspect `go.mod` and `go.sum`,
  and run the relevant tests.

## Test timer behavior with virtual time

### Prompt

Use the `go-development` and `code-testing` skills.
Do not modify files.

Sketch a Go test for a worker that marks itself ready
after a ten-second timer.
The test must establish that readiness remains false
one nanosecond before the deadline
and becomes true at the deadline.
Show context setup, synchronization, and assertions.
Avoid real-time waiting.

### Expected behavior

- Create the timer and goroutine inside `testing/synctest.Test`.
- Use `t.Context()` for test-scoped context.
- Use `synctest.Wait` or another deterministic signal
  to establish that the worker reached the timer.
- Advance virtual time to each boundary with `synctest.Sleep`.
- Use top-level assertion functions rather than assertion objects.
- Do not use a real sleep to prove the timing boundary.

## Reach the reference that governs the task

Run each row as a separate case with a fresh runner.

### Prompt

Use the `go-development` skill for the Go-specific task below.
Do not modify files or external state.

{TASK}

Give a concise recommendation with the relevant Go shape or commands.

### Cases

- `modules-and-dependencies.md`:
  Change a module's Go version,
  add a tool dependency,
  and inspect a downloaded dependency before selecting it.
- `source-organization.md`:
  Organize imports,
  package-level names,
  declaration order,
  and files for a new package abstraction.
- `errors-and-diagnostics.md`:
  Replace `log.Fatal` in a helper
  and add useful context when returning its error.
- `interfaces.md`:
  Design a consumer-owned interface
  and verify implementation compliance.
- `signatures-and-construction.md`:
  Design a constructor and parameter object for an exported API.
- `map-and-boolean-apis.md`:
  Choose between a map or named records,
  and between a boolean or named mode for an exported API.
- `type-semantics.md`:
  Choose pointer or value semantics for an object
  and parse its external identifier at the boundary.
- `collections-and-iteration.md`:
  Stream fallible records from a map-backed store
  without retaining the full result.
- `context-and-concurrency.md`:
  Propagate context into concurrent work
  and wait for all goroutines to finish.
- `json.md`:
  Define a JSON record with an omitted zero `time.Time`
  and encode it to a writer.
- `identifiers-and-randomness.md`:
  Choose representations for a UUID and an opaque random token.
- `filesystem.md`:
  Open a user-supplied path
  while confining access to a configured directory.
- `http.md`:
  Register a method-specific route with a path parameter
  and read that parameter.
- `testing.md`:
  Choose assertions, test context, and resource cleanup for a unit test.
- `async-tests.md`:
  Test timer behavior without real waiting.
- `http-tests.md`:
  Test an HTTP handler with a client and server.
- `benchmarks.md`:
  Add a benchmark for an operation.
- `table-tests.md`:
  Choose a structure and names for uniform test cases.

### Expected behavior

- Read `go-development` and the reference named for the case.
- Base the recommendation on the rule in that reference.
- Do not read unrelated references merely to survey the skill package.
- Verify reference access from the runner's file-access trace,
  not from a claim in its response.
