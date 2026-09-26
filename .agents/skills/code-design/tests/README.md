# Code design behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
For application tests,
install the candidate as `code-design`,
invoke it by name,
or supply the entrypoint path for an isolated candidate snapshot,
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

For substantial written designs, have a separate fresh judge evaluate
source inputs, the raw artifact, and held-out expectations.
Require evidence for the verdict and allow equivalent coherent designs.
For reference coverage, distinguish a sound answer based on prior knowledge
from concepts actually taught by the supplied guidance.
A passing baseline design is not a reproduced behavioral failure.

For pointer-reach claims, require a tool trace of guidance-file access;
self-reported reading or a citation alone does not establish retrieval.
If the trace is unavailable, report that routing remains unverified.

Capture the raw response and any required access trace,
then compare it with the held-out expectations.
A scenario passes only when every required behavior holds
and no contrary behavior appears.

Repeat important or borderline scenarios two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
