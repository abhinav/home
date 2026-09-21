# Prose formatting behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
For application and explicit-invocation tests,
give the runner only the scenario's `Prompt` section;
the prompt invokes `$prose-formatting` by name.
For automatic-selection tests,
give the runner a realistic task without naming or providing the skill.
For catalog-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill path and body.
Keep the expectations and intended answer hidden from the runner.
For a pressure or adjacent case,
give a fresh runner the base `Prompt` plus only the prose before
the first evaluator bullet list in that variant section.
Keep every expectation bullet hidden.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response and any required access trace,
then compare them with the held-out expectations.
Require the trace to show whether the runner loaded `prose-formatting`;
do not substitute the runner's self-report.
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
