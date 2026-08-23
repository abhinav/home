# ADR skill behavioral tests

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
The grading sections are evaluator-only;
withhold them and the intended answer.
Keep tests read-only or confined to a task-local temporary directory outside the
target repository.

Capture the raw response or artifact,
then compare it with the held-out expectations.
For a substantial ADR,
give a separate fresh judge the artifact, source input, expectations,
and governing guidance principles.
Require the judge to cite source-and-output evidence for each verdict.
A scenario passes only when every required behavior holds
and no unacceptable behavior appears.

For repair-loop scenarios,
first run the scenario without the new skill or against the current guidance.
Rerun the exact scenario after the smallest green candidate.
Then integrate the candidate,
remove provisional or duplicated text,
and rerun the exact scenario and relevant regressions.
Repeat important or borderline cases two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
