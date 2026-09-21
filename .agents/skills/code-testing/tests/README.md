# Code testing behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
For application tests,
install the candidate as `code-testing`,
invoke it by name,
and give the runner only the scenario's `Prompt` section.
For catalog-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill body.
Do not give the runner a filesystem path to the skill.
Keep the expectations and intended answer hidden from the runner.
For an adjacent case,
give a fresh runner the base `Prompt` plus only that case's `Prompt addition`.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response and any required access trace,
then compare it with the held-out expectations.
A scenario passes only when every required behavior holds
and no contrary behavior appears.

For a repair loop,
first run the relevant scenario against the current guidance.
Rerun the same scenario after the smallest candidate change,
then against the integrated final form.
Run each applicable adjacent case and relevant previously passing case.
Repeat important or borderline scenarios two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
