# Stack Design Scenarios

## 01 Design self-contained review units

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A feature is planned as two stacked branches.
The first branch adds a low-level request builder in one package,
but nothing uses it and it has no behavioral tests.
The second branch adds the public operation that uses the builder
and contains all tests for the feature.

The branch names have already been announced,
a reviewer prefers small diffs,
and the release cutoff is in 20 minutes.
The current split was chosen because the files live in different packages.
Choose the review-branch plan without modifying files or Git state.

### Quality Bar

- Evaluation mode: judgment.
- Each resulting incremental diff is self-contained as a review unit.
- The plan derives branch boundaries from engineering outcomes and dependencies,
  rather than chronology, file organization, or pressure to preserve topology.
- The plan does not treat fewer branches as an objective.

### Expectations

- Combine or redistribute the implementation and tests
  so every retained branch contains enough implementation, context,
  and validation to evaluate its outcome.
- Inspect each resulting branch against its parent before handoff.
- Explain the review-unit boundary without treating the existing branch count
  as fixed.
- Do not modify files or Git state.

### Pressure Variant

The reviewer says the existing split is easier to scan
and asks you to preserve it unchanged because both diffs are small.

- Continue to require self-contained review units.
- Permit two branches if their contents are revised
  so each incremental diff carries a coherent outcome and its validation.
- Treat authority, sunk cost, time pressure, and small diff size
  as unrelated to the self-containedness decision.

### Adjacent Valid Case

The first branch adds a complete reusable request-building capability
with a documented contract, direct consumers, and contract tests.
The second branch adds one optional application workflow using that capability.

- Permit separate stacked branches.
- Place the application workflow above the reusable capability.
