# Code Testing

Tests should protect the system's intended behavior
and make that protection easy to inspect.

## Make Tests Useful

A useful test fails when behavior that matters has changed.
Prefer tests that describe an observable contract: what callers can rely on,
what users can see, what state transitions must happen, what errors mean,
or what invariants must hold after an operation.

Avoid tests that only detect that the implementation changed.
A change-detector test restates private mechanics,
such as helper structure, mock call sequence, intermediate representation,
or copied production logic.
These tests are brittle during behavior-preserving changes
and provide weak evidence that the behavior is correct.

When writing or reviewing a test,
ask what promise the test protects.
The reader should be able to identify the setup, action,
and expected behavior from the test body without reconstructing hidden state
from distant fixtures, loops, or helper chains.
If that promise is hard to name without referring to private mechanics,
the test is probably too tightly coupled to implementation.
Rewrite it around the behavior that should remain true,
or delete it if no meaningful behavior is at risk.

A useful pressure test is:
would a different correct implementation fail this test?
If so, the test may be detecting implementation shape
rather than protecting behavior.

Implementation details can still appear in tests
when those details are the boundary being tested.
For example, a parser's token stream, a file format, a public API type,
or a documented ordering rule may be the contract.
The key question is whether the detail is something a caller, user,
or maintainer is meant to rely on.

## Keep Test Scenarios DAMP

Prefer tests that make the scenario visible at the point of use.
Tests do not usually have their own tests,
so their correctness depends on human inspection.
A test that saves a few lines by hiding scenario-specific values, actions,
or assertions can make failures harder to diagnose.

Do not apply DRY to repeated test text by default.
DRY protects duplicated knowledge, not coincidental duplicated lines.
If two tests repeat the same setup value, call,
or assertion because they are checking different behavior,
the repetition may be useful documentation.

Keep the test's what visible:
the inputs that matter,
the operation being exercised,
and the expected externally visible result.
Extract the how when it is incidental:
object construction noise,
protocol setup,
temporary file plumbing,
or other mechanics that distract from the behavior under test.

A good helper names a meaningful testing operation
and leaves the scenario in control.
For example, `OpenRepositoryWithBranches("main", "feature")`
can improve clarity.
A helper such as `Setup()` or `RunCases()` is suspect
when the reader must open it to understand what behavior the test covers.

Before adding a new test helper,
state what behavior or setup concept the helper names.
Do not add a helper whose only purpose is to satisfy required fields,
hide mock construction,
reduce repeated struct literals,
or shorten a test.
Prefer explicit setup in each test when the repeated lines are part
of the scenario or make required dependencies visible.

A test helper is appropriate only when it names a real testing operation
that a reader can understand without opening the helper.

Shared fixtures, mutable fields, table loops,
and assertion loops are useful only when they make the behavior easier
to inspect.
Avoid them when they hide the case being tested,
couple unrelated tests,
or make a failure report identify an index instead of a behavior.
