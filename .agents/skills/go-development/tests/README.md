# Go development behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
For application tests,
install the candidate as `go-development`,
invoke it by name,
and give the runner only the scenario's `Prompt` section.
For catalog-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill body and filesystem location.
Replace `{GUIDANCE_DESCRIPTION}` with the candidate's current catalog
description.
Keep the expectations and intended answer hidden from the runner.
For a pressure or adjacent case,
give a fresh runner the base `Prompt` plus only that case's prompt addition.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response and any required access trace,
then compare it with the held-out expectations.
A scenario passes only when every required behavior holds
and no contrary behavior appears.

For reference-reach scenarios,
invoke `go-development` by name and describe only the task decision.
Do not give the runner a skill file or reference path.
Use the runner's file-access trace to verify that it followed the router
to the applicable reference without surveying unrelated references.

Repeat important or borderline scenarios two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
