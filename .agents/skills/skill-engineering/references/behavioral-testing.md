# Behavioral testing

Use behavioral tests to determine whether a skill changes decisions or outcomes
under the conditions it claims to govern.
A test is useful when the task genuinely needs the skill's judgment;
a task solved entirely from its prompt or local evidence says little about the
skill.

## Define the claim

State what behavior the skill should improve
and what observable result would weaken that belief.
Choose a representative task with enough information for a competent worker to
act.
Do not reward terminology, section recall, or access to the skill file.

Distinguish the evidence needed for different changes:

- A reported repair needs the failure under the prior guidance
  and the same case passing after the repair.
- A new skill or new requirement needs representative application cases;
  its baseline may succeed if the claim concerns consistency, transfer,
  proof quality, or recovery rather than basic capability.
- A mechanical edit outside runner-visible guidance needs no behavioral claim.

Use a broader controlled comparison only when claiming that the skill caused an
improvement,
when behavior is variable,
or when the intervention has meaningful cost.
Hold the task, runner, active context, available evidence, authority,
tool access, and relevant environment state steady.
A passing treatment alone does not establish that the skill contributed.

## Investigate a failure that does not reproduce

When the reported run is unavailable or fresh baselines pass,
recover the conditions that could have changed the decision:
the task, skill revision, task-local inputs, active context,
tool access, authority, and relevant runtime or environment state.
Preserve passing results,
but do not count them as reproduction of the reported failure.

Define a bounded campaign before rerunning:
choose representative variations,
repeat fresh runs when the behavior may be intermittent,
and state when the search will stop.
If the campaign does not fail,
report the reproduction gap and do not claim a repair.
A preventive change may instead test a reachable analogue,
but the unavailable boundary remains unverified.

## Write scenarios

Keep the runner-visible prompt separate from evaluator-held expectations.
Use this default form:

```markdown
## <Scenario name>

### Prompt

<Task, inputs, and constraints visible to the runner.>

### Expected behavior

- <Observable decision, outcome, or artifact property.>
- <Evidence the result must use or produce.>

### Unacceptable behavior

- <Observable violation, omission, or overfit response.>
```

State outcomes rather than a hidden reference implementation.
For judgment tasks,
allow defensible differences in structure and method.
For fixed contracts,
name the required fields, format, or sequence directly.

Put unusual setup beside the scenario when it is needed to run or judge that
case.
Keep common execution guidance in the test suite's README.

Do not copy private source material into reusable fixtures.
Keep the original evidence in its protected location,
and persist only a synthetic case that preserves the decision boundary
without preserving recognizable details.

## Select coverage from risk

Additional cases are required when the claim depends on their boundary:

| Condition | Add |
| --- | --- |
| The skill claims to generalize beyond its seed example. | A held-out task from the same failure class with different surface details. |
| The claim or observed behavior includes a credible incentive to bypass a boundary. | A pressure case that makes the boundary material and judges the resulting action. |
| A repair could forbid legitimate behavior. | A nearby valid case that the guidance must still permit. |
| The description or discovery language changes. | Selection, alternate-wording, competing-skill, and nearby non-selection cases as applicable. |
| The skill produces a substantial qualitative artifact. | Independent judgment against the source input and behavioral expectations. |
| A failure is intermittent or the result is borderline. | Repeated fresh runs sufficient to expose variance. |

Keep these as separate scenarios when they can fail independently.
Do not attach every variation to every test.
Add a case only when the task or observed behavior establishes its condition.
Pressure and repetition are not generic safeguards for every repair.

## Exercise pressured decisions

Neutral cases establish a boundary,
not whether it governs behavior under a credible incentive.
Build a pressure case from the incentives present at the real decision point.
Combine only pressures that can coexist there,
then require a concrete disposition and its supporting evidence
without revealing the desired result.
Preserve every response the contract permits,
including escalation or gathering evidence;
the test should expose how the runner resolves the pressure,
not force one implementation or a fixed number of stressors.

## Protect evaluation integrity

Use a fresh runner that receives the skill and task-local inputs,
but not the expectations, intended answer, diagnosis, or proposed repair.
For trigger tests,
give the runner the available skill descriptions and task
without identifying the desired selection.

Keep validation read-only
or confine writes to an isolated temporary location.
Capture the raw result before interpreting it.
When a separate judge is useful,
give the judge the result, source input, and expectations,
not a preferred implementation.

Distinguish whether the skill was available,
selected or retrieved,
relevant to the decision,
and applied correctly.
Failure at one boundary should not be misdiagnosed as failure at another.

## Interpret results

Outcome, supporting evidence, and preservation of the governing boundary decide
whether a scenario passes.
Latency, retries, and other trajectory details explain cost or friction;
they do not substitute for an accepted result.

Treat one passing run as one observation.
Use repetitions when variance matters,
and preserve failures rather than selecting the best run.
When both baseline and treatment succeed from local evidence,
the scenario does not establish added value.

Classify a failure before changing the skill:

- A skill gap means the model, boundary, routing, or discovery text did not
  support the needed decision.
- A test gap means the scenario leaked the answer,
  omitted required context,
  prescribed one implementation,
  or did not exercise the claimed behavior.
- A capability gap means the worker lacked a necessary tool or authority;
  prose may not be the right repair.

Improve the smallest owner of the observed gap,
rerun the scenario that exposed it,
and remove evaluation machinery whose value no longer covers its carrying cost.
