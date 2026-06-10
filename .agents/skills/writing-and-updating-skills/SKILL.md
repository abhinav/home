---
name: writing-and-updating-skills
description: Use when creating or updating skills, testing skill behavior with subagents, repairing unclear triggers or observed misbehavior, designing pressure tests, closing loopholes, addressing rationalizations, or validating skill folders before deployment.
---

# Writing And Updating Skills

## Overview

Treat skill authoring as test-driven process design.
Observe how an agent fails without the guidance,
write or revise the skill to address that failure,
then pressure test until the desired behavior holds.

The goal is not to write a large document.
The goal is to make future agents reliably do the right thing
with the least context that can carry the behavior.

## Core Workflow

Follow this loop for new skills and for edits to existing skills:

1. Orient to the requested behavior,
   target runtime,
   destination folder,
   and existing skill conventions.
2. Capture a baseline failure before finalizing the skill or edit.
   For a new skill,
   test without the new guidance.
   For an update,
   test the current skill before the proposed change.
3. Write the smallest useful skill or update
   that addresses the observed failure.
4. Pressure test with fresh subagents that have empty context windows.
   First rerun the baseline scenario with the guidance,
   then add pressure that tempts the agent to misbehave.
5. Close loopholes by converting observed rationalizations
   into explicit guidance,
   trigger-description changes,
   red flags,
   or better section order.
6. Persist reusable behavioral tests
   when the scenario should protect future changes to the skill.
   Before adding or planning these artifacts,
   read `references/test-artifact-templates.md`.
7. Validate the folder mechanically and behaviorally before deployment.

Read `references/subagent-testing.md` before designing subagent validation,
running pressure tests,
or repairing a loophole found during testing.

Choose the validation shape from the skill's behavioral purpose.
Discipline skills need pressure scenarios.
Technique and pattern skills need application, variation, and counter-example scenarios.
Reference skills need retrieval, gap, and written-application checks.
Use `references/subagent-testing.md` for the detailed test shapes.

## Write Effective Skills

Use the local skill format for the target runtime.
Create a folder named after the skill,
use the runtime's required entrypoint,
and add any harness-specific metadata
when that runtime expects it.

Keep the frontmatter focused on discovery:

- `name` is lowercase,
  hyphenated,
  and matches the folder.
- `description` says when to use the skill,
  including concrete triggers,
  symptoms,
  file types,
  tools,
  or failure modes.
- Avoid stuffing the description with the workflow.
  If the description fully summarizes the steps,
  an agent may follow the summary instead of loading the body.

Keep `SKILL.md` focused on the operating procedure:

- Explain only the knowledge a capable agent would not already know.
- Match specificity to risk.
  Fragile workflows need exact commands;
  judgment-heavy work needs principles and checks.
- Keep frequently used skills especially compact.
  Move bulky examples, rare cases, command references,
  and repeated workflow details into referenced files or existing tools.
- Prefer one strong example over several similar examples.
  Add more examples only when each one protects a distinct decision boundary.
- Check size when a skill starts to sprawl.
  If a skill is hard to scan,
  split reference material out before adding more primary guidance.
- Put rare,
  bulky,
  or optional details in one-level reference files.
- Add scripts only when deterministic behavior matters
  or the same code would otherwise be rewritten often.
- Add assets only when the skill uses them in outputs.
- Do not add README,
  changelog,
  installation guide,
  or process notes unless the runtime explicitly requires them.

## Update Existing Skills

Start from the observed malfunction,
not from a broad rewrite impulse.

For each update:

1. Identify the failing behavior,
   the prompt or scenario that exposed it,
   and the part of the skill the agent likely relied on.
2. Preserve guidance that still works.
   Skill edits should close the gap without changing unrelated behavior.
3. Generalize the failure before drafting the patch.
   For behavior-shaping repairs,
   name the boundary the failure exposed before writing normative text:

   ```markdown
   Invariant:
   <general boundary future agents must preserve>

   Observed symptom:
   <concrete failure that revealed the boundary>

   Adjacent valid case:
   <nearby case the repair must still permit>
   ```

   Only the invariant belongs in the primary rule.
   Use observed symptoms and adjacent valid cases in examples,
   red flags,
   or retest scenarios instead.
4. Patch the smallest section that can prevent the same failure.
   Prefer precise wording,
   reordered emphasis,
   or a short table over a new framework.
   Write the primary repair as positive criteria:
   what future agents should optimize for,
   include,
   preserve,
   or verify.
   Avoid making the primary repair a negative rule about the observed symptom.
   Use negative wording only for details that are always invalid
   across the skill's intended use cases.
   When quoting patch text,
   quote the recommended invariant-based wording only.
   Do not add fallback patch text that reintroduces symptom-shaped wording.
   If placement depends on the target skill's structure,
   describe where the same invariant wording should go.
5. Retest the same scenario.
   A prose-only change still needs behavioral validation
   when the skill is meant to shape agent behavior.

Common repairs:

| Observed failure | Repair |
| --- | --- |
| Skill does not trigger | Add concrete symptoms to the description. |
| Skill triggers too broadly | Narrow the description and add non-use boundaries. |
| Agent skips a required step | Move the step earlier and make the decision point explicit. |
| Agent follows a shortcut | Name the shortcut as a red flag and state the correct action. |
| Agent misses a detail | Move rare detail to a reference and link it at the decision point. |
| Agent treats testing as optional | Require a subagent or scenario check before deployment. |
| Agent overfits a repair to one observed example | Replace the symptom-specific rule with positive criteria for the underlying decision boundary, then test an adjacent valid case. |

## Test With Subagents

Use subagents as independent validation surfaces.
The point is to learn whether the skill transfers,
not whether another agent can infer your intended answer.

When testing:

- Use fresh subagents with empty context windows
  for independent passes.
- Pass the skill path and task-local artifacts,
  not your diagnosis,
  expected answer,
  or planned fix.
- Keep tests isolated.
  Ask the subagent for a decision,
  rationale,
  diagnostic plan,
  or patch sketch,
  not for changes to shared files,
  commits,
  deployments,
  or external systems.
  If a test requires tool use,
  constrain it to read-only inspection
  or artifacts under a task-local temporary directory
  outside the target repository.
- Capture raw output,
  decisions,
  skipped steps,
  and rationalizations.
- Treat subagent failures as diagnostics for the skill
  or the test setup.

Do not rely only on academic questions such as
`What does this skill say?`
Good skill tests make the agent respond under realistic constraints,
not recite the skill.

## Persist Reusable Tests

When a skill update exposes a durable behavioral boundary,
leave behind reusable test artifacts for future maintainers.
Use a `tests/` directory when the target skill does not already define
another test location.
Any plan to add or update persisted tests is incomplete
until it reads `references/test-artifact-templates.md`
and uses that file for the test README,
scenario template,
and skill footer.

The lightweight default layout is:

```text
tests/
  README.md
  scenarios.md
```

`tests/README.md` explains how to run the reusable scenarios.
It should say to use fresh subagents with empty context windows,
hide expectations from the tested subagent,
keep tests read-only or confined to task-local temporary directories,
and compare the raw response with expectations afterward.

`tests/scenarios.md` records the reusable gamut.
Store prompts, expectations, pressure variants,
adjacent valid cases,
and any special harness steps needed to reproduce the behavioral check.

Do not use a real failure as persisted scenario text verbatim.
Real failures are diagnostic evidence,
not reusable test fixtures.
Persisted scenarios must be invented analogues
that preserve the same behavioral boundary,
temptation,
and expected decision
without copying the real prompt, private context, names, paths, data,
or exact incident shape.

When a real failure produced useful rationalization wording,
capture the exact wording in the repair record.
For persisted tests,
translate that wording into expectations,
red flags,
or an invented pressure variant
unless the quoted text is already generic and safe to reuse.

## Pressure Tests And Loopholes

Pressure tests should make the wrong behavior tempting.
Combine at least three pressures for discipline-enforcing guidance:

- Time pressure:
  a deadline,
  urgent bug,
  or closing review window.
- Sunk cost:
  a draft or implementation already exists.
- Authority:
  a manager,
  reviewer,
  or senior engineer asks for the shortcut.
- Exhaustion:
  end of day,
  repeated failures,
  or a long session.
- Social pressure:
  fear of seeming slow,
  rigid,
  or difficult.
- Ambiguity:
  the prompt leaves room to claim the rule does not apply.
- Small-change temptation:
  the edit looks too minor to test.

When an agent misbehaves,
capture the exact reasoning and turn it into skill text.

| Rationalization | Skill repair |
| --- | --- |
| "This is just documentation." | Require behavioral validation for behavior-shaping prose. |
| "The skill is clear enough." | Require a realistic subagent pass before deployment. |
| "I'll test after shipping." | Make validation part of the deployment boundary. |
| "This follows the spirit." | State the specific boundary the shortcut violates. |
| "The fix is obvious." | Require retesting the scenario that exposed the gap. |

## Validation

Before considering a skill ready:

- Run the runtime's validator when available.
- Inspect the file list for clutter or missing resources.
- Confirm frontmatter is valid and trigger-focused.
- Follow the sufficient testing checklist
  in `references/subagent-testing.md`.
- Update or create persisted tests
  when the repair protects a reusable behavioral boundary.
- For updates,
  rerun the scenario that exposed the original misbehavior.
- Report the behavioral evidence,
  not only that the Markdown looked correct.

If testing reveals a new loophole,
revise the skill and repeat the relevant scenario.
Do not treat the first passing run as enough
when the skill enforces discipline under pressure.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
Read [references/test-artifact-templates.md](references/test-artifact-templates.md)
when adding or updating persisted test artifacts.
