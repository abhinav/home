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
