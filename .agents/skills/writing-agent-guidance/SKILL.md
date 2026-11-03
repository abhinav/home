---
name: writing-agent-guidance
description: >
  Create, revise, or test agent instructions in skills, AGENTS.md, CLAUDE.md,
  and their references. Use for instruction routing and behavioral evaluations,
  not ordinary prose.
---

# Writing agent guidance

Write the least guidance that reliably changes the agent's decisions.
Assume a capable agent; supply local knowledge, constraints, and procedures
it cannot infer from the task or environment.
Measure success in the work it produces, including the cost of the guidance.

## Establish the task and baseline

Identify the requested behavior, runtime, entry route, and governing local sources.
Define a representative input and an observable quality bar before drafting.
For an artifact, identify its reader and what that reader must decide, do, or observe.
For updates or compaction, read [Updating guidance](references/updating-guidance.md)
for requirement preservation and package restructuring.

Choose evidence for the claim:

| Work | Baseline and comparison |
| --- | --- |
| Repair a behavioral defect | Capture the failed decision with current guidance, or without the new skill. Rerun it after the repair. |
| Improve efficiency or clarity | Compare current and candidate guidance on the same tasks. Preserve useful behavior while reducing unnecessary text or work. A passing baseline is useful here. |
| Repair syntax, references, or a mechanical contract | Reproduce and rerun the corresponding validator or retrieval check. |

For a behavioral defect, classify the failure before editing:
guidance, routing, test setup, missing capability, or missing authority.
Repair the owning boundary.
For guidance, use the visible context and actions to identify the earliest missing
distinction that would change the decision; do not invent hidden motives.
Before concluding that a reported defect cannot be reproduced,
use the [Subagent testing](references/subagent-testing.md) workflow
to check the setup and try realistic variants.
If those attempts still pass, stop that defect repair and report the gap.
Do not call an optimization a verified repair of an unreproduced failure.

## Choose the smallest useful form

Start with the condition and action.
Include the result check when the agent needs it to recognize completion.
Add an explanation only when it changes a choice, resolves ambiguity,
or helps the agent apply the rule to an unfamiliar case.
These are authoring questions, not required sections in the finished guidance.

| What the agent needs | Preferred form |
| --- | --- |
| One behavior or constraint | One or two direct statements |
| A command, configuration, API shape, or output format | A short faithful example; prose supplies only missing conditions and meaning |
| Different actions under different conditions | A condition/action list or table, including no action when applicable |
| An unfamiliar judgment | A concise decision criterion and, if needed, one example that reveals the boundary |
| Actions whose order matters | Ordered steps with observable completion conditions |
| Independent definitions or criteria | A peer set, not an invented sequence |

For example, a small operation can be complete without an explanatory section:

````markdown
Check JSON syntax with:

```sh
python -m json.tool config.json > /dev/null
```

A successful parse does not establish schema conformance.
````

Let the example carry syntax and structure; remove prose that narrates it again.
Keep examples representative and label illustrative code.
Add another only for a distinct decision that the first does not teach.
Preserve necessary actors, conditions, authority, and recovery boundaries.
Shorter wording is not an improvement when it makes the agent guess.

Use fixed commands and bright-line gates for fragile operations or demonstrated
skipping under pressure.
Use outcomes and decision criteria when several methods satisfy the contract.
For reference-only work, account for every applicable rule or affected entity.
Do not turn every preference into a mandatory procedure.

## Put each requirement in one place

Choose the artifact by when the agent needs the information:

| Artifact | Contents |
| --- | --- |
| Skill description | Capability and distinct activation conditions; a nearby exclusion only when it prevents likely misrouting |
| Automatically loaded instructions | Rules needed throughout that scope and pointers for other tasks |
| Skill body | Shared operating decisions, constraints, completion conditions, and branch pointers |
| Linked reference | Substantial detail needed only after the named branch is chosen |
| Script | Repeated deterministic work whose execution is more reliable or economical than regenerating it |

Keep skill names and frontmatter valid for the runtime.
Descriptions should help select the skill, not summarize its procedure.
Use established task terms and name each distinct trigger once.
Preserve existing invocation settings unless changing them is part of the task.

At each reference pointer, state when to read it and what it supplies.
Keep references one level from the entrypoint and start them with the branch's work.
Keep knowledge every invocation needs in the body.
Moving text to a later heading does not defer its loading;
moving it to another file helps only if some tasks can skip that file.

Link to a source when the task needs current facts or authority absent here.
Keep sufficient stable instructions self-contained.
Do not add retrieval solely for attribution, or copy a rule into an overview,
procedure, warning, and checklist.
Keep a rule with its conditions and exceptions.
Add scripts, assets, or package documentation only for a concrete use.

## Integrate and test

Before testing a candidate, inspect the complete affected guidance and routed files.
Integrate changes into their governing rules, remove provisional duplication,
and account for each changed requirement and route.
The inspected diff and a brief integration note can supply this evidence;
use a separate mapping only when needed for reviewability.

Before behavioral evaluation, read
[Subagent testing](references/subagent-testing.md)
for isolation, scenario selection, independent grading, and repetitions.
Use fresh runners with only the active guidance version and realistic inputs.
Keep expected answers and the proposed diagnosis outside their prompts.

Test the produced artifact as well as the agent's choices.
For efficiency work, compare artifact length and avoidable prose alongside
correctness, unnecessary actions, loaded context, and available run-cost metrics.
Choose the shorter clear form only when it preserves the required behavior.
An arbitrary word limit, a shorter main file with larger references,
or a convincing completion statement does not establish improvement.

Validate the final integrated form:

- Run the available runtime validator and check affected resources and links.
- For semantic changes, run the target, relevant regressions, and adjacent valid cases.
  For mechanical-only changes, use the corresponding mechanical check.
- Test changed discovery routes separately from application after loading.
- Inspect substantial generated artifacts independently against the quality bar.
- Repeat important or variable cases and report observed results and material gaps.

For reusable behavioral boundaries, retain scenarios for future changes.
Before planning or creating those artifacts, read
[Test artifact templates](references/test-artifact-templates.md).
Keep test evidence and research notes outside execution guidance unless future
execution needs them.

Before delivery, delete any passage whose removal preserves the decisions,
required output, and necessary understanding.
Report the changed behavior, measured comparison, and remaining uncertainty.
