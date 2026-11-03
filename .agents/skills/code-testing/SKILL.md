---
name: code-testing
description: >
  Decide what test evidence a code change needs; write, change, delete,
  or review tests and their supporting infrastructure.
  Do not use merely to explain an existing test result or compiler error
  when no code, test, or validation decision is requested.
---

# Code testing

Protect intended promises with durable detectors that are easy to inspect.
A useful test fails for a credible violation and passes for every acceptable
implementation of its promise; a production change does not automatically need
a new test.

## Choose evidence before tests

Name the intended promise and a plausible regression.
Prefer observable contracts for callers and users, transitions, errors, and invariants.
Identify its current detector: an existing test, compiler, type system,
schema validator, static analyzer, build, or other repeatable check owning the guarantee.
During ordinary implementation and test planning, look for promises over input
combinations or operation histories: preservation, inverse operations, or model agreement.
When these relationships can expose evidence gaps,
read [Property-based testing](references/property-based-testing.md)
and choose a useful property test alongside concrete examples.
Also read it when designing or reviewing property-based tests.

Mentally introduce the regression and choose:

| Condition | Disposition |
| --- | --- |
| A new or changed promise or uncovered bug would pass every relevant detector | Add or strengthen a permanent test. A bug regression should fail without the fix and pass with it. |
| Existing tests fail for the regression at a useful boundary | Retain and run them. |
| The guarantee belongs to compilation, types, schema, static analysis, or build | Use that owning detector, plus affected behavior tests when runtime behavior must remain unchanged. |
| A proposed assertion reflects implementation shape but a behavioral gap remains | Replace the proposed test to protect that behavior. |
| A new test only repeats evidence or makes the changed implementation a promise | Omit the new permanent test. |

For behavior-preserving refactors, run existing tests protecting affected promises.
For removal of unsupported or unreachable behavior, verify the governing contract
and remaining supported paths.
Omitting a new permanent test still requires validation by existing or owning detectors.

Repeated coverage is useful when it detects a distinct failure mode,
exercises a materially different boundary or environment,
or makes an important failure substantially easier to localize.
If removing a proposed test would let no credible regression pass all remaining
detectors, one of those additional benefits must justify its maintenance.

## Make the promise and distinct defect signal visible

Show setup, action, and expected behavior in the body without reconstruction
from distant fixtures, loops, or helper chains.
Avoid tests that only detect implementation change by restating private mechanics:
helper structure, mock call order, intermediate representation, or copied production logic.
They are brittle during behavior-preserving changes
and give weak evidence that the behavior is correct.
If a promise is hard to name without private mechanics,
it is probably too coupled to implementation; rewrite around behavior
or delete the test when no meaningful behavior is at risk.
Ask whether a different correct implementation would fail;
if so, the test may be detecting shape rather than behavior.

Implementation detail is legitimate when it is the tested contract:
a parser's token stream, file format, public API type, or documented ordering rule.
Ask whether a caller, user, or maintainer is meant to rely on it.

## Keep scenarios DAMP

Prefer scenarios visible at the point of use.
Tests usually lack their own tests, so correctness depends on human inspection.
Do not apply DRY to repeated text by default: it protects duplicated knowledge,
not coincidental lines checking different behavior.
Keep meaningful inputs, the exercised operation, and expected externally visible
results in the test; extract incidental construction, protocol, file plumbing,
or other mechanics that distract from the behavior.

`OpenRepositoryWithBranches("main", "feature")` names a testing operation
while leaving the scenario in control.
`Setup()` or `RunCases()` is suspect when readers must open it to discover the behavior.
Before adding a helper, state the behavior or setup concept it names.
Use a helper only for a real testing operation understandable without opening it.
Do not add one solely to satisfy required fields, hide mock construction,
reduce repeated struct literals, or shorten tests.
Prefer explicit repeated setup when it expresses the scenario or required dependencies.

Use shared fixtures, mutable fields, table loops, or assertion loops only when
they make behavior easier to inspect.
Avoid hiding cases, coupling unrelated tests, or reporting an index instead of behavior.
