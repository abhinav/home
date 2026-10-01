# Receiving Code Review Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
Replace `{GUIDANCE_PATH}` or the example skill path with the candidate path.
Give the subagent only the skill path and scenario's `Prompt` section.
For a variant, also supply only its prose before the first expectation bullet.
Do not give it the expectations, diagnosis, or intended answer.
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
Repeat important or borderline cases with fresh agents.
For substantial judgment, use a separate fresh judge with the input, response,
expectations, and governing principles; require cited evidence for the verdict.

Scenarios 02, 06, and 07 protect independent judgment,
routine no-change decisions, operator authority, and credible security risks.
The `codex-review-green` gamut also exercises this skill through its findings
route; its cycle mechanics remain governed by that skill.

Use [scenarios.md](scenarios.md) for the reusable gamut.
