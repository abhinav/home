# Documentation Guidance Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
For application tests, give the subagent the relevant guidance path and scenario prompt.
For routing tests, give the subagent the task and guide catalog
without identifying the guide it should select.
Do not give the subagent the quality bar, expectations, or intended answer.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response or artifact
and compare it with the quality bar and expectations afterward.
For a substantial written artifact, give a separate fresh judge the artifact,
source input, quality bar, and applicable guidance.
Require a verdict supported by the source and artifact.
A scenario passes only when it meets the quality bar, every expectation holds,
and no contrary behavior appears.

For repair-loop scenarios, first run the relevant scenario against the current guidance.
After the edit, rerun that exact scenario.
Also run each applicable pressure variant and adjacent valid case.
Repeat important or borderline scenarios two or three times
and record the observed pass rate.
Rerun previously passing scenarios
when the change can affect their protected behavior.

Use [scenarios.md](scenarios.md) for the reusable gamut.
