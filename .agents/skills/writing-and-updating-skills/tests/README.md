# Writing and updating skills behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
Replace `{SKILL_PATH}` with the path to the candidate under test.
For application tests, give the runner only the scenario's `Prompt` section.
For trigger-selection tests, give the runner the scenario prompt and
available-skill catalog, but withhold the target skill path and body.

Two first-class scenario styles appear in this suite:

- Full-prompt examples preserve the complete runner-visible request and use
  `Expected behavior` and `Unacceptable behavior`.
  Use them for trigger selection, end-to-end application, substantial artifacts,
  and interactions among several rules.
- Focused boundary tests isolate one failure or decision and use `Quality bar`
  and `Expectations`.
  Use them for red reproduction, pressure or adjacent cases, loophole diagnosis,
  and fixed conformance checks.

The grading sections are evaluator-only.
Withhold `Expected behavior`, `Unacceptable behavior`, `Quality bar`,
`Expectations`, the intended answer, and conclusions from earlier runs.

For a full-prompt pressure or adjacent-valid trial, give the runner the base
`Prompt` plus only the variant's `Runner prompt addition`.
For a focused trial, give the runner the base `Prompt` plus only the prose
before the first bullet in that variant section.
All expectation bullets remain evaluator-only.
Keep tests read-only or confined to a task-local temporary directory outside the
target repository.

Capture the raw response or artifact and compare it with the held-out
expectations afterward.
For substantial artifact or judgment tests,
give a separate fresh judge the artifact, source input, expectations,
and governing skill principles; require the verdict to cite source-and-output
evidence.
A scenario passes only when every required behavior holds and no unacceptable
behavior appears.

For repair-loop scenarios, first run the relevant scenario against the current
guidance.
Rerun that exact scenario after the smallest green candidate.
Then integrate the candidate into the existing guidance,
remove provisional or duplicated text, and rerun the exact scenario,
each applicable pressure or adjacent-valid variant,
and relevant previously passing cases against the final refactor form.
Repeat important or borderline cases two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
