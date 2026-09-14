# Diagram design behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
Replace `{GUIDANCE_PATH}` with the path to the candidate under test.
Replace `{GUIDANCE_DESCRIPTION}` with the candidate's current catalog
description when a catalog-selection scenario uses it.

For application tests,
give the runner only the scenario's `Prompt` section.
For catalog-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill path and body.
Full-prompt examples use `Expected behavior` and `Unacceptable behavior`.
Focused boundary tests use `Quality bar` and `Expectations`.
Those grading sections are evaluator-only;
withhold them and the intended answer.
For a full-prompt adjacent-valid trial,
give the runner the base `Prompt`
plus only that variant's `Runner prompt addition`.
Keep tests read-only or confine artifacts to a task-local temporary directory
outside the target skill.

Capture the raw response or artifact,
then compare it with the held-out expectations afterward.
For substantial artifact or judgment tests,
give a separate fresh judge the artifact, source input, expectations,
and governing guidance principles.
Require the verdict to cite source-and-output evidence.
A scenario passes only when every required behavior holds
and no unacceptable behavior appears.

For repair-loop scenarios,
first run the relevant scenario without the new guidance.
Rerun the same scenario against the smallest green candidate.
Then integrate the candidate,
remove provisional or duplicated text,
and rerun the scenario and relevant variants against the final guidance.
Repeat important or borderline cases two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
