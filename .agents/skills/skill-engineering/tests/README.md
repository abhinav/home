# Skill engineering behavioral tests

Run each applicable scenario with a fresh agent.
Replace `{SKILL_PATH}` with the path to the skill under test,
then give application runners only the scenario's `Prompt` section.
Do not show them `Expected behavior`, `Unacceptable behavior`,
or conclusions from earlier runs.

For trigger-selection scenarios,
give the runner only the available skill descriptions and user request.
Do not identify the desired skill.

Keep runs read-only
or confine writes to a task-local temporary directory.
Capture the raw result before evaluation.
Compare it with the held-out expectations afterward
and accept equivalent approaches that preserve the stated boundary.

Use [scenarios.md](scenarios.md) for the reusable cases.
