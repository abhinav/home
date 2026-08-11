# Writing And Updating Skills Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
For application tests,
give the runner the skill path and scenario prompt.
For trigger-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill path and body.
Give a runner the prompt and input;
withhold the Quality Bar, Expectations, and intended answer.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response or artifact and compare it with the quality bar
and expectations afterward.
For substantial artifact or judgment tests,
give a separate fresh judge the artifact, source input, quality bar,
and governing skill principles;
require the verdict to cite source-and-output evidence.
A scenario passes only when it clears the bar,
every expectation holds,
and no contrary behavior appears.

For repair-loop scenarios,
first run the relevant scenario against the current guidance.
After the edit,
rerun that exact scenario.
Also run each defined,
applicable pressure variant and adjacent valid case.
Repeat important or borderline cases two or three times,
record the observed pass rate,
and rerun relevant previously passing cases.

Use [scenarios.md](scenarios.md) for the reusable gamut.
