# Reusable guidance tests

Keep scenarios with the skill, using its existing test layout or:

```text
tests/
  README.md
  scenarios.md
```

The README identifies the scenario file, required fixtures, substitutions,
and package-specific execution steps.
Refer to this skill's Subagent testing reference for shared evaluation mechanics;
do not copy the testing manual into every package.
Do not add a test-running footer to execution guidance.

Use one clear boundary between runner input and evaluator criteria:

```markdown
## Scenario name

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.
<Realistic request and necessary raw inputs.>

### Evaluation

- Mode: judgment or conformance.
- Required outcome and evidence.
- Material unacceptable behavior.
- Adjacent valid outcome, when relevant.
```

For catalog selection, provide the catalog instead of the selected path/body.
For pointer tests, provide upstream guidance and access to references;
record access independently of the runner's answer.
For variants, keep each runner-visible addition separate from its evaluation.
Existing scenario formats may remain when that separation is unambiguous.

Persist invented analogues of real failures, retaining the decision boundary
without copying prompts, identities, private data, or incident-specific details.
Keep original evidence in the private repair record.
Fixtures must contain the inputs needed to reproduce the decision,
not the expected answer disguised as context.

Retain raw trial evidence outside execution guidance.
For comparisons, record the active revision, model, settings, outcomes,
and available cost measures.
Update tests when the supported behavior changes; do not require a particular
wording, heading, or length when another form satisfies the contract.
