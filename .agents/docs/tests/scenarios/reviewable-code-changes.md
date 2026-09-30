# Reviewable code changes

## Separate moved pricing from behavioral additions

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable routes.
This is a delivery-planning exercise.
Do not modify files, Git state, or external systems.

An established checkout operation validates orders, applies member discounts
and coupons, computes delivery, tax, handling, and credit usage,
then charges the customer and records the result.
Standard free shipping currently uses gross merchandise value,
and tax excludes delivery charges.
Its public inputs, receipt, errors, rounding, minimum-charge rules,
and payment/recording order must remain compatible.

The user requested a pure checkout preview and two pricing changes:
free shipping should use merchandise remaining after discounts and coupons,
and tax should include delivery charges while still excluding handling.
Preview must use the same validation and calculation as checkout
without charging or recording anything.
The approved final design puts pricing validation and calculation
in one shared owner, leaving payment and recording in checkout.

The agent has already completed one passing patch.
It deletes about 180 lines of established validation and calculation from
checkout, adds them to the pricing module with renamed helpers and records,
changes the shipping and tax bases there, and adds preview.
The existing suite and new feature tests pass.
The maintainer wants the approved final ownership delivered today,
and considers the two arithmetic changes small.
Branch stacking is available.

Choose how to deliver this completed work for review.
State what belongs in each review unit, its comparison base,
which behavior it preserves or changes, and the evidence a reviewer needs.
Include the requested final ownership and preview in the delivered result.
Do not implement the plan or defer part of the requested outcome.

### Expected behavior

- Retain the approved pricing owner shared by preview and checkout.
- Make the changed shipping and tax bases visible independently
  of moving and renaming the established calculation.
- Describe concrete contents and a parent for each review unit,
  allowing a preparatory refactor or a subsequent preservation refactor
  when its intermediate state is coherent.
- State what validation must establish against each parent,
  including requested behavior already present below a refactor.
- Preserve unchanged public contracts, calculation rules,
  and payment/recording order.

### Unacceptable behavior

- Deliver the mixed patch unchanged because it is complete or its tests pass.
- Supply branch titles without explaining their contents and comparison bases.
- Call the extracted calculation wholly new code because its file is new.
- Omit the approved pricing owner or preview to reduce the diff.
- Include unrelated behavior changes in a preservation refactor.

## Keep review boundaries proportional

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable routes.
Choose the code organization and review boundaries for each independent case.
Do not modify files or run mutating commands.

1. Add an independently owned catalog exporter in a new module.
   Existing integration needs one import and one dispatch entry.
   Nearby legacy modules have poor declaration order,
   but none of their implementation is reused by the exporter.
2. A twelve-line calculation needs one early return for a newly supported input.
   Moving a two-line local calculation below that return is necessary
   to avoid evaluating it on the new path.
   Both the movement and the behavioral condition fit in one visible hunk.
3. A requested reservation feature needs a shared owner for an existing rule
   before changing that rule across two callers.
   Introducing that owner can preserve both callers' behavior,
   and a local test can establish the old rule before the feature changes it.
   The destination and scope have been approved.
4. A user explicitly requests only reordering declarations and renaming
   private helpers throughout one established module.
   The requested scope has one owner and requires no behavior change.

### Expected behavior

- Design the new exporter well immediately,
  keep integration focused, and leave unrelated legacy organization alone.
- Keep the small necessary control-flow edit with the behavioral change;
  do not create a contrived intermediate implementation to split it.
- Put the preservation refactor below the reservation feature
  when it establishes the owner needed for the behavioral review.
- Deliver the structural-only task coherently without manufacturing
  a behavioral branch or abandoning the authorized refactor.

### Unacceptable behavior

- Require a poor initial design or whole-project cleanup for new code.
- Mandate a separate branch for every moved line.
- Retain duplicate policy owners merely to reduce the current diff.
- Treat reviewability as a reason to omit requested refactoring.

## Preserve the parent's behavior in a subsequent refactor

### Prompt

Use the guidance at `{GUIDANCE_PATH}` and its applicable routes.
Do not modify files or run mutating commands.

A parser change adds support for empty lists.
Its behavioral patch is small and clear in the established function.
The requested final organization also moves that function and its helpers
into a parsing module, with clearer private names.
A proposed extraction would move most of the same lines as the behavior patch.
The new module is useful for the completed feature,
while extracting the old parser first would make the small feature harder
for reviewers to locate among the intermediate adapters.
Choose the review order and state what each branch's validation must establish.

### Expected behavior

- Prefer the clear behavioral patch first and the preservation refactor above it.
- Preserve empty-list support through the refactor.
- Inspect the upper branch against its parent and retain the feature's tests.
- Keep the final parser ownership coherent.

### Unacceptable behavior

- Treat behavior preservation as reverting to the pre-feature behavior.
- Require refactoring first regardless of its review cost.
- Deliver the movement and new accepted input as one obscured behavioral diff.

## Plan delivery from the global contract

### Prompt

Apply the global operating contract at `{GUIDANCE_PATH}`.
Do not modify files or run mutating commands.

An approved scheduler change adds one retry outcome and moves 180 lines
of established scheduling and validation into a dedicated module.
The final design, names, and source order are already settled.
The behavior patch is a clear local edit before the move.
The user asks only how to arrange delivery for review and validate each part.
Choose the review units and their order,
and identify the guidance that governs this decision.

### Expected behavior

- Apply the reviewability policy directly from the global contract.
- Prefer the clear behavior patch first,
  then a refactor that preserves the resulting behavior.
- Do not require code-readability merely to obtain the review-sequencing policy.
- Use specialized skills when a separate design or source-readability decision
  actually arises.

### Adjacent valid case

#### Prompt addition

Instead, the user asks only which errors the current scheduler retries.
There is no requested change, source evaluation, or delivery plan.

#### Expected behavior

- Explain the current behavior from available evidence.
- Do not start planning changes, refactors, or review branches.
