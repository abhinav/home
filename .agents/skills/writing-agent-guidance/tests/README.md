# Writing agent guidance tests

Use [Subagent testing](../references/subagent-testing.md)
for isolation, baseline comparisons, grading, repetitions, and evidence.
The reusable cases are in [scenarios.md](scenarios.md).

Replace `{GUIDANCE_PATH}` with the active skill path and
`{GUIDANCE_DESCRIPTION}` with its current catalog description.
Give the runner only `Prompt`.
For catalog cases, withhold the selected path and body.
Keep `Evaluation`, `Quality bar`, `Expectations`, `Expected behavior`,
and `Unacceptable behavior` outside runner input.

For an older full-task variant, append only `Runner prompt addition`.
For an older focused variant, append only the prose before its first expectation
bullet.
Record file-access traces for pointer cases 16–18.

Cases 23–30 protect efficiency comparisons, code demonstrations, necessary
rationale, isolation, semantic preservation, compaction transfer, and evaluation scope.
For case 28, supply `{TARGET_PACKAGE_PATH}` as a frozen existing package
with conditional references; keep competing copies outside runner discovery.
Grade produced guidance for correctness and avoidable prose separately.
Compare length and run cost on matched inputs; a word quota is not the quality bar.

Run the cases affected by a change and relevant regressions against the final
integrated guidance.
Retain raw evidence in the task's evaluation directory, outside this skill's
execution instructions.
