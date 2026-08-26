---
name: writing-agent-guidance
description: >
  Use when creating, updating, or testing agent-facing guidance, including
  skills, AGENTS.md, CLAUDE.md, and references linked from them; deciding when
  guidance should be reached or applied; repairing unclear triggers, pointers,
  or observed misbehavior; designing pressure tests; closing loopholes; or
  validating guidance before deployment. Do not use for ordinary prose that
  does not steer agent behavior, or for discussion or review when no guidance
  artifact or behavioral evaluation is requested.
---

# Writing agent guidance

## Overview

Treat agent-guidance authoring as test-driven process design.
Observe how an agent fails without the guidance,
make the smallest repair that changes that behavior,
integrate the repair into its governing guidance and routed resources,
then validate the complete integrated result.

The goal is not to write a large document.
The goal is to make future agents reliably do the right thing with the least
context that can carry the behavior.

A useful guidance system teaches the agent enough to understand the work,
then gives it the procedure needed to act reliably.
Theory should help the agent predict unfamiliar cases:
who experiences the outcome, what forces or invariants govern it,
why one choice follows from those conditions,
and what evidence distinguishes success from failure.
Application boundaries say when that theory changes the next action.
Operational guidance says what to do and how to know it is complete.
None of these substitutes for the others when the task requires all three.

## Core workflow

Follow this loop for new guidance and for edits to existing guidance:

1. Orient to the requested behavior, target runtime, destination,
   entry mechanism, and existing guidance conventions.
   Inspect the target's instructions, architecture, tools, tests,
   and neighboring guidance to find the local owner of each constraint.
   Use general authoring guidance only for a decision that local evidence leaves
   unresolved; adapt the governing idea instead of copying another skill's
   surface form.
   Classify the work as operational, judgment-plus-format, deterministic,
   or a mixture.
   Identify how the guidance enters context or is reached,
   then identify the decisions it must prompt after entry.
   Define the observable quality bar and whether the guidance needs judgment or
   conformance before spending subagent runs.
   Orientation is complete when the target, representative input,
   and pass/fail boundary are clear.
2. **Red:** Capture failed evidence appropriate to the claim before drafting the
   repair.
   Behavior-shaping changes require failed agent behavior:
   test new guidance without the candidate,
   or an update against the current guidance.
   Deterministic, retrieval, reference,
   or mechanical-contract changes may instead use the corresponding failed
   conformance or validation check.
   A passing baseline is not red.
   If realistic behavioral variants still pass,
   stop and report the reproduction gap;
   use the narrow inaccessible-boundary exception only when it applies.
3. Classify the owner of the failure before changing guidance prose.
   Distinguish a guidance gap from a test or evaluator gap, routing gap,
   application-support gap, unavailable capability, or missing authority.
   Enter green for guidance only when changing it can change the
   failed decision.
   Otherwise repair or report the owning boundary and rerun red there.
   For a guidance-owned behavior gap, reconstruct the decision as the agent
   encountered it: what it could observe, what it inferred,
   which model made the failed choice seem reasonable,
   and which observable distinction should change the next action.
   Ground that reconstruction in the runner's visible context and captured
   reasoning, not a claim about hidden motives.
   Treat it as a falsifiable hypothesis: change the earliest distinction
   it identifies, then rerun the same scenario.
   Repair the earliest missing or incorrect distinction instead of encoding the
   observed symptom.
4. **Green:** Make the smallest candidate change that makes the failed evidence
   pass.
   Rerun the same evidence type; use fresh subagents for behavioral claims.
   Treat the passing candidate as proof of the repair direction,
   not as the finished guidance.
5. **Refactor:** Inspect the complete affected guidance
   and its directly routed resources.
   Integrate the passing repair into its governing text,
   merge or remove provisional and duplicated material,
   and preserve distinct valid behavior.
   Account for each changed requirement and its one governing home,
   verify that affected routes reach it,
   and record the disposition of each provisional addition.
   This pass is complete only when that integration evidence exists,
   including when inspection establishes that no further edit is necessary.
6. Close any remaining loophole by refining the existing guidance that owns the
   failed behavior.
   Keep a red flag or example only when it materially improves recognition
   without restating the rule, then repeat green and refactor for that failure.
7. Persist reusable behavioral tests when the scenario should protect future
   changes to the guidance.
   Before adding or planning these artifacts,
   read `references/test-artifact-templates.md`.
8. After the recorded integration pass,
   validate the affected guidance mechanically and behaviorally.
   Rerun the failing scenario, applicable pressure or adjacent cases,
   and relevant regressions against the final integrated form.
   For artifact-producing guidance,
   grade the artifact independently against the quality bar.
   Validation is complete when the integration result
   and final-form evidence establish the requested behavior.

Read `references/subagent-testing.md` before designing subagent validation,
running pressure tests, or repairing a loophole found during testing.

Choose the validation shape from the guidance's behavioral purpose.
Discipline guidance needs pressure scenarios.
Technique and pattern guidance needs application, variation,
and counter-example scenarios.
Reference guidance needs retrieval, gap, and written-application checks.
Use `references/subagent-testing.md` for the detailed test shapes.

## Build understanding and execution

The direct reader is the agent performing the task.
Write theory to give that agent a usable model, not to sound generally wise.
Introduce the outcome recipient, relevant state, causal relationships,
invariants, and evidence before asking the agent to reason from them.
Name what the outcome recipient already knows and what the recipient must
decide, do, or observe.
Derive the required output from the gap between those states;
omit content that does not change the recipient's outcome.
A principle earns space when it helps the agent explain a choice,
predict a new case, or recognize when the procedure changes.
Use a small example when it makes that model concrete;
change one material condition at a time so the boundary remains visible.

For each required behavior, make the applicable parts of this contract explicit:

1. **Entry:** What user intent, task state, scope, or pointer makes the guidance
   available or causes the agent to reach it?
2. **Application:** What condition means act now,
   and when is another action or no action correct?
3. **Model:** What reader need, causal relationship, invariant,
   or risk explains the choice?
4. **Action:** What concrete step, format, command, reference, or tool follows?
5. **Evidence:** What observable result establishes completion?

A quality model is incomplete when the agent cannot tell when to use it.
For judgment artifacts, name each materially different disposition such as
create, update, keep, or omit instead of leaving the action implicit.
Put that decision where the agent encounters it.

Match the emphasis to the work:

| Guidance shape | Required emphasis |
| --- | --- |
| Concrete operational workflow | Outcome recipient and takeaway, entry conditions, actors and state transitions, decision gates, bounded recovery, and observable proof after each material stage. |
| Judgment plus format | Outcome recipient, application and omission conditions, explicit dispositions, decision criteria, and format. |
| Small deterministic workflow | Applicability precondition, authoritative configuration, exact operation, result check, and bounded recovery. |

## Design the guidance architecture

Choose the artifact from how and when the agent must receive the guidance:

| Artifact | Entry mechanism | Governing content |
| --- | --- | --- |
| Model-invoked skill | Selected from a catalog description | A reusable workflow or body of guidance the agent must discover for relevant tasks. |
| Automatically loaded instruction file | Loaded for every task in its directory or configured scope | Rules and routing needed throughout that scope. |
| Linked reference | Reached through a pointer in another guidance document | Material needed only by the branch named in that pointer. |

Packaging changes entry, not the writing model.
Use the same application, model, action, and evidence contract after the
guidance enters context.

Treat each description or other pointer in the agent's current context as a
routing interface.
It names material outside that context and the condition that
should cause the agent to reach it.
Its wording controls reliable discovery,
so test it as part of the guidance rather than treating the referenced material
as sufficient on its own.

Keep in the current guidance document the procedure and knowledge every path
through that document needs.
For a distinct branch, move conditional mechanics to a one-level reference or
script and link it at the decision that enters that branch.
The decision is reach, not length: a short branch-specific rule can obscure the
main path, while a bulky rule that every path needs belongs in the current
guidance document.

Use the same established term in the pointer, destination heading,
and surrounding task vocabulary when it accurately names the same decision.
This makes the route recognizable before entry and reinforces the concept after
the agent follows it.

Keep each requirement in one governing home.
Link to authoritative commands, configuration, source, policy,
or external specifications instead of copying facts that the agent can retrieve
cheaply.
Copy only what is expensive to recover or what the source does not carry,
such as an unwritten convention, rationale, or durable gotcha.

Splitting a document creates progressive disclosure only when the later material
sits behind a real context boundary.
A later section in the same loaded document changes organization,
but it does not hide post-completion steps from the agent.

Within each guidance document,
distinguish an execution sequence from reference material.
Put dependent actions in the order the agent must perform them.
Keep independently consulted definitions, rules, and criteria as a peer set;
do not invent an order that changes no decision.

## Write effective guidance

Use the local format and routing conventions for the target runtime.

Keep model-invoked skill frontmatter focused on discovery:

- `name` is lowercase, hyphenated, and matches the folder.
- `description` says when to use the skill, including concrete triggers,
  symptoms, file types, tools, or failure modes.
- Treat the description as a context pointer:
  name each distinct trigger branch once, front-load the material identifier
  agents will recognize, and remove synonymous trigger lists.
- Reuse the target's established terms for concepts that guide discovery or
  reasoning, especially in descriptions and decision headings.
  Coin a term only when it materially compresses a repeated distinction,
  define it at first use, and verify that it changes runner behavior.
- Name a nearby non-use boundary when adjacent intent could plausibly select the
  skill for work it does not govern.
- Avoid stuffing the description with the workflow.
  If the description fully summarizes the steps,
  an agent may follow the summary instead of loading the body.
- When the runtime distinguishes autonomous and manual invocation,
  choose autonomous discovery only when the agent or another skill must reach
  the skill without the user naming it.
  Otherwise prefer the mode that avoids permanent catalog context when users
  can reliably find the skill.

For automatically loaded instruction files:

- Keep only rules and routing that apply throughout the file's scope.
- Point to branch-specific guidance at the condition that requires it.
- State the target and the condition in the pointer;
  a bare path supplies identity but not reliable routing.

For linked references:

- Assume the parent pointer supplied the branch context;
  do not repeat the entire parent document.
- Start with the decision, procedure, or reference material the branch needs.
- Keep definitions, rules, and caveats for one concept together.

Choose the instruction form from the causal shape of the failure.
More forceful wording does not repair a missing model or a bad output contract.

| Failure shape | Useful form |
| --- | --- |
| Agent lacks the model needed to choose | Explain the causal relationship and the evidence that distinguishes cases. |
| Behavior should change under an observable condition | State the predicate and the distinct dispositions it selects. |
| A produced artifact omits or buries required content | Give a positive structure or required slot at the point of production. |
| Agent understands a required gate but skips it under pressure | Use a bright-line gate; add counters or red flags only for observed, reusable rationalizations. |

Keep the governing document focused on the operating contract:

- Explain only the knowledge a capable agent would not already know.
- Match specificity to risk.
  Fragile workflows need exact commands;
  judgment-heavy work needs principles and checks.
- Pair principles with their decision points.
  State what observable condition invokes the principle and what the agent
  should do next.
- Keep required gates and completion checks near the actions they govern.
  Do not bury them in background prose or expect the agent to reconstruct them
  from a distant theory section.
- Keep frequently used guidance especially compact.
  Keep the main path visible; defer examples, command references, and mechanics
  reached only by particular branches.
- Prefer one strong example over several similar examples.
  Add another example only when it materially improves recognition or
  application, or protects a distinct decision boundary.
- Use examples to teach the recurring symptom, the evidence that reveals it,
  and the decision boundary.
  Keep incident-specific implementation details out of durable guidance unless
  the guidance teaches a required format or procedure.
- Check the information hierarchy when a guidance system starts to sprawl.
  Split reference material only when a branch or sequence needs a real context
  boundary, not merely to lower the line count.
  Keep distinct rules co-located with their definitions and caveats.
- Put branch-specific details in one-level reference files.
  Link each reference at the condition that requires it and say what authority
  it supplies.
- For skill packages, add scripts only when deterministic behavior matters or
  the same code would otherwise be rewritten often.
  Add assets only when the skill uses them in outputs,
  and do not add package documentation the runtime does not require.
- Give ordered steps completion criteria that are checkable and appropriately
  demanding for their scope.
  Give reference-only work an exhaustive application bound,
  such as accounting for every applicable rule or affected entity.
  Prefer an exhaustive observable bound such as "each affected rule has one
  governing home" over an aspirational bound such as "review the guidance."
  Disclose a finding that materially affects the user's current decision when it
  is discovered; workflow order governs execution and presentation,
  not disclosure.

## Update existing guidance

Start from the observed malfunction, not from a broad rewrite impulse.
Apply the core workflow, with these update-specific checks:

1. Locate the current entry mechanism,
   the guidance the agent likely relied on,
   and every primary rule, pointer, example, reference,
   and test that governs the affected boundary.
2. For a behavior-shaping repair,
   generalize the failure before drafting normative text:

   ```markdown
   Invariant:
   <general boundary future agents must preserve>

   Observed symptom:
   <concrete failure that revealed the boundary>

   Adjacent valid case:
   <nearby case the repair must still permit>
   ```

   Put only the invariant in the primary rule.
   Use observed symptoms and adjacent valid cases in examples, red flags,
   or retest scenarios instead.
3. Derive every normative sentence from the user's requested behavior,
   retained valid guidance, or authoritative evidence.
   Preserve unrelated valid behavior within the authorized scope.

The core workflow owns red, green, refactor, and failure classification.
Do not restate that lifecycle in an update-specific section or reference.

Common repairs:

| Observed failure | Repair |
| --- | --- |
| Model-invoked skill is not selected | Add the missing distinct trigger branch to the description, then rerun catalog-selection tests. |
| Guidance is reached too broadly | Remove non-distinct routing wording, narrow the relevant branch, and test a nearby non-use case. |
| Linked guidance is not reached | Put the pointer at the decision that needs the reference, name the target and condition, then rerun pointer-reach tests. |
| Agent knows what good looks like but omits or overproduces the artifact | Add the in-task condition for acting, the adjacent condition for not acting, and the next step at that decision point. |
| Agent repeats the theory without changing behavior | Pair the governing principle with a concrete decision, action, and completion check. |
| Agent skips a required step | Move the step earlier and make the decision point explicit. |
| Agent ends a step early | Replace the vague done-condition with an observable completion criterion. |
| Agent passes only because an input was volunteered | Add the elicitation or inspection step that reliably obtains the input. |
| Agent follows a shortcut | Refine the governing rule; retain a red flag only when the shortcut remains hard to recognize. |
| Agent misses a detail | Put the detail with the decision every path needs, or move a branch-specific detail to a reference linked at that decision. |
| Agent treats testing as optional | Make the existing validation gate explicit before deployment. |
| Agent overfits a repair to one observed example | Replace the symptom-specific rule with positive criteria for the underlying decision boundary, then test an adjacent valid case. |
| Several ordered stages collapse into one response | Make each stage's deliverable checkable; split later stages behind a real hand-off only when their visibility demonstrably causes premature completion. |
| Agent withholds a finding because it belongs to a later stage | Disclose findings that materially affect the user's current decision when discovered. |
| Guidance points to transient paths, lines, or constants | State the durable boundary and direct the agent to locate the current owner. |
| Guidance has accumulated repeated or stale rules | Prune, merge, or move them behind the relevant reference pointer. |
| Guidance does not change the agent's next action | Treat it as a no-op; confirm against a control, then remove it rather than merely rewording it. |

## Test with subagents

Use subagents as independent validation surfaces.
The point is to learn whether the guidance transfers,
not whether another agent can infer your intended answer.
Read `references/subagent-testing.md` before designing the evaluation;
it owns runner isolation, held-out inputs, pressure design,
independent artifact grading, repetition, and regression mechanics.

Keep these boundaries in the primary workflow:

- Test entry and application separately.
  A catalog-selection runner receives the task and skill catalog but not the
  target skill path or body.
  A pointer-reach runner receives the realistic task and upstream guidance with
  access to its references, but not the expected route.
  An application runner receives the target guidance and realistic task.
- Use a focused boundary test for red and green when one failed decision or
  fixed contract must be isolated.
- After refactor, use a full-prompt example when the final claim depends on
  complete task context, interactions among rules, or a substantial artifact.
- Keep every quality bar, expectation, diagnosis,
  and proposed repair hidden from the runner.
- Grade substantial judgment artifacts with a separate fresh judge.
- Keep trials read-only or confined to task-local temporary artifacts,
  retain raw outcomes, and report repeated-run evidence for important or
  borderline cases.

## Persist reusable tests

When a guidance update exposes a durable behavioral boundary,
leave behind reusable test artifacts for future maintainers.
Use a `tests/` directory when the target guidance does not already define
another test location.
Any plan to add or update persisted tests is incomplete until it reads
`references/test-artifact-templates.md` and uses that file for the test README,
scenario template, and guidance footer.

The lightweight default layout is:

```text
tests/
  README.md
  scenarios.md
```

`tests/README.md` explains how to run the reusable scenarios.
It should say to use fresh subagents with empty context windows,
hide expectations from the tested subagent,
keep tests read-only or confined to task-local temporary directories outside the
target repository, and compare the raw response with held-out expected and
unacceptable behavior afterward.
It should distinguish application tests from catalog-selection and pointer-reach
tests and explain any independent artifact-grading step.

`tests/scenarios.md` records the reusable gamut.
Store full-prompt examples or focused boundary tests according to the behavior
being protected, plus any special harness steps needed to reproduce the check.
Add pressure variants or adjacent valid cases when the claimed boundary requires
them.

Do not use a real failure as persisted scenario text verbatim.
Real failures are diagnostic evidence, not reusable test fixtures.
Persisted scenarios must be invented analogues that preserve the same behavioral
boundary, temptation, and expected decision without copying the real prompt,
private context, names, paths, data, or exact incident shape.

When a real failure produced useful rationalization wording,
capture the exact wording in the repair record.
For persisted tests, translate that wording into expectations, red flags,
or an invented pressure variant unless the quoted text is already generic and
safe to reuse.

## Pressure tests and loopholes

Pressure tests should make the wrong behavior tempting.
For discipline-enforcing guidance, combine at least three applicable pressures
at the decision point.
Use the pressure categories and loophole procedure in
`references/subagent-testing.md`.

When an agent misbehaves, capture the exact reasoning and use it to refine the
governing guidance or behavioral scenario.
Keep a separate rationalization entry only when it protects a distinct,
reusable recognition cue.
Use the common red flags in `references/subagent-testing.md` to recognize these
shortcuts without maintaining a second rationalization table.

## Validation

Before considering guidance ready:

- Run the runtime's validator when available.
- Inspect the affected file list for clutter or missing resources.
- For skills, confirm frontmatter is valid and trigger-focused.
- Confirm every catalog description and in-file pointer has one route per
  distinct branch, names the material it reaches, and does not summarize the
  workflow.
- Confirm main guidance contains what every execution path needs and each
  reference is linked at the branch decision that requires it.
- Confirm dependent actions appear in execution order,
  while independently consulted reference material remains a peer set.
- Confirm each retained requirement has one governing home and each copied
  authoritative fact earns its maintenance cost.
- Confirm each required behavior supplies the applicable parts of the entry,
  application, model, action, and evidence contract.
- Confirm the guidance does not merely define a good artifact;
  it must make the decision to create, omit, or change that artifact reliable.
- Confirm ordered work has observable completion criteria
  and reference-only work accounts for every applicable rule or affected entity.
- For operational artifacts intended for a viewer or reader,
  confirm the procedure derives visible content from that recipient's takeaway.
- Follow the sufficient testing checklist in `references/subagent-testing.md`.
- Repeat important or borderline scenarios and report their observed pass rate.
- Rerun relevant previously passing scenarios after the repair.
- Update or create persisted tests when the repair protects a reusable
  behavioral boundary.
- For updates, show the pre-change failure and rerun the same scenario after the
  repair, or state the narrow inaccessible-boundary exception and its validation
  gap.
- Treat a missing reproduction as a validation gap,
  not as evidence that speculative guidance fixed the report.
- Report the behavioral evidence, not only that the Markdown looked correct.

If testing reveals a new loophole, revise the guidance and repeat the relevant
scenario.
Do not treat the first passing run as enough
when the guidance enforces discipline under pressure.

## Tests

When changing this guidance, read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
Before adding or updating persisted test artifacts, read
[the test artifact templates](references/test-artifact-templates.md).
