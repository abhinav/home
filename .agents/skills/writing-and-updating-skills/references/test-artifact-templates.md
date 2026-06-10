# Test Artifact Templates

Use these templates when a skill repair leaves behind reusable behavioral tests.
Adapt headings and scenario names to the target skill.
Preserve the behavioral boundary,
but do not copy a real failure into the persisted scenario text verbatim.

## `tests/README.md`

```markdown
# <Skill Name> Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
Give the subagent the skill path and scenario prompt.
Do not give it the expectations or intended answer.
Keep tests read-only or confined to a task-local temporary directory.

Capture the raw response and compare it with the expectations afterward.
A scenario passes only when every expectation holds
and no contrary behavior appears.

For repair-loop scenarios,
first run the relevant scenario against the current guidance.
After the edit,
rerun that exact scenario.
Also run a pressure variant or adjacent valid case
when the scenario defines one.

Use [scenarios.md](scenarios.md) for the reusable gamut.
```

## `tests/scenarios.md`

````markdown
# <Skill Name> Scenarios

## 01 <Behavioral Boundary>

### Prompt

Use the skill at `/path/to/skill/SKILL.md`.

A user says:
"<invented analogue that preserves the behavioral boundary, temptation,
and expected decision without copying a real failure verbatim>"

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Expectations

- <Expected behavior the skill should cause.>
- <Evidence or decision the agent should report.>
- <Shortcut or rationalization the agent must avoid.>
- Do not copy the real failure prompt,
  private context,
  names,
  paths,
  data,
  or exact incident shape into the persisted scenario.

### Pressure Variant

The user adds:
"<invented pressure that combines time, authority, sunk cost,
or small-change temptation>"

- <Expected behavior under pressure.>
- <Rationalization to reject.>

### Adjacent Valid Case

<Nearby case the repair must still permit (if any).>

- <Expected valid behavior.>
````

## Skill Footer

Add this footer to the target `SKILL.md`
when the skill has persisted behavioral tests:

```markdown
## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
```

If the target skill needs a special harness,
add one sentence after the footer command
that names the required scenario group or harness file.
