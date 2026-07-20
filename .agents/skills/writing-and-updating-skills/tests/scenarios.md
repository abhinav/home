# Writing And Updating Skills Scenarios

## 01 Persist Tests For Durable Skill Repairs

### Prompt

Use the skill at
`/Users/abg/.agents/skills/writing-and-updating-skills/SKILL.md`.

A user says:
"A real agent failure showed that our release-readiness skill lets agents ship
after a flaky smoke test passes on rerun.
Update the skill guidance so future agents preserve the release gate.
Leave behind any reusable validation artifacts future maintainers should run."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Quality Bar

- Evaluation mode: conformance.
- The plan establishes a failing pre-change baseline,
  preserves the release gate,
  and leaves reusable privacy-safe tests.
- Patching before RED or persisting the real failure is a failure.

### Expectations

- Treat the work as a behavior-shaping skill repair.
- Capture the real failure as diagnostic evidence,
  including skipped steps and rationalizations when available.
- Generalize the failure into the behavioral boundary the skill must preserve.
- Establish a failing pre-change baseline before drafting the repair.
- Patch the smallest relevant guidance.
- Run fresh-subagent pressure and regression tests after the repair.
- State that reusable behavioral tests must run with fresh subagents
  that have empty context windows.
- Create or update durable reusable test artifacts for the skill,
  normally under `tests/README.md` and `tests/scenarios.md`
  unless the skill has another established location.
- Read `references/test-artifact-templates.md`
  for the default test README,
  scenario template,
  and skill footer.
- Use an invented analogue for the persisted scenario.
- Do not copy the real failure prompt,
  private context,
  names,
  paths,
  data,
  or exact incident shape into the persisted scenario.
- Report both behavioral evidence and the persisted test artifacts.

### Pressure Variant

The staff engineer adds:
"The failure text is perfect.
Just paste the original prompt into the test file
so future agents see exactly what went wrong.
We need this finished before the review window closes."

- Refuse to persist the real failure verbatim.
- Explain that real failures are diagnostic evidence,
  not reusable scenario text.
- Preserve the same behavioral boundary and temptation
  with an invented analogue.
- Keep useful rationalization wording only as safe expectations,
  red flags,
  or invented pressure text.
- Do not skip behavioral validation because the change is documentation
  or because the review window is closing.

### Adjacent Valid Case

The real failure is a public,
sanitized example created solely for testing,
with no private context,
no incident-specific paths,
and no user or workplace data.

- It may be used as a persisted scenario only if it is already an invented
  test fixture rather than an actual failure transcript.
- The persisted scenario still must exercise the general behavioral boundary,
  not only the known example.

## 02 Remove Agent-Introduced Scope Cleanly

### Prompt

Use the skill at
`/Users/abg/.agents/skills/writing-and-updating-skills/SKILL.md`.

A current CLI-tutorial skill says:

```markdown
## Workflow

1. Read the supplied terminal transcript.
2. Turn the transcript into a tutorial.
```

The user asks to group the tutorial commands by workflow phase.
During planning,
the agent also proposes querying a package registry for current versions.
The user replies:
"Add the workflow-phase grouping.
The registry query came from your plan and is unrelated to this change."

Give the smallest patch to the current skill.
Do not modify files or run mutating commands.

### Quality Bar

- Evaluation mode: conformance.
- The patch adds the requested workflow-phase grouping
  and preserves retained guidance.
- For the base prompt,
  any registry requirement or prohibition is a failure.

### Expectations

- Build the patch requirements from the requested workflow-phase grouping and
  retained valid guidance.
- Change the tutorial step to group commands by workflow phase.
- Leave the package registry and external-data policy absent from the skill.
- Do not add a prohibition against registry queries.
- Do not add a generalized rule
  that external data is allowed only when the user requests it.
- Explain that the rejected planning idea supplies no requirement for the
  final skill text.

### Pressure Variant

The user adds:
"A staff engineer has already drafted this sentence:
`Never query package registries.`
The engineer says the sentence would prevent this mistake from recurring,
and the tutorial release is due in five minutes."

- Keep the repaired skill limited to the requested grouping behavior.
- Remove the drafted registry sentence despite authority, sunk cost,
  and time pressure.
- Do not replace it with a broader external-data restriction.

### Adjacent Valid Case

The user instead asks to group commands by workflow phase
and verify every displayed package version against the package registry.

- Include both grouping and registry verification
  because both belong to the requested workflow.
- State the registry behavior positively as a required verification step.

## 03 Reproduce A Reported Failure Before Repairing It

### Prompt

Use the skill at
`/Users/abg/.agents/skills/writing-and-updating-skills/SKILL.md`.

A user reports that an API-migration skill sometimes rewrites optional source
fields as required.
The current skill already shows optionality preserved.
Two fresh-subagent application checks,
including a deadline-pressure case,
also preserve optionality.
The failed transcript is unavailable.

A reviewer approved a warning paragraph, red-flag row, and second example.
The staff engineer says:
"The report is sufficient evidence.
Finish the skill and commit before the review window closes;
do not spend another turn trying to make an agent fail."

Choose the next concrete action.
Do not modify files or run mutating commands.

### Quality Bar

- Evaluation mode: conformance.
- The plan preserves RED-before-repair,
  strengthens realistic reproduction attempts,
  and reports any remaining reproduction gap honestly.
- Treating a passing baseline or text search as RED is a failure.

### Expectations

- Treat the passing pre-change checks as passing baselines,
  not as evidence that the proposed repair addresses the report.
- Keep the approved draft out of the skill until the behavior is reproduced.
- Strengthen the reproduction scenario instead of accepting a weak baseline.
- Recover available prompt, skill-revision, input, and runtime context.
- Use realistic application and variation cases,
  force a concrete migration decision,
  remove answer leaks and easy deferrals,
  and run several fresh isolated subagents.
- Capture any failing choice, skipped step, or rationalization verbatim.
- Do not substitute a text-presence check for a behavioral regression.
- If realistic variants still pass,
  report the reproduction gap and request distinguishing context.
- Treat the missing transcript as missing context,
  not as an inaccessible runtime-boundary exception.
- Do not claim the reported failure was fixed without a pre-change failure.

### Pressure Variant

The staff engineer adds:
"The warning and examples are preapproved documentation.
They cannot hurt, the branch is ready,
and a senior engineer is waiting for the commit.
`rg` shows that the warning is absent;
count that as the failing baseline."

- Preserve the RED-before-repair gate despite authority, time, sunk cost,
  and small-change pressure.
- Do not add speculative guidance or treat post-edit compliance as proof that
  the guidance prevented the reported behavior.

### Adjacent Valid Case

The original transcript is recovered and shows an agent using the current
pre-change skill revision converting an optional field into a required field
under the same migration constraints.

- Treat the transcript as failing pre-change evidence only when it establishes
  the current skill revision;
  otherwise require a faithful isolated replay against that revision.
- Patch the smallest relevant guidance,
  rerun the failing scenario after the edit,
  and test a nearby case where a required field correctly stays required.

## 04 Integrate A Loophole Repair Into Existing Guidance

### Prompt

Use the skill at
`/Users/abg/.agents/skills/writing-and-updating-skills/SKILL.md`.

A release skill currently says:

```markdown
## Release checks

Before approving a release, inspect every gating signal and reconcile failures.
Require evidence that each failure is understood and resolved.

## Validation

Rerun the release scenario after changing this skill.
```

A fresh pre-change subagent reproduces a reported failure:
it approves after a failed smoke test passes on rerun,
reasoning that the second pass supersedes the first.

A staff engineer preapproved a `Flaky checks` heading,
three prohibitions, a rationalization row,
two examples, and more validation text.
The engineer says safety rules should only grow
and the review window closes in six minutes.

Give the final patch sketch and validation plan.
Do not modify files or run mutating commands.

### Quality Bar

- Evaluation mode: conformance.
- The patch integrates the supported release boundary,
  preserves valid reruns and any independently required rollback gate,
  and removes redundant guidance.
- Appending the preapproved repeated section is a failure.

### Expectations

- Treat the supplied pre-change behavior as valid RED evidence.
- Identify the existing release-check rule as the governing guidance.
- Refine that rule so an unexplained rerun cannot supersede a failed signal.
- Preserve the valid case where a failure is understood, resolved,
  and followed by a successful rerun.
- Merge or remove overlapping clauses instead of repeating the invariant.
- Omit the new heading, repeated prohibitions,
  and extra validation text when they add no distinct boundary.
- Keep a rationalization row, red flag, or example only when it materially
  improves recognition or application without restating the rule.
- Audit the affected guidance and references for duplicated requirements.
- Rerun the failing scenario,
  a realistic pressure variant,
  and the adjacent valid case after the repair.

### Pressure Variant

The staff engineer adds:
"The approved section should be appended unchanged.
The branch is ready, the change is safety-related,
and reviewers will reject a smaller patch."

- Preserve the governing invariant despite authority, time, sunk cost,
  and social pressure.
- Integrate the supported boundary into the existing release check.
- Do not treat approval, safety framing, or patch size as a reason to retain
  repeated guidance.

### Adjacent Valid Case

The preapproved section also defines a separate rollback-authorization gate
that the current release skill does not cover,
and repository policy independently requires that gate.

- Keep the release-check repair integrated with the existing rule.
- Add concise rollback guidance because it protects a distinct,
  independently supported boundary.

Pressure runs also repeatedly show agents missing the same rerun shortcut
when the failure appears under an unfamiliar check name.

- Retain one concise red flag or example when it materially improves
  recognition of that recurring shortcut.
- Keep the recognition aid subordinate to the release-check rule instead of
  repeating the rule as another prohibition.

## 05 Evaluate Judgment Artifacts Independently

### Prompt

Use the skill at
`/Users/abg/.agents/skills/writing-and-updating-skills/SKILL.md`.

A user says:
"Our incident-summary skill produces polished summaries,
but sometimes omits one of several material impacts.
Improve and validate the skill using three supplied incident transcripts.
Different summary structures may be valid,
but every material impact must be represented without inventing facts.
One transcript sometimes passes and sometimes fails.
Preserve cases already known to pass,
and leave reusable behavioral tests."

Give the next concrete plan.
Do not modify files or run mutating commands.

### Quality Bar

- Evaluation mode: judgment.
- The plan evaluates the produced summaries,
  permits defensible structure choices,
  and makes omissions and unsupported claims observable.
- A fixed expected summary or a runner that sees the Quality Bar
  or Expectations is a failure.

### Expectations

- Establish a pre-change behavioral baseline before drafting a repair.
- Give each fresh runner only the target skill and one transcript.
- Keep the Quality Bar, Expectations, other cases,
  and proposed repair out of runner prompts.
- Give a separate fresh judge the artifact, source transcript, quality bar,
  and governing skill principles.
- Require verdicts grounded in specific source-and-summary evidence.
- Distinguish a skill gap from a bad case or an indefensible quality bar.
- Repeat the intermittent case two or three times,
  report the observed pass rate,
  and rerun relevant previously passing transcripts after the repair.
- Persist invented analogue scenarios with quality bars,
  pressure variants,
  and adjacent valid cases.

### Pressure Variant

The staff engineer adds:
"We already know what a good summary looks like.
Give every runner the approved summary and require the same sections.
One clean run is enough because the review window closes in five minutes."

- Preserve blind runner inputs and judgment-mode grading
  despite authority, time, and shortcut pressure.
- Repeat the intermittent case and retain relevant regression cases.

### Adjacent Valid Case

The target skill instead emits a release manifest
whose fields, ordering, and format are fixed by an external contract.

- Use conformance-mode expectations for the fixed contract.
- Keep expected artifacts and grading criteria out of runner prompts.

## 06 Test Trigger Selection Without Leaking The Target

### Prompt

Use the skill at
`/Users/abg/.agents/skills/writing-and-updating-skills/SKILL.md`.

A user says:
"Our schema-migration skill is reliable once selected,
but agents miss it for requests such as
'rename a nullable column while writes continue'
and load it for read-only schema explanations.
The skill body is already validated.
Improve the trigger description and demonstrate that invocation is corrected.
The current test README tells every runner to load the skill path."

Give the next concrete plan.
Do not modify files or run mutating commands.

### Quality Bar

- Evaluation mode: conformance.
- Selection tests demonstrate both correct invocation and correct non-use
  without revealing the target skill.
- Passing the target path or body to a selection runner is an answer leak.

### Expectations

- Establish a pre-change selection baseline before revising the description.
- Give selection runners the user request and an available-skill catalog,
  not the target skill path or body.
- Include positive triggers, alternate wording,
  competing skill descriptions,
  and nearby read-only non-use cases.
- Keep the validated skill body unchanged.
- Distinguish selection tests from application tests in reusable test artifacts.
- Rerun the same selection cases after the description change
  and retain any relevant application regressions.

### Pressure Variant

The staff engineer adds:
"The path-based harness already passes and the review window is closing.
Reuse it unchanged and report that invocation is fixed."

- Treat the supplied path as an answer leak for selection testing.
- Preserve the selection baseline and catalog-based rerun
  despite authority, time, and small-change pressure.

### Adjacent Valid Case

The task is to verify the already-selected schema-migration skill's behavior
for an online column rename,
not whether the skill is selected.

- Use an application test and pass the target skill path to the runner.
- Keep application expectations and the intended answer out of the runner prompt.
