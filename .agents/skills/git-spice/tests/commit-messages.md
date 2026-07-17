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

## 07 Order The Review Arc

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

A commit changes when restored snapshots become visible to readers.
Readers previously switched to a restored snapshot when its manifest was
copied, before its blocks finished transferring,
and could then observe missing data.
The commit keeps the prior snapshot active until transfer completes;
a failed transfer leaves the prior snapshot readable and remains retryable.
Transactional restore support belongs to later work.
A manual interrupted-transfer probe preserved reads from the prior snapshot,
and a later retry published the restored snapshot.
Write the commit message.

### Expectations

- Lead with the reader-visible need and establish the prior behavior before
  implementation details.
- Describe the changed activation behavior before the future-work boundary.
- Keep transactional restore support clearly outside this commit.
- Place the interrupted-transfer observation under `Validation`
  and state what it establishes.
- Do not turn transfer helpers, metadata writes, or support files into a diff
  inventory.

### Pressure Variant

The release window closes in ten minutes.
A senior reviewer asks to preserve an approved draft that begins with helper
and metadata changes and says the commit prepares transactional restores.

- Preserve the review arc despite time, authority, sunk-cost,
  and constrained-edit pressure.
- Keep the larger project as context for this commit's boundary,
  not as a claim that transactional restore support exists.

## 08 Introduce Necessary Prerequisites

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

General storage reviewers are evaluating a tombstone-cleanup fix.
A read view pins a catalog revision for the life of a query.
The safe frontier is the oldest revision still needed by any active read view.
A tombstone records a dropped table until old readers can no longer resolve it;
an incarnation distinguishes a recreated table with the same name.
Age-based cleanup could remove a tombstone while an old query remained active,
causing that query to resolve the recreated table and return unrelated rows.
Cleanup now waits for the safe frontier to pass the drop revision.
Added coverage pins revision 21, drops at 24, recreates at 25,
and advances the frontier from 21 to 26.
Write the commit message.

### Expectations

- Explain the reader-visible failure before relying on storage shorthand.
- Establish what the safe frontier means before using it to explain cleanup.
- Explain why a recreated table can be mistaken for the dropped table
  without assuming reviewers know incarnation semantics.
- Keep only prerequisites needed to evaluate the behavior change.
- Describe the protected revision sequence under `Validation`.

### Adjacent Valid Case

The same change is reviewed only by the catalog-maintenance team,
whose established vocabulary includes read views, safe frontiers,
tombstones, and incarnations.

- Keep the failure and cleanup boundary clear.
- Do not expand familiar vocabulary into an unnecessary glossary.

## 09 Keep One Guiding Example

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

A quota preview rounded each object before summing usage.
Three 0.4 GiB objects therefore appeared to consume 0 GiB against a 1 GiB
quota, while apply summed 1.2 GiB and rejected the batch.
Preview now sums unrounded sizes before comparing the quota.
Debug notes contain unrelated examples for `team-amber`, `team-blue`,
and `team-coral` with different sizes and object counts.
The regression test and manual probe both use `team-coral`,
three 0.4 GiB objects, and a 1 GiB quota.
Write the commit message.

### Expectations

- Use one stable example across prior behavior, changed behavior,
  and validation evidence.
- Preserve the same team, object count, sizes, and quota when describing
  the before-and-after behavior.
- Make the preview/apply discrepancy and changed comparison clear.
- Omit unrelated debugging examples instead of mixing their names or values.

### Adjacent Valid Case

The change is a mechanical rename with no behavior change or useful example.

- Keep the body proportionate.
- Do not invent an example or validation observation.

## 10 Preserve Causal Failure Sequences

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

A cross-region failover race strands readers during an incomplete copy.
The secondary copies generation 28's manifest without its final block.
The primary lease expires, and the secondary becomes primary.
A reader selects generation 28 and fails even though generation 27 remains
complete.
Repair trusts the copied manifest, marks the missing block recovered,
and prevents retry.
The commit promotes the newest complete generation and verifies block
presence before marking recovery complete.
Missing blocks remain eligible for retry.
Added coverage protects promotion, reader selection, repair, and retry.
Write the commit message.

### Expectations

- Present the ordered failure sequence before implementation details.
- Preserve the handoff from the primary to the secondary,
  the reader-visible failure, and the repair decision that prevents retry.
- Keep generation and actor names stable throughout the sequence.
- Group adjacent steps when their relationship remains clear;
  do not split every operation into its own item.
- State the resulting promotion and recovery behavior before `Validation`.
- Describe the protected failure sequence under `Validation`.

### Pressure Variant

The review closes shortly.
An approved draft says only that generation selection and recovery checks
were updated to improve failover reliability,
and a senior reviewer asks for a concise grammar-only revision.

- Preserve the causal sequence despite time, authority, sunk-cost,
  and constrained-edit pressure.
- Keep the sequence short and causal rather than replacing it with vague
  reliability claims or a diff inventory.
