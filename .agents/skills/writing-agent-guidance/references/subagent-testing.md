# Subagent testing for agent guidance

Use this reference before validating agent-guidance behavior with subagents,
designing pressure tests, or repairing loopholes discovered during testing.

## When to test

Use subagent tests for guidance that enforces discipline, has compliance costs,
can be rationalized away, or contradict immediate pressure.

Do not pressure-test pure reference guidance, guidance without rules to violate,
or guidance agents have no incentive to bypass.
For those, use retrieval, gap, or written application checks instead.

## Test shapes

Baseline tests show what agents naturally do before the new guidance exists.
For new guidance, run them without the candidate.
For an update, run them against the current guidance before drafting the
behavior-changing edit.
A baseline is red only when it produces the behavior the repair must prevent.
A passing baseline does not show that a proposed repair addresses the report.

Pressure tests show whether the guidance holds when the agent has a reason to
skip, reinterpret, or minimize it.
Run them after the guidance or update exists.

Subagent tests should be isolated.
They test choices, rationalizations, and expected use of the guidance;
they should not mutate shared files, create commits, publish artifacts,
deploy systems, or modify external state.
If tool use is necessary, limit it to read-only inspection or artifacts under a
task-local temporary directory outside the target repository.

## Prepare the evaluation

Before spending subagent runs, resolve the target guidance and a representative
input, then define the quality bar a useful result must clear.
The bar should state the observable outcome and the smells that demonstrate
failure.
If either the input or bar is unavailable,
ask for the missing information instead of inventing an evaluation.

Choose the evaluation mode:

- Judgment: state the outcome and failure smells,
  then allow defensible differences in structure or approach.
  Do not turn the bar into a prescribed answer.
- Conformance: list the required fields, format, procedure,
  or other fixed contract the result must satisfy.

```markdown
Input:
<representative task or artifact>

Quality bar:
<observable outcome a competent practitioner should achieve>

Failure smells:
<behaviors or omissions that demonstrate the bar was missed>

Evaluation mode:
judgment | conformance
```

Give the runner the prompt and representative input.
Keep the quality bar, expectations, and proposed repair outside the runner
prompt;
the evaluator or judge applies them afterward.

## Choose the scenario scope

Use a full-prompt example when the claim depends on the complete task context.
Persist the complete runner-visible request under `Prompt`,
then keep `Expected behavior` and `Unacceptable behavior` evaluator-only.
This shape is strongest for entry routing, end-to-end application,
substantial artifact production, and interactions among several rules.

Use a focused boundary test when one decision must be isolated.
State the representative input, quality bar, expectations,
and only the pressure or adjacent variants needed for that boundary.
This shape is strongest for red reproduction, loophole diagnosis,
one-rule pressure tests, and fixed conformance checks.

Do not confuse scope with realism.
A focused test must still present a plausible decision point,
and a full-prompt example must still have an observable pass boundary.
For a behavior-changing repair, use the focused case for red and green.
After refactor, use a full-prompt example when surrounding context could affect
discovery, application, or the produced artifact.

When ownership is clear but several instruction forms remain plausible,
compare candidate wording against the same focused decision and realistic
surrounding context.
Keep the current or no-guidance condition as a control,
run multiple fresh samples per candidate,
and inspect raw responses rather than relying on counts alone.
Convergence on the intended decision is evidence about wording quality;
the comparison chooses a green candidate and does not replace final-form
refactor or end-to-end testing.

## Guidance kinds and test shapes

Use the test shape that matches the guidance kind.
Many guidance systems mix kinds;
test the behavior that carries the highest risk.

- Discipline guidance: force a concrete choice under pressure.
  Examples: test-first development, release readiness,
  verification-before-completion, safety reviews, and approval gates.
- Technique and pattern guidance: ask for the plan, diagnosis,
  transformed snippet, or patch sketch the guidance would produce.
  Examples: condition-based waiting, root-cause tracing, reducing complexity,
  defensive programming, and dependency upgrade triage.
- Reference guidance: ask the subagent to retrieve and apply the relevant
  information in a written answer.
  Observe which references it opens and in what order;
  repeatedly ignored or overread files are evidence about routing and
  information architecture.
  Examples: command references, API guides, file-format notes,
  schema references, and style guides.
- Catalog-selection tests: present the task and an available-skill catalog,
  but withhold the target skill path and body.
  Test positive triggers, alternate user wording, competing skill descriptions,
  and nearby non-use cases.
- Pointer-reach tests: present the realistic task and upstream guidance with
  access to its linked references, but withhold the expected route.
  Test the branch that should follow the pointer,
  a nearby branch that should not, alternate condition wording,
  and competing pointers when they exist.
  Require a harness or tool trace of guidance-file access;
  do not infer pointer use from the final answer or the runner's self-report.
  When the runtime cannot expose that trace,
  mark the pointer-reach claim unvalidated and use the answer only as
  lower-confidence application evidence.
- Artifact-producing guidance: ask a runner to produce the artifact,
  then grade that artifact against the quality bar.
  A convincing rationale does not establish that the artifact is useful.

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

For catalog-selection tests, passing the target skill path is an answer leak:

```text
Available skills:
- schema-migration: Plans and performs live schema changes.
- schema-inspection: Explains or inspects existing schemas.

User request:
Rename a nullable column while writes continue.

Choose the skill or skills you would load and explain briefly.
```

## Classify the failure owner

Use the failure-owner gate in the core workflow.
For a subagent test, inspect the runner-visible setup before assigning the gap to
guidance:

- A leaked answer, missing input, or expectation outside the stated contract is
  a test or evaluator gap.
- Failure to discover a skill or follow a pointer is a routing gap.
- Missing local context or tooling instructions are application-support gaps.
- An unavailable operation or missing permission is a capability or authority
  gap.

Assign the gap to guidance only when changing the loaded guidance can change the
failed decision.

## Grade artifacts independently

When the guidance produces an artifact, use separate runner and judge roles:

1. Give a fresh runner the target guidance and representative input.
   Withhold the quality bar, expectations, other cases, and proposed repair.
   Capture the artifact without modifying shared state.
2. Give a separate fresh judge the artifact, source input, quality bar,
   and the target guidance's governing principles.
   Withhold any expected artifact and do not ask the judge to make the run pass.
3. Require the judge to cite the source-and-output evidence behind each verdict.
   A numeric score alone can hide which part of the bar failed.
4. Classify a failing verdict using `Classify the failure owner`.
   If the bar punishes a defensible choice or requires behavior outside the
   guidance's purpose, repair the case instead of bending the guidance to pass.

For a simple decision test, the parent evaluator can apply the stated
expectations directly.
Use an independent judge when the artifact or judgment boundary is substantial.

## Account for variability and regressions

One passing run is weak evidence for intermittent or borderline behavior.
Run important or borderline cases two or three times with fresh subagents,
record the observed pass rate, and retain the raw failures.
A case that passes once and fails twice remains a failure.

After repairing guidance, rerun the failing case, applicable variants,
and relevant previously passing cases.
The regression sweep should exercise every retained behavior the repair could
plausibly affect, not every unrelated scenario in the folder.
Run that sweep against the final integrated guidance,
not only the provisional green patch.

## Baseline prompt pattern

For new guidance, omit the candidate from baseline tests.
For an update, use the current guidance before the proposed change.
Give only the realistic task, constraints, and raw artifacts.

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

## When a reported failure does not reproduce

Do not draft a behavioral repair after passing baselines.
Passing runs show only that the tested scenario passed;
agent behavior varies between isolated runs,
and a weak scenario can hide the reported decision.
Strengthen the reproduction campaign first:

1. Recover the failed prompt, guidance revision, task inputs, tool availability,
   and relevant runtime state when they are available.
   Replay the decision point against the current guidance without leaking the
   diagnosis, expected answer, or proposed patch to the tested subagent.
2. Check the test itself.
   Make the expected behavior and pass/fail boundary unambiguous,
   remove accidental hints and shared state,
   and confirm that the scenario permits the reported shortcut.
   A search proving that a sentence is absent or present is a text check,
   not a behavioral regression test.
3. Match the scenario to the reported behavior.
   For discipline-enforcing guidance,
   make the shortcut attractive with at least three realistic pressures,
   force a concrete action, and remove easy deferrals.
   For technique and reference guidance, use realistic application, variation,
   retrieval, or gap cases.
   Vary trigger wording, inputs, workflow stage,
   and available evidence while preserving the same behavioral boundary.
4. Run several fresh, isolated subagents and capture raw choices, skipped steps,
   and rationalizations.
   Use the attempts that produce the failure as red evidence;
   passing attempts are useful contrast,
   not permission to write an unproven repair.

If realistic variants still pass, stop the repair and report the reproduction
gap.
Request the missing transcript, runtime signal, or distinguishing context.
Approval, urgency, a small diff, and a claim that extra guidance cannot hurt do
not make a passing baseline red.

When a required runtime boundary is genuinely inaccessible and the user
explicitly requires preventive hardening anyway,
make only a narrowly supported change and label it preventive.
A missing transcript alone is not an inaccessible boundary.
When a task-local analogue can still exercise the reported decision,
continue the reproduction campaign instead of using this exception.
Validate the reachable decision boundary,
state that the reported behavior was not reproduced,
and preserve the missing runtime check as an explicit validation gap.
Do not describe that exception as a verified fix.

## Pressure scenario pattern

Combine several pressures and force an action.
The prompt should make the shortcut attractive.
Use concrete options, real constraints, real paths when relevant,
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

A good result chooses the action that preserves the guidance's boundary,
cites the relevant guidance, and avoids expanding scope without evidence.

## Useful pressure types

Use at least three pressures for discipline guidance:

| Pressure | Example |
| --- | --- |
| Time | "The release branch closes in 15 minutes." |
| Sunk cost | "You already wrote the fix and it passes locally." |
| Authority | "The reviewer says the rerun is enough." |
| Exhaustion | "It is late and this is the third revision." |
| Social | "You do not want to look rigid." |
| Ambiguity | "The failure might be unrelated to your change." |
| Small change | "It is just a one-line fix." |

## Rationalization capture

Record failures in this shape:

```markdown
## Scenario
[Prompt and constraints.]

## Expected behavior
[What the guidance should cause the agent to do.]

## Observed behavior
[What the subagent did.]

## Exact rationalizations
- "[Quote exact wording.]"
- "[Quote exact wording.]"

## Likely gap
[Trigger, ordering, missing rule, vague boundary, test leak, or weak scenario.]

## Repair
[Smallest guidance or scenario repair that should prevent the same failure.]
```

Exact wording matters.
Do not summarize a rationalization as "the agent made excuses" when the repair
depends on the excuse's shape.

For each new rationalization, diagnose and repair the exposed gap concretely:

- For behavior-shaping repairs, identify the invariant, the observed symptom,
  and an adjacent valid case before drafting normative text.
- Classify the failure using `Classify the failure owner`.
- For a guidance gap, locate and refine the rule, table, example,
  or reference that already governs the boundary using positive criteria.
- For a test gap, repair the scenario, setup,
  or answer leak before changing guidance.
- Use a direct negation only when the workaround is always invalid across the
  guidance's intended use cases.
- Keep a rationalization row, red flag,
  or example for a guidance gap when it materially improves recognition or
  application without restating the rule.
- Update the description if the rationalization is a trigger symptom.
- Rerun the scenario that exposed the loophole.

Audit overfitting before treating a repair as ready:

- Read the affected primary guidance and references together.
- Consolidate redundant requirements and retain repetition only where a separate
  decision point needs it.
- Preserve normative clauses that protect a distinct boundary or are needed at a
  separate decision point.
- Keep rows or examples only when they materially improve recognition or
  application without restating the rule.
- Search the draft repair for terms copied from the observed failure.
- Keep copied terms in normative guidance only when they name the stable
  boundary across intended use cases.
- Move symptom details into examples, red flags,
  or retest scenarios when they are only the case that exposed the boundary.
- Test an adjacent valid case so the repair does not outlaw valid behavior.

Return to green in the core workflow after diagnosing the loophole.
Carry the exact failing scenario, captured rationalization,
applicable pressure or adjacent variant,
and relevant previously passing cases into that loop.

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

## Meta-test prompt

When a subagent fails despite having the guidance,
ask a follow-up that exposes whether the problem is wording, organization,
or deliberate noncompliance.
This diagnoses a failed scenario; it does not replace baseline or pressure
tests.

```text
You read the guidance and still chose [failing action].

How should the guidance have been written or organized
to make [correct action] the clear next step?
If the guidance already made that clear,
say so and explain what you ignored.
```

Use the answer carefully:

- If the subagent names missing wording,
  integrate or sharpen that wording in the governing guidance.
- If the subagent missed an existing section,
  move the guidance earlier or link it at the decision point.
- If the subagent says the guidance was clear, inspect the scenario, setup,
  and answer leaks before changing guidance.
  Repair a test gap in the scenario; for an evidenced guidance gap,
  refine the boundary or retain a useful recognition aid.

## Sufficient testing checklist

Agent guidance is ready when evidence shows that agents can use it,
not merely recite it.

- New guidance was tested without the candidate,
  or an update was tested against the current guidance.
- Reproduced behavior-changing repairs have a failing pre-change scenario with
  failures captured verbatim.
  Narrowly supported preventive changes have reachable-boundary validation and
  an explicit unreproduced-runtime gap.
- The new or changed guidance addresses an observed failure or the narrowly
  supported preventive boundary.
- A fresh subagent ran a realistic isolated scenario with the guidance.
- The evaluation has a representative input and an observable quality bar.
- Judgment tests permit defensible variation;
  conformance tests state the fixed contract.
- Catalog-selection tests withhold the target skill path and body and cover
  positive and nearby non-use cases.
- Pointer-reach tests withhold the expected route and cover the target branch,
  a nearby non-use branch, and competing pointers when relevant.
- Artifact-producing tests grade the artifact with cited source-and-output
  evidence.
- Discipline tests combined multiple pressures and forced a concrete choice with
  no easy out.
- For reproduced repairs, the same failing scenario passes after the change.
- The passing green candidate was integrated into the existing guidance,
  and the exact scenario passes against the final refactor form.
- Important or borderline cases have repeated-run evidence,
  and relevant previously passing cases were rerun.
- The passing subagent cites or relies on the relevant guidance.
- When a post-change subagent fails despite having the candidate guidance,
  meta-testing was used to diagnose whether the guidance was unclear.
- Mechanical validation passes.
- Remaining risks are reported explicitly.

Guidance is not ready if the subagent finds a new rationalization,
argues the guidance is wrong, creates a hybrid workaround,
or asks for permission while arguing for the violation.

If a new rationalization appears, capture and diagnose it.
Revise the governing guidance or behavioral scenario when the evidence exposes a
gap, then rerun the scenario that exposed it.
