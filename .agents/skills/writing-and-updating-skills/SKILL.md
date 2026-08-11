---
name: writing-and-updating-skills
description: >
  Use when creating or updating skills, deciding when guidance should apply,
  testing skill behavior with subagents, repairing unclear triggers or observed
  misbehavior, designing pressure tests, closing loopholes, addressing
  rationalizations, or validating skill folders before deployment. Do not use
  for discussion or review when no skill artifact or behavioral evaluation is
  requested.
---

# Writing and updating skills

## Overview

Treat skill authoring as test-driven process design.
Observe how an agent fails without the guidance,
write or revise the skill to address that failure,
then pressure test until the desired behavior holds.

The goal is not to write a large document.
The goal is to make future agents reliably do the right thing with the least
context that can carry the behavior.

A useful skill teaches the agent enough to understand the work,
then gives it the procedure needed to act reliably.
Theory should help the agent predict unfamiliar cases:
who experiences the outcome, what forces or invariants govern it,
why one choice follows from those conditions,
and what evidence distinguishes success from failure.
Application boundaries say when that theory changes the next action.
Operational guidance says what to do and how to know it is complete.
None of these substitutes for the others when the task requires all three.

## Core workflow

Follow this loop for new skills and for edits to existing skills:

1. Orient to the requested behavior, target runtime, destination folder,
   and existing skill conventions.
   Inspect the target's instructions, architecture, tools, tests,
   and neighboring skills to find the local owner of each constraint.
   Use general authoring guidance only for a decision that local evidence leaves
   unresolved; adapt the governing idea instead of copying another skill's
   surface form.
   Classify the work as operational, judgment-plus-format, deterministic,
   or a mixture.
   Identify both the catalog trigger and the decisions the skill must prompt
   after it is loaded.
   Define the observable quality bar and whether the skill needs judgment or
   conformance before spending subagent runs.
   Orientation is complete when the target, representative input,
   and pass/fail boundary are clear.
2. **Red:** Capture failed evidence appropriate to the claim before drafting the
   repair.
   Behavior-shaping changes require failed agent behavior:
   test a new skill without its guidance,
   or an update against the current skill.
   Deterministic, retrieval, reference,
   or mechanical-contract changes may instead use the corresponding failed
   conformance or validation check.
   A passing baseline is not red.
   If realistic behavioral variants still pass,
   stop and report the reproduction gap;
   use the narrow inaccessible-boundary exception only when it applies.
3. Classify the owner of the failure before changing skill prose.
   Distinguish a skill-guidance gap from a test or evaluator gap, routing gap,
   application-support gap, unavailable capability, or missing authority.
   Enter green for skill guidance only when changing the skill can change the
   failed decision.
   Otherwise repair or report the owning boundary and rerun red there.
   For a skill-owned behavior gap, reconstruct the decision as the agent
   encountered it: what it could observe, what it inferred,
   which model made the failed choice seem reasonable,
   and which observable distinction should change the next action.
   Repair the earliest missing or incorrect distinction instead of encoding the
   observed symptom.
4. **Green:** Make the smallest candidate change that makes the failed evidence
   pass.
   Rerun the same evidence type; use fresh subagents for behavioral claims.
   Treat the passing candidate as proof of the repair direction,
   not as the finished skill.
5. **Refactor:** Integrate the repair into the existing skill and its routed
   resources.
   Replace or merge governing text, remove provisional headings and duplicated
   rules, and preserve distinct valid behavior.
   Rerun the failing scenario, applicable pressure or adjacent cases,
   and relevant regressions against the final integrated form.
   For artifact-producing skills, grade the artifact independently against the
   quality bar.
6. Close any remaining loophole by refining the existing guidance that owns the
   failed behavior.
   Keep a red flag or example only when it materially improves recognition
   without restating the rule, then repeat green and refactor for that failure.
7. Persist reusable behavioral tests when the scenario should protect future
   changes to the skill.
   Before adding or planning these artifacts,
   read `references/test-artifact-templates.md`.
8. Validate the folder mechanically and behaviorally before deployment.
   Validation is complete when the failing case, applicable variants,
   and relevant previously passing cases clear the bar.

Read `references/subagent-testing.md` before designing subagent validation,
running pressure tests, or repairing a loophole found during testing.

Choose the validation shape from the skill's behavioral purpose.
Discipline skills need pressure scenarios.
Technique and pattern skills need application, variation,
and counter-example scenarios.
Reference skills need retrieval, gap, and written-application checks.
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

1. **Selection:** What user intent or task state loads the skill?
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

| Skill shape | Required emphasis |
| --- | --- |
| Concrete operational workflow | Outcome recipient and takeaway, entry conditions, actors and state transitions, decision gates, bounded recovery, and observable proof after each material stage. |
| Judgment plus format | Outcome recipient, application and omission conditions, explicit dispositions, decision criteria, and format. |
| Small deterministic workflow | Applicability precondition, authoritative configuration, exact operation, result check, and bounded recovery. |

Keep required routing and procedure in `SKILL.md`.
Move bulky conditional mechanics to a reference or script and link it at the
decision that requires it.

## Write effective skills

Use the local skill format for the target runtime.
Create a folder named after the skill, use the runtime's required entrypoint,
and add any harness-specific metadata when that runtime expects it.

Keep the frontmatter focused on discovery:

- `name` is lowercase, hyphenated, and matches the folder.
- `description` says when to use the skill, including concrete triggers,
  symptoms, file types, tools, or failure modes.
- Name a nearby non-use boundary when adjacent intent could plausibly select the
  skill for work it does not govern.
- Avoid stuffing the description with the workflow.
  If the description fully summarizes the steps,
  an agent may follow the summary instead of loading the body.

Choose the instruction form from the causal shape of the failure.
More forceful wording does not repair a missing model or a bad output contract.

| Failure shape | Useful form |
| --- | --- |
| Agent lacks the model needed to choose | Explain the causal relationship and the evidence that distinguishes cases. |
| Behavior should change under an observable condition | State the predicate and the distinct dispositions it selects. |
| A produced artifact omits or buries required content | Give a positive structure or required slot at the point of production. |
| Agent understands a required gate but skips it under pressure | Use a bright-line gate; add counters or red flags only for observed, reusable rationalizations. |

Keep `SKILL.md` focused on the operating contract:

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
- Keep frequently used skills especially compact.
  Move bulky examples, rare cases, command references,
  and repeated workflow details into referenced files or existing tools.
- Prefer one strong example over several similar examples.
  Add another example only when it materially improves recognition or
  application, or protects a distinct decision boundary.
- Use examples to teach the recurring symptom, the evidence that reveals it,
  and the decision boundary.
  Keep incident-specific implementation details out of durable guidance unless
  the skill teaches a required format or procedure.
- Check size when a skill starts to sprawl.
  If a skill is hard to scan, split reference material out before adding more
  primary guidance.
- Put rare, bulky, or optional details in one-level reference files.
  Link each reference at the condition that requires it and say what authority
  it supplies.
- Add scripts only when deterministic behavior matters or the same code would
  otherwise be rewritten often.
- Add assets only when the skill uses them in outputs.
- Do not add README, changelog, installation guide,
  or process notes unless the runtime explicitly requires them.
- Give ordered steps checkable completion criteria.
  Disclose a finding that materially affects the user's current decision when it
  is discovered; workflow order governs execution and presentation,
  not disclosure.

## Update existing skills

Start from the observed malfunction, not from a broad rewrite impulse.

For each update:

1. Identify the failing behavior, the prompt or scenario that exposed it,
   and the part of the skill the agent likely relied on.
   Locate the existing rules, tables, examples,
   and references that govern the affected boundary before deciding where the
   repair belongs.
   Reproduce a reported behavioral failure against the current skill before
   drafting its repair.
   If the baseline passes, follow the non-reproduction loop in
   `references/subagent-testing.md`.
   If the failure reproduces, classify its owner before changing guidance.
   A test, routing, support, capability, or authority failure is not repaired by
   adding skill prose.
2. Generalize the failure before drafting the patch.
   For behavior-shaping repairs, name the boundary the failure exposed before
   writing normative text:

   ```markdown
   Invariant:
   <general boundary future agents must preserve>

   Observed symptom:
   <concrete failure that revealed the boundary>

   Adjacent valid case:
   <nearby case the repair must still permit>
   ```

   Only the invariant belongs in the primary rule.
   Use observed symptoms and adjacent valid cases in examples, red flags,
   or retest scenarios instead.
3. **Green:** Make the smallest candidate change in the section that owns the
   failure.
   Derive every normative sentence from the user's requested behavior,
   retained valid guidance, or authoritative evidence.
   State the repair as positive criteria and rerun the failing scenario.
4. **Refactor:** Treat the passing candidate as material to integrate,
   not a section to append.
   Read the affected primary guidance and references together.
   Replace, narrow, merge, or delete existing text so each requirement has one
   governing home.
   Preserve distinct requirements and unrelated valid behavior.
   Keep a heading, red flag, table row,
   or example only when it protects a distinct decision or improves recognition
   without restating the rule.
   Rerun the failing scenario and affected regressions against the final
   integrated skill.
   A prose-only change still needs behavioral validation when the skill is meant
   to shape agent behavior.
   Persist a reusable analogue of a reproduced behavioral failure unless another
   owned test suite already protects the same boundary.

Common repairs:

| Observed failure | Repair |
| --- | --- |
| Skill does not trigger | Add concrete symptoms to the description. |
| Skill triggers too broadly | Narrow the description and add non-use boundaries. |
| Agent knows what good looks like but omits or overproduces the artifact | Add the in-task condition for acting, the adjacent condition for not acting, and the next step at that decision point. |
| Agent repeats the theory without changing behavior | Pair the governing principle with a concrete decision, action, and completion check. |
| Agent skips a required step | Move the step earlier and make the decision point explicit. |
| Agent ends a step early | Replace the vague done-condition with an observable completion criterion. |
| Agent passes only because an input was volunteered | Add the elicitation or inspection step that reliably obtains the input. |
| Agent follows a shortcut | Refine the governing rule; retain a red flag only when the shortcut remains hard to recognize. |
| Agent misses a detail | Move rare detail to a reference and link it at the decision point. |
| Agent treats testing as optional | Make the existing validation gate explicit before deployment. |
| Agent overfits a repair to one observed example | Replace the symptom-specific rule with positive criteria for the underlying decision boundary, then test an adjacent valid case. |
| Several ordered stages collapse into one response | Make each stage's deliverable checkable and progressively disclose later stages when needed. |
| Agent withholds a finding because it belongs to a later stage | Disclose findings that materially affect the user's current decision when discovered. |
| Guidance points to transient paths, lines, or constants | State the durable boundary and direct the agent to locate the current owner. |
| Guidance has accumulated repeated or stale rules | Prune, merge, or move them behind the relevant reference pointer. |
| Guidance does not change the agent's next action | Remove the no-op. |

## Test with subagents

Use subagents as independent validation surfaces.
The point is to learn whether the skill transfers,
not whether another agent can infer your intended answer.
Read `references/subagent-testing.md` before designing the evaluation;
it owns runner isolation, held-out inputs, pressure design,
independent artifact grading, repetition, and regression mechanics.

Keep these boundaries in the primary workflow:

- Test selection and application separately.
  A trigger-selection runner receives the task and skill catalog but not the
  target skill path or body; an application runner receives the selected skill
  and realistic task.
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

When a skill update exposes a durable behavioral boundary,
leave behind reusable test artifacts for future maintainers.
Use a `tests/` directory when the target skill does not already define another
test location.
Any plan to add or update persisted tests is incomplete until it reads
`references/test-artifact-templates.md` and uses that file for the test README,
scenario template, and skill footer.

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
It should distinguish application tests from trigger-selection tests and explain
any independent artifact-grading step.

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

Before considering a skill ready:

- Run the runtime's validator when available.
- Inspect the file list for clutter or missing resources.
- Confirm frontmatter is valid and trigger-focused.
- Confirm each required behavior supplies the applicable parts of the selection,
  application, model, action, and evidence contract.
- Confirm the skill does not merely define a good artifact;
  it must make the decision to create, omit, or change that artifact reliable.
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

If testing reveals a new loophole, revise the skill and repeat the relevant
scenario.
Do not treat the first passing run as enough when the skill enforces discipline
under pressure.

## Tests

When changing this skill, read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
Before adding or updating persisted test artifacts, read
[the test artifact templates](references/test-artifact-templates.md).
