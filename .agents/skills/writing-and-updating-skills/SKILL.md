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
4. Pressure test with fresh subagents.
   First rerun the baseline scenario with the guidance,
   then add pressure that tempts the agent to misbehave.
5. Close loopholes by converting observed rationalizations
   into explicit guidance,
   trigger-description changes,
   red flags,
   or better section order.
6. Validate the folder mechanically and behaviorally before deployment.

Read `references/subagent-testing.md` before designing subagent validation,
running pressure tests,
or repairing a loophole found during testing.

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
3. Patch the smallest section that can prevent the same failure.
   Prefer precise wording,
   reordered emphasis,
   or a short table over a new framework.
4. Retest the same scenario.
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

## Test With Subagents

Use subagents as independent validation surfaces.
The point is to learn whether the skill transfers,
not whether another agent can infer your intended answer.

When testing:

- Use fresh subagents for independent passes.
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
- For updates,
  rerun the scenario that exposed the original misbehavior.
- Report the behavioral evidence,
  not only that the Markdown looked correct.

If testing reveals a new loophole,
revise the skill and repeat the relevant scenario.
Do not treat the first passing run as enough
when the skill enforces discipline under pressure.
