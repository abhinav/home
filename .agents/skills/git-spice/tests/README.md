# Git-Spice Behavioral Tests

Run each scenario with a fresh subagent using `fork_turns: "none"`.
Give the subagent the skill path and scenario prompt.
Do not give it the expectations or intended answer.
Keep tests read-only or confined to a task-local temporary directory.

Capture the raw response and compare it with the expectations afterward.
A scenario passes only when every expectation holds
and no contrary behavior appears.

For import scenarios,
the subagent should not contact GitHub or mutate Git state.
Ask for the intended command plan,
the references it loaded,
and the safety checks it would perform.

Use [scenarios.md](scenarios.md) for the reusable gamut.
