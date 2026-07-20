# Subagent Testing For Skills

Use this reference before validating skill behavior with subagents,
designing pressure tests,
or repairing loopholes discovered during testing.

## When To Test

Use subagent tests for skills that enforce discipline,
have compliance costs,
can be rationalized away,
or contradict immediate pressure.

Do not pressure-test pure reference skills,
skills without rules to violate,
or skills agents have no incentive to bypass.
For those,
use retrieval,
gap,
or written application checks instead.

## Test Shapes

Baseline tests show what agents naturally do before the new guidance exists.
For a new skill,
run them without the skill.
For an update,
run them against the current skill before drafting the behavior-changing edit.
A baseline is RED only when it produces the behavior the repair must prevent.
A passing baseline does not show that a proposed repair addresses the report.

Pressure tests show whether the skill holds
when the agent has a reason to skip,
reinterpret,
or minimize the guidance.
Run them after the skill or update exists.

Subagent tests should be isolated.
They test choices,
rationalizations,
and expected use of the skill;
they should not mutate shared files,
create commits,
publish artifacts,
deploy systems,
or modify external state.
If tool use is necessary,
limit it to read-only inspection
or artifacts under a task-local temporary directory
outside the target repository.

## Prepare The Evaluation

Before spending subagent runs,
resolve the target skill and a representative input,
then define the quality bar a useful result must clear.
The bar should state the observable outcome and the smells that demonstrate
failure.
If either the input or bar is unavailable,
ask for the missing information instead of inventing an evaluation.

Choose the evaluation mode:

- Judgment:
  state the outcome and failure smells,
  then allow defensible differences in structure or approach.
  Do not turn the bar into a prescribed answer.
- Conformance:
  list the required fields, format, procedure, or other fixed contract
  the result must satisfy.

```markdown
Input:
<representative task or artifact>

Quality bar:
<observable outcome a competent practitioner should achieve>

Failure smells:
<behaviors or omissions that demonstrate the bar was missed>

Evaluation mode:
judgment | conformance
```

Give the runner the prompt and representative input.
Keep the Quality Bar, Expectations, and proposed repair outside the runner
prompt;
the evaluator or judge applies them afterward.

## Skill Kinds And Test Shapes

Use the test shape that matches the skill kind.
Many skills mix kinds;
test the behavior that carries the highest risk.

- Discipline skills:
  force a concrete choice under pressure.
  Examples:
  test-first development,
  release readiness,
  verification-before-completion,
  safety reviews,
  and approval gates.
- Technique and pattern skills:
  ask for the plan,
  diagnosis,
  transformed snippet,
  or patch sketch the skill would produce.
  Examples:
  condition-based waiting,
  root-cause tracing,
  reducing complexity,
  defensive programming,
  and dependency upgrade triage.
- Reference skills:
  ask the subagent to retrieve and apply the relevant information
  in a written answer.
  Examples:
  command references,
  API guides,
  file-format notes,
  schema references,
  and style guides.
- Trigger-selection tests:
  present the task and an available-skill catalog,
  but withhold the target skill path and body.
  Test positive triggers, alternate user wording,
  competing skill descriptions,
  and nearby non-use cases.
- Artifact-producing skills:
  ask a runner to produce the artifact,
  then grade that artifact against the quality bar.
  A convincing rationale does not establish that the artifact is useful.

```text
Given the skill at /path/to/skill and the scenario below,
choose the next action and explain briefly.
Do not implement the choice.

Scenario:
[pressure scenario and options]
```

```text
Given the skill at /path/to/flaky-test-repair
and the intermittent failure below,
write the diagnostic plan and smallest likely fix.
Do not modify files or external state.

Failure:
The checkout test fails about once every 20 CI runs.
The failing assertion expects the confirmation email job to be queued.
Local reruns pass unless the full payment suite runs first.
```

Avoid prompts that leak the answer:

```text
Review this flaky-test skill and confirm whether it should mention
shared-state pollution.
```

For trigger-selection tests,
passing the target skill path is an answer leak:

```text
Available skills:
- schema-migration: Plans and performs live schema changes.
- schema-inspection: Explains or inspects existing schemas.

User request:
Rename a nullable column while writes continue.

Choose the skill or skills you would load and explain briefly.
```

## Grade Artifacts Independently

When the skill produces an artifact,
use separate runner and judge roles:

1. Give a fresh runner the skill path and representative input.
   Withhold the Quality Bar, Expectations, other cases,
   and proposed repair.
   Capture the artifact without modifying shared state.
2. Give a separate fresh judge the artifact, source input, quality bar,
   and the target skill's governing principles.
   Withhold any expected artifact and do not ask the judge to make the run pass.
3. Require the judge to cite the source-and-output evidence behind each verdict.
   A numeric score alone can hide which part of the bar failed.
4. Diagnose a failing verdict as a skill gap or a bad case.
   If the bar punishes a defensible choice or requires behavior outside the
   skill's purpose,
   repair the case instead of bending the skill to pass it.

For a simple decision test,
the parent evaluator can apply the stated expectations directly.
Use an independent judge when the artifact or judgment boundary is substantial.

## Account For Variability And Regressions

One passing run is weak evidence for intermittent or borderline behavior.
Run important or borderline cases two or three times with fresh subagents,
record the observed pass rate,
and retain the raw failures.
A case that passes once and fails twice remains a failure.

After repairing a skill,
rerun the failing case, applicable variants,
and relevant previously passing cases.
The regression sweep should exercise every retained behavior the repair could
plausibly affect,
not every unrelated scenario in the folder.

## Baseline Prompt Pattern

For a new skill,
use no skill path for baseline tests.
For an update,
use the current skill before the proposed change.
Give only the realistic task,
constraints,
and raw artifacts.

```text
A user asks you to diagnose an intermittent CI test failure.
They say the release branch closes in 20 minutes,
the test passed on rerun,
and a reviewer suggested bumping the timeout.

Produce the next action you would take
and the validation evidence you would collect.
Be concrete.
```

Look for failures such as:

- Accepting a rerun-only pass as sufficient.
- Bumping a timeout without evidence.
- Skipping diagnosis because the release is urgent.
- Ignoring order dependence or shared-state clues.
- Reporting confidence without repeat validation.

## When A Reported Failure Does Not Reproduce

Do not draft a behavioral repair after passing baselines.
Passing runs show only that the tested scenario passed;
agent behavior varies between isolated runs,
and a weak scenario can hide the reported decision.
Strengthen the reproduction campaign first:

1. Recover the failed prompt, skill revision, task inputs, tool availability,
   and relevant runtime state when they are available.
   Replay the decision point against the current skill without leaking the
   diagnosis, expected answer, or proposed patch to the tested subagent.
2. Check the test itself.
   Make the expected behavior and pass/fail boundary unambiguous,
   remove accidental hints and shared state,
   and confirm that the scenario permits the reported shortcut.
   A search proving that a sentence is absent or present is a text check,
   not a behavioral regression test.
3. Match the scenario to the reported behavior.
   For discipline-enforcing guidance,
   make the shortcut attractive with at least three realistic pressures,
   force a concrete action,
   and remove easy deferrals.
   For technique and reference guidance,
   use realistic application, variation, retrieval, or gap cases.
   Vary trigger wording, inputs, workflow stage,
   and available evidence while preserving the same behavioral boundary.
4. Run several fresh, isolated subagents and capture raw choices,
   skipped steps,
   and rationalizations.
   Use the attempts that produce the failure as RED evidence;
   passing attempts are useful contrast,
   not permission to write an unproven repair.

If realistic variants still pass,
stop the repair and report the reproduction gap.
Request the missing transcript, runtime signal, or distinguishing context.
Approval, urgency, a small diff,
and a claim that extra guidance cannot hurt do not make a passing baseline RED.

When a required runtime boundary is genuinely inaccessible
and the user explicitly requires preventive hardening anyway,
make only a narrowly supported change and label it preventive.
A missing transcript alone is not an inaccessible boundary.
When a task-local analogue can still exercise the reported decision,
continue the reproduction campaign instead of using this exception.
Validate the reachable decision boundary,
state that the reported behavior was not reproduced,
and preserve the missing runtime check as an explicit validation gap.
Do not describe that exception as a verified fix.

## Pressure Scenario Pattern

Combine several pressures and force an action.
The prompt should make the shortcut attractive.
Use concrete options,
real constraints,
real paths when relevant,
and no easy option to defer the decision.

```text
Use the skill at /path/to/release-readiness.

The release branch closes in 15 minutes.
The smoke test failed once,
passed on rerun,
and the release manager says to ship because the change is small.

Choose the next action:
A. Ship because the rerun passed.
B. Ask the release manager to decide because the evidence is mixed.
C. Inspect the failed check signal before making the release decision.

Explain briefly.
Do not execute the choice.
```

A good result chooses the action that preserves the skill's boundary,
cites the relevant guidance,
and avoids expanding scope without evidence.

## Useful Pressure Types

Use at least three pressures for discipline skills:

| Pressure | Example |
| --- | --- |
| Time | "The release branch closes in 15 minutes." |
| Sunk cost | "You already wrote the fix and it passes locally." |
| Authority | "The reviewer says the rerun is enough." |
| Exhaustion | "It is late and this is the third revision." |
| Social | "You do not want to look rigid." |
| Ambiguity | "The failure might be unrelated to your change." |
| Small change | "It is just a one-line fix." |

## Rationalization Capture

Record failures in this shape:

```markdown
## Scenario
[Prompt and constraints.]

## Expected behavior
[What the skill should cause the agent to do.]

## Observed behavior
[What the subagent did.]

## Exact rationalizations
- "[Quote exact wording.]"
- "[Quote exact wording.]"

## Likely gap
[Trigger, ordering, missing rule, vague boundary, test leak, or weak scenario.]

## Repair
[Smallest guidance or scenario repair that should prevent the same failure.]
```

Exact wording matters.
Do not summarize a rationalization as "the agent made excuses"
when the repair depends on the excuse's shape.

For each new rationalization,
diagnose and repair the exposed gap concretely:

- For behavior-shaping repairs,
  identify the invariant,
  the observed symptom,
  and an adjacent valid case before drafting normative text.
- Identify whether the failure exposes a skill gap or a test gap.
- For a skill gap,
  locate and refine the rule, table, example, or reference that already
  governs the boundary using positive criteria.
- For a test gap,
  repair the scenario, setup, or answer leak before changing guidance.
- Use a direct negation only when the workaround is always invalid
  across the skill's intended use cases.
- Keep a rationalization row, red flag, or example for a skill gap when it
  materially improves recognition or application without restating the rule.
- Update the description if the rationalization is a trigger symptom.
- Rerun the scenario that exposed the loophole.

Audit overfitting before treating a repair as ready:

- Read the affected primary guidance and references together.
- Consolidate redundant requirements and retain repetition only where a
  separate decision point needs it.
- Preserve normative clauses that protect a distinct boundary or are needed at
  a separate decision point.
- Keep rows or examples only when they materially improve recognition or
  application without restating the rule.
- Search the draft repair for terms copied from the observed failure.
- Keep copied terms in normative guidance only when they name the stable
  boundary across intended use cases.
- Move symptom details into examples,
  red flags,
  or retest scenarios when they are only the case that exposed the boundary.
- Test an adjacent valid case so the repair does not outlaw valid behavior.

Use the smallest repair that preserves the boundary exposed by the loophole.
Then retest in this order:

1. Rerun the exact failing scenario.
2. Rerun a pressure variant with the same temptation.
3. If a new rationalization appears,
   capture it verbatim and repeat the repair loop.

Common red flags:

| Red flag | Treat as |
| --- | --- |
| "Just documentation" | Behavior-shaping prose still needs behavioral validation. |
| "Small change" | A pressure to skip validation, not an exemption. |
| "Obvious fix" | A reason to run the scenario that exposed the gap. |
| "Spirit, not letter" | A likely boundary violation. |
| "Test after" | Loss of proof that the test can catch the failure. |
| "Ask permission" while arguing for violation | A disguised attempt to bypass the skill. |
| Hybrid workaround | A new loophole; capture and repair it. |

## Meta-Test Prompt

When a subagent fails despite having the skill,
ask a follow-up that exposes whether the problem is wording,
organization,
or deliberate noncompliance.
This diagnoses a failed scenario;
it does not replace baseline or pressure tests.

```text
You read the skill and still chose [failing action].

How should the skill have been written or organized
to make [correct action] the clear next step?
If the skill already made that clear,
say so and explain what you ignored.
```

Use the answer carefully:

- If the subagent names missing wording,
  integrate or sharpen that wording in the governing guidance.
- If the subagent missed an existing section,
  move the guidance earlier or link it at the decision point.
- If the subagent says the skill was clear,
  inspect the scenario, setup, and answer leaks before changing guidance.
  Repair a test gap in the scenario;
  for an evidenced skill gap,
  refine the boundary or retain a useful recognition aid.

## Sufficient Testing Checklist

A skill is ready when evidence shows that agents can use it,
not merely recite it.

- A new skill was tested without its guidance,
  or an update was tested against the current skill.
- Reproduced behavior-changing repairs have a failing pre-change scenario
  with failures captured verbatim.
  Narrowly supported preventive changes have reachable-boundary validation
  and an explicit unreproduced-runtime gap.
- The new or changed guidance addresses an observed failure
  or the narrowly supported preventive boundary.
- A fresh subagent ran a realistic isolated scenario with the skill.
- The evaluation has a representative input and an observable quality bar.
- Judgment tests permit defensible variation;
  conformance tests state the fixed contract.
- Trigger-selection tests withhold the target path and body
  and cover positive and nearby non-use cases.
- Artifact-producing tests grade the artifact with cited source-and-output
  evidence.
- Discipline tests combined multiple pressures
  and forced a concrete choice with no easy out.
- For reproduced repairs,
  the same failing scenario passes after the change.
- Important or borderline cases have repeated-run evidence,
  and relevant previously passing cases were rerun.
- The passing subagent cites or relies on the relevant guidance.
- When a subagent fails,
  meta-testing was used to diagnose whether the skill was unclear.
- Mechanical validation passes.
- Remaining risks are reported explicitly.

A skill is not ready if the subagent finds a new rationalization,
argues the skill is wrong,
creates a hybrid workaround,
or asks for permission while arguing for the violation.

If a new rationalization appears,
capture and diagnose it.
Revise the governing guidance or behavioral scenario when the evidence exposes
a gap,
then rerun the scenario that exposed it.
