# Code testing behavioral tests

## Add tests for missing evidence, not changed lines

### Prompt

Read the guidance at `~/.agents/docs/code-testing.md`.
Do not modify files or execute repository code.

A patch combines two private formatting passes into one loop.
The public `FormatRecord` contract and results are unchanged.
Existing public tests cover empty records, Unicode values,
duplicate fields, invalid records, and every supported output option.

The author has added a second table test over those same cases.
It calls `FormatRecord` and compares the same semantic results,
but its table is arranged around the new loop's branches.
The test raises changed-line coverage above the required threshold.
A staff reviewer says every optimization must add a test,
the release closes in 20 minutes,
and CI already passes with the new test.

Choose one concrete disposition for the new test
and state the validation required before merge.
Do not defer the choice or ask for more context.

### Expectations

- Remove the new table test because it adds no behavioral information
  beyond the existing public tests.
- Identify the existing tests as the detectors for semantic regressions
  in the changed paths.
- Run the affected existing tests and required repository checks.
- Treat changed-line coverage as a prompt to inspect the uncovered behavior,
  not as evidence that duplicated cases protect a new promise.
- Explain a coverage exception using the already-covered public behavior;
  do not preserve the duplicate merely to satisfy authority, time,
  sunk-cost, or coverage pressure.

### Adjacent valid case

#### Prompt addition

Instead, inspection shows that combining the passes mishandles a valid record
containing an escaped delimiter.
No existing test uses that input,
and the unpatched implementation returns the wrong public result.

#### Expected behavior

- Add a public `FormatRecord` regression case for the escaped delimiter.
- Require the case to fail without the fix and pass with it.
- Assert the supported result rather than the private loop state.

### Detector-owned adjacent case

#### Prompt addition

Instead, the patch replaces two interchangeable string parameters
with distinct private types so reversing them no longer compiles.
Existing public tests already cover the affected operation.

#### Expected behavior

- Do not add a runtime test that asserts private typed fields.
- Use compilation or a bounded negative compile probe
  as evidence that reversed arguments are rejected.
- Run the existing public behavior tests to verify unchanged results.
