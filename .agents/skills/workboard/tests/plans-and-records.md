# Workboard Scenarios: Plans And Records

## 12 Validation Fits The Work

### Prompt

Coordinate three non-code workstreams.
One workstream assesses architecture option A from fixture documents.
Another independently assesses option B from the same source set.
After both assessments are ready,
the third synthesizes the evidence and drafts a rollout design.
Define workstream assessment and root completion evidence.

### Expectations

- Match assessment to each artifact and claim.
- For research, use source coverage, citations, claim-to-evidence traceability,
  alternatives, and stated uncertainty.
- For design, use requirements, constraints, risks,
  and review against explicit criteria.
- Treat commands as optional.
  Use them only when they establish relevant evidence.
- Do not invent build commands, tests, or mutable code surfaces
  to fill a template.
- Distinguish workstream evidence from root completion evidence.

## 14 Execution Plan Self-Containment

### Prompt

A workstream plan owns a payment retry migration.
The original task is to move failed card retries from a cron job
to a queue worker.
During execution,
the worker discovers that idempotency is enforced by
`payments.retry_attempts.idempotency_key`,
that the queue worker must preserve the existing 24-hour retry window,
and that the cron job must remain enabled until the worker proves parity
in staging metrics.

Write the current plan sections needed for a fresh worker
who receives only this plan and the current tree.
Assume the plan already exists and must be updated with the discovery.

### Expectations

- Restate the owned outcome and completion criteria
  in terms of the cron-to-queue migration.
- Explain the relevant repository orientation,
  including the cron job, queue worker, retry table,
  and staging metrics surfaces.
- Record the discovered idempotency key,
  the 24-hour retry-window constraint,
  and the staging parity gate as operative plan facts.
- Update the execution path to preserve the cron job
  until the staging parity evidence is available.
- Define evidence and assessment for idempotency, retry timing,
  and staging parity.
- End with one concrete next action.
- Do not merely instruct the next worker to inspect the payment code
  and rediscover these facts.

## 15 Self-Contained Supporting Log

### Prompt

Instantiate `plan.md` and `log.md`
for a workstream that investigates a production metric change.
Keep both files independently understandable
while avoiding needless duplication.
Preregister one delegated attempt.

### Expectations

- Put the full mission, project orientation, decisions,
  and execution path in `plan.md`.
- Define the log's useful contents, organization, and update rules in `plan.md`.
- Keep identity, owned outcome, essential context, dependency contracts,
  and a dated latest recovery checkpoint in `log.md`.
- Treat `plan.md` as authoritative if mutable current state differs.
- Preserve detailed supporting material outside attempt lifecycle entries,
  such as metric observations, queries and results, source inventories,
  hypotheses, disconfirming evidence, reviewer findings, or artifact indexes.
- After accepting assignment,
  preregister attempt-specific intent, starting state, expected evidence,
  and assessment before meaningful execution.
- Append the attempt outcome afterward,
  summarizing or referencing the detailed supporting record.
- Do not duplicate the plan's full implementation narrative
  or turn the log into a transcript of every command and message.

## 16 Supporting Material By Work Type

### Prompt

Create self-contained `plan.md` and `log.md` examples
for four fixture-owned records:

- an implementation workstream with failed and successful checks;
- a research workstream with sources, contradictory claims,
  query results, screenshots, and a rejected hypothesis;
- a design workstream with constraints, alternatives, tradeoffs,
  a decision, and unresolved risk;
- root orchestration with ownership changes, reconciliation decisions,
  combined evidence, and one unresolved integration question.

Each workstream record has exactly one delegated attempt.
The root orchestration record has no delegated attempt;
it records coordination and reconciliation by workstream ID.
Show what belongs in each log and what remains authoritative in its plan.
Stop before dispatch.

### Expectations

- Keep preregistration and outcome fields for each delegated attempt.
- Do not force all four logs into one fixed schema.
- Implementation logs preserve changed paths or symbols,
  behavioral observations, check results, failures, and residual risks.
- Research logs preserve source provenance, claim-to-evidence links,
  contradictions, gaps, alternatives, and uncertainty.
- Design logs preserve requirements, constraints, options, tradeoffs,
  decisions with rationale, review findings, and open risks.
- Root logs preserve root-owned coordination, reconciliation,
  returned integration evidence, unresolved conflicts,
  and dated acceptance assessments.
- Root logs do not replace an owning workstream log
  for delegated review, integration, or validation.
- Attempt entries may summarize or reference supporting sections;
  they are not the sole evidence store.
- Every plan and log is understandable without inherited conversation
  or another workstream's files.
- Promote current conclusions, decisions, state, and next actions to the plan.
- Preserve detailed provenance and chronology in the log.
- Before handoff,
  synchronize the plan with the latest recovery checkpoint recorded in the log.

### Log-Only Readback

Run the log self-containment harness from `tests/README.md`
against at least one generated workstream log.

- The fresh agent correctly explains the outcome and record organization.
- It identifies material evidence, uncertainty,
  and the dated latest recovery checkpoint.
- It does not require the plan, original prompt,
  conversation, or another workstream's files to interpret the record.
- It does not treat the checkpoint as guaranteed current beyond its timestamp
  or attempt to execute the mission from the log alone.

## 21 Log Evidence Versus Locator Process

### Prompt

Workstream `005-diagnose-config-test-failure`
must determine why the current branch cannot pass validation
and give root enough information to schedule the next workstream.
The workstream is complete when the failing validation boundary is identified
well enough for root to decide whether this is a product bug,
a fixture problem,
or an environment issue.

The worker ran:

```text
go test ./...
```

It failed with:

```text
--- FAIL: TestDefaultModePreservesExplicitRetry (0.00s)
    config_test.go:87: expected retry=5, got retry=3
FAIL
FAIL example.com/project/internal/config 0.122s
ok   example.com/project/internal/sync 0.041s
FAIL
```

The worker also used routine inspection commands while investigating:

```text
rg -n "DefaultMode|Retry" internal
sed -n '1,180p' internal/sync/sync_test.go
nl -ba internal/config/config_test.go
```

Those inspection commands only located these relevant references:

- `internal/config/config_test.go:87`
  asserts that explicit retry remains `5`.
- `internal/config/config.go:42`
  applies the default retry after parsing explicit retry.

The worker concludes that validation is blocked by a product bug
in config default application order.
Root should schedule implementation work to preserve explicit retry values
before applying defaults,
then rerun `go test ./...`.

Write the terminal log entry or supporting-record entry for this workstream.

### Expectations

- Preserve the deterministic validation command and relevant output
  because they establish the routing decision.
- Preserve the located references and what each reference establishes.
- Separate observation, supported inference, conclusion,
  and root scheduling recommendation.
- State that no project files were modified if that is part of the checkpoint.
- Do not create a command-history, process-history,
  or supporting-inspection section for `rg`, `sed`, or `nl -ba`.
- Do not treat locator commands as evidence beyond the references they found.

## 22 Validation Order Is Material Evidence

### Prompt

Workstream `006-identify-validation-order`
must determine the exact validation sequence root should use
before scheduling remediation.
The workstream is complete when root knows which command order establishes
the failure and what the failing output means.

The worker ran:

```text
mise run lint
```

It passed:

```text
lint: ok
```

Then the worker ran:

```text
mise run generate
```

It completed:

```text
generated docs/api.md
generated internal/schema.json
```

Then the worker ran:

```text
mise run lint
```

It failed:

```text
docs/api.md:42: trailing whitespace introduced by generator
lint: failed
```

Routine searches and file inspections only located the generated file
and confirmed line 42 is in `docs/api.md`.

The worker concludes that `mise run lint` alone is insufficient evidence.
The durable validation fact is that lint passes before generation
and fails after generation because generated `docs/api.md:42`
contains trailing whitespace.
Root should schedule generator remediation
and use `mise run generate` followed by `mise run lint`
as the verification sequence.

Write the terminal log entry or supporting-record entry for this workstream.

### Expectations

- Preserve the command sequence and observed outputs
  because order is material evidence.
- Explain that the failing condition appears only after generation.
- Identify `docs/api.md:42` as the located artifact and failure coordinate.
- Recommend generator remediation and the verification sequence.
- Collapse routine locator work into the path, line,
  and significance it established.
- Do not omit useful commands merely because routine locator commands
  are not preserved.

## 38 Completed Plan Preserves Current Truth

### Prompt

A completed workstream plan still describes future implementation steps.
Its `Current State And Next Action` section says only that commit `abc1234`
passed tests and no work remains.
The sibling log establishes that:

- `internal/index/decoder.go` now defines the consumer-owned `Decoder` API;
- `adapter/json/decoder.go` implements strict JSON decoding;
- typed `SchemaError` was chosen over returning raw decoder errors
  so callers retain field coordinates;
- a generic `map[string]any` result was rejected because it would move schema
  validation back into business logic;
- duplicate JSON keys were an unexpected behavior that required an adapter
  token check before decoding; and
- `go test ./internal/index/... ./adapter/json/...` passed 27 tests.

State the exact plan updates required before handoff.
Do not modify files or external state.

### Expectations

- Preserve stable purpose, boundaries, and completion criteria unless the work
  changed them.
- Replace stale future-tense implementation instructions with the final design.
- Explain what was implemented and how the named paths and API fit together.
- Record the typed-error decision and its rationale.
- Record the rejected generic-map alternative and why it violated the boundary.
- Record the duplicate-key discovery and its effect on the implementation.
- Update `Evidence And Assessment` from planned checks to observed evidence,
  the supported conclusion,
  remaining uncertainty,
  and how the result meets the completion criteria.
- Make progress, decisions, discoveries, outcome, and remaining work easy to
  find without imposing empty mandatory sections.
- Keep `Current State And Next Action` as a concise status and handoff.
  Point to the plan's named decision and evidence sections
  instead of copying their full narratives into the final section.
- Preserve branch, artifact, recovery, remaining-work,
  and root-follow-up information needed to assess the current state.
- Keep detailed chronology and raw evidence in the log.

### Pressure Variant

The workstream is complete,
the log already contains every detail,
integration review begins in five minutes,
and a senior engineer says the plan should remain the original launch brief.

- Reconcile the plan before handoff despite time,
  authority,
  sunk-cost,
  and duplication pressure.

### Adjacent Valid Case

A short workstream has no material surprise or rejected alternative.

- Keep the current state concise.
- Do not add empty discovery or alternative sections merely to imitate another
  plan's shape.

## 39 Reference-First Supporting Record

### Prompt

A workstream implemented a distributed quota boundary:

- `internal/quota/limiter.go` defines interface `Limiter` with
  `Reserve(context.Context, string, int64) (Reservation, error)`;
- `adapter/redis/limiter.go` implements atomic reservation with a Lua script;
- typed `ErrExhausted` preserves remaining quota and reset time;
- a process-local counter was rejected because replicas would disagree;
- Redis expiry rounds to milliseconds,
  so the adapter normalizes sub-millisecond durations; and
- `go test ./internal/quota/... ./adapter/redis/...` passed 31 tests on
  commit `def5678`.

Write the completed implementation entry for the workstream log.
Do not modify files or external state.

### Expectations

- Lead with the concrete paths and `Reserve` API.
- Explain how `adapter/redis/limiter.go` implements the contract.
- Connect typed `ErrExhausted` to the diagnostic behavior it preserves.
- Record the rejected process-local counter and its cross-replica failure.
- Record the expiry discovery and the adapter-boundary normalization.
- Anchor validation to the exact command, observed test count, and commit.
- Use an implementation-appropriate record structure
  rather than defaulting to a generic chronological diary.
- Use a compact API example if it materially improves the explanation,
  but do not treat a code block as a universal log requirement.
- Avoid vague prose such as only saying that quota handling was refactored.

### Pressure Variant

The source already contains the interface,
the log is growing,
and a reviewer says the entry should only say that quota handling was
refactored.

- Preserve the stable references,
  contract,
  decision rationale,
  discovery,
  and evidence while omitting unrelated detail.

### Adjacent Valid Cases

- A mechanical code change whose path and symbol fully explain the result does
  not require a code block.
- A research workstream uses sources, claims, confidence,
  and contradictory evidence instead of code references.
