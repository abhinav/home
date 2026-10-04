# Outcome planning behavioral tests

Run each case with a fresh subagent that has an empty context window.
Give the runner only the case's `Prompt`, replacing `{GUIDANCE_PATH}`
with the AGENTS.md under test.
Keep the expectations and other cases outside the runner's context.
The exercise is read-only: do not execute the proposed operational actions.

Grade the concrete next action and completion plan against the expectations.
Accept defensible implementation choices that preserve the requirements.
Evaluate problem-solving independently of message wording or posting choices.
Capture the raw response and record each verdict with supporting output.
Repeat the continuation case with two or three fresh runners.
For a repair, retain the baseline evidence and rerun the same cases
against the candidate and the final integrated guidance.
Passing baselines do not establish that an edit improved behavior.

Use [scenarios.md](scenarios.md) for the cases.
