# Prose writing behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
For application and explicit-invocation tests,
give the runner only the scenario's `Prompt` section;
the prompt invokes `$prose-writing` by name.
For automatic-selection tests,
give the runner a realistic task through the governing AGENTS instructions
and available-skill catalog, without directing it to load the target skill.
For catalog-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill path and body.
Keep the expectations and intended answer hidden from the runner.
For a pressure or adjacent case with a prompt-addition subheading,
give a fresh runner the base `Prompt` plus only that addition.
For older sections without that subheading,
give the runner the base `Prompt` plus only the prose before
the first evaluator bullet list in the variant section.
Keep every expectation bullet hidden.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response or artifact and any required access trace,
then compare them with the held-out expectations.
Require the trace to show whether the runner loaded `prose-writing`;
do not substitute the runner's self-report.
For a task that enters a conditional reference branch,
also check the tool trace for the required reference read.
For a substantial written artifact,
give a separate fresh judge the artifact, source input, expectations,
and governing skill principles;
require the verdict to cite source-and-output evidence.
A scenario passes only when every required behavior holds
and no contrary behavior appears.

For a repair loop,
first run the relevant scenario against the current guidance.
Rerun the same scenario after the smallest candidate change,
then against the integrated final form.
Run each applicable adjacent case and relevant previously passing case.
Repeat important or borderline scenarios two or three times,
and record the observed pass rate.

Replace `{GUIDANCE_PATH}` with the candidate's entrypoint
and `{GUIDANCE_DESCRIPTION}` with its catalog description where present.
For integration trials, replace `{AGENTS_PATH}` with the governing candidate
instructions and `{SKILL_CATALOG}` with the available skills and their paths.
When testing edits across related skills,
resolve each skill name to the corresponding candidate version.
Keep the production failure record separate from reusable invented fixtures.

Use [scenarios.md](scenarios.md) for the retained prose and code contracts
and [representation scenarios](representation-scenarios.md)
for chat, revision, comparison, transfer, and rendering decisions.
Grade the reader's ability to compare, trace, locate, or use the information;
the presence of a diagram, table, or list alone does not establish success.
A nearby qualification may serve several rows or branches.
Do not require every source fact in one structure or a visual in a simple answer.
Compare the whole explanation with a simpler faithful form;
a large diagram plus repeated narration can fail despite correct relationships.
