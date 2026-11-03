# Subagent testing

Test observable decisions and produced artifacts.
A runner's explanation of the guidance is not evidence that it can use it.

## Define the comparison

Before running a trial, record the representative input, quality bar,
failure conditions, and evidence to capture.
Use judgment criteria when several results are defensible;
use conformance checks for a fixed format, command, or contract.
Keep grading criteria separate from runner input.

For a new skill, compare against no skill.
For an update, retain the current version as the baseline.
For a claimed behavioral repair, the baseline must exhibit the failed behavior.
For an authorized efficiency revision, compare quality and cost even when both
versions succeed; report it as an optimization.

Hold task inputs, model, reasoning settings, tools, and surrounding instructions
constant where possible.
Record differences that could explain a result.
Measure the costs that matter: guidance loaded, output size, unnecessary actions,
tool calls, tokens, and elapsed time when available.
Separate main-file size, whole-package size, and context actually loaded.
Static token counts are not runtime savings;
input tokens may include repeated cached context.
Small local samples reveal regressions and large effects, not universal laws
about prompt length or model behavior.

## Isolate the runner

Use a fresh context with only one guidance version.
A candidate at a new path is not isolated if the installed version remains
discoverable, automatically loaded, or inherited from the parent.
Use the active path in place, or a harness that excludes the competing version.
Snapshot the baseline outside skill discovery, record revision hashes,
and inspect prompts or access traces for contamination.
Do not edit the active guidance while trials are using it.

Give the runner only the realistic request and necessary raw inputs.
Withhold the diagnosis, proposed repair, expected answer, other trials,
and evaluator-only sections.
Keep side effects read-only or inside a disposable task directory;
do not let tests commit, publish, deploy, or mutate shared state.
Retain raw outputs, produced artifacts, and relevant tool traces.

## Match the case to the claim

| Claim | Test |
| --- | --- |
| Required discipline survives pressure | Force a concrete decision with realistic incentives to skip the rule. |
| A technique transfers | Ask for an application, then change a material condition and test a counterexample. |
| Reference material is usable | Retrieve and apply it; include a case where needed information is absent. |
| A catalog description triggers correctly | Supply the catalog and task, withholding the selected skill path and body. Include alternate wording, a competing skill, and a nearby non-use case. |
| A pointer is reached correctly | Supply upstream guidance and accessible references, withholding the expected route. Require a tool or harness trace; self-report is insufficient. |
| Guidance produces useful artifacts | Have a runner produce the artifact and a separate judge assess it. |

To test compaction transfer, give fresh authors an existing package
and a realistic editing request, without a prepared requirement inventory.
Compare their rewrites under baseline and candidate authoring guidance,
then test downstream use of the rewritten guidance.
A prompt that supplies all requirements tests writing, not their recovery.

Use a focused case to isolate one decision.
Use a full task when surrounding context, routing, or interacting rules matter.
Pressure belongs in discipline tests; pure reference or technique guidance needs
application tests, not invented incentives to violate it.
Combine relevant pressures such as time, authority, sunk cost, or a small change
when they make the reported shortcut plausible.
Do not leak the expected answer through suggestive options or grading language.

For pointer claims, inspect which files were read and in what order.
Include a matching task, alternate wording, and a nearby task that should skip
the reference; test competing pointers when present.
If the harness cannot expose access, mark routing unvalidated;
the final answer can still supply application evidence.

## Grade the result

The parent may grade a simple decision against the stated contract.
For substantial artifacts or judgment, use a fresh independent judge with:

- the source task and produced artifact;
- the held-out quality bar and governing requirements;
- no preferred artifact or instruction to make the candidate pass.

Require evidence for material verdicts: artifacts for content,
access traces for retrieval, and tool actions for execution.
A read-only plan establishes planning behavior, not execution discipline.
Grade against facts supplied or retrievable by the runner;
allow valid conditional plans when facts are unspecified.
Do not infer skipped work from missing narration or require a preferred implementation.
Retain raw judgments and record evidence-backed corrections separately.
When comparing versions, hide their labels or vary presentation order where possible.
Grade correctness and efficiency separately so a shorter incomplete artifact
cannot win on length.
Check unsupported obligations, redundant explanations, and examples whose
incidental details have become rules.

For compact guidance, include a task unlike its examples and a case requiring
more context, so the evaluation does not reward omission.
Test behavior under the authored guidance when claiming it reliably guides
downstream agents; judging its prose alone supports a narrower claim.

Classify failures before changing the skill:

- Wrong or leaked expectations: repair the test or evaluator.
- Missing selection or retrieval: repair the route.
- Missing inputs or tooling setup: repair application support.
- Unavailable capability or authority: resolve or report that prerequisite.
- Wrong decision despite sufficient context: investigate the governing guidance.

## Repeat and integrate

Run important or variable cases two or three times with fresh runners.
Keep failures and report the observed pass rate rather than selecting the best run.
Compare promising wording on matched cases before choosing it.
Test the integrated form under the main skill's workflow.
After further edits, repeat only checks affected by the change.
Distinguish baseline limitations, possible regressions, demonstrated regressions,
and evaluator errors.
Investigate consequential uncertainty; do not expand compaction into unrelated repairs
or add rules solely to make a small sample pass.

If a claimed defect does not reproduce:

1. Recover the failed prompt, revision, inputs, tools, and runtime facts when available.
2. Check for answer leaks, missing inputs, shared context, and an invalid quality bar.
3. Try realistic variants of wording, task stage, evidence, or pressure.
4. If they still pass, stop that defect repair and report the reproduction gap.

A missing transcript alone does not make a boundary inaccessible.
If the runtime boundary cannot be exercised and the user requires preventive work,
make only the supported change, test the reachable analogue,
and state the unverified boundary.
Urgency or a small diff does not turn a passing baseline into failed evidence.

When a failure reveals a new workaround, preserve the runner's wording in the
private repair record and identify the underlying condition that changes the action.
Refine the existing rule; retain an example or warning only when it adds recognition.
Test a nearby permitted case to detect overrestriction.
