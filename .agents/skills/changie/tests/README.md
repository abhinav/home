# Changie behavioral tests

Run application checks with fresh subagents and an empty context window.
Substitute the candidate skill path for `{GUIDANCE_PATH}`.
Give each runner only a scenario's Prompt section;
keep Expected behavior evaluator-only.
Keep runs read-only and capture the raw response for grading.
A scenario passes when its action and evidence meet every expectation.
Repeat the leave-alone and update cases with two fresh runners.

For a repair, run the relevant scenario against the original guidance first,
then the candidate and final integrated guidance.
After integration, run every scenario in [scenarios.md](scenarios.md)
to check release-state decisions and adjacent valid behavior.
