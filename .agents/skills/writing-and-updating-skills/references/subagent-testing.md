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

Baseline tests show what agents naturally do without the new guidance.
Run them before writing or finalizing a new skill
or behavior-changing edit.
If you did not watch an agent fail without the skill,
you do not yet know whether the skill prevents the right failure.

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

## Likely skill gap
[Trigger, ordering, missing rule, vague boundary, or test leak.]

## Repair
[Smallest skill change that should prevent the same failure.]
```

Exact wording matters.
Do not summarize a rationalization as "the agent made excuses"
when the repair depends on the excuse's shape.

For each new rationalization,
repair the skill concretely:

- For behavior-shaping repairs,
  identify the invariant,
  the observed symptom,
  and an adjacent valid case before drafting normative text.
- Add positive criteria for the boundary the workaround violates.
- Use a direct negation only when the workaround is always invalid
  across the skill's intended use cases.
- Add the excuse to a rationalization table when the skill has one.
- Add a red flag for wording that signals the agent is about to violate.
- Update the description if the rationalization is a trigger symptom.
- Rerun the scenario that exposed the loophole.

Audit overfitting before treating a repair as ready:

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
  add or sharpen that wording.
- If the subagent missed an existing section,
  move the guidance earlier or link it at the decision point.
- If the subagent says the skill was clear,
  add a red flag or boundary statement for that rationalization.

## Sufficient Testing Checklist

A skill is ready when evidence shows that agents can use it,
not merely recite it.

- Baseline behavior was observed without the skill,
  and failures were captured verbatim.
- The new or changed guidance addresses observed failures.
- A fresh subagent ran a realistic isolated scenario with the skill.
- Pressure tests combined multiple pressures
  and forced a concrete choice with no easy out.
- The same failing scenario passes after repair.
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
the test campaign is still producing useful diagnostics.
Patch the skill and rerun the scenario that exposed it.
