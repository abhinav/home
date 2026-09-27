# Testing

## Place tests by the boundary they check

Choose test placement from the boundary being checked.
Unit tests can remain inline; a separate test file is optional.
When splitting a module's unit tests into a separate file,
keep them in its child module named `tests`, gated by `#[cfg(test)]`.
For `src/foo.rs`, put the tests in `src/foo/tests.rs`
and declare the child in `src/foo.rs`:

```rust
#[cfg(test)]
mod tests;
```

The separate file contains the test module's items directly.
This preserves `foo::tests` and access to `foo`'s private items through `super`.
An integration test is a separate crate and checks external access.
Do not widen production visibility to fit a test directory.
Choose the test that detects a failure of the supported contract;
Rust's test layout does not make integration tests universally preferable.

## Make failures name the behavior

Use named tests for distinct behaviors.
When the project already uses [rstest](https://docs.rs/rstest/latest/rstest/),
or the user requests it, use rstest for tests that need its parameterized cases,
fixture injection, or other features.
A test with no rstest features uses `#[test]` or the project's async test
attribute, such as `#[tokio::test]`.
When rstest is not already in use or requested, ordinary named tests
or small case loops with informative assertion messages are sufficient.

Choose the scenario grouping before the case syntax,
including when converting an existing loop or table to rstest.
Parameterize inputs and expected observations within a shared setup, action,
and checking sequence that a maintainer can understand as one scenario.
Read a selected case on its own: its name, arguments, and nearby body should
explain the relevant state, what happens, and why the expected result follows.
Common construction code, the same API call, and the same assertion macro
are not sufficient reasons to combine scenarios.

Split cases when a parameter selects different scenario histories:
which state to establish, which failure to induce, which steps to perform,
or which outcome to expect because of those choices.
Even one environment or backend flag can require the reader to trace several
separated branches to reconstruct the chosen scenario.
Give such scenarios separate named tests or coherent parameterized groups,
with their distinguishing setup, actions, and expectations visible together.
Helpers and fixtures may share incidental construction or meaningful setup
operations; moving a scenario selector into a helper does not reduce that
reconstruction work.

Case data should have a meaningful use in every case.
Configuration booleans passed to the operation, complete expected `Result`
values, predicate results, and several related output fields can all fit
one shared scenario with unconditional checks.
A short branch that inspects the actual result is reasonable when the shared
action and each expected outcome remain clear.
Unused columns, placeholder values, flags that enable assertions,
and callbacks that choose scenario steps are further signs to split the group.
Choose the grouping by the reader's reconstruction work,
rather than parameter count or the amount of repeated setup.

## Express cases with rstest

Use named `#[case::description(...)]` rows for related inputs and outcomes.
Each row becomes an independently runnable test with its own failure report.
Success and error cases can share a test when the expected result carries
the distinction and every case runs the same check:

```rust
use rstest::rstest;
use std::num::IntErrorKind;

/// Checks decimal conversion and its failure categories.
#[rstest]
#[case::decimal("17", Ok(17))]
#[case::leading_zeroes("004", Ok(4))]
#[case::empty("", Err(IntErrorKind::Empty))]
#[case::overflow("65536", Err(IntErrorKind::PosOverflow))]
fn parses_u16(
    #[case] input: &str,
    #[case] expected: Result<u16, IntErrorKind>,
) {
    assert_eq!(
        input.parse::<u16>().map_err(|error| error.kind().clone()),
        expected,
    );
}
```

Use `#[values(...)]` for independent input dimensions
when every combination meaningfully exercises the same claim.
Check the product size; use case rows for values that belong together.
Filtering combinations in the body can leave passing tests that check nothing.
For `#[files(...)]`, group corpus files by the contract they exercise
and apply the same operation and checks to each file in that group.

Use `#[fixture]` for environment construction or a meaningful setup operation
whose name and contract let the reader understand the test without opening it.
Keep behavior-defining state visible at the test site:
a file replacement test should show the prior contents and the replacement.
Fixture defaults, dependency chains, and shared case templates earn their place
only when each scenario remains understandable where it is used.
For parsing tests, pass the original input to the parser in the body;
implicit fixture or case conversions must not perform the behavior under test.

Use the project's supported rstest version and runtime conventions.
For syntax and advanced features, consult its
[test attributes](https://docs.rs/rstest/latest/rstest/attr.rstest.html)
and [fixtures](https://docs.rs/rstest/latest/rstest/attr.fixture.html)
documentation for that version.

## Keep test errors lightweight

Use assertions with useful diagnostics for the behavior under test.
Let fallible setup and helpers use `?` with a cheap error representation.
Choose that representation from the project's existing libraries using
[Errors and diagnostics](errors-and-diagnostics.md#follow-the-projects-error-representation).
For a project using `anyhow`:

```rust
/// Checks that saved settings can be read back.
#[test]
fn settings_round_trip() -> anyhow::Result<()> {
    // Fallible setup, operation, and assertions omitted.
    Ok(())
}
```

Without a generic error library, a result such as
`Result<(), Box<dyn std::error::Error>>` or a simple string error is sufficient.
Production error contracts do not require a corresponding test-only hierarchy.
When testing production error behavior, assert its relevant variant or fields
instead of converting it to text and losing the distinction under test.

## Keep resource owners alive

Apply [Resources and completion](resources-and-completion.md)
to fixture guards and child processes, including assertion failures and timeouts.
Pass a temporary-resource guard's borrowed path when setup needs a location;
moving the guard into an `AsRef<Path>` argument can drop it before the test runs.
In rstest, a `#[once]` fixture shares a value that is never dropped;
use it only when shared state and process lifetime fit the fixture's contract,
not for resources that rely on ordinary destructor cleanup.

Configure child environments and working directories through `Command`
instead of mutating process globals shared by parallel tests.
When checking a CLI contract, run the actual package binary.
For a project already using `tempfile` and a binary named `widget`:

```rust
let fixture = tempfile::tempdir()?;
let output = std::process::Command::new(env!("CARGO_BIN_EXE_widget"))
    .current_dir(fixture.path())
    .env("APP_MODE", "test")
    .output()?;
assert!(output.status.success(), "stderr: {:?}", output.stderr);
```

Keep fixtures in the parent when the child exercises process termination.
For a long-lived child, its test fixture must own termination and waiting
on assertion failure and timeout paths too.
For a terminating command with bounded output, `output` or `wait_with_output`
can collect its outcome without a custom stream fixture.
Use explicit stream handling when output is unbounded or the fixture stays alive.
Check fallible cleanup explicitly when cleanup success is the behavior under test.

## Observe timer behavior rather than elapsed wall time

For async rstest tests, retain the project's runtime test attribute
and the fixture's readiness, shutdown, and joining obligations.
A test timeout bounds waiting; it does not establish readiness or cleanup.

In projects using Tokio, prefer its paused clock for Tokio backoff,
deadline, and interval behavior.
Synchronize readiness before timing the event,
then observe the resulting state transition or completion.
For a delay contract, have the worker report when it armed the timer
and timestamp the attempt with Tokio time:

```rust
let started_at = timer_ready.recv().await.expect("worker should arm its timer");
let attempt = attempts.recv().await.expect("worker should retry");
assert_eq!(attempt.number, 2);
assert_eq!(attempt.at - started_at, backoff);
```

Awaiting the attempt lets the paused clock advance to its deadline.
The timestamp assertion detects an early or late retry.
Jumping straight to `backoff` before the receive would hide an early deadline:
the worker could run at the jumped clock value instead.

The channel receive establishes progress;
the fixture must still own worker termination and joining.
`advance` makes timers ready without waiting for their tasks to finish.
Repeated `yield_now` calls do not establish readiness either.
Prefer awaiting the operation with automatic clock advancement
when that directly expresses the scenario;
use explicit advancement when the test needs a deliberate jump.

A paused Tokio clock does not control `std::time::Instant`, external processes,
or blocking work.
Keep tests of those boundaries when their behavior matters.
For executable documentation and intended rejection examples,
use the [documentation guidance](documentation.md#make-examples-teach-supported-use).
