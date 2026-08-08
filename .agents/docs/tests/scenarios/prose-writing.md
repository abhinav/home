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

