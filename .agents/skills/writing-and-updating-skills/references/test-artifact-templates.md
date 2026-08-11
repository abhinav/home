# Test artifact templates

Use these templates when a skill repair leaves behind reusable behavioral tests.
Adapt headings and scenario names to the target skill.
Preserve the behavioral boundary, but do not copy a real failure into the
persisted scenario text verbatim.

## `tests/README.md`

```markdown
# <Skill name> behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
Replace `{SKILL_PATH}` with the path to the candidate under test.
For application tests,
give the runner only the scenario's `Prompt` section.
For trigger-selection tests,
give the runner the scenario prompt and available-skill catalog,
but withhold the target skill path and body.
Full-prompt examples use `Expected behavior` and `Unacceptable behavior`.
Focused boundary tests use `Quality bar` and `Expectations`.
Those grading sections are evaluator-only;
withhold them and the intended answer.
For a full-prompt pressure or adjacent-valid trial,
give the runner the base `Prompt` plus only that variant's
`Runner prompt addition`.
For a focused trial,
give the runner the base `Prompt` plus only the prose before the first bullet
in that variant section.
Withhold all expectation bullets.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response or artifact and compare it with the held-out
expectations afterward.
For substantial artifact or judgment tests,
give a separate fresh judge the artifact, source input, expectations,
and governing skill principles;
require the verdict to cite source-and-output evidence.
A scenario passes only when every required behavior holds
and no unacceptable behavior appears.

For repair-loop scenarios,
first run the relevant scenario against the current guidance.
Rerun that exact scenario after the smallest green candidate.
Then integrate the candidate into the existing guidance,
remove provisional or duplicated text,
and rerun the exact scenario,
each applicable pressure or adjacent-valid variant,
and relevant previously passing cases against the final refactor form.
Repeat important or borderline cases two or three times,
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
```

## `tests/scenarios.md`

Choose the scenario style from the behavior under test.
Use a full-prompt example when complete task context or interactions among rules
matter.
Use a focused boundary test when one failure, decision, pressure,
or conformance contract should be isolated.

### Full-prompt example

````markdown
# <Skill name> scenarios

## 01 <Behavioral boundary>

### Prompt

Use the skill at `{SKILL_PATH}`.

A user says:
"<invented analogue that preserves the behavioral boundary, temptation,
and expected decision without copying a real failure verbatim>"

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expected behavior

- <Observable decision, outcome, or artifact property.>
- <Evidence the result must use or produce.>
- <Equivalent approaches the contract permits, when judgment is involved.>

For trigger-selection scenarios,
replace the skill path in the prompt with an available-skill catalog
and include a nearby non-use case.

### Unacceptable behavior

- <Observable violation, omission, answer leak, or overfit response.>
- <Shortcut or rationalization that demonstrates the boundary failed.>
- Do not copy the real failure prompt,
  private context,
  names,
  paths,
  data,
  or exact incident shape into the persisted scenario.

### Pressure variant

#### Runner prompt addition

The staff engineer adds:
"<invented pressure>"

Include this section only when the claimed behavior has a credible incentive
to bypass the boundary.
Use the pressures present at that decision point;
for discipline scenarios,
combine applicable pressures such as time,
authority,
sunk cost,
or small-change temptation.

#### Expected behavior

- <Expected behavior under pressure.>

#### Unacceptable behavior

- <Rationalization to reject.>

### Adjacent valid case

#### Runner prompt addition

<Nearby case the repair must still permit (if any).>

#### Expected behavior

- <Expected valid behavior.>

#### Unacceptable behavior

- <Overrestriction or false positive that would reject this valid case.>

Include this section only when the guidance could forbid legitimate behavior
or when the adjacent case establishes an important decision boundary.
````

### Focused boundary test

````markdown
## 01 <Behavioral boundary>

### Prompt

Use the skill at `{SKILL_PATH}`.

<Representative task and only the context needed to reach the decision.>

### Quality bar

- Evaluation mode: judgment | conformance.
- <Observable outcome a useful result must achieve.>
- <Failure smell that demonstrates the boundary was missed.>

### Expectations

- <Required decision or behavior.>
- <Evidence the result must use or produce.>
- <Shortcut or rationalization the runner must avoid.>

### Pressure variant

<Optional runner-visible pressure that makes the shortcut attractive.>

- <Held-out expectation under pressure.>
- <Rationalization that demonstrates failure.>

### Adjacent valid case

<Optional runner-visible case the repair must still permit.>

- <Held-out expected valid behavior.>
- <Overrestriction that demonstrates failure.>
````

For a focused variant trial, give the runner the base `Prompt` plus only the
prose before the first bullet in that variant section.
The bullets remain evaluator-only.

## Skill footer

Add this footer to the target `SKILL.md` when the skill has persisted behavioral
tests:

```markdown
## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
```

If the target skill needs a special harness,
add one sentence after the footer command that names the required scenario group
or harness file.
