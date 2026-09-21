# Writing commit messages behavioral tests

Run each applicable scenario with a fresh subagent
that has an empty context window.
For application tests,
install the candidate as `writing-commit-messages`,
invoke it by name,
and give the runner only the scenario's `Prompt` section.
For catalog-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill body and filesystem location.
Replace `{GUIDANCE_DESCRIPTION}`
with the candidate's current catalog description.
Keep the expectations and intended answer hidden from the runner.
For a pressure, alternate-positive, intended-destination,
or adjacent case,
give a fresh runner the base `Prompt`
plus only that case's runner-visible prose.
Keep all expectation bullets hidden.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response or artifact and any required access trace,
then compare them with the held-out expectations.
For a substantial artifact,
give a separate fresh judge the artifact,
source input,
expectations,
and governing guidance principles.
Require the verdict to cite source-and-output evidence.
A scenario passes only when every required behavior holds
and no unacceptable behavior appears.

Repeat important or borderline scenarios two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
