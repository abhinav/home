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
- `subprocess-tests.md`:
  Test an adapter that invokes an external formatter
  without requiring that formatter to be installed.
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

## Choose an API for successive values

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A current-Go package has a draft helper:

```go
func (c *Catalog) Visit(visit func(Entry) error) error
```

It reads entries incrementally from an existing parser until EOF;
read failures are terminal.
A callback error means stop visiting.
Callers need to write selected entries, count matches, or return the first match.
The helper is new and has no compatibility obligations.
Review the helper's API before implementation
and show the API and a minimal caller you would retain.
Explain briefly.

### Expected behavior

- Reach `callbacks.md` from the skill router without being given its path.
- Follow its iteration pointer to `collections-and-iteration.md`.
- Return an `iter.Seq2[Entry, error]` and show ordinary loop control in the caller.
- Preserve incremental reads, terminal error delivery, and early stopping.
- Keep a consumer's own errors in the caller's control flow.

### Unacceptable behavior

- Retain the traversal callback solely because it can stop on an error.
- Collect the entire stream or use a sentinel error to return the first match.
- Infer reference access from the answer instead of checking the tool trace.

### Adjacent valid case

#### Prompt addition

For a separate helper, the parser cannot fail and yields one Entry per step.
Show the corresponding API shape too.

#### Expected behavior

- Use `iter.Seq[Entry]` for the infallible producer.
- Do not introduce an error result that the producer does not need.

## Preserve caller control over resource lifetime

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

Two current-Go build commands duplicate opening a scratch workspace
and releasing it after a sequence of steps.
Opening can fail; Release cannot fail.
The commands choose different steps and may return an error between steps.
Both currently open the workspace successfully, defer its Release,
and then perform their work.
Design a shared helper to remove the duplicated setup and cleanup,
and show how one command calls it.
No existing helper API is published.
Give your proposed API, a minimal caller snippet, and a brief rationale.

### Expected behavior

- Return an acquired resource with a cleanup method or cleanup function.
- Defer cleanup immediately after checking acquisition succeeded.
- Keep caller-selected steps and early returns outside a lifetime callback.
- Explain that a shared acquisition helper can preserve the short caller defer;
  removing every repeated statement is not the design goal.
- Read `signatures-and-construction.md` for resource lifetime mechanics.
- If considering a callback, reach `callbacks.md` before settling the API.

### Unacceptable behavior

- Introduce a `With` helper that accepts the command's work as a callback.
- Drop cleanup on an early return or defer cleanup before checking acquisition.

### Adjacent valid case

#### Prompt addition

A command processes many independent jobs in a loop.
Each job's workspace must be released before opening the next one.
Show where the deferred cleanup belongs.

#### Expected behavior

- Scope a function to one job and defer cleanup in that function.
- Do not retain every workspace until the outer loop's function returns.
- Do not introduce a lifetime callback to obtain the per-job scope.

## Keep behavior that the caller supplies

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A current-Go command has an in-memory `[]Build`.
Build has `Rank int` and `ID string`.
Sort ascending by Rank and break ties by ID.
Give the code you would introduce and briefly explain the choice of API.

### Expected behavior

- Reach `callbacks.md` when choosing to pass a comparison function.
- Keep a typed comparator with `slices.SortFunc` or another suitable sorting API.
- Compare Rank first, then ID, without integer subtraction overflow.
- Recognize that the comparison result determines ordering;
  repeated invocation does not make it a traversal callback.

### Unacceptable behavior

- Replace the comparator with an iterator or a resource-lifetime API.
- Treat all function parameters as prohibited.

## Avoid callback guidance for unrelated construction

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A current-Go package needs a constructor for an Indexer.
It requires an IndexStore and a Logger, validates their configuration,
and accepts an optional batch size.
Choose the constructor shape and show its configuration type.
Explain briefly.

### Expected behavior

- Reach `signatures-and-construction.md` and use its constructor guidance.
- Preserve required dependency markers and optional configuration defaults.
- Do not read `callbacks.md` merely because the task involves a function signature.

## Own background work and broadcast readiness

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A cache service starts workers for a caller-supplied list of keys.
Several consumers wait for the cache to finish initialization,
including consumers that may begin waiting after initialization completes.
Initialization can fail.
The service also emits a stream of refresh results.
Design its readiness signal and shutdown contract,
and explain how the amount of concurrent work is controlled.
Show the relevant Go shapes.

### Expected behavior

- Use closure for a permanent readiness notification without a payload,
  with one owner and a receive-only view for observers.
- Keep readiness success distinct from failure or cancellation.
- Use value delivery for repeated refresh results, not repeated channel closure.
- Identify who cancels background work and who waits for completion.
- Bound concurrent work independently of the number of supplied keys.
- Do not treat cancellation as proof of completion.

## Represent errors callers can handle

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A parser's caller needs to show the line and column of an invalid token.
A session caller needs to recognize that a session is closed.
An internal decoding failure only needs diagnostic context.
All three failures may pass through several wrappers.
Choose their error representations and show how callers inspect them
with the current Go standard library.

### Expected behavior

- Use a structured error for actionable coordinates,
  a sentinel for the closed-session condition,
  and an ordinary error for the diagnostic-only failure.
- Match through wrappers using `errors.Is` and `errors.AsType`.
- Preserve matching with `%w` or an appropriate custom `Unwrap` method.
- Do not match error text or rely on a direct type assertion.

### Adjacent valid case

#### Prompt addition

The package must also support Go 1.25.
Show the typed matching form for that support requirement.

#### Expected behavior

- Use `errors.As` instead of imposing a newer minimum Go version.

## Select subprocess behavior without changing the environment

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

An archive adapter invokes an external executable with `os/exec`.
Its tests need success output, rejected arguments, and a nonzero exit status
without installing that executable.
The adapter intentionally supplies a fixed child environment.
One caller allows command customization after creation;
another accepts only an executable path.
Design the test fixture for each caller,
including the test executable's entry point and dispatch.

### Expected behavior

- Reach `subprocess-tests.md` and use the real process boundary.
- Dispatch helper behavior from `filepath.Base(os.Args[0])` in `TestMain`.
- For command customization, set `Cmd.Args[0]` after creating the command
  with the real executable path; do not confuse it with `Cmd.Path`.
- For an executable-path seam, prefer a temporary symlink under the helper name
  where supported; copying is a fallback.
- Preserve normal `m.Run` behavior and return the helper's exit status.
- Reject unrecognized helper selectors instead of recursing into the suite.
- Keep hard exits at `TestMain`; helper functions return status.
- Explain that simulated behavior does not establish the real program's behavior.

### Adjacent valid case

#### Prompt addition

A third caller supports per-command environment configuration.
Another invokes a fixed bare program name through `PATH`.
Explain the isolation and parallel-test consequences of each route.

#### Expected behavior

- Prefer a child-specific environment selector where available.
- Respect inheritance versus replacement when setting `Cmd.Env`.
- Set the lookup environment before constructing a command with a bare name;
  changing `Cmd.Env` afterward does not change that lookup.
- Keep tests using `t.Setenv` nonparallel, including their ancestors.
- Do not claim that changing `PATH` redirects a fixed absolute path.

## Extend capabilities while preserving existing implementations

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A public sink interface exposes `Write([]byte) (int, error)`.
Some implementations can write strings more efficiently.
Existing third-party implementations and wrappers must keep working.
The application root owns closing sinks;
request handlers only write to them.
Design string writing and explain which interface members the handlers need.

### Expected behavior

- Keep the base interface stable and use a checked optional capability
  with a working fallback.
- Preserve the write operation's result and error contract on both paths.
- Account for a wrapper hiding the optional method.
- Keep convenience methods on a concrete wrapper or in functions
  instead of enlarging every implementation's interface.
- Do not require `Close` on an interface for consumers that do not own closing.

## Choose a strategy shape from demonstrated capabilities

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A new public renderer currently accepts `func(Entry) string`.
Callers also need an optional measure operation for rich renderers;
plain renderers have a correct fallback based on the formatted text.
There is no published API to migrate yet.
Choose the strategy API and show the optional operation's dispatch.
Separately choose an API for a local sort comparator with no other requirements.

### Expected behavior

- Consider a small strategy interface with an optional capability and fallback.
- Keep the local sort comparator as a function.
- Do not add interface machinery for hypothetical capabilities.
- Reach the optional capability guidance from the callback decision.

## Preserve input and partial-result contracts

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

A released request record gains a required credential field.
Old callers using keyed literals still compile.
Assess compatibility and propose a disposition.
A separate batch import operation promises to return accepted records
alongside an error when some records fail.
An atomic import operation makes no partial-result promise.
Choose error-result behavior for both operations.

### Expected behavior

- Recognize that compiling old callers does not preserve the required-field contract.
- Use a behavior-preserving optional default if possible,
  or acknowledge a deliberate contract change.
- Preserve the batch operation's documented partial results.
- Return a zero result for the failed atomic operation.

## Choose examples that demonstrate useful caller behavior

### Prompt

Use the `go-development` skill.
Do not read its tests or modify files or external state.

Choose documentation and test forms for two Go packages.
One is a self-contained interval parser with a three-line parse-and-format use case.
The other is a deployment coordinator whose public use requires a cluster,
credentials, and a long fixture setup.
Explain where executable examples help,
how Go treats examples with and without output comments,
and how you would verify the chosen examples.

### Expected behavior

- Recommend an `Example...` function for useful self-contained usage.
- Prefer ordinary tests or other documentation when example setup obscures the lesson.
- Use an external test package when demonstrating public API usage is appropriate.
- Distinguish compiled examples from examples run and checked via output comments.
- Run `go test` without inventing output assertions for nondeterministic behavior.
- Do not add examples solely to repeat existing tests.
