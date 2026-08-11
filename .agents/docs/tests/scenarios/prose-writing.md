# Prose writing behavioral tests

## Explain a failure through one stable example

### Prompt

Read the guidance at `~/.agents/docs/prose-writing.md`.
Do not modify files.

Write a reviewer-facing explanation of at most 160 words.
The system accepts a report request
and places a report job in a durable queue.
The old worker consumes one tenant allowance on every delivery attempt
before acquiring the report job.
For tenant `harbor` and report `report-8`, the first attempt consumes the last allowance
and stops on a temporary storage error.
The redelivered job is rejected even though report generation never began.
The repair acquires the job first
and keys allowance reservations by tenant and report identifier.
It applies only to queued report generation;
direct report downloads keep their existing path.
A unit test replays the delivery and observes one reservation.
Production traffic has not been checked.

### Quality bar

- Evaluation mode: judgment.
- A reviewer can identify the affected behavior, failure sequence, changed behavior,
  material boundary, and actual verification.
- Implementation inventories, unstable example names,
  and unsupported production claims miss the bar.

### Expectations

- Lead with the reviewer-visible problem or changed behavior.
- Explain reservation, error, redelivery, and rejection in causal order.
- Preserve `harbor` and `report-8` as the guiding example.
- State that direct downloads remain unchanged.
- Distinguish the unit-test result from live verification.

### Pressure variant

A reviewer requests a shorter explanation
and asks to substitute a list of changed helper functions.

- Retain the observable cause, change, material boundary, and evidence.
- Use implementation details only when they explain reader-visible behavior.

### Adjacent valid case

A release note requests a single sentence
describing the corrected queued report behavior.

- State the corrected observable behavior in one sentence.
- Do not expand the release note into a failure timeline.

## Separate recovery from an established root cause

### Prompt

Read the guidance at `~/.agents/docs/prose-writing.md`.
Do not modify files.

Write a self-contained incident handoff of at most 160 words.
A replacement gateway was created but never became ready
because a required configuration Secret was absent.
Traffic remained on the old gateway,
which reached its connection limit and returned 503 errors.
An operator restored the Secret.
Live checks now show both gateways ready and a successful health-check request.
A fake-gateway test shows that a simulated gateway becomes ready
when supplied with a valid Secret.
The production Secret issuer, synchronization path, and responsible team have not been established.
A deployment dashboard records submission, not gateway readiness.

### Quality bar

- Evaluation mode: judgment.
- The reader can identify current service health, the observed failure sequence,
  what each signal establishes, and material unresolved facts.
- Invented owners, unverified permanent root causes,
  and substituted test or dashboard signals miss the bar.

### Expectations

- State that live health has recovered.
- Explain why the old gateway returned 503 errors.
- Identify the missing Secret as the observed readiness blocker.
- Distinguish the simulation and submission dashboard
  from live recovery evidence.
- Preserve uncertainty about issuance, synchronization, and ownership.

### Pressure variant

An incident lead requests a definite root cause
before the next status update.

- State the observed blocker and verified recovery.
- Identify the permanent cause and owner as unestablished.

### Adjacent valid case

The Secret issuer logs independently establish
that a documented issuer outage caused the missing Secret.

- State the established cause
  and identify the evidence supporting it.
- Retain any other relevant unknowns.

## Introduce a prerequisite before its consequences

### Prompt

Read the guidance at `~/.agents/docs/prose-writing.md`.
Do not modify files.

Write a short design explanation for an engineer
who understands background jobs
but does not know this scheduler.
An ordinary worker can lease a task
only after all dependency tasks complete.
Privileged maintenance recovery previously returned abandoned tasks
directly to the ready queue.
Task `publish-3` depends on `prepare-2`.
Direct reinsertion allowed `publish-3` to run
while `prepare-2` remained incomplete.
The repair submits recovered tasks
to the existing dependency evaluator.
Normal task creation and ordinary worker eligibility do not change.
A deterministic test observes
that `publish-3` cannot run before `prepare-2` completes.

### Quality bar

- Evaluation mode: judgment.
- A new reader can explain the scheduler invariant, the recovery-only violation,
  the corrected behavior, and the unaffected ordinary worker path.
- Unintroduced terminology, unstable task identities,
  or a claim that all scheduling behavior changed miss the bar.

### Expectations

- Establish dependency-based task eligibility
  before explaining its violation.
- Preserve `publish-3` and `prepare-2` throughout the example.
- Identify recovery as a privileged maintenance operation.
- State that ordinary task creation and eligibility are unchanged.
- Describe only the behavior established by the deterministic test.

### Pressure variant

A reviewer asks to explain the repair
only by naming the private evaluator helper.

- Describe the evaluator's observable scheduling responsibility.
- Include a helper name only if it matters to the reader's task.

### Adjacent valid case

The intended reader maintains the scheduler
and explicitly requests the private helper's name.

- Name the helper when supplied and relevant.
- Preserve its behavioral meaning and recovery boundary.

## Keep a simple explanation simple

### Prompt

Read the guidance at `~/.agents/docs/prose-writing.md`.
Do not modify files.

Write one release-note sentence of at most 24 words.
Previously, queued archive exports stopped after the first 100 records.
Queued exports now include every requested record.
Direct downloads and archive permissions are unchanged.

### Quality bar

- Evaluation mode: conformance.
- Produce one accurate release-note sentence
  containing no more than 24 words.
- A causal timeline, headings, invented implementation details,
  or additional paragraphs miss the bar.

### Expectations

- Identify the corrected queued export behavior.
- Preserve the material unchanged behavior if it fits naturally.
- Produce one sentence within the word limit.

### Pressure variant

A reviewer requests the full learning arc, a worked example, and a validation section.

- Retain the requested one-sentence release-note format.
- Include only claims supported by the scenario.

### Adjacent valid case

The reader requests a separate engineering incident report
about the same record-limit failure.

- Expand the explanation to cover relevant baseline,
  cause, changed behavior, and evidence when supplied.
- Do not retain the release-note word limit
  after the artifact and reader task change.

## Match implementation specificity to the reader's task

### Prompt

Read the guidance at `~/.agents/docs/prose-writing.md`.
Do not modify files.

Write public documentation for a queue client.
Callers select delayed delivery with `DeliveryPolicy::Delayed`,
observe it through `MessageState::Scheduled`,
and cancel it with `Queue::cancel`.
The implementation uses private helpers
`stageDelayedMessage` and `removeTimerEntry`.

Explain delayed delivery precisely enough for callers to use and observe it.

### Expectations

- Name the public surface areas needed to select, observe, and cancel
  delayed delivery.
- Include supported names or syntax when callers need them
  to act on the documentation.
- Omit private helper names and internal sequencing
  that do not change the caller's task.
- Choose specificity from the reader's decisions,
  not from how much implementation detail is available.
- Do not replace actionable public details
  with a vague summary of the feature.

### Pressure variant

A reviewer asks for every function involved
so the documentation proves that the implementation was inspected.

- Keep the explanation at the caller's public boundary.
- Reject investigation history and private implementation inventory
  as substitutes for reader-relevant specificity.

### Adjacent valid case

The reader is a maintainer diagnosing timer-entry leaks,
and repository evidence establishes that `removeTimerEntry`
owns removal from the private timer index.

- Include the supported private helper
  because it changes the maintainer's debugging task.
- Explain the helper's relevant ownership
  without expanding into unrelated implementation detail.

## Apply the prose model to substantive short documentation

### Prompt

Read the guidance at `~/.agents/docs/prose-writing.md`.
Do not modify files.

Write the documentation comment for:

```go
func (q *Queue) Pending() int
```

The returned count includes delayed messages
but excludes messages already leased to workers.
The final comment may fit on one physical line.

### Expectations

- Treat the behavioral distinction as a reader-facing explanation
  even if the artifact is short.
- State the inclusion and exclusion boundary precisely.
- Do not use expected line count
  to decide whether the prose model applies.
- Keep the result proportional to the reader's task.

### Pressure variant

A reviewer says prose guidance is intended only for multi-line artifacts
and asks for the shortest possible restatement of the method name.

- Preserve the behavioral distinction.
- Reject physical length as the applicability boundary.

### Adjacent valid case

A private increment is preceded by:

```go
// Increment i.
i++
```

- Treat the comment as a same-scale translation
  rather than a substantive explanatory artifact.
- Permit deletion instead of expanding it
  merely to justify prose guidance.
