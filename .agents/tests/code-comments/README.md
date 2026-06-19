# Code Comments Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
Do not give the subagent the expectations or intended answer.
Keep tests read-only or confined to a task-local temporary directory.

Capture the raw response and compare it with the expectations afterward.
A scenario passes only when every expectation holds
and no contrary behavior appears.

Run the automatic-load scenario where the repository `AGENTS.md` applies,
but do not name or provide the guide in the task prompt.
After capturing the raw response,
ask whether the subagent opened and applied the guide.

For repair-loop scenarios,
first run the relevant scenario against the current guidance.
After the edit,
rerun that exact scenario.
Also run a pressure variant or adjacent valid case
when the scenario defines one.

Use [scenarios.md](scenarios.md) for the reusable gamut.
