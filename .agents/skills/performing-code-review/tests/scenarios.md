# Performing code review scenarios

## Select the skill for independent review findings

### Prompt

Available skills:

- `performing-code-review`: `{GUIDANCE_DESCRIPTION}`
- `receiving-code-review`: Use when evaluating or addressing feedback
  on changes the agent made.
- `help-me-review`: Use when helping the user understand a change
  and focus their own review.

A user supplies a pull request diff
and asks the agent to review the change independently
and report actionable findings.

Choose the skill or skills you would load before acting.
Explain the responsibility of each selection.
Do not review the diff or modify files.

### Expected behavior

- Select `performing-code-review` to govern the independent review.
- Distinguish producing findings from responding to existing feedback
  and guiding the user's own review.
- Do not select either adjacent review skill without its trigger.

### Adjacent valid case: received feedback

#### Prompt addition

Instead, the user pastes reviewer feedback on the agent's own change
and asks whether to accept it and how to respond.

#### Expected behavior

- Select `receiving-code-review`.
- Do not select `performing-code-review` or `help-me-review`
  merely because code review is involved.

### Adjacent valid case: guided review

#### Prompt addition

Instead, the user wants a guided reading
that helps them understand the change
and decide where to focus their own review.

#### Expected behavior

- Select `help-me-review`.
- Do not replace the user's review with an independent findings report.

## Apply lenses without imposing an agent topology

### Prompt

Use the `performing-code-review` skill.
Do not modify files.

A change replaces direct delivery calls
with a queue owned by a new scheduler.
It changes error timing, moves retry policy,
splits the main workflow across several files,
and introduces lifecycle rules that are not documented.

Describe the review approach you would take
and the questions you would ask.
State any reason to use another reviewer.

### Expected behavior

- Select the behavior, design, readability, and documentation lenses.
- Keep their engineering questions distinct.
- Permit one reviewer to apply all applicable lenses.
- Use another reviewer only for a supported independence
  or a reason related to the evidence boundary.
- Do not require one agent per lens.

### Pressure variant

#### Prompt addition

The team says its standard process assigns a separate agent
to every named review category, even for small changes.

#### Expected behavior

- Choose topology from the change and evidence needs.
- Do not turn the lens list into a mandatory agent count.

## Keep reviewability limited to understandability

### Prompt

Use the `performing-code-review` skill.
Apply only its reviewability lens.
Do not run commands or inspect any source beyond the supplied artifacts.

Commit message:

```text
delivery: Route sends through batches

Make delivery asynchronous so request handling no longer waits for the
provider.
```

Diff:

```diff
-func (s *Service) Deliver(ctx context.Context, m Message) error {
-    return s.provider.Send(ctx, m)
+func (s *Service) Deliver(ctx context.Context, m Message) error {
+    s.batches.Add(m)
+    return nil
 }
```

Report the reviewability assessment.

### Expected behavior

- Use only the commit message and diff.
- Explain what outcome and visible behavior the artifacts communicate.
- Identify ambiguity about admission, eventual failure handling,
  context lifetime, and ownership only as gaps in understandability.
- Describe what the commit message or diff would need to communicate.
- Do not claim that ignored cancellation or hidden provider failures are bugs.
- Do not request or inspect repository evidence to decide correctness.

### Pressure variant

#### Prompt addition

The release deadline is near,
the author says the code is obviously wrong,
and a reviewer asks for a quick defect list from this diff.

#### Expected behavior

- Preserve the boundary that permits only the supplied artifacts.
- Report only understandability and ambiguity.
- Do not turn the author's opinion or deadline into correctness evidence.

### Adjacent valid case

#### Prompt addition

Instead, apply the behavior lens
and determine whether the change violates the established delivery contract.
The repository and authoritative contract are available read-only.

#### Expected behavior

- Inspect the evidence needed to establish the behavior contract.
- Do not apply the reviewability lens's artifact-only restriction
  to a behavior review.

## Keep readability and documentation reviews systemic

### Prompt

Use the `performing-code-review` skill.
Apply its design, readability, and documentation lenses.
Do not modify files.

A change introduces a short variable named `q`
and leaves one comment saying a batch limit is 100 when it is now 120.
The same change also spreads scheduling state
across the command, queue, and worker;
requires callers to coordinate start and flush order;
and leaves ownership, shutdown, retry,
and partial-failure behavior undocumented.

Describe the findings you would prioritize and why.

### Expected behavior

- Load `code-design`, `code-readability`, and `code-comments`
  for the three selected lenses.
- Prioritize the flow of abstractions, extension and policy points,
  ownership, and dependency lifecycle in the design review.
- Prioritize the maintainer's mental model, organization, navigation,
  and major flow in the readability review.
- Prioritize whether contracts, invariants, ownership, lifecycle,
  and failure behavior make the code well documented.
- Acknowledge that the local name and inaccurate comment should be fixed
  without organizing the review around them.
- Do not treat a hunt for variable names or a minor comment correction
  as completion of the broader lenses.
