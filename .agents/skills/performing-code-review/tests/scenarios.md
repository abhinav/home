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
- Judge findings by their consequences for the maintainer or caller.
  Minor naming and accuracy observations cannot substitute for that assessment.

## Check the requirement that makes a simpler design insufficient

### Prompt

Use the `performing-code-review` skill.
Apply the design lens.
Do not edit files.

A profile API writes a durable row before returning from an update.
A worker retries copying the update to a reporting system.
A proposed simplification calls the reporting system directly after
the profile write. The profile write is authoritative.
The diff, commit message, and API contract are all the available evidence.
They do not say whether reporting must reflect every accepted update after
a crash. Give the findings you would send to the author.

### Expected behavior

- Identify the failure window between the profile commit and the direct call.
- State the open requirement and explain when the direct call would suffice
  and when durable follow-up would still be needed.
- Leave the recommendation conditional while the contract is unresolved.

### Adjacent valid case

#### Prompt addition

The API contract requires reporting to apply every accepted update,
even if the process exits immediately after the profile commit.
The worker row is written in the same transaction as the profile change.
The reporting API supports retries with the update ID.

#### Expected behavior

- Explain why the proposed direct call would violate the established contract.
- Keep durable follow-up tied to the profile commit and use the update ID
  to retry the same update.

## Review the readability of a changed workflow

### Prompt

Use the `performing-code-review` skill.
Please review this change.
Focus on readability and how easy it is for a maintainer
to follow the monthly report flow.

```diff
diff --git a/reports/monthly.py b/reports/monthly.py
--- a/reports/monthly.py
+++ b/reports/monthly.py
@@ -1,4 +1,9 @@
+from reports.export_context import ExportContext
+from reports.stages import run_stage
+
+
 def export_month(rows, organization, uploader):
-    selected = select_billable_rows(rows, organization.timezone)
-    summary = summarize_by_currency(selected)
-    return uploader.put(render_workbook(summary))
+    state = ExportContext(rows=rows, organization=organization, uploader=uploader)
+    for step in ("A", "E", "P"):
+        run_stage(step, state)
+    return state.result
diff --git a/reports/stages.py b/reports/stages.py
--- /dev/null
+++ b/reports/stages.py
@@ -0,0 +1,11 @@
+from reports.rows import select_billable_rows
+from reports.render import render_workbook, summarize_by_currency
+
+
+def run_stage(step, state):
+    if step == "A":
+        state.data = select_billable_rows(state.rows, state.organization.timezone)
+    elif step == "E":
+        state.data = summarize_by_currency(state.data)
+    elif step == "P":
+        state.result = state.uploader.put(render_workbook(state.data))
diff --git a/reports/export_context.py b/reports/export_context.py
--- /dev/null
+++ b/reports/export_context.py
@@ -0,0 +1,11 @@
+from dataclasses import dataclass
+from typing import Any
+
+
+@dataclass
+class ExportContext:
+    rows: list
+    organization: Any
+    uploader: Any
+    data: Any = None
+    result: Any = None
diff --git a/reports/summary.py b/reports/summary.py
--- a/reports/summary.py
+++ b/reports/summary.py
@@ -1,4 +1,2 @@
 def mean_line_amount(amounts):
-    if not amounts:
-        return 0
     return sum(amounts) / len(amounts)
```

### Repository evidence

Make this available as `contracts/reporting.md`.

```markdown
# Reporting API
Monthly summary exports include inactive accounts.
For an account with no line items, the average amount is zero.
```

### Expected behavior

- Explain how the stage keys and shared intermediate state affect a maintainer
  following the export flow.
- Keep the findings and investigation focused on that flow.
  Reading the contract to verify the separate empty-account bug or running
  a probe for that bug is outside the requested review.

### Adjacent valid case: broad release review

#### Prompt substitution

Replace the review request with “Please review this change for release readiness.”

#### Expected behavior

- Establish the empty-account contract from repository evidence and report
  the regression alongside other material findings relevant to release readiness.

## Review whether comments teach the reader what matters

### Prompt

Use the `performing-code-review` skill.
Please review this change and focus on whether it has adequate comments.

```diff
diff --git a/index/compact.py b/index/compact.py
--- a/index/compact.py
+++ b/index/compact.py
@@ -1,4 +1,7 @@
-def compact_segment(segment, store):
+def compact_segment(segment, store, readers):
     new_segment = store.write(segment.live_records())
+    previous_epoch = readers.current_epoch()
     store.set_active(new_segment)
+    readers.advance_epoch()
+    readers.wait_for_epoch(previous_epoch)
     store.drop(segment)
@@ -7,3 +10,3 @@
 def batch_metadata(keys):
-    # Keep a couple of keys in each metadata batch.
-    return [keys[i:i + 2] for i in range(0, len(keys), 2)]
+    # Keep up to four keys in each metadata batch.
+    return [keys[i:i + 5] for i in range(0, len(keys), 5)]
```

### Repository evidence

Make this available as `index/readers.py`.

```python
class ReaderRegistry:
    def pin_active(self, store):
        """Register the reader's current epoch, then obtain the active segment."""
        ...

    def wait_for_epoch(self, epoch):
        """Wait for every reader pinned at or before epoch to release its segment."""
        ...
```

Make this available as `tests/test_compact.py`.

```python
def test_pins_keep_old_segment_alive(store, readers, executor):
    old = store.active()
    with readers.pin_active(store):
        task = executor.submit(compact_segment, old, store, readers)
        store.wait_for_active_change(old)
        assert store.exists(old)
    task.result()
    assert not store.exists(old)
```

### Expected behavior

- Use the evidence about when readers pin the active segment to explain
  the missing reason for the order of publication, epoch advance, and reclamation.
- Judge adequacy by what callers and maintainers need to understand.
  The internal batch-size mismatch is visible in the adjacent code.
  It does not warrant an adequacy finding without evidence of a consequence
  for the reader.

### Adjacent valid case: absent comments

#### Prompt substitution

Present only the change to `compact_segment` in the diff.

#### Expected behavior

- Load `code-comments` and find the missing explanation even though
  the change contains no comments.

### Adjacent valid case: accuracy review

#### Prompt substitution

Replace the review request with “Please review whether the wording of the
changed comments matches the implementation.”

#### Expected behavior

- Report the specific mismatch between the stated limit and the slicing code.
- Keep the review concerned with the claims in the changed comments.
