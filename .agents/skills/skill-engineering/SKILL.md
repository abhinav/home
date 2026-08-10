---
name: skill-engineering
description: >
  Use when the requested outcome is to create, change, repair, or behaviorally
  test a reusable skill. Covers theory-first guidance, choosing between skills
  and other durable artifacts, context routing, and behavioral evaluation.
  Do not invoke for discussion or review that does not ask to apply this skill
  or change an artifact.
---

# Skill engineering

A skill is context delivered when a task reaches a decision
that benefits from reusable judgment.
It earns its attention cost when it helps a capable worker choose and complete
unfamiliar cases,
not when the worker can merely repeat its instructions.

## Teach a usable model

The direct reader of a skill is the agent that will perform the task.
People who experience or review the agent's work are outcome recipients.
Teach the agent to model their needs
without writing the skill as though they were its readers.

Identify what the agent can already recover
from task context and local evidence,
and what it must understand to predict or decide.
When the skill owns a behavioral failure,
reconstruct the decision from the agent's position:
what it could observe and infer,
which model the guidance supplied,
and which ambiguity or incentive made the failure seem reasonable.
Repair the failed model or its application support,
not merely the observed output.
Build only the parts of the operating model that the domain requires:

- who experiences the outcome and what useful completion means;
- which state, forces, and causal relationships govern the work;
- which invariants, ownership boundaries, or risks constrain the choice;
- what evidence establishes success, failure, or uncertainty; and
- when an exception, escalation, or different artifact is appropriate.

Establish why a choice follows from those conditions,
then provide the practices, examples, procedures, references, or tools
needed to apply that model without reconstructing established technique.
Keep them aligned with the model
so the agent can adapt them instead of merely imitating them.
Use ordered steps only when order is part of correctness.
A good principle transfers to a new case
and leaves room for legitimate alternatives.

Use one small example when it makes the model easier to apply.
Change one relevant condition at a time
so the example exposes the decision boundary instead of supplying a script
to imitate.

## Choose the durable owner

Do not assume every recurring task needs a skill.
Place knowledge where it can shape the decision with the least carrying cost.

| Artifact | Use it for |
| --- | --- |
| Skill | An approach or judgment that must transfer across varied cases. |
| Runbook | Repeatable work whose preconditions, order, safety, recovery, or rollback must be preserved. |
| Reference | Facts, schemas, commands, or options that must be retrieved accurately. |
| Script, tool, or check | A deterministic operation or settled invariant that should execute rather than be remembered. |

A skill may route to these artifacts without absorbing their contents.
When a requirement becomes stable and mechanically enforceable,
move it toward an executable owner
and remove prose that no longer changes a decision.

## Spend context deliberately

Keep `SKILL.md` as the task's operating model and map.
Place specialized mechanics in a reference
and link it where the decision to retrieve it arises.
Name what the reference establishes and when to read it.
Do not duplicate its rules in the primary file.

Add a script only when the same deterministic operation would otherwise be
recreated or when reliability requires an executable implementation.
Keep changing facts with their authoritative source
rather than copying a parallel corpus into the skill.

Make each paragraph earn its place.
Retain prose when it changes a likely decision,
establishes an outcome or boundary,
prevents a supported failure,
or routes the reader to needed evidence.
Remove prose that merely describes the authoring process,
restates another rule,
or sounds prudent without changing action.

## Create from the decision boundary

For a new skill,
use representative uses and nearby non-uses to locate the decisions
a capable worker cannot reliably recover from local evidence.
Draft the smallest model that closes those gaps;
do not invent a failing baseline merely to justify the design.

For a revision,
derive requirements from the requested outcome,
retained valid guidance,
and evidence about observed behavior.
Existing wording is evidence about prior intent,
not authority to preserve a weak structure.

For a behavioral repair,
work through red, green, and refactor in that order:

1. **Red:** Reproduce the malfunction against the prior guidance
   and preserve the result.
   Classify which boundary owns the failure before changing the skill.
   Continue only when its discovery, model, boundary, routing,
   or application guidance owns the gap;
   otherwise repair or report the actual owner and leave the skill unchanged.
   Without a demonstrated skill-owned malfunction,
   do not claim a skill repair.
2. **Green:** Make the smallest behaviorally sufficient candidate repair
   in the owning section.
   Rerun the exposing case
   and any additional coverage justified by the claim and risk.
3. **Refactor:** Use the whole-skill review below
   to integrate the candidate repair.
   Rerun the affected cases against the final integrated form.

A passing provisional patch is not completion.
The integrated skill must remain green.
A new design does not require a manufactured failure.

## Evaluate decisions and outcomes

Test the work an agent should perform,
not its ability to explain or quote the skill.
Judge observable outcomes, supporting evidence, and protected boundaries
while accepting equivalent approaches the contract permits.

Read [references/behavioral-testing.md](references/behavioral-testing.md)
before designing or running behavioral evaluation.
It defines the scenario format,
comparison boundary,
and interpretation rules.

## Review the whole skill

Use this review as the refactor step for a repair
and after any other draft or change.
Check that every change serves the authorized outcome
and an established responsibility of the skill.
Review the model from the acting agent's position:
it should supply the causal structure needed to decide unfamiliar cases
and the practices or tools needed to apply that structure.
Fold incident-shaped directives into the transferable model when it owns them;
remove unsupported or out-of-scope residue.

Inspect the primary file and its routed resources together.
Resolve contradictions,
place each surviving requirement with its durable owner,
and replace, merge, or delete duplicated guidance.
Verify that each practice, example, or exception supports the model
and protects a distinct boundary.
Check that the description selects the intended work
without claiming ordinary discussion about a skill.

Retain the skill only while its effect justifies its context and maintenance cost.

## Tests

When changing this skill,
read [tests/README.md](tests/README.md)
and run the scenarios affected by the change.
