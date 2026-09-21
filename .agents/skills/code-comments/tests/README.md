# Code comments behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
For application and explicit-invocation tests,
give the runner only the scenario's `Prompt` section;
the prompt invokes `$code-comments` by name.
For automatic-selection tests,
give the runner the scenario prompt without naming or providing the skill.
For catalog-selection tests,
replace `{GUIDANCE_DESCRIPTION}` with the candidate's current catalog
description,
but withhold the target skill path and body.
Keep the expectations and intended answer hidden from the runner.
For a pressure or adjacent case with a prompt-addition subheading,
give a fresh runner the base `Prompt` plus only that addition.
For older sections without that subheading,
give the runner the base `Prompt` plus only the prose before the first
evaluator bullet list in the variant section.
Keep every expectation bullet hidden.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response and any required access trace,
then compare them with the held-out expectations.
Require the trace to show whether the runner loaded `code-comments`;
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

Use [dispatch.md](dispatch.md) for catalog, automatic-selection,
and explicit-invocation cases.
Use [scenarios.md](scenarios.md) for application cases.
