# Prose writing behavioral tests

## Explain a failure through one stable example

### Prompt

Use `$prose-writing`.
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

Use `$prose-writing`.
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

Use `$prose-writing`.
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

Use `$prose-writing`.
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

Use `$prose-writing`.
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

Use `$prose-writing`.
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

## Show a source-backed partial code shape

### Prompt

Use `$prose-writing`.
Do not modify files.

Write a concise reviewer-facing explanation
of this proposed TypeScript boundary:

```typescript
interface Subscription {
  id: SubscriptionID;
  createdAt: Date;
  close(): Promise<void>;
}

function subscribe(
  client: Client,
  metrics: Metrics,
  topic: Topic,
  handler: (event: Event) => Promise<void>,
): Promise<Subscription>;
```

The discussion concerns the `topic`, `handler`, returned `Subscription`,
and its `close` method.
The client, metrics, identifier, and creation time are unchanged
and irrelevant to this discussion.
The handler is fixed for the subscription's lifetime,
and the returned `Subscription` owns cancellation through `close`.
The team is considering an error callback,
but its name, type, and placement are not established.
Do not invent that API.

### Quality bar

- Evaluation mode: judgment.
- A reviewer can see the relevant public shape directly,
  then understand handler lifetime and cancellation ownership.
- Narrating the API only in prose,
  reproducing every irrelevant member and dependency,
  or inventing the unresolved error callback misses the bar.

### Expectations

- Lead with partial TypeScript declarations
  that preserve `topic`, `handler`, `Subscription`, and `close`.
- Preserve the supplied parameter, callback, and return types;
  do not replace them with invented aliases or pseudocode.
- Mark omitted members and parameters with TypeScript comments
  when the fragments could otherwise appear complete.
- Use prose to explain the handler lifetime
  and the returned subscription's cancellation ownership.
- Identify the shape as proposed.
- Do not invent the unresolved error-callback API.

### Pressure variant

#### Prompt addition

A reviewer requires an answer under 100 words
and warns that reproducing the complete declarations
would obscure the boundary under discussion.

#### Expected behavior

- Keep a labeled, source-backed partial shape within the limit.
- Elide irrelevant members and parameters
  instead of reproducing the complete declarations.
- Keep the unresolved error callback out of the shape.

### Adjacent valid case

#### Prompt addition

The user instead requests one release-note sentence saying
that uploads with expired credentials are now rejected.
The implementation uses a private `isExpired` helper.

#### Expected behavior

- State the observable upload behavior in prose.
- Do not add a code shape or expose the private helper
  when neither reveals a relevant relationship.

## Demonstrate executable logic instead of narrating it

### Prompt

Use `$prose-writing`.
Do not modify files.

Write a concise maintainer note for a cache refresher.
When an entry is absent, the refresher fetches and stores a replacement.
When an entry is fresh, it returns the entry unchanged.
When an entry is stale, the refresher tries to acquire its refresh lease.
If another worker holds the lease, it returns the stale entry.
After acquiring the lease, it fetches a replacement.
A successful fetch replaces the entry and releases the lease.
A temporary fetch failure releases the lease and returns the stale entry.
Other failures release the lease and return the error.
Specific APIs and the programming language are not yet chosen.
Client setup, tracing, and metrics are outside the note's scope.

Keep the note under 220 words.

### Quality bar

- Evaluation mode: judgment.
- A maintainer can follow the branching control flow
  without reconstructing it from prose that mechanically narrates each step.
- A complete implementation, invented API details,
  or an unexplained code block misses the bar.

### Expectations

- Use a compact code or pseudocode demonstration
  to expose the branching control flow.
- Use prose for the lease invariant, important consequences,
  and the limits of the demonstration.
- Permit an illustrative or partial sample
  that omits irrelevant setup and instrumentation.
- Make an omission visible when the sample could otherwise appear complete.
- Do not imply that illustrative syntax is a supported implementation.

### Pressure variant

The implementation has not been written,
and the reader requests an incremental walkthrough
with the reason for each lease decision between the relevant fragments.

- Use clearly identified pseudocode rather than inventing supported syntax.
- Permit nearby interleaved blocks while preserving identifiers, state,
  and execution order across them.
- Make skipped steps or material discontinuities apparent.

### Adjacent valid case

The same reader instead requests one release-note sentence stating only
that a stale entry remains available while another worker refreshes it.

- Use one clear sentence without adding a code block.
- Do not expand the release note into the refresher's full control flow.

## Choose a change-focused visual and gate Mermaid

### Prompt

Use `$prose-writing`.
Do not modify files.

Write the smallest visual section for an external Markdown migration guide.
The renderer supports Mermaid,
but the user requested only a concise diagram and did not name a syntax.
The current `publish` flow calls `loadDraft`, then `sendArticle`.
The proposed flow adds `validateDraft` between those calls
and `recordReceipt` after `sendArticle`.
The maintainer needs to compare the runtime flow quickly.

### Quality bar

- Evaluation mode: judgment.
- The maintainer can identify the two additions and their runtime order quickly.
- Mermaid in the external guide without an explicit Mermaid request,
  a complete implementation,
  or duplicated representations miss the bar.

### Expectations

- Use a compact non-Mermaid change view,
  such as a plain-text `diff` of the call tree.
- Preserve `publish`, the established calls, both additions,
  and their runtime order.
- Include only prose needed to state what the visual establishes.
- Do not treat renderer support or a general diagram request
  as an explicit Mermaid request.

### Pressure variant

The documentation team usually uses Mermaid,
a staff reviewer says it will look more polished,
and the migration review begins in 15 minutes.

- Keep Mermaid out of the external guide
  because the user still did not explicitly request it.
- Do not turn convention, authority, polish, or time pressure
  into permission to choose Mermaid.

### Adjacent conversational case

The same user instead asks in conversational chat
to show the actor handoffs in a multi-service request.

- Permit Mermaid when it is the smallest useful chat representation.
- Do not require Mermaid when a simpler representation answers the question.

### Adjacent explicit external case

The user explicitly requests a Mermaid diagram
in the external migration guide.

- Permit Mermaid for that artifact.
- Continue to limit the diagram to the relationships the reader needs.

## Retain only useful tables during revision

### Prompt

Use `$prose-writing`.
Do not modify files.

Revise both Markdown sections below.
Keep only the representations and prose that best support each reader's task.

The first maintainer must compare every status
with its owner and recovery action:

```markdown
## Recovery

Ready belongs to the scheduler and needs no recovery.
Blocked belongs to the dispatcher and requires retrying dispatch.
Stale belongs to the reconciler and requires rebuilding the snapshot.

| Status | Owner | Recovery |
| --- | --- | --- |
| `ready` | scheduler | none |
| `blocked` | dispatcher | retry dispatch |
| `stale` | reconciler | rebuild snapshot |

The table above shows each status, owner, and recovery action.
```

The second reader needs only to know what `ready` means:

```markdown
## Status

| Status | Meaning |
| --- | --- |
| `ready` | work can begin |

The table shows that ready means work can begin.
```

Return only the two revised sections.

### Quality bar

- Evaluation mode: judgment.
- Each section uses the smallest representation
  that makes its required relationship easy to evaluate.
- Retaining every existing structure or flattening both sections misses the bar.

### Expectations

- Retain the recovery table and remove prose that duplicates it.
- Replace the one-row status table with one sentence.
- Preserve the supplied statuses, owners, recovery actions, and meaning.

## Preserve actor ownership under brevity pressure

### Prompt

Use `$prose-writing`.
Do not modify files.

Rewrite this implementation comment:

> After handling it, it checks it and publishes it if valid.

The verifier checks the snapshot.
If verification succeeds,
the publisher moves the snapshot to the active catalog.
If verification fails,
the verifier leaves the snapshot in quarantine.

The comment appears above a coordinator call
that does not name the verifier or publisher.
Maintainers use the comment to identify which component owns each outcome.

A staff reviewer requires at most 18 words,
says nearby code makes the actors obvious,
and asks you not to repeat `snapshot`.
Return only the comment.

### Quality bar

- Evaluation mode: judgment.
- The comment preserves the ownership handoff and both verification outcomes.
- Passive or elliptical wording that hides an actor or affected entity
  misses the bar.

### Expectations

- Name the verifier and publisher because they own different outcomes.
- Preserve the active-catalog and quarantine destinations.
- Keep the comment descriptive rather than converting it to instructions.
- Prefer a compliant concise sentence when one preserves the claim.

### Pressure variant

The reviewer says the release is waiting,
the nearby code is obvious,
and exceeding 18 words will block approval.

- Preserve the actor ownership and outcome distinctions.
- Do not treat urgency, nearby context, or reviewer authority
  as permission to erase the claim.

### Adjacent valid case

The source establishes only that invalid snapshots remain in quarantine.
The actor is unknown and does not affect the reader's task.

- Permit wording that omits the unknown, irrelevant actor.
- Do not invent an actor merely to force active voice.

## Preserve relationships while compressing prose

### Prompt

Use `$prose-writing`.
Do not modify files.

Edit this design-review note for clear, direct prose.
Preserve every material fact and keep established technical terms.
Keep the result under 95 words.

> The scheduler-started worker performs a deployment-manifest-sourced,
> control-plane-record-targeted comparison.
> This makes the reviewer-needed source relationship precisely clear.
> Operator-requested retries are ten-minute-bounded comparison reruns.
> The manifest is retry-protected, so retries do not modify it.
> The control plane continues to use optimistic concurrency control.

The reviewer uses the note to identify who starts the worker,
which source the worker reads, what the worker compares it with,
who can request a retry, how long retries may continue,
and whether a retry can modify the manifest.

### Quality bar

- Evaluation mode: judgment.
- The reviewer can recover every stated actor, action, source,
  comparison target, limit, and protection directly from the prose.
- Compressed labels that require the reviewer to infer those relationships,
  empty emphasis, or a changed comparison direction miss the bar.

### Expectations

- State the scheduler's action, the worker's source and comparison,
  the operator's action, the ten-minute limit,
  and the manifest's unchanged state with verbs or prepositions.
- Replace compound modifiers that are neither familiar nor established.
- Remove emphasis that does not alter the claim.
- Retain `optimistic concurrency control` as an established technical term.
- Do not ban familiar compounds or established technical terms.

### Pressure variant

A staff reviewer asks for the densest possible phrasing,
says the relationships are obvious,
and wants the note reduced to 45 words before an imminent review.

- Preserve every relationship needed by the reviewer within the shorter limit.
- Do not coin modifiers or stack labels to meet the word limit.

### Adjacent valid case

The note also states that the worker uses optimistic concurrency control
and sends a health check after the retry.

- Keep the established term `optimistic concurrency control`
  and the familiar compound `health check`.
- Do not expand a familiar compound merely because it appears before a noun.

### Adjacent required-precision case

The artifact must tell an operator
that the identifier must match `job-17` character for character
and that the listed recovery steps must run in the stated order.

- Retain words or syntax that carry the required match and ordering constraints.
- Do not remove precision merely because a shorter sentence sounds emphatic.

## Explain an architectural relationship in plain words

### Prompt

Use `$prose-writing`.
Do not modify files.

Write a concise conceptual explanation for an architecture reviewer
who knows Go but is new to this subsystem.
Keep it under 180 words and do not explain the code line by line.

```go
type Plan struct {
    Tasks        []Task
    Dependencies []Dependency
}

func (p *Planner) Plan(ctx context.Context, change Change) (Plan, error)
func (e *Executor) Run(ctx context.Context, plan Plan) error
```

Each `Planner.Plan` call reads the repository rules
that exist when the call begins.
It returns all selected tasks and their dependencies in `Plan`.
Planning does not reserve resources or run tasks.
The caller can inspect `Plan` before execution.
`Executor.Run` later runs the tasks in the supplied `Plan`
and does not read the repository rules again.
If the repository rules change,
another `Planner.Plan` call for the same `Change`
can return a different `Plan`.

Return only the explanation.

### Quality bar

- Evaluation mode: judgment.
- The code shape remains visible.
- The prose uses the supplied names and direct relationships.
- A plain synthesis may connect the supplied facts
  when it helps the reader build a mental model.
- Compressed architectural jargon, invented pattern names,
  inferred purposes, or stronger claims than the supplied facts miss the bar.

### Expectations

- Preserve `Plan`, `Planner.Plan`, `Executor.Run`, `Change`,
  repository rules, tasks, and dependencies.
- State when `Planner.Plan` reads the rules,
  what it returns, and what `Executor.Run` does not reread.
- A sentence such as `` `Plan` separates choosing tasks from running them``
  is a useful synthesis in common words.
- Do not rename those relationships as rule-dependent planning,
  plan-bound execution,
  a materialized decision, policy resolution, or temporal semantics.
- Do not infer why the caller inspects `Plan`
  or how `Executor.Run` uses its dependencies.

## Add a useful familiar term after the plain behavior

### Prompt

Use `$prose-writing`.
Do not modify files.

Write two or three sentences for an architecture review.
This paragraph describes one worker design;
the reader will compare it with other designs documented elsewhere.
Do not describe or infer behavior for those other designs.
In this design, producers pause while the queue is full
and resume when consumers make room.
The audience already knows common concurrency patterns.
The reviewer asks for the familiar pattern name if one applies,
but the explanation must remain understandable without that name.

Return only the explanation.

### Quality bar

- Evaluation mode: judgment.
- The reader can understand the producer and consumer behavior
  without relying on a pattern name.
- Omitting the requested familiar name
  or replacing the behavior with the name misses the bar.

### Expectations

- Explain the pause and resume behavior in common words.
- Identify the behavior with a familiar, accurate pattern name,
  such as `backpressure` or bounded producer-consumer behavior.
- Do not infer dropping, buffering limits, memory effects,
  throughput, or latency behavior that the prompt does not establish.

## Explain an unfamiliar term after its behavior

### Prompt

Use `$prose-writing`.
Do not modify files.

Write a conceptual explanation of no more than 120 words
for an operator who knows service routing but is new to this system.

The service documentation and API use the established term
`activation epoch`, so the reader must learn that term
and recognize the `activation_epoch` field later.

The router gives each active backend a number.
It increments the number when it replaces that backend.
Every routed write includes the number.
The backend accepts the write only when the number matches its current number.
It rejects a write with an older number.
This check stops a write intended for a replaced backend
from changing the current backend.
The API calls the required number `activation_epoch`.

Return only the explanation.

### Quality bar

- Evaluation mode: judgment.
- The reader can understand the check before relying on its unfamiliar name.
- Omitting the established term or API field misses the bar.

### Expectations

- Explain the numbered comparison in common words before naming it
  as the `activation epoch`.
- Connect `activation_epoch` to the backend's current number.
- Preserve the router, backend, replacement, acceptance, rejection,
  and protection relationships.

### Adjacent valid case

The operator asks, "What does `activation epoch` mean?"

- Permit the explanation to begin with `activation epoch`
  because that established name is the subject of the question.
- Still pair the name with the numbered comparison in common words.

## Explain established technical names with plain prose

### Prompt

Use `$prose-writing`.
Do not modify files.

Write a reviewer-facing explanation of at most 180 words
for engineers who know job queues but are new to this subsystem.

```go
type Reservation interface {
    Commit()
    Release()
}

func (g *Gate) Reserve(
    tenant TenantID,
    job JobID,
) (Reservation, error)
```

`Gate` limits how many jobs each tenant can run.
`Reserve` temporarily holds one tenant slot for one job.
A worker calls `Commit` only after that job starts.
If startup fails, the worker calls `Release`, which returns the slot.
A retry with the same `tenant` and `job`
gets the same outstanding reservation instead of holding another slot.
The implementation uses a map and a mutex,
but those details do not affect the contract.

The reviewer asks you to keep the note concise
and make it suitable for an architecture review
rather than a beginner tutorial.

Return only the explanation.

### Quality bar

- Evaluation mode: judgment.
- A new reader can see the relevant API shape
  and understand the contract in familiar words.
- New labels for supplied relationships,
  renamed source concepts,
  or prose that restates the code without explaining it miss the bar.

### Expectations

- Lead with the smallest faithful Go shape.
- Preserve the spelling of `Gate`, `Reserve`, `Reservation`, `Commit`,
  `Release`, `tenant`, and `job` in the code shape,
  and use the same names when the prose refers to those entities.
- Explain the hold, startup, release, and retry behavior in common words.
- Do not rename the hold as an admission phase,
  the slot as execution capacity,
  or the retry behavior as an identity or lifecycle guarantee.
- Do not explain the map or mutex;
  if they are mentioned, state only that callers do not depend on them.

### Pressure variant

A staff reviewer says the audience already knows architecture,
limits the answer to 100 words,
and asks the writer to avoid unnecessary repetition.

- Keep the established name when it identifies the same entity.
- Shorten the explanation without inventing abstract labels or aliases.
- Retain a partial code shape and the contract's material behavior.

### Adjacent valid case

The subsystem's public documentation and API both use `lease`
for a renewable, time-limited claim,
and the explanation must discuss that concept several times.

- Keep `lease` as the established domain term.
- Explain its unfamiliar meaning in common words on first material use.
- Do not replace it with several friendlier synonyms.
