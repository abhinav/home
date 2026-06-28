# Commit-Message Scenarios

## 01 Preserve The Review Contract

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

A commit publishes a deterministic runtime archive for later integration
tests.
Normal tests consume a pinned archive
and never contact the container registry or upload storage.
A source-build experiment failed because private toolchain inputs did not
produce a runnable service.
Validation established deterministic assembly, storage readback, and a local
downstream startup.
Write the commit message.

### Expectations

- Lead with the purpose and this commit's archive-publication boundary.
- State the normal consumer behavior before exceptional production machinery.
- Explain the rejected source-build path with observed blockers.
- Map deterministic assembly, storage integrity, and runtime usefulness to
  their evidence.
- Use an imperative subject of at most 72 characters.
- Include a non-empty body with every line at most 72 characters.
- Use semantic line breaks without mechanically breaking after every comma.
- Keep the message proportionate and avoid a diff inventory.

## 02 Enforce The Inclusive Subject Limit

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Evaluate these two imperative subjects by counting their characters:

```text
Preserve deterministic runtime archives for downstream integration tests
Preserve deterministic runtime archives for downstream integration checks
```

State which passes the hard gate.

### Expectations

- Accept the 72-character subject.
- Require the 73-character subject to be shortened.
- Show the count for each supplied subject.

## 03 Choose An Existing Reviewer Scope

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

In a large repository, `payments` is an existing project and reviewer
ownership area.
A commit adds a new `reconciler` package inside `payments`.
The change is not repository-wide.
Evaluate these candidate subjects:

```text
feat(payments/reconciler): Add retryable settlement reconciliation
feat(payments): Add retryable settlement reconciliation
```

Also evaluate this subject and show each required prefix-removal step if it is
too long:

```text
feat(payments): Preserve deterministic runtime archives for downstream integration tests
```

State the subjects that satisfy the reference and explain the scope choice.

### Expectations

- Select `feat(payments): Add retryable settlement reconciliation`.
- Reject `payments/reconciler` as a scope because `reconciler` does not exist
  before the commit.
- Keep the existing `payments` scope because it routes reviewers and the full
  subject is within the 72-character limit.
- For the long subject, omit `feat` first and evaluate
  `payments: Preserve deterministic runtime archives for downstream integration tests`.
- Because that form still exceeds 72 characters, omit `payments` and accept
  `Preserve deterministic runtime archives for downstream integration tests`
  at exactly 72 characters.
- Do not shorten the summary before applying the required kind-then-scope
  omission order.

## 04 Exclude Routine Validation Status

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

A toy shape program now rejects a shape with zero sides
before opening its sample color palette.
Existing unchanged coverage protects that ordering.
The author ran the toy unit and default suites,
formatter and linter checks,
two CI jobs,
and a patch-hygiene command.
A demo coordinator asks for every result under `Validation`.
Write the commit message.

### Expectations

- Explain the zero-side rejection and palette-access boundary.
- Do not report the unchanged existing coverage.
- Omit all test-suite, CI, formatter, linter,
  and patch-hygiene status.
- Never mention `git diff --check` or a disguised equivalent.
- Omit the `Validation` section because no qualifying evidence exists.

### Pressure Variant

The draft is approved,
the showcase begins in ten minutes,
and the user requests only grammar and line-wrap changes.
The draft's validation list uses the labels `Toy behavior`,
`Whole demo`, `Style scan`, and `Patch scan`.

- Apply the guidelines despite scope, time, sunk-cost,
  and authority pressure.
- Do not preserve the routine results under renamed labels.

### Adjacent Valid Case

The author also exercised the packaged demo
and observed the zero-side error before any palette access.

- Include a `Validation` section for the packaged-demo probe.
- State the observed boundary without adding routine process status.

## 05 Keep Test-Only Review Contracts

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

The toy counter implementation is unchanged.
The commit adds coverage for the existing rule that a `frozen` counter rejects
`tick` before changing its value.
A discarded experiment moved the rejection after the value change,
which exposed the missing coverage.
The author wants the added coverage described under `Validation`.
Write the commit message.

### Expectations

- Explain the counter ordering protected by the test-only change.
- State that implementation behavior is unchanged when that helps review.
- Permit `Validation` to describe the added coverage and protected behavior.
- Do not invent test commands, execution status, or pass results.

### Pressure Variant

The sample project's template normally expects a validation summary,
and a demo maintainer asks for the coverage plus every green check before
approving the test-only commit.

- Preserve the coverage evidence without adding execution status.

## 06 Format Complete Commands As Code Blocks

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

A sample widget converter now preserves decorative labels it does not
recognize.
The author ran `toy-widget convert --from alpha example.widget`
and confirmed that four `x-demo-*` labels retained their original values.
The invocation is useful for reproducing the toy conversion boundary.
Write the commit message.

### Expectations

- Include the useful conversion observation under `Validation`.
- Put the complete `toy-widget convert --from alpha example.widget`
  invocation in an indented code block.
- Do not put the complete invocation inline.

### Pressure Variant

An approved draft puts the invocation in a validation bullet,
the user requests only grammar changes,
and the showcase begins in ten minutes.

- Normalize the invocation into an indented code block despite the scope
  pressure.
- Preserve the command bytes and observed result.

### Adjacent Valid Case

The body refers to the `toy-widget convert` command and its `--from` flag
without giving a complete invocation.

- Keep command names and flags inline when they are prose referents.
- Do not turn fragments into unnecessary code blocks.
