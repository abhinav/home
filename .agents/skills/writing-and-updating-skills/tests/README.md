# Writing And Updating Skills Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
Give the subagent the skill path and scenario prompt.
Do not give it the expectations or intended answer.
Keep tests read-only or confined to a task-local temporary directory.

Capture the raw response and compare it with the expectations afterward.
A scenario passes only when every expectation holds
and no contrary behavior appears.

For repair-loop scenarios,
first run the relevant scenario against the current guidance.
After the edit,
rerun that exact scenario.
Also run a pressure variant or adjacent valid case
when the scenario defines one.

Use [scenarios.md](scenarios.md) for the reusable gamut.
