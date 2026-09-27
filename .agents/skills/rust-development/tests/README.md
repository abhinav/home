# Rust development guidance tests

The scenarios protect judgment and reference application, not Rust syntax recall.
Run relevant cases with fresh agents, keeping the evaluator's expectations out
of the runner prompt.
Replace `{GUIDANCE_PATH}` with the candidate's absolute `SKILL.md` path.
For an update baseline, run against the current guidance before editing it.
For new guidance, omit that guidance sentence and withhold the candidate.
Prior passing baselines do not establish a behavioral improvement.

Give an application runner only the selected `Prompt`.
For a variant, add only its `Runner prompt addition` to the base prompt;
keep its expected behavior hidden from the runner.
Capture its unedited answer, then apply the held-out quality bar.
Grade substantial code artifacts with a separate fresh judge who receives the
prompt, artifact, bar, and governing guidance, but no preferred full solution.
Allow equivalent designs that preserve the contract.
Keep work read-only or in task-local temporary storage outside this repository.

Repeat important or borderline cases with two or three fresh agents.
After a repair, repeat the failing case and affected adjacent cases against the
complete integrated package.
Record failures, findings, revisions, and final observed pass counts separately
from the reusable scenarios.

For catalog selection, substitute the current description and withhold the
skill path and body.
For pointer reach, use the application prompts and capture actual tool access
to the references independently of the answer.
Without tool traces, mark pointer reach unvalidated;
a correct answer or self-reported reading establishes only application evidence.

Mechanically check frontmatter, local links, source formatting, and the affected
file list, then review coverage against the approved contract.
Do not confuse a missing reference, a source check, or compilation of an example
with failed agent behavior.
Use [scenarios.md](scenarios.md) for prompts and evaluator expectations.

For ordinary property-selection scenarios,
give only the task prompt and the normal available-skill catalog.
Do not name the desired technique, framework, skill, or reference.
The explicit library and fuzzing cases establish application evidence only.
Grade substantial code artifacts independently and check reference access traces.

For changes to operation boundaries, dependency lifetimes, independently available
data, or persisted compatibility, run the applicable cases in
[Change locality](change-locality.md).
The independent cases include contrasting valid contracts;
include those contrasts when checking that a new rule does not overreach.
For construction or API evolution edits, also rerun scenarios 01, 03, and 19–21
from the main gamut when their contracts could be affected.
