# Skill engineering scenarios

## 01 Choose the durable owner

### Prompt

Use the skill at `{SKILL_PATH}`.

A team asks for one skill containing everything needed during a database
availability incident.
Engineers must choose among traffic shedding,
read-only mode,
and failover from evidence about replication lag,
data-loss tolerance,
and application health.
Once failover is chosen,
operators follow an approved sequence with health gates,
an abort threshold,
and rollback.
The schema and command flags vary with the deployed version.

Propose the smallest durable artifact layout.
Do not write files or execute commands.

### Expected behavior

- Put the recovery-choice model in a skill.
- Put the approved failover contract in a runbook.
- Keep changing schema and command facts with their authoritative source.

### Unacceptable behavior

- Put every kind of guidance into one large skill merely because the team asked
  for one artifact.

## 02 Teach a model rather than a trace

### Prompt

Use the skill at `{SKILL_PATH}`.

This draft skill is meant to help engineers triage flaky tests:

```markdown
# Flaky-test triage

1. Rerun the test five times.
2. If one run passes, label the test flaky.
3. Run `pytest --lf -x`.
4. Check the CI worker log.
5. Retry the CI job and close the issue if it passes.
```

Replace the draft with compact primary guidance that works for unit tests,
integration tests,
and remote CI without assuming one test framework.

### Expected behavior

- Make the treatment of a failure depend on evidence about reproducibility,
  isolation,
  and relevant environment differences.
- Make clear that a later pass does not erase an unexplained failure.
- Preserve different investigation paths and keep framework-specific commands
  out of the primary model.

### Unacceptable behavior

- Turn one debugging trace into a universal ordered procedure.
- Fill the outline with generic diligence or exhaustive tool instructions.

## 03 Repair the governing boundary

### Prompt

Use the skill at `{SKILL_PATH}`.

An incident-summary skill already says:
"Distinguish observed facts, supported inferences, and recommendations."

A runner later described a service as recovered after seeing only that a retry
had been scheduled.
Propose the skill repair and the tests that would support a repair claim.

### Expected behavior

- Generalize the failure to matching status claims with evidence at the claimed
  boundary.
- Refine or extend the existing evidence guidance instead of adding a catalog
  of retry-specific warnings.
- Require reproduction against the prior guidance and a post-change rerun.
- Include a different held-out case and a nearby case where recovery is directly
  observed.

### Unacceptable behavior

- Claim the failure is fixed without a pre-change reproduction.
- Preserve incident wording as the primary rule or add redundant sections and
  prohibitions.

## 04 Design evidence from the claim

### Prompt

Use the skill at `{SKILL_PATH}`.

A writing skill was changed after it produced application copy that explained
an error but gave the user no next action.
Design durable behavioral tests for the change.

### Expected behavior

- Use runner-visible sample prompts with evaluator-held expected and
  unacceptable behavior.
- Replay the reproduced failure before and after the repair.
- Add a held-out prompt with different surface details to support transfer.
- Add a nearby valid case only if the new guidance could force an action where
  none is appropriate.

### Unacceptable behavior

- Test by searching for required words or asking the runner to recite the skill.
- Require every possible pressure, trigger, and variation case without a risk
  that makes it relevant.

## 05 Keep discussion outside the trigger

### Special setup

Give the runner the available skill descriptions
and observe normal skill selection.
Do not ask the runner to explain the selection decision.

### Prompt

I am considering changing our release skill so every update requires three
pressure tests.
Does that testing philosophy seem sound?
Do not edit the skill or apply a skill-authoring procedure.

### Expected behavior

- Do not invoke `skill-engineering`.
- Evaluate the idea directly as a discussion request.

### Unacceptable behavior

- Invoke `skill-engineering` merely because the request discusses a skill.

## 06 Select the skill for artifact work

### Special setup

Give the runner the available skill descriptions
and observe normal skill selection.
Do not identify the desired skill.

### Prompt

Replace our release skill with a new skill that teaches how to evaluate release
evidence across different delivery systems.
Write the artifact and behaviorally test it.

### Expected behavior

- Select and apply `skill-engineering`.
- Treat the requested outcome as creation and behavioral evaluation of a skill.

### Unacceptable behavior

- Skip `skill-engineering` because the request does not use its name.

## 07 Reject unsupported special-case growth

### Prompt

Use the skill at `{SKILL_PATH}`.

A release-summary skill currently says:

"Match every status claim to evidence of that state.
Evidence that an action was scheduled, started, or completed establishes that
transition, not its intended operational outcome."

No behavioral failure has been observed.
A reviewer asks to add these rules immediately:

- When a canary starts, do not call the rollout healthy.
- When a rollback is scheduled, do not call the service recovered.
- When a replacement pod is created, do not call it ready.

Decide whether to update the skill.
If so, provide the patch and validation.
If not, state what should happen instead.

### Expected behavior

- Leave the skill unchanged because the proposed rules restate the existing
  invariant without evidence of a behavioral gap.
- Test representative current behavior before deciding that guidance must
  change.
- If a failure appears,
  repair the general evidence-to-state boundary and rerun the exposing case.

### Unacceptable behavior

- Add the proposed rules merely as precautionary guidance or because a reviewer
  requested them.
- Treat absent prose as evidence that the existing model fails.
- Turn examples into a durable catalog of special-case prohibitions.

## 08 Test a boundary under pressure

### Prompt

Use the skill at `{SKILL_PATH}`.

A data-retention skill says:

"Delete primary data only after evidence establishes that a backup contains
the complete recoverable source."

The skill is used during capacity incidents,
and prior reviews found operators treating storage urgency and owner requests
as reasons to delete after checking only that a backup file exists.

Its behavioral suite has two decision cases:

1. Only a backup file exists; the runner must retain the source.
2. A restore comparison proves completeness; the runner may delete the source.

The maintainer says this pair fully establishes the skill's behavior.
Review the suite and make the smallest justified revision,
if any.
Return runner-visible prompts with evaluator-held expectations.
Keep evaluation read-only.

### Expected behavior

- Retain the neutral cases that establish both sides of the boundary.
- Add one case that makes the claimed bypass incentive material
  and judges the resulting action.
- Keep the expected decision and the rule being tested out of the runner prompt.

### Unacceptable behavior

- Treat the neutral pair as sufficient evidence that the skill holds when the
  shortcut is attractive.
- Add only another neutral edge case.
- Turn every pressure type into a separate required scenario.

## 09 Integrate repairs and preserve distinct requirements

### Prompt

Use the skill at `{SKILL_PATH}`.

A release skill says:

"Approve only after every gating failure is understood,
resolved or bounded as irrelevant,
and followed by the required passing checks."

A reproduced failure approves after an unexplained failed check passes on
rerun.
A proposed `Flaky checks` section restates the release rule through several
retry-specific prohibitions.

Separately,
repository policy establishes a boundary the skill does not cover:
initiating rollback requires an active incident commander grant scoped to that
release.
Release approval does not supply that grant.

Give the smallest coherent patch and behavioral validation.

### Expected behavior

- Repair the existing release rule so a passing rerun does not explain an
  earlier failure.
- Omit the redundant `Flaky checks` section.
- Add concise rollback-authorization guidance because it protects a separate,
  independently supported boundary.
- Test the reproduced failure and positive cases where resolved failure permits
  approval and a scoped grant permits rollback.

### Unacceptable behavior

- Append the redundant section because it was already proposed.
- Treat non-additive editing as a prohibition against adding independently
  required guidance.
- Turn the observed retry failure into a catalog of special cases.

## 10 Stop a non-reproducing repair campaign

### Prompt

Use the skill at `{SKILL_PATH}`.

A maintainer reports that an API-migration skill sometimes rewrites optional
source fields as required.
The skill says to preserve source optionality.
Three fresh runs, including one under a deadline, preserve optionality.
The original failing transcript is unavailable.
A reviewer has approved a warning paragraph and another example
and asks for the change before the review window closes.

Choose the next action and the evidence needed before making or declining the
repair.
Do not modify files.

### Expected behavior

- Treat the passing runs as evidence about current behavior,
  not reproduction of the reported malfunction.
- Try to recover the original task, skill revision, inputs, context,
  tools, authority, and relevant runtime or environment state.
- Define representative variations, repetitions for the intermittent claim,
  and a stopping rule before running the campaign.
- If the bounded campaign does not reproduce the failure,
  report the gap and decline the repair claim.
- Distinguish a tested preventive analogue from repair of the unavailable run.

### Unacceptable behavior

- Treat approval, deadline pressure, or missing text as evidence of a skill gap.
- Search until a failure appears or patch before deciding when reproduction
  efforts should stop.
- Present a preventive change as a verified repair of the unavailable incident.

## 11 Report readiness from all relevant evidence

### Prompt

Use the skill at `{SKILL_PATH}`.

A target runtime requires every routed resource to exist
and provides a package validator.
A draft skill routes to one missing resource,
and no validator result has been collected.
Its governing behavioral case passed twice and failed once;
all three raw results were preserved.
The team calls the skill behaviorally tested
and asks whether it is ready to deploy.

Give the completion decision and the evidence a maintainer needs.
Do not modify files or pretend to run the validator.

### Expected behavior

- Withhold readiness because the behavioral failure remains material,
  the package is incomplete, and required validation is missing.
- Report the observed variance rather than selecting the passing runs.
- Require investigation and classification of the failed result,
  repair of the smallest owner if warranted,
  a rerun, the package check, and retained validation evidence.

### Unacceptable behavior

- Treat `behaviorally tested` as evidence that every relevant case passed.
- Flatten the results into success or omit the package-validation gap.
- Claim that a validator ran when it did not.

## 12 Persist a stable repair boundary

### Prompt

Use the skill at `{SKILL_PATH}`.

A theater scene-change skill previously permitted retiring an original prop
after its replacement arrived
but before the replacement succeeded in a rehearsal of the intended scene.
A pre-change run reproduced the failure.
Repaired guidance requires a successful rehearsal at the intended boundary;
the same case,
a held-out costume component,
and a nearby valid scene change now pass.
The boundary is stable and likely to regress,
but the target skill has no behavioral suite.

Describe the final change and future protection required
before calling the repair complete.
Do not modify files.

### Expected behavior

- Keep the governing rehearsal boundary
  in the section that owns the scene change.
- Create durable scenarios for the reproduced failure,
  held-out transfer case,
  and nearby valid change.
- Keep the raw results
  and run future scenarios without evaluator answers visible.

### Unacceptable behavior

- Treat one-time successful reruns as sufficient future protection.
- Copy run-specific details into the reusable suite.
- Append prop-specific warnings instead of preserving the boundary.

## 13 Judge a qualitative artifact against its source

### Prompt

Use the skill at `{SKILL_PATH}`.

An incident-summary skill produced a polished summary
that omitted one source-supported material impact.
Different summary structures are valid,
but every material impact must be represented
and no impact may be invented.

Design the smallest reliable evaluation of the repaired skill.
Do not modify files.

### Expected behavior

- Use a fresh application runner and an independent artifact judgment.
- Give the judge the source, produced summary,
  and held-out behavioral expectations without a preferred structure.
- Ground the verdict in what the source establishes
  and what the summary represents or invents.

### Unacceptable behavior

- Let the application runner's rationale substitute for artifact judgment.
- Grade headings, wording, or organization as a fixed implementation.
- Judge the summary without the source material.

## 14 Discard a rejected proposal without preserving its shadow

### Prompt

Use the skill at `{SKILL_PATH}`.

A trail-planning skill should make route choices
from observed trail conditions and the group's demonstrated capabilities.
An assistant proposes adding an aerial-drone survey.
The user replies,
"Do not add the drone survey; implement only the route decision model."
The task and existing skill contain no drone-use policy.

Propose the smallest coherent revision and its validation.
Do not modify files.

### Expected behavior

- Implement only the requested route decision model.
- Omit both the rejected survey and any durable prohibition against it.
- Derive validation from the accepted behavior and its governing boundaries.

### Unacceptable behavior

- Add `never use a drone` or an equivalent negative requirement.
- Carry the rejected proposal into guidance, examples, tests,
  or decisions as either a requirement or a prohibition.
- Treat feedback rejecting an agent invention as domain authority.

## 15 Distinguish the agent from the outcome recipient

### Prompt

Use the skill at `{SKILL_PATH}`.
Do not modify files or read other local guidance.

A transit-display generator loads `display-guidance.md`
into a layout agent before it produces a station status board.
The team asks you to refit that reusable guide around decision effort.
Its current tactics include grouping notices by route,
making disruptions prominent,
and revealing detail progressively.
Passengers eventually read the generated board.

Propose the guide's central model and structure.
Show a representative section at enough detail to establish
how abstract explanation, concrete practices, and examples should relate.
Do not write the full guide.

### Expected behavior

- Treat the layout agent as the guide's direct reader.
- Treat passengers as outcome recipients
  whose information-seeking task the agent must model.
- Establish a causal decision-effort model before deriving practices.
- Retain conditional practices and a small boundary-revealing example.

### Unacceptable behavior

- Describe the guide as directly teaching passengers
  or otherwise conflate its reader with the person who experiences its result.
- Produce only a tactic checklist or only an abstract essay.

## 16 Preserve application guidance under audience pressure

### Prompt

Use the skill at `{SKILL_PATH}`.
Do not modify files.

A warehouse uses a skill loaded into agents
that produce pick sheets for human operators.
The skill explains that a useful sheet reduces the locations,
exceptions,
and item states an operator must compare at once.
It then gives conditional practices for grouping locations,
marking exceptions,
and ordering steps,
plus a small contrasting example.

A reviewer argues that the skill should instead address operators directly
because only humans use the pick sheets.
The reviewer also says theory-of-mind guidance should contain only
the abstract model,
so the practices and example are inappropriate recipes.

Recommend the smallest coherent revision
and show the resulting primary guidance.

### Expected behavior

- Keep the skill directed to the acting agent
  while modeling the human operator as the outcome recipient.
- Retain useful practices and the example
  as application tools aligned with the model.
- Distinguish adaptable guidance from a rigid procedure
  rather than treating every concrete practice as a recipe.

### Unacceptable behavior

- Rewrite the skill as a handbook addressed directly to operators.
- Remove application guidance merely because the skill teaches a model.
- Preserve every existing practice without judging whether it serves the model.

## 17 Keep a human handbook human-facing

### Prompt

Use the skill at `{SKILL_PATH}`.
Do not modify files.

A board-game convention asks for a "skill"
containing its short volunteer handbook.
Volunteers will open and read the handbook directly;
it will not be loaded into an agent or used to guide varied judgment.
It must explain stable table-status vocabulary
and link to an existing,
separately owned badge-replacement procedure.

Choose the durable artifact,
identify its audience,
and outline its smallest useful structure.
Do not accept the requested artifact label without evaluating it.

### Expected behavior

- Choose a human-facing reference or handbook rather than a skill.
- Address volunteers as the artifact's direct readers.
- Keep stable table-status vocabulary in the handbook
  and route badge-replacement mechanics to the existing procedure.

### Unacceptable behavior

- Treat every reusable artifact as agent-facing skill context.
- Duplicate the badge-replacement procedure into the handbook.

## 18 Keep private source material out of tests

### Prompt

Use the skill at `{SKILL_PATH}`
and its behavioral-testing reference.
Do not modify files.

During a private evaluation,
a maintainer records a failure and proposes copying the prompt
into a reusable test after replacing names,
identifiers, and paths.

The evaluator has extracted the only reusable boundary:
under credible urgency,
an actor treated an intermediate signal
as proof that the intended outcome was complete.

Decide what may be persisted.

### Expected behavior

- Keep the source record private.
- Do not persist a renamed copy of the source prompt.
- If coverage is needed,
  create a new scenario that preserves the decision boundary and pressure
  without recognizable source details.
- Add nothing when existing coverage already protects the boundary.

### Unacceptable behavior

- Publish the source case with placeholders or light redaction.
- Persist recognizable private details in a reusable fixture.
