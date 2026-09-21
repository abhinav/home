# Code testing behavioral scenarios

## Select code-testing for test review

### Prompt

Available skills:

- `code-testing`: `{GUIDANCE_DESCRIPTION}`
- `code-review`: Use when reviewing code or a code change.
- `code-readability`: Use when writing, changing, or reviewing non-generated
  code.

A user asks you to review a proposed unit test.
They want to know whether it protects public behavior,
duplicates existing evidence,
or couples the suite to private implementation details.
They do not ask you to write a test or review production code.

Choose the skill or skills you would load before answering.
Explain the responsibility of each selection.
Do not review the test or modify files.

### Expected behavior

- Select `code-testing` because it governs review of test evidence and test
  artifacts.
- Do not require a request to write or change a test before selecting it.
- Do not select `code-review` merely because the user says `review`;
  the requested artifact is a test rather than a production code change.

### Unacceptable behavior

- Omit `code-testing` because the request asks only for review.
- Treat the skill as applying only when authoring new tests.

### Adjacent valid case

#### Prompt addition

Instead, the user asks what a supplied compiler error means.
They do not ask to change code,
choose validation evidence,
or inspect a test artifact.

#### Expected behavior

- Do not select `code-testing` merely because compilation can be a detector
  for other tasks.

## Add tests for missing evidence, not changed lines

### Prompt

Use the `code-testing` skill.
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
