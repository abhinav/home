# Update existing guidance

Start from the observed malfunction, not from a broad rewrite impulse.
Apply the core workflow, with these update-specific checks:

1. Locate the current entry mechanism,
   the guidance the agent likely relied on,
   and every primary rule, pointer, example, reference,
   and test that governs the affected boundary.
2. For a behavior-shaping repair,
   generalize the failure before drafting normative text:

   ```markdown
   Invariant:
   <general boundary future agents must preserve>

   Observed symptom:
   <concrete failure that revealed the boundary>

   Adjacent valid case:
   <nearby case the repair must still permit>
   ```

   Put only the invariant in the primary rule.
   Use observed symptoms and adjacent valid cases in examples, red flags,
   or retest scenarios instead.
3. Derive every normative sentence from the user's requested behavior,
   retained valid guidance, or authoritative evidence.
   Preserve unrelated valid behavior within the authorized scope.

The core workflow owns red, green, refactor, and failure classification.
Do not restate that lifecycle in an update-specific section or reference.

Common repairs:

| Observed failure | Repair |
| --- | --- |
| Model-invoked skill is not selected | Add the missing distinct trigger branch to the description, then rerun catalog-selection tests. |
| Guidance is reached too broadly | Remove non-distinct routing wording, narrow the relevant branch, and test a nearby non-use case. |
| Linked guidance is not reached | Put the pointer at the decision that needs the reference, name the target and condition, then rerun pointer-reach tests. |
| Agent knows what good looks like but omits or overproduces the artifact | Add the in-task condition for acting, the adjacent condition for not acting, and the next step at that decision point. |
| Agent repeats the theory without changing behavior | Pair the governing principle with a concrete decision, action, and completion check. |
| Agent skips a required step | Move the step earlier and make the decision point explicit. |
| Agent ends a step early | Replace the vague done-condition with an observable completion criterion. |
| Agent passes only because an input was volunteered | Add the elicitation or inspection step that reliably obtains the input. |
| Agent follows a shortcut | Refine the governing rule; retain a red flag only when the shortcut remains hard to recognize. |
| Agent misses a detail | Put the detail with the decision every path needs, or move a branch-specific detail to a reference linked at that decision. |
| Agent treats testing as optional | Make the existing validation gate explicit before deployment. |
| Agent overfits a repair to one observed example | Replace the symptom-specific rule with positive criteria for the underlying decision boundary, then test an adjacent valid case. |
| Several ordered stages collapse into one response | Make each stage's deliverable checkable; split later stages behind a real hand-off only when their visibility demonstrably causes premature completion. |
| Agent withholds a finding because it belongs to a later stage | Disclose findings that materially affect the user's current decision when discovered. |
| Guidance points to transient paths, lines, or constants | State the durable boundary and direct the agent to locate the current owner. |
| Guidance has accumulated repeated or stale rules | Prune, merge, or move them behind the relevant reference pointer. |
| Guidance does not change the agent's next action | Treat it as a no-op; confirm against a control, then remove it rather than merely rewording it. |
