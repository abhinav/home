# Subagent quorum behavioral tests

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
The grading sections are evaluator-only.
Withhold the expected behavior, unacceptable behavior, quality bar,
expectations, intended answer, and conclusions from earlier runs.

For a pressure or adjacent-valid trial,
give the runner the base prompt plus only that variant's runner prompt addition.
Keep tests read-only or confined to a task-local temporary directory outside the
target skill.

Capture the raw response,
then compare it with the held-out expectations afterward.
For substantial judgment artifacts,
give a separate fresh judge the artifact, source input, expectations,
and governing guidance principles.
Require the judge to cite source-and-output evidence for the verdict.
A scenario passes only when every required behavior holds
and no unacceptable behavior appears.

For a behavior-changing repair,
run the relevant scenario without the candidate first.
Rerun the same scenario after the smallest green candidate.
Then integrate the candidate,
remove provisional or duplicated text,
and rerun the scenario and relevant variants against the final guidance.
Repeat important or borderline scenarios two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
