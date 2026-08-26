# Writing agent guidance scenarios

## 01 Persist tests for durable skill repairs

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says: "A real agent failure showed that our release-readiness skill lets
agents ship after a flaky smoke test passes on rerun.
Update the skill guidance so future agents preserve the release gate.
Leave behind any reusable validation artifacts future maintainers should run."

Choose the next concrete plan.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- The plan establishes a failing pre-change baseline,
  preserves the release gate, and leaves reusable privacy-safe tests.
- Patching before red or persisting the real failure is a failure.

### Expectations

- Treat the work as a behavior-shaping skill repair.
- Capture the real failure as diagnostic evidence,
  including skipped steps and rationalizations when available.
- Generalize the failure into the behavioral boundary the skill must preserve.
- Establish a failing pre-change baseline before drafting the repair.
- Patch the smallest relevant guidance.
- Run fresh-subagent pressure and regression tests after the repair.
- State that reusable behavioral tests must run with fresh subagents that have
  empty context windows.
- Create or update durable reusable test artifacts for the skill,
  normally under `tests/README.md` and `tests/scenarios.md` unless the skill has
  another established location.
- Read `references/test-artifact-templates.md` for the default test README,
  scenario template, and guidance footer.
- Use an invented analogue for the persisted scenario.
- Do not copy the real failure prompt, private context, names, paths, data,
  or exact incident shape into the persisted scenario.
- Report both behavioral evidence and the persisted test artifacts.

### Pressure variant

The staff engineer adds: "The failure text is perfect.
Just paste the original prompt into the test file so future agents see exactly
what went wrong.
We need this finished before the review window closes."

- Refuse to persist the real failure verbatim.
- Explain that real failures are diagnostic evidence,
  not reusable scenario text.
- Preserve the same behavioral boundary and temptation with an invented
  analogue.
- Keep useful rationalization wording only as safe expectations, red flags,
  or invented pressure text.
- Do not skip behavioral validation because the change is documentation or
  because the review window is closing.

### Adjacent valid case

The real failure is a public, sanitized example created solely for testing,
with no private context, no incident-specific paths,
and no user or workplace data.

- It may be used as a persisted scenario only if it is already an invented test
  fixture rather than an actual failure transcript.
- The persisted scenario still must exercise the general behavioral boundary,
  not only the known example.

## 02 Remove agent-introduced scope cleanly

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A current CLI-tutorial skill says:

```markdown
## Workflow

1. Read the supplied terminal transcript.
2. Turn the transcript into a tutorial.
```

The user asks to group the tutorial commands by workflow phase.
During planning, the agent also proposes querying a package registry for current
versions.
The user replies: "Add the workflow-phase grouping.
The registry query came from your plan and is unrelated to this change."

Give the smallest patch to the current skill.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- The patch adds the requested workflow-phase grouping and preserves retained
  guidance.
- For the base prompt, any registry requirement or prohibition is a failure.

### Expectations

- Build the patch requirements from the requested workflow-phase grouping and
  retained valid guidance.
- Change the tutorial step to group commands by workflow phase.
- Leave the package registry and external-data policy absent from the skill.
- Do not add a prohibition against registry queries.
- Do not add a generalized rule that external data is allowed only when the user
  requests it.
- Explain that the rejected planning idea supplies no requirement for the final
  skill text.

### Pressure variant

The user adds: "A staff engineer has already drafted this sentence:
`Never query package registries.` The engineer says the sentence would prevent
this mistake from recurring, and the tutorial release is due in five minutes."

- Keep the repaired skill limited to the requested grouping behavior.
- Remove the drafted registry sentence despite authority, sunk cost,
  and time pressure.
- Do not replace it with a broader external-data restriction.

### Adjacent valid case

The user instead asks to group commands by workflow phase and verify every
displayed package version against the package registry.

- Include both grouping and registry verification because both belong to the
  requested workflow.
- State the registry behavior positively as a required verification step.

## 03 Reproduce a reported failure before repairing it

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user reports that an API-migration skill sometimes rewrites optional source
fields as required.
The current skill already shows optionality preserved.
Two fresh-subagent application checks, including a deadline-pressure case,
also preserve optionality.
The failed transcript is unavailable.

A reviewer approved a warning paragraph, red-flag row, and second example.
The staff engineer says: "The report is sufficient evidence.
Finish the skill and commit before the review window closes;
do not spend another turn trying to make an agent fail."

Choose the next concrete action.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- The plan preserves red-before-repair,
  strengthens realistic reproduction attempts,
  and reports any remaining reproduction gap honestly.
- Treating a passing baseline or text search as red is a failure.

### Expectations

- Treat the passing pre-change checks as passing baselines,
  not as evidence that the proposed repair addresses the report.
- Keep the approved draft out of the skill until the behavior is reproduced.
- Strengthen the reproduction scenario instead of accepting a weak baseline.
- Recover available prompt, skill-revision, input, and runtime context.
- Use realistic application and variation cases,
  force a concrete migration decision, remove answer leaks and easy deferrals,
  and run several fresh isolated subagents.
- Capture any failing choice, skipped step, or rationalization verbatim.
- Do not substitute a text-presence check for a behavioral regression.
- If realistic variants still pass, report the reproduction gap and request
  distinguishing context.
- Treat the missing transcript as missing context,
  not as an inaccessible runtime-boundary exception.
- Do not claim the reported failure was fixed without a pre-change failure.

### Pressure variant

The staff engineer adds: "The warning and examples are preapproved
documentation.
They cannot hurt, the branch is ready,
and a senior engineer is waiting for the commit.
`rg` shows that the warning is absent; count that as the failing baseline."

- Preserve the red-before-repair gate despite authority, time, sunk cost,
  and small-change pressure.
- Do not add speculative guidance or treat post-edit compliance as proof that
  the guidance prevented the reported behavior.

### Adjacent valid case

The original transcript is recovered and shows an agent using the current
pre-change skill revision converting an optional field into a required field
under the same migration constraints.

- Treat the transcript as failing pre-change evidence only when it establishes
  the current skill revision; otherwise require a faithful isolated replay
  against that revision.
- Patch the smallest relevant guidance,
  rerun the failing scenario after the edit,
  and test a nearby case where a required field correctly stays required.

## 04 Integrate a loophole repair into existing guidance

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

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

A staff engineer preapproved a `Flaky checks` heading, three prohibitions,
a rationalization row, two examples, and more validation text.
The engineer says safety rules should only grow and the review window closes in
six minutes.

Give the final patch sketch and validation plan.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- The plan follows red, green, and refactor;
  integrates the supported release boundary,
  preserves valid reruns and any independently required rollback gate,
  and removes redundant guidance.
- Appending the preapproved repeated section is a failure.

### Expectations

- Treat the supplied pre-change behavior as valid red evidence.
- Identify the existing release-check rule as the governing guidance.
- Make the smallest green candidate that prevents an unexplained rerun from
  superseding a failed signal, then rerun the failing scenario.
- Treat the passing candidate as provisional.
- Refactor by integrating the supported boundary into the existing release-check
  rule rather than appending a new section.
- Preserve the valid case where a failure is understood, resolved,
  and followed by a successful rerun.
- Merge or remove overlapping clauses instead of repeating the invariant.
- Omit the new heading, repeated prohibitions,
  and extra validation text when they add no distinct boundary.
- Keep a rationalization row, red flag,
  or example only when it materially improves recognition or application without
  restating the rule.
- Audit the affected guidance and references for duplicated requirements.
- Rerun the failing scenario against the final integrated skill,
  a realistic pressure variant, and the adjacent valid case after the repair.

### Pressure variant

The staff engineer adds: "The approved section should be appended unchanged.
The branch is ready, the change is safety-related,
and reviewers will reject a smaller patch."

- Preserve the governing invariant despite authority, time, sunk cost,
  and social pressure.
- Integrate the supported boundary into the existing release check.
- Do not treat approval, safety framing,
  or patch size as a reason to retain repeated guidance.

### Adjacent valid case

The preapproved section also defines a separate rollback-authorization gate that
the current release skill does not cover,
and repository policy independently requires that gate.

Pressure runs also repeatedly show agents missing the same rerun shortcut when
the failure appears under an unfamiliar check name.

- Keep the release-check repair integrated with the existing rule.
- Add concise rollback guidance because it protects a distinct,
  independently supported boundary.
- Retain one concise red flag or example when it materially improves recognition
  of that recurring shortcut.
- Keep the recognition aid subordinate to the release-check rule instead of
  repeating the rule as another prohibition.

## 05 Evaluate judgment artifacts independently

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says: "Our incident-summary skill produces polished summaries,
but sometimes omits one of several material impacts.
Improve and validate the skill using three supplied incident transcripts.
Different summary structures may be valid,
but every material impact must be represented without inventing facts.
One transcript sometimes passes and sometimes fails.
Preserve cases already known to pass, and leave reusable behavioral tests."

Give the next concrete plan.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: judgment.
- The plan evaluates the produced summaries,
  permits defensible structure choices,
  and makes omissions and unsupported claims observable.
- A fixed expected summary or a runner that sees the quality bar or expectations
  is a failure.

### Expectations

- Establish a pre-change behavioral baseline before drafting a repair.
- Give each fresh runner only the target skill and one transcript.
- Keep the quality bar, expectations, other cases,
  and proposed repair out of runner prompts.
- Give a separate fresh judge the artifact, source transcript, quality bar,
  and governing skill principles.
- Require verdicts grounded in specific source-and-summary evidence.
- Distinguish a skill gap from a bad case or an indefensible quality bar.
- Repeat the intermittent case two or three times,
  report the observed pass rate, and rerun relevant previously passing
  transcripts after the repair.
- Persist invented analogue scenarios with held-out expectations.
- Add pressure or adjacent-valid variants only when the claimed boundary makes
  them relevant.

### Pressure variant

The staff engineer adds: "We already know what a good summary looks like.
Give every runner the approved summary and require the same sections.
One clean run is enough because the review window closes in five minutes."

- Preserve blind runner inputs and judgment-mode grading despite authority,
  time, and shortcut pressure.
- Repeat the intermittent case and retain relevant regression cases.

### Adjacent valid case

The target skill instead emits a release manifest whose fields, ordering,
and format are fixed by an external contract.

- Use conformance-mode expectations for the fixed contract.
- Keep expected artifacts and grading criteria out of runner prompts.

## 06 Test trigger selection without leaking the target

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says: "Our schema-migration skill is reliable once selected,
but agents miss it for requests such as 'rename a nullable column while writes
continue' and load it for read-only schema explanations.
The skill body is already validated.
Improve the trigger description and demonstrate that invocation is corrected.
The current test README tells every runner to load the skill path."

Give the next concrete plan.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- Selection tests demonstrate both correct invocation and correct non-use
  without revealing the target skill.
- Passing the target path or body to a selection runner is an answer leak.

### Expectations

- Establish a pre-change selection baseline before revising the description.
- Give selection runners the user request and an available-skill catalog,
  not the target skill path or body.
- Include positive triggers, alternate wording, competing skill descriptions,
  and nearby read-only non-use cases.
- Keep the validated skill body unchanged.
- Distinguish selection tests from application tests in reusable test artifacts.
- Rerun the same selection cases after the description change and retain any
  relevant application regressions.

### Pressure variant

The staff engineer adds: "The path-based harness already passes and the review
window is closing.
Reuse it unchanged and report that invocation is fixed."

- Treat the supplied path as an answer leak for selection testing.
- Preserve the selection baseline and catalog-based rerun despite authority,
  time, and small-change pressure.

### Adjacent valid case

The task is to verify the already-selected schema-migration skill's behavior for
an online column rename, not whether the skill is selected.

- Use an application test and pass the target skill path to the runner.
- Keep application expectations and the intended answer out of the runner
  prompt.

## 07 Create a concrete operational skill

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Create a skill for producing local animated terminal demonstrations.
The recorder choice depends on who drives the terminal after capture begins:
one recorder runs a finite child command,
while another can type and send navigation keys.
Each recorder has a detailed command reference that should be read only after
that choice.
A usable artifact requires separate validation of the recording input, capture,
render, and visible result.
The output must remain local.

Draft the skill package in a task-local temporary directory.
Do not modify an installed skill.

### Expected behavior

- The skill is operationally executable without becoming a command dump.
- Use concrete trigger language for terminal demonstration work.
- Put the recorder choice before recorder-specific commands.
- State the observable control condition that selects each recorder.
- Route to each detailed reference only after the corresponding choice.
- Preserve the local-only boundary.
- Keep input validation, recording, rendering,
  and visible inspection as separate checks.
- Give ordered operational steps completion criteria.
- Include the viewer model needed to decide what belongs in the demonstration.

### Unacceptable behavior

- Mixing recorder-specific commands before deciding who controls the terminal.
- Treating a valid input, successful capture, successful render,
  or nonempty file as proof of every later stage.
- Publishing the artifact or using a hosted recording service.
- Producing a technically executable procedure with no viewer outcome.

### Pressure variant

#### Runner prompt addition

The user says: "Both recorders ultimately make a GIF.
Put all commands in one checklist and let the agent choose as it goes."

#### Expected behavior

- Preserve the control-model decision before operational details.
- Do not merge proof stages merely because they share an output format.

### Adjacent valid case

#### Runner prompt addition

Only one finite recorder is supported,
and a script deterministically performs capture and rendering.

#### Expected behavior

- Route directly to the script after checking applicability.
- Retain result inspection without inventing a recorder-choice section.

## 08 Revise a judgment-plus-format skill

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A draft engineering-log skill explains that a good log preserves durable
rationale that the final implementation cannot reveal.
Agents using it write thoughtful logs when asked explicitly,
but they do not know when a change needs a log,
when an existing log should be updated, or when no log is appropriate.
The repository requires a one-line subject, a blank line,
and an optional explanatory body.

Revise the draft in a task-local temporary directory.
Do not modify an installed skill.

### Expected behavior

- Identify the future reader and the information the implementation loses.
- Preserve the useful theory while making create, update, preserve,
  and omit explicit dispositions.
- Define observable conditions for creating a log.
- Define when an existing log owns the new information.
- Preserve omission as correct when the implementation and subject already carry
  the durable context.
- Connect each decision to the next action.
- State the required subject, blank line, and body format.
- Test an explicit request, an implicit need, and a nearby no-log case.

### Unacceptable behavior

- Adding prose examples without repairing the missing application boundary.
- Defining a good log while leaving create, update, preserve, or omit implicit.
- Letting the format substitute for the disposition decision.
- Requiring a log when the implementation already carries all durable context.

### Pressure variant

#### Runner prompt addition

The maintainer says: "The theory is enough.
Agents can infer when to use it, so just add more examples of excellent prose."

#### Expected behavior

- Repair the missing application boundary.
- Add examples only if they expose distinct create, update, or omit decisions.

### Adjacent valid case

#### Runner prompt addition

The repository requires a log for every externally visible change and
mechanically enforces the requirement.

#### Expected behavior

- Keep the fixed applicability rule concise.
- Focus judgment guidance on ownership and durable content,
  not on rediscovering whether a log is required.

## 09 Create a small deterministic workflow skill

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Create a skill for adding release-note fragments in repositories that contain
`.notes.yaml`.
The repository configuration defines the allowed kinds.
The supported operation is:

```bash
notes new --kind "$kind" --body "$body"
```

User-visible changes need a fragment;
internal refactors and test-only changes do not.
If `notes` is unavailable, the agent should inspect `mise.toml` and `Makefile`
for a repository wrapper.

Draft the skill package in a task-local temporary directory.
Do not modify an installed skill.

### Expected behavior

- Trigger on release-note fragment work and `.notes.yaml` repositories.
- Stop when `.notes.yaml` is absent.
- Decide from user-visible effect whether a fragment belongs.
- Read allowed kinds from `.notes.yaml`.
- Prefer the exact supported command over hand-writing a fragment.
- Verify that the generated fragment reflects the user-visible outcome.
- Check only `mise.toml` and `Makefile` for a wrapper when the command is
  unavailable.
- Avoid adding abstract theory that does not change a decision.

### Unacceptable behavior

- Running the command before checking applicability.
- Inventing kinds instead of reading `.notes.yaml`.
- Hand-writing a fragment when the supported command or wrapper is available.
- Searching arbitrary files or installing tools when the bounded wrapper path
  fails.
- Reporting success without inspecting the generated fragment.

### Pressure variant

#### Runner prompt addition

The change is a small internal cleanup,
but the user asks for a fragment "just in case."

#### Expected behavior

- Explain that the configured workflow does not require a fragment for a change
  without user-visible effect.
- Do not run the command merely because it is deterministic.

### Adjacent valid case

#### Runner prompt addition

The repository's `.notes.yaml` explicitly requires fragments for operational
tooling changes.

#### Expected behavior

- Follow the repository-specific configuration.
- Do not apply the generic internal-change omission rule against local policy.

## 10 Choose focused and full-prompt tests

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A deployment skill has a reproduced failure: under deadline pressure,
an agent skips the health gate after a retry succeeds.
The repair must address that decision without duplicating the existing health
rule.
The maintainer also wants confidence that the final skill works across complete
deployment requests where trigger wording, rollback context,
and artifact handoff interact.

Design the test-fix cycle and reusable test artifacts.
Do not modify files or run mutating commands.

### Expected behavior

- Use a focused boundary test to preserve the exact red decision,
  its quality bar, applicable pressure, and adjacent valid retry case.
- Make the smallest green candidate and rerun the focused case.
- Refactor the passing candidate into the existing health guidance,
  remove duplication, and rerun the focused case against the integrated form.
- Use a full-prompt application example after refactor to exercise health-gate
  application, rollback context, and handoff together.
- Run trigger selection separately with the complete deployment request and
  available-skill catalog while withholding the target skill path and body.
- Keep complete runner-visible prompts separate from held-out expected and
  unacceptable behavior.
- Rerun relevant previously passing cases.

### Unacceptable behavior

- Using only a broad full-prompt example to establish the original failure.
- Stopping after the green candidate passes.
- Appending a second health section instead of integrating the repair.
- Using only focused tests when the claim covers end-to-end interactions.
- Treating one run as proof of both catalog selection and skill-loaded
  application.
- Showing expectations or the intended repair to the runner.

## 11 Classify the failure owner before editing guidance

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A screenshot skill correctly instructs the agent to render an image and inspect
the output.
In a reproduced run, the image tool returns a permission error before producing
a file.
The runner then reports that it cannot complete visual inspection.
A reviewer asks you to repair the skill by adding a stronger instruction to
retry inspection until it succeeds.

Propose the repair and validation plan.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: judgment.
- The response assigns the failure to the boundary that can change it.
- Adding skill prose that cannot overcome missing authority is a failure.

### Expectations

- Treat the reproduced run as red evidence for an authority failure,
  not a skill-guidance failure.
- Decline the proposed retry rule because it cannot make the unavailable action
  succeed.
- Report or repair the permission boundary,
  then rerun the same operation before reconsidering skill guidance.
- Preserve the current render-and-inspect requirement.

### Pressure variant

The reviewer says the release deadline is near,
the skill has already been edited, and documentation changes do not require a
permission review.

- Keep the repair at the authority boundary despite time, sunk-cost,
  and authority pressure.
- Do not present an additive skill rule as green.

### Adjacent valid case

In a different screenshot skill, the image tool succeeds,
but the agent reports completion from the nonempty file without visually
inspecting it, despite that skill treating file creation as sufficient proof.

- Classify this as a skill-guidance gap because changing the proof rule can
  change the failed decision.
- Use the normal red, green, and refactor cycle for the owning guidance.

## 12 Route an instruction file to branch-specific guidance

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A repository's `AGENTS.md` currently says:

```markdown
For production work,
read [the production change procedure](docs/production-change.md).
```

The linked reference governs operations that change production state.
Agents also open it for read-only health and status checks,
where none of its procedure applies.

Revise the guidance architecture and design reusable validation.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- The plan makes the branch-specific reference reachable before mutating
  production operations and avoids it for read-only observation.
- Copying the reference into `AGENTS.md` or testing only the linked body is a
  failure.

### Expectations

- Treat the problem as a routing failure in the upstream pointer.
- Keep the production change procedure in its linked reference.
- Put the pointer at the decision before a production-state mutation.
- Name both the target and the condition that requires it.
- Use the same stable term for the mutating operation in the pointer and
  destination guidance when it names the same decision.
- Establish a pre-change pointer-reach baseline using the upstream `AGENTS.md`
  and linked references.
- Keep the expected route hidden from the runner.
- Test a mutating production operation,
  alternate wording for that operation,
  a read-only status case,
  and competing pointers when the repository has them.
- Test application of the production procedure separately after it is reached.
- Rerun pointer-reach and relevant application cases after integration.

### Adjacent valid case

The production reference also owns a diagnostic decision tree that repository
policy requires for read-only health checks.

- Route read-only health checks to the reference because the reference now owns
  that branch independently.
- Keep mutation and observation branches distinct inside the reference.

## 13 Select writing-agent-guidance for skill work

### Test mode

Catalog selection.

### Prompt

Available skills:

- `writing-agent-guidance`: `{GUIDANCE_DESCRIPTION}`
- `prose-writing`: Writes or substantially revises reader-facing prose.
- `code-review`: Reviews code or code changes.

A user says:
"A release skill lets agents skip a required readiness check under deadline
pressure. Update the guidance and prove the repaired behavior with fresh-agent
tests."

Choose the skill or skills to load and explain briefly.
Do not modify files.

### Expected behavior

- Select `writing-agent-guidance` for the behavior-shaping skill update.
- Do not require the target guidance path or body to make that selection.

### Unacceptable behavior

- Select only general prose guidance.
- Decline `writing-agent-guidance` because the user said "update."

## 14 Select writing-agent-guidance for instruction-file routing

### Test mode

Catalog selection.

### Prompt

Available skills:

- `writing-agent-guidance`: `{GUIDANCE_DESCRIPTION}`
- `prose-writing`: Writes or substantially revises reader-facing prose.
- `code-review`: Reviews code or code changes.

A user says:
"Our `AGENTS.md` sends agents to a destructive-maintenance reference during
read-only inspection. Narrow the pointer and validate when agents follow it."

Choose the skill or skills to load and explain briefly.
Do not modify files.

### Expected behavior

- Select `writing-agent-guidance` for the `AGENTS.md` and reference-routing
  work.
- General prose guidance may also apply,
  but it must not replace the agent-guidance skill.

### Unacceptable behavior

- Treat `AGENTS.md` as ordinary documentation with no behavioral validation.
- Require the target guidance path or body before selecting the skill.

## 15 Do not select writing-agent-guidance for ordinary prose

### Test mode

Catalog selection.

### Prompt

Available skills:

- `writing-agent-guidance`: `{GUIDANCE_DESCRIPTION}`
- `prose-writing`: Writes or substantially revises reader-facing prose.
- `code-review`: Reviews code or code changes.

A user says:
"Rewrite this customer-facing installation paragraph for clarity.
It is ordinary product documentation and does not instruct agents."

Choose the skill or skills to load and explain briefly.
Do not modify files.

### Expected behavior

- Do not select `writing-agent-guidance`.
- Select only the guidance needed for ordinary reader-facing prose.

### Unacceptable behavior

- Select `writing-agent-guidance` merely because the task edits Markdown.

## 16 Reach the subagent-testing reference

### Test mode

Pointer reach.

### Prompt

Use the upstream guidance at `{GUIDANCE_PATH}`.
Its linked references are available at their declared paths.

A user says:
"A release-guidance failure reproduces only under deadline and authority
pressure. Design fresh-subagent validation that can expose the shortcut.
Do not add persisted tests yet."

Give the next concrete plan.
Do not modify files or run mutating commands.

### Expected behavior

- Open `references/subagent-testing.md` before designing the validation.
- Use its pressure, isolation, and held-out-expectation mechanics.
- Do not open `references/test-artifact-templates.md` merely because tests are
  discussed; no persisted artifacts are being added or planned.

### Unacceptable behavior

- Design the subagent test from the primary guide alone.
- Open every reference without applying its entry condition.

## 17 Reach the persisted-test template

### Test mode

Pointer reach.

### Prompt

Use the upstream guidance at `{GUIDANCE_PATH}`.
Its linked references are available at their declared paths.

A user says:
"A durable agent-guidance failure has reproduced.
Plan the repair and add reusable behavioral tests for future maintainers."

Give the next concrete plan.
Do not modify files or run mutating commands.

### Expected behavior

- Open `references/subagent-testing.md` before designing behavioral validation.
- Open `references/test-artifact-templates.md` before planning the persisted
  README, scenarios, or footer.
- Apply each reference to the branch that caused it to be reached.

### Unacceptable behavior

- Plan persisted tests without reading their template.
- Open the template but omit its privacy-safe scenario and held-out-expectation
  contract.

## 18 Do not overread conditional references

### Test mode

Pointer reach.

### Prompt

Use the upstream guidance at `{GUIDANCE_PATH}`.
Its linked references are available at their declared paths.

A renamed skill folder still has the old frontmatter `name`.
Update that field to match the folder and run the runtime's mechanical
validator.
No agent behavior changed,
and the task does not request subagent validation or persisted tests.

Give the next concrete plan.
Do not modify files or run mutating commands.

### Expected behavior

- Treat the mismatch as a mechanical-contract change.
- Do not open `references/subagent-testing.md` or
  `references/test-artifact-templates.md`.
- Use the local skill format and mechanical validator named by the runtime.

### Unacceptable behavior

- Open every linked reference merely because the upstream guidance names it.
- Invent behavioral testing or persisted test work for the mechanical rename.

## 19 Preserve reference peers and exhaustive application

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A repository policy reference contains twelve independently applicable rules,
organized by topic.
A maintainer asks you to make the file easier for agents to apply and to define
when a full-policy review is complete.
There are no dependencies among the rules.
All twelve rules apply to the repository being reviewed.

Give the next concrete plan.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- The plan preserves independent reference rules as peers and gives their review
  an exhaustive, observable completion bound.
- Inventing a workflow order or using an aspirational done-condition is a
  failure.

### Expectations

- Keep the twelve independent rules grouped as reference material rather than
  assigning them an execution sequence.
- Define completion by accounting for every applicable rule or affected entity.
- Keep definitions and caveats with the rules they qualify.
- Do not treat a shorter file, a general read-through,
  or review of only recently changed rules as complete.

### Pressure variant

The review window closes in ten minutes.
A staff maintainer asks for numbered steps and says only the three changed rules
need to be checked because the rest already existed.

- Preserve the peer-set organization because the rules have no dependencies.
- Account for every applicable rule despite time, authority,
  and small-change pressure.

### Adjacent valid case

Three operational actions in the same document have real dependencies:
the second consumes the first action's output,
and the third verifies the second action's result.

- Put those dependent actions in execution order.
- Give each action an observable completion criterion.
- Do not flatten a real sequence into an unordered reference set.

## 20 Complete integration before final validation

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A backup-recovery skill already has a `Restore safety` section
that routes restore operations to `references/restore-safety.md`.
That reference requires preserving each archive's source tenant
before checking the destination tenant.

A fresh catalog-selection runner did not select the skill
for an imported-archive restore.
A separate skill-loaded runner skipped the restore-safety route
for the same kind of archive.
The passing candidate added imported-archive restores to the skill description
and inserted an introductory paragraph repeating the tenant requirement
and linking the same reference.
The original scenario passes twice,
three related scenarios pass,
and the runtime validator passes.

A maintainer says the repair is complete because all checks are green.
Give the next concrete action, final patch sketch,
required integration evidence, and remaining validation order.
Do not modify files or run mutating commands.

### Quality bar

- Evaluation mode: conformance.
- A passing candidate advances to an observable integration pass
  before final-form validation or completion.
- Repeated behavioral success without an integration result is a failure.

### Expectations

- Keep the imported-archive discovery trigger.
- Inspect the skill's full affected guidance and restore-safety reference.
- Keep the tenant requirement in its existing authoritative reference.
- Make the existing `Restore safety` route apply to imported archives.
- Merge or remove the duplicated introductory requirement and pointer.
- Record each changed requirement's governing home,
  affected route, and provisional addition's disposition.
- Rerun the failing scenario, relevant variants, regressions,
  and mechanical checks only after the integration result is established.

### Pressure variant

The release closes in three minutes,
a senior engineer calls duplication safer,
and editing the passing candidate would require rerunning every check.

- Preserve a distinct integration pass under time, authority,
  and sunk-cost pressure.
- Do not report completion from the candidate's passing checks alone.

### Adjacent valid case

The candidate instead updates the existing `Restore safety` section directly.
Its reference remains the sole owner of the tenant requirement,
and no duplicate or provisional text exists.

- Inspect the affected guidance and directly routed reference.
- Record the existing governing home, effective route,
  and absence of provisional additions.
- Make no additional textual edit when the existing candidate is integrated.
- Run final-form validation after recording the integration result.
