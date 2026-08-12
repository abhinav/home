# Pikchr behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
Replace `{SKILL_PATH}` with the path to the candidate under test.
For application tests,
give the runner only the scenario's `Prompt` section.
For trigger-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill path and body.
Full-prompt examples use `Expected behavior` and `Unacceptable behavior`.
Focused boundary tests use `Quality bar` and `Expectations`.
Those grading sections are evaluator-only;
withhold them and the intended answer.
Keep tests read-only or confine artifacts to a task-local temporary directory
outside the target skill.

Capture the raw response and artifacts,
then compare them with the held-out expectations.
For a rendered diagram,
give a separate fresh judge the source request, Pikchr source, rendered SVG,
expectations, and governing skill principles.
Require the verdict to cite source-and-output evidence.
A scenario passes only when every required behavior holds
and no unacceptable behavior appears.

For repair-loop scenarios,
run the scenario against the current skill as the update baseline.
Rerun the exact scenario after the smallest green candidate.
Then integrate the candidate,
remove provisional or duplicated text,
and rerun the scenario and relevant variants against the final skill.
Repeat important or borderline cases two or three times
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
