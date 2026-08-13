# Code Testing

Tests should protect the system's intended behavior
and make that protection easy to inspect.

## Choose evidence for intended behavior

A test suite is a set of durable detectors for promises that matter,
not a receipt requiring one new test for every production change.
Useful test evidence distinguishes an acceptable change from a defect.
It fails for a credible violation of a protected promise
and passes for every acceptable implementation of that promise.

Decide what evidence a code change needs before writing a test:

1. Name the intended promise and a plausible regression.
   Prefer observable contracts: what callers can rely on,
   what users can see, what state transitions must happen,
   what errors mean, or what invariants must hold after an operation.
2. Identify the current detector for that regression.
   It may be an existing test, the compiler, the type system,
   a schema validator, a static analyzer, the build,
   or another repeatable check that owns the guarantee.
3. Mentally introduce the regression and choose the disposition:
   - Add or strengthen a permanent test when a new or changed promise,
     or an uncovered bug, would otherwise pass every relevant detector.
     A bug-fix regression test should fail without the fix
     and pass with it.
   - Retain and run existing tests when they already fail for the regression
     at a useful boundary.
   - Use the owning non-test detector for compile-time, type, schema,
     static-analysis, or build guarantees,
     together with affected behavior tests when runtime behavior must remain
     unchanged.
   - Replace a proposed test when its assertion is implementation-shaped
     but a real behavioral gap remains.
   - Omit a new permanent test when it would only repeat existing evidence
     or turn the changed implementation into a new promise.

For a behavior-preserving refactor,
run the existing tests that protect the affected promises.
For removal of unsupported or unreachable behavior,
verify the governing contract and the remaining supported paths.
No new permanent test does not mean no validation;
it means the existing or owning detectors already supply the relevant signal.

Repeated coverage is useful when it detects a distinct failure mode,
exercises a materially different boundary or environment,
or makes an important failure substantially easier to localize.
If removing the proposed test would not let a credible regression
pass every remaining detector,
the test needs one of those additional benefits to justify its maintenance.

Avoid tests that only detect that the implementation changed.
A change-detector test restates private mechanics,
such as helper structure, mock call sequence, intermediate representation,
or copied production logic.
These tests are brittle during behavior-preserving changes
and provide weak evidence that the behavior is correct.

When writing or reviewing a test,
make its protected promise and distinct defect signal visible.
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

## Tests

When changing this guide,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents
that have empty context windows.
