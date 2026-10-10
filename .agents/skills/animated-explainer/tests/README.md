# Animated explainer behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
Replace `{GUIDANCE_PATH}` with the path to the candidate under test.
Replace `{GUIDANCE_DESCRIPTION}` with the candidate's current catalog
description when a catalog-selection scenario uses it.

For application tests, give the runner only the scenario's `Prompt` section.
For catalog-selection tests, give the runner the scenario prompt and
available-skill catalog, but withhold the target skill path and body.
The grading sections are evaluator-only; withhold them and the intended answer.

Keep tests read-only or confine generated artifacts to a task-local temporary
directory outside the target skill.
Capture the raw response or artifact, then compare it with the held-out
expectations afterward.
For an artifact trial, give a separate fresh judge the artifact, source input,
expectations, and governing guidance principles.
Require the verdict to cite source-and-output evidence.

A scenario passes only when every required behavior holds and no unacceptable
behavior appears.
For a new or repaired boundary, first run the relevant scenario without the
candidate or against the current guidance.
Rerun that exact scenario after the smallest green candidate, then rerun it and
the applicable adjacent cases against the final integrated guidance.
Repeat important or borderline cases two or three times and record the observed
pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
