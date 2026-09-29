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

## Select properties during ordinary stateful implementation

### Prompt

Use the applicable installed guidance.
Do not modify files or execute repository code.

Please sketch the implementation and accompanying tests for a small ReservationBook in
language-neutral pseudocode.
The constructor accepts a nonnegative integer capacity.
Reserve(id, amount) accepts a positive integer amount and an identifier.
It succeeds only if id is not already active and enough capacity is available.
Failure leaves the book unchanged.
Release(id) restores the amount associated with an active identifier and removes it;
releasing an absent identifier has no effect.
An identifier can be reused after release.
Available() returns the remaining capacity.
Operations are sequential; there is no expiry or persistence.

The storage implementation is up to you.
Existing tests cover successful reservation, rejection of a reservation larger than
capacity, and release of one active reservation.

Include the implementation, the tests you would keep or add, and the checks you would run
before handing off the change.

### Expected behavior

- Chooses and concretely designs generated operation histories with property checks or a
  simple independent model, without being prompted to use the technique.

- Uses identifier reuse and successful as well as failed operations, independently
  checking capacity accounting and failure preserving state.

- Preserves useful fixed regressions and accepts a straightforward mapping model despite
  overlap in domain operations.

- Mere mention of possible future fuzzing or only adding handpicked examples does not
  establish proactive use. Do not require particular wording or a library.

- Require tool evidence that the runner reaches the property-based testing reference.
  A claim of having read it is insufficient.

## Select properties while implementing a codec

### Prompt

Use the applicable installed guidance.
Do not modify files or execute repository code.

Please sketch the implementation and tests for EncodeFields(fields) and DecodeFields(text)
in language-neutral pseudocode.
This is a small text protocol for a nonempty list of strings.
Separate fields with |.
Within a field, encode a literal | as \p and a literal backslash as \s; preserve other
Unicode characters.
The empty string is a valid field, so an empty encoded string represents one empty field.
DecodeFields rejects a trailing backslash or a backslash followed by any character other
than p or s.
No other normalization is allowed.

There is no current implementation.
An existing protocol document gives these examples: ["a", "b"] encodes to "a|b", and ["",
""] encodes to "|".

Include the implementation, the permanent tests you would add, and how you would validate
the change before handing it off.

### Expected behavior

- Chooses and concretely designs a permanent property-based test without being prompted to
  use the technique; bounded exhaustive generation also qualifies.

- Uses a supported relation such as decoding an encoded list preserving every string,
  alongside independent format examples and rejection tests.

- Designs a domain that includes empty fields, separators, backslashes, Unicode, and
  multiple fields; avoids relying solely on compensating encoder and decoder mistakes.

- Mere mention of possible future fuzzing or only adding handpicked examples does not
  establish proactive use. Do not require particular wording or a library.

- Require tool evidence that the runner reaches the property-based testing reference.
  A claim of having read it is insufficient.

## Select properties while changing a collection algorithm

### Prompt

Use the applicable installed guidance.
Do not modify files or execute repository code.

Please sketch this change and its accompanying tests in language-neutral pseudocode.
Our scheduling library has MergeCoverage(ranges), which takes a list of inclusive integer
ranges [start, end] with start <= end.
It returns sorted maximal ranges covering the same integers, joining both overlaps and
adjacency.
Inputs may arrive in any order and must remain unchanged.
Endpoints use arbitrary precision integers.

The current implementation repeatedly scans pairs and merges them, which is slow for large
lists.
Replace it with a sort followed by a single pass.
Existing tests are: empty input; one range; [1, 3] with [3, 5] produces [1, 5]; [1, 2]
with [3, 4] produces [1, 4]; and [1, 2] with [4, 5] stays separate.

Include the implementation, the tests you would keep or add, and the checks you would run
before handing off the change.

### Expected behavior

- Chooses and concretely designs property-based testing without being prompted to use the
  technique. Bounded exhaustive input generation is acceptable. Record unclear retention
  intent separately from selection.

- Generated inputs cover relationships across multiple intervals and assert independently
  justified coverage and canonical output, without copying the new merge algorithm.

- Retains useful fixed examples and makes the observable assertions and input domain
  clear.

- Mere mention of possible future fuzzing or only adding handpicked examples does not
  establish proactive use. Do not require particular wording or a library.

- Require tool evidence that the runner reaches the property-based testing reference.
  A claim of having read it is insufficient.

## Keep existing evidence for a fully exercised finite contract

### Prompt

Use the applicable installed guidance.
Do not modify files or execute repository code.

Please sketch this small refactor and its accompanying tests in language-neutral
pseudocode.
StatusLabel accepts a closed enum with only Pending, Running, and Complete.
It returns respectively the strings pending, running, and complete.
Replace a switch statement with a constant lookup.
The compiler requires coverage of every enum member, and existing public tests already
assert all three outputs.
No behavior or supported input changes.

Include the implementation, the tests you would keep or add, and the checks you would run
before handing off the change.

### Expected behavior

- Retains and runs the existing exhaustive public examples and owning compiler checks.

- Does not add a property merely because the skill now mentions the technique.

- Does not need to load the property reference because current detectors cover the finite
  contract. Record any reference access separately from the test disposition.

## Review oracle independence and incomplete properties

### Prompt

Use the code-testing skill.
Do not modify files or execute repository code.

Review the test designs below for a Canonicalize function.
Its published contract accepts supported documents with unordered unique key-value fields
and insignificant whitespace, returns fields in lexical key order with standardized
whitespace, preserves every field and value, and rejects duplicate keys.
The format deliberately permits several different byte representations of one document.
The parser and serializer are also implemented in this package.

A: for generated supported documents d, assert Canonicalize(Canonicalize(d)) ==
Canonicalize(d). B: for generated values v, assert Parse(Serialize(v)) == v. C: compute
expected canonical bytes by copying Canonicalize's scanner, state transitions, sorting
helper, and escape handling into the test. D: enumerate short lists of abstract unique
key-value pairs, render them with an independent elementary renderer using chosen field
permutations and whitespace, and compare the canonical result's independently observed
fields with the original pairs; retain specified byte examples for escaping and key
ordering.

Give a disposition for each design and a coherent minimal test design in pseudocode.
Explain what remains unestablished by passing it, how generated failures should be
investigated, and what input coverage matters.

### Expected behavior

- Recognizes idempotence and roundtrip useful but insufficient for content/compatibility;
  keeps justified examples.

- Rejects copied oracle while permitting justified independently simpler model; observers
  need justified independence.

- Uses semantic vs canonical byte equality appropriately and rejects duplicate keys
  separately.

- Does not call every failure production bug or claim finite test proves universal
  contract.

- Treat this scenario as application evidence, not proactive-selection evidence.
