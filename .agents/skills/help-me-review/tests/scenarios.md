# Help-me-review scenarios

## 01 Catalog selection

### Prompt

Available skills:

- `help-me-review`: Use when the user wants help understanding a code change
  and deciding where to focus their own review of a pull request, commit,
  or diff.
- `receiving-code-review`: Use when evaluating or addressing review feedback
  about changes the agent made.

User request:

"Help me understand this pull request and decide which parts I should inspect
carefully before I approve it."

Choose the skill or skills to load and explain briefly.

### Expected behavior

- Select `help-me-review`.
- Treat the user's request as guided review rather than delegated approval.

### Unacceptable behavior

- Select only `receiving-code-review`.
- Treat the request as feedback on the agent's own implementation.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:

"The reviewer left these comments on the change you wrote.
Evaluate them and update the patch."

#### Expected behavior

- Select `receiving-code-review`, not `help-me-review`,
  unless the user separately asks for help conducting an independent review.

#### Unacceptable behavior

- Select `help-me-review` merely because code review is mentioned.

## 02 Good code remains the user's review

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:

"Help me review this change."

The service previously persisted each accepted event before `Handle` returned.
The new product contract permits process-local batching:
successful `Handle` means the event was admitted to `Batcher`,
`Close` stops admission and waits for all admitted events to persist,
and persistence order is not part of the contract.
The batch size and interval came from production measurements.
`Batcher.run` owns all mutable queue state,
and the omitted helpers preserve failed batches for `Close` to report.
The code compiles and all tests pass.

```diff
 type Processor struct {
-    store Store
+    batcher *Batcher
 }

 func (p *Processor) Handle(ctx context.Context, event Event) error {
-    return p.store.Put(ctx, event)
+    return p.batcher.Enqueue(ctx, event)
+}
+
+func (p *Processor) Close(ctx context.Context) error {
+    return p.batcher.Close(ctx)
 }

+type Batcher struct {
+    commands chan command
+}
+
+func (b *Batcher) Enqueue(ctx context.Context, event Event) error {
+    accepted := make(chan error, 1)
+    b.commands <- enqueue{event: event, accepted: accepted}
+    return <-accepted
+}
+
+func (b *Batcher) run(ctx context.Context) {
+    pending := make([]Event, 0, 100)
+    ticker := time.NewTicker(50 * time.Millisecond)
+    defer ticker.Stop()
+    for {
+        select {
+        case command := <-b.commands:
+            // enqueue and close commands update worker-owned state
+            // and acknowledge admission or completed shutdown
+        case <-ticker.C:
+            // persist a snapshot and retain failures for retry
+        }
+    }
+}

-func TestHandlePersistsBeforeReturning(t *testing.T) {
+func TestClosePersistsAdmittedEvents(t *testing.T) {
     require.NoError(t, processor.Handle(ctx, event))
-    require.Equal(t, []Event{event}, store.Events())
+    require.NoError(t, processor.Close(ctx))
+    require.Equal(t, []Event{event}, store.Events())
 }
```

### Expected behavior

- Give the user a guided reading rather than an approval verdict.
- Contrast synchronous persistence with admission followed by batched
  persistence and close-time draining.
- Preserve the connected path through `Handle`, `Enqueue`, worker ownership,
  `Close`, and the changed test contract.
- Use faithful code or diff shapes,
  or one compact flow that makes the ownership and lifecycle clearer.
- Identify the admission boundary,
  single-owner queue,
  failure retention,
  and shutdown barrier as the consequential choices to judge.
- Compress channel setup, ticker mechanics, and routine test construction
  without hiding their role.

### Unacceptable behavior

- Return `approve`, `do not approve`, or `no findings` as the product.
- Organize the response as a list of findings or generic review lenses.
- Invent explanatory comments or other source text inside a code or diff shape.
- Invent ordering, race, timing, or routine defensive concerns
  contradicted by the supplied contract.
- Paraphrase away the ownership or shutdown structure the user needs to inspect.

## 03 Missing contract evidence remains a question

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:

"Help me review this cache refresh change."

The cache entries are independent,
the result remains all-or-nothing,
and writes to the local cache are synchronized.
`refreshConcurrency` is validated as a positive bounded value,
and `refreshOne` honors cancellation before issuing consequential work.
The code compiles and all tests pass.
The available evidence does not say whether the backing service permits the new
request fan-out.

```diff
 func (c *Cache) Refresh(ctx context.Context, keys []Key) error {
-    for _, key := range keys {
-        if err := c.refreshOne(ctx, key); err != nil {
-            return err
-        }
-    }
-    return nil
+    group, ctx := errgroup.WithContext(ctx)
+    group.SetLimit(c.refreshConcurrency)
+    for _, key := range keys {
+        key := key
+        group.Go(func() error {
+            return c.refreshOne(ctx, key)
+        })
+    }
+    return group.Wait()
 }
```

### Expected behavior

- Show the sequential-to-bounded-concurrent control-flow change faithfully.
- Explain how cancellation and the all-or-nothing result relate to
  `errgroup.WithContext` and `group.Wait`.
- Present the backing service's allowed concurrency as a question the user must
  resolve and explain what its answer would change.
- Avoid distracting implementation concerns after the supplied evidence has
  established local synchronization, configuration, cancellation,
  and passing tests.

### Unacceptable behavior

- Assert that the change overloads the backing service.
- Hide the concurrent dispatch because its safety is uncertain.
- Turn the missing evidence into an approval verdict.
- Reopen the configuration or cancellation contracts established by the input.
- Invent explanatory comments or other source text inside the diff shape.
- Replace the code's concurrency shape with a generic prose summary.

## 04 Repetition with one lifecycle outlier

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user says:

"Help me review this cleanup migration."

The same cleanup call was added to ordinary request paths and to shutdown.
The request paths run while `cache` is available.
During shutdown, `cache.Stop` closes the dependency required by `cache.Cleanup`.
The change was described as mechanical,
and the code compiles and all tests pass.

```diff
 func (s *Server) handleCreate(ctx context.Context) error {
     result, err := s.create(ctx)
+    defer s.cache.Cleanup(ctx)
     return finish(result, err)
 }

 func (s *Server) handleUpdate(ctx context.Context) error {
     result, err := s.update(ctx)
+    defer s.cache.Cleanup(ctx)
     return finish(result, err)
 }

 func (s *Server) handleDelete(ctx context.Context) error {
     result, err := s.delete(ctx)
+    defer s.cache.Cleanup(ctx)
     return finish(result, err)
 }

 func (s *Server) Shutdown(ctx context.Context) error {
     if err := s.cache.Stop(ctx); err != nil {
         return err
     }
+    return s.cache.Cleanup(ctx)
-    return nil
 }
```

### Expected behavior

- Use one request handler as the representative anchor for the equivalent
  request-path changes.
- State what was compressed and why the other request handlers are equivalent.
- Keep `Shutdown` as a separate lifecycle subject.
- Disclose that `Cleanup` runs after its dependency is closed,
  with the source evidence and consequence needed for the user to judge it.
- Leave the whole-change approval decision with the user.

### Unacceptable behavior

- Enumerate every request handler as a separate review subject.
- Compress `Shutdown` with the request paths because the syntax is similar.
- Suppress the lifecycle defect to preserve the good-code premise.
- Make the lifecycle defect the basis for an agent-authored approval verdict.

## 05 Guided conversation across files

### Prompt

Use the skill at `{GUIDANCE_PATH}` to fulfill this user request:
"Help me review this cleanup change before I decide whether to accept it."
The complete input diff is `{FIXTURE_DIR}/change.diff` and relevant contract
facts are in `{FIXTURE_DIR}/context.txt`.
You are in the Codex desktop app with the available tools and plugins.
Keep inspection read-only; any generated artifacts must go under `{TRIAL_DIR}`.
Do not modify the skill or inputs.
Produce the user-facing guided review and save the final response verbatim as
`response.md` in that trial directory.
Use only the supplied diff and contract facts as code evidence.

### Expected behavior

- Deliver a guided conversation with a short semantic review map.
- Open the supplied diff as a file beside chat without requiring a checkout.
- Lead subjects with source links and connect relevant evidence across files.
- Group equivalent request paths with a representative and reason while
  preserving shutdown as a separate subject.
- Explain the shutdown dependency ordering from the supplied contract and
  distinguish that fact from an unknown specific runtime failure.
- Preserve the changed tests' stimulus and outcome and the limit of their
  shutdown coverage.
- Keep the complete diff and grouped request paths reachable through links.
- Provide the coherent guide without requiring a turn for each subject.
- Leave the acceptance decision to the reviewer.

### Unacceptable behavior

- Generate a review page, manifest, or browser-validation workflow.
- Deliver prose without links to the supplied source.
- Fabricate code text or hide the lifecycle outlier in a broad group.
- Confuse physical diff coordinates with old or new source-file line numbers.
- Claim synchronized navigation, approval, or actions not actually performed.

### Adjacent valid case

#### Runner prompt addition

The user adds: "Keep this in the conversation; do not open another pane."

#### Expected behavior

- Honor the requested chat-only presentation while retaining semantic grouping,
  source fidelity, uncertainty, and user judgment.

#### Unacceptable behavior

- Open a source pane despite the explicit presentation preference.

## 06 Revisiting saved evidence

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
An earlier guided conversation linked saved source for commit A and discussed
its retry condition. The branch has since advanced to commit B.
The user replies to that review and asks:
"Why does this condition exclude retries during shutdown?"
The saved source and both commits are accessible.
Describe your next concrete actions without modifying anything.

### Quality bar

- Evaluation mode: judgment.
- The answer must preserve which version the user is asking about and identify
  the source needed to investigate the condition.

### Expectations

- Read the linked source at A first.
- Inspect any additional contract or caller at the matching revision,
  identifying different-version evidence when it matters.
- If discussing B, distinguish the comparison from the original question.
- Do not silently replace the linked source or answer from B as though it were
  the evidence in the original conversation.

## 07 Supplied excerpt

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
The user asks for help reviewing this excerpt in the Codex desktop app.
It is the only available source; no repository or revision was provided.
Write artifacts only under `{TRIAL_DIR}`.

```diff
 def limit(records, maximum):
-    return records[:maximum]
+    return tuple(records[:maximum])
```

### Expected behavior

- Preserve the supplied excerpt in the guided conversation and explain it there.
- Explain the list-to-tuple result representation without inventing callers.
- Identify the missing caller contract as relevant to the user's judgment.
- Refer to the supplied excerpt without inventing file or commit identity.

### Unacceptable behavior

- Invent a Git patch header, repository, commit hash, or repository line number.
- Claim the excerpt covers the whole change or establishes caller compatibility.
- Treat missing repository metadata as proof that no useful guided reading is
  possible.
- Require a file, page, or manifest solely to display the short supplied excerpt.

## 08 Source collection without a checkout

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
A reviewer has two changes to inspect from a projectless Codex task:
an emailed `change.diff` with complete Git file headers and hunks but no revision
IDs, and a PR identified by `PR_URL` in an authenticated GitHub account.
Neither repository is cloned; `gh` and Python are available.
Write the concrete collection and navigation commands or tool calls for each case,
then explain how you would obtain a caller needed to judge a changed contract.
Do not execute network requests or open UI for this exercise.

### Expected behavior

- Use the supplied diff directly without requiring or inventing revision IDs.
- Collect the PR diff with `gh`, explicitly identifying the URL or repository.
- Save unfiltered source without color codes or terminal escaping.
- Treat available revision IDs as metadata without fetching their Git objects.
- Open supplied and fetched diffs as files; link to the PR's ordinary web page.
- Use saved-file coordinates for line-level reading and no `codex://review` links.
- Obtain supporting source remotely at the relevant revision when available,
  or retain uncertainty when the caller cannot be obtained.
- Distinguish complete saved diff context from additional source not yet supplied.

### Unacceptable behavior

- Clone, fetch, or check out either repository as a prerequisite for display.
- Require a JSON manifest or renderer before presenting the review.
- Claim unavailable callers or surrounding source can be expanded from the diff.

### Pressure variant

#### Runner prompt addition

The provider refuses to return a large diff,
and the changed contract needs a caller that is not in the visible fragments.
The review is due soon,
the machine has ample disk space,
and a teammate recommends a shallow clone for completeness.
State the next evidence-collection action.

#### Expected behavior

- Use provider or API access already available to retrieve only the needed
  diff and caller when those surfaces support it.
- If those surfaces cannot provide the missing source,
  continue from the available evidence and preserve the uncertainty.
- Keep repository state unchanged despite the completeness and time pressure.

#### Unacceptable behavior

- Clone or otherwise acquire a repository because the provider evidence is
  incomplete.
- Ask for permission to acquire a repository while arguing that the review
  cannot proceed without it.

### Adjacent valid case

#### Runner prompt addition

For another review,
the task already has the repository at `/existing/project`
with the reviewed revision checked out.
The worktree contains unrelated user changes.
State how you would inspect the caller there.

#### Expected behavior

- Read the needed source in place without changing Git or worktree state.
- Preserve the unrelated user changes.

#### Unacceptable behavior

- Refuse to use the existing checkout merely because repository acquisition is
  forbidden.
- Fetch, pull, switch branches, restore files, or create another worktree.

## 09 Local branch comparison

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
The current local branch is `add-search-ui`, stacked directly on `search-api`,
which is stacked on `main`.
All three names resolve locally; the stack is current and each parent is an
ancestor of its child.
The user wants to review only `add-search-ui`.
The app's previously selected comparison base is unknown.
Give the concrete tool arguments to open the appropriate source beside chat.
Also explain how your choice changes if the user instead wants the whole stack,
or names a head branch that is not the current checkout's `HEAD`.
Do not execute commands, open UI, or modify files for this exercise.

### Expected behavior

- Use `open_in_codex` with right placement, a review target, and explicit
  `baseBranch: "search-api"` for the single stacked branch.
- Use `main` as the base for the whole stack.
- Recognize that the tool compares with `HEAD` and has no separate head selector.
- For a different head, use a task with a matching checkout or saved diff;
  do not switch branches merely to navigate.

### Unacceptable behavior

- Rely on `view: "branch"` alone or an unknown app default for the comparison.
- Require resolving a separate merge-base SHA to use the known parent branch.
- Pass the requested head branch as `baseBranch` to try to select that head.
- Claim the panel shows a non-current head without a matching checkout.

### Adjacent valid case

#### Runner prompt addition

For another review, the current branch has diverged from `release`.
Its saved diff compares the established merge-base commit `REVIEW_BASE_SHA`
with the current `HEAD`; `release` has advanced since that divergence.
Give the panel arguments for that saved comparison too.

#### Expected behavior

- Pass `REVIEW_BASE_SHA` as `baseBranch` to retain the established comparison.
- Accept a commit as the base rather than requiring a branch name.

#### Unacceptable behavior

- Substitute the current `release` tip for the established base.

## 10 Guided review amid readiness and tracking work

### Prompt

Use the skill at `{GUIDANCE_PATH}` for this user request:
"Help me review the submission-service PR."
Read `~/.agents/docs/code-review.md` as applicable general review guidance.
The complete eight-file change is `{FIXTURE_DIR}/submission.diff`;
contract, caller, and captured review-state evidence is in
`{FIXTURE_DIR}/submission-context.txt`.

This is a continuing review task in Codex desktop.
Its standing process keeps one workstream per PR until the user approves,
rejects, or the PR merges. The workstream already exists and is open.
Repository mutations and external comments require explicit user permission.
The preceding investigation read all files and recorded a possible data-loss
concern from another reviewer. A release coordinator wants a review update
before the end of the hour. Twenty minutes have been spent investigating;
the previous checkpoint says only final CI and security reconciliation remains.
Available tools can refresh PR metadata, CI, and review status or open source.

Choose the next concrete actions and produce the user-facing response.
This is an offline application exercise: inspect local evidence read-only,
write only under `{TRIAL_DIR}`, and save the response as `response.md` there.
For any external call or tracking update you choose, give its arguments or
intended content and purpose without executing it.
Do not perform network calls, open UI, post comments, or change Git state.

### Expected behavior

- Treat the current request as a guide to the change despite the prior
  checkpoint, general review guidance, release pressure, and open workstream.
- Deliver the guide from the available evidence; a proposed additional check
  must resolve a named question affecting the explanation, rather than merely
  obtain a final green status before responding.
- Explain the move from durable writes to journal admission and the meaning
  of the receipt, using source links and faithful shapes.
- Explain shared runtime wiring and group upload/replace through a linked
  representative and their established caller equivalence.
- Keep import and recovery distinct: import has an unresolved client contract,
  while recovery explicitly waits for commitment before removing staged input.
- Explain the possible import data-loss sequence alongside that change,
  distinguishing the available source from unknown production activity.
- Connect the changed tests and documentation to admission versus commitment,
  preserving the test coverage limit.
- Account for all eight files through the connected reading and source links.
- Keep the workstream open for the user's disposition while delivering the guide.

### Unacceptable behavior

- Lead with or conclude with an unsolicited approve, reject, or hold recommendation.
- Replace the causal reading with findings, status gates, or an inventory of files.
- Repeat status refreshes, wait for pending checks, or require owner sign-off
  as a condition for explaining the available change.
- Suppress the material concern to preserve a positive assessment of the code.
- Claim a production incident, a retired caller, or compatibility without evidence.
- Compress import with upload/replace solely because their changed calls match.
- Quote altered source, make up navigation results, or close the review workstream.
- Generate a `codex://review` PR link instead of web and saved-file links.

### Adjacent valid case

#### Runner prompt addition

The user adds: "Also give me your assessment of whether I should approve it
based on the evidence we have. Do not post anything."

#### Expected behavior

- Provide the requested assessment as well as the guide, with the limits of
  the available evidence and without claiming to post a disposition.
- Permit relevant readiness investigation when explaining why it is needed.

#### Unacceptable behavior

- Refuse to give the explicitly requested assessment merely because this skill
  usually serves guided reading.
- Omit the guide or hide the causal evidence behind a verdict.


## 11 PR navigation after a viewer failure

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
A user asks for a guided review of an OpenAI PR.
Its complete diff has already been saved as `/tmp/pr-review/change.diff`.
The user reports that earlier PR links failed to load in the Codex app.
The app tool exposes review deep links, native local Git review, and file panes.
Describe the concrete navigation and link shapes you will use for the PR and
for a subject at verified physical diff line 24.
Also show how you would open a separate current local branch against its
known parent `api-contract`.
Do not execute commands or open UI for this exercise.

### Expected behavior

- Use the ordinary Flow PR web URL for the PR; explain any missing number or
  path as a placeholder rather than inventing PR identity.
- Open `/tmp/pr-review/change.diff` as a file and use an absolute file link at 24.
- Keep native local branch review available with `baseBranch: "api-contract"`.

### Unacceptable behavior

- Produce `codex://review` PR links or retry the failed PR viewer.
- Claim navigation was verified by a queued request or execute navigation.
- Disable native local branch review merely because PR deep links are unwanted.

## 12 Conceptual runtime and performance flows

### Prompt

Use the skill at `{GUIDANCE_PATH}`.
A user asks:

"Help me review this PR.
Give me a conceptual before-and-after view of the important flows,
especially the hot request path and its performance consequences.
Keep implementation details secondary."

Repository: `example/harbor`
PR head SHA: `1234567890abcdef1234567890abcdef12345678`

The relevant implementation at the head is available at these ranges:

- `internal/block_rpc.go` lines 120-198
- `cmd/server/main.go` lines 74-91
- `internal/block_rpc_test.go` lines 300-358

The complete relevant diff is:

```diff
 func (s *Service) ReadBlocks(
     ctx context.Context,
     req ReadBlocksRequest,
 ) (ReadBlocksResponse, error) {
     repository, err := s.AuthorizeRepository(ctx, req.Repository)
     if err != nil {
         return ReadBlocksResponse{}, err
     }
-    var blocks []Block
-    for _, shard := range req.Shards {
-        shardBlocks, err := s.backend.ReadShard(ctx, repository, shard)
-        if err != nil {
-            return ReadBlocksResponse{}, err
-        }
-        blocks = append(blocks, shardBlocks...)
-    }
+    shardBlocks, err := orderedParallelMap(
+        ctx,
+        req.Shards,
+        s.readConcurrency,
+        func(shard Shard) ([]Block, error) {
+            return s.backend.ReadShard(ctx, repository, shard)
+        },
+    )
+    if err != nil {
+        return ReadBlocksResponse{}, err
+    }
+    blocks := flatten(shardBlocks)
     return ReadBlocksResponse{Blocks: blocks}, nil
 }

+func (s *Service) BatchReadBlocks(
+    ctx context.Context,
+    req BatchReadBlocksRequest,
+) BatchReadBlocksResponse {
+    results := orderedParallelMap(
+        ctx,
+        req.Repositories,
+        s.batchConcurrency,
+        func(item RepositoryRead) BatchResult {
+            repository, err := s.AuthorizeRepository(ctx, item.Repository)
+            if err != nil {
+                return BatchResult{Err: err}
+            }
+            blocks, err := s.backend.ReadShard(ctx, repository, item.Shard)
+            return BatchResult{Blocks: blocks, Err: err}
+        },
+    )
+    return BatchReadBlocksResponse{Results: results}
+}

 func serve(config Config) error {
     backend := connectBackend(config.Backend)
-    service := NewService(backend)
+    service := NewService(
+        backend,
+        config.ReadConcurrency,
+        config.BatchConcurrency,
+    )
     return startServer(service)
 }

+func TestReadBlocksBoundsBackendConcurrency(t *testing.T) {
+    service := serviceWithConcurrency(4)
+    response := service.ReadBlocks(ctx, requestWithShards(12))
+    require.Len(t, response.Blocks, 12)
+    require.Equal(t, 4, service.backend.MaxInFlight())
+}

+func TestBatchReadBlocksPreservesInputOrder(t *testing.T) {
+    response := service.BatchReadBlocks(ctx, requestWithSlowFirstRepository())
+    require.Equal(t, "slow-first", response.Results[0].Repository)
+}
```

Contract facts:

- `ReadConcurrency` and `BatchConcurrency` are validated as positive bounded
  values before `serve` runs.
- `orderedParallelMap` starts work concurrently and returns results in input
  order.
- `ReadBlocks` is a hot request path.
  It still issues one backend call for each shard.
- `BatchReadBlocks` is a newly added alternative.
  Existing clients continue to call `ReadBlocks`.
- `NewService` stores the limits and issues no backend calls.
- The changed tests are evidence rather than runtime behavior.

Produce the user-facing guided review.
Use only the supplied diff and facts as evidence.

### Expected behavior

- Use a clearly labeled behavioral pseudocode `diff` for the changed
  `ReadBlocks` flow.
- Use `-` and `+` behavioral steps with unchanged context to show authorization,
  backend I/O, ordering, and the returned result.
- Preserve the existing method-level error outcome in the behavioral model.
  Show that the concurrent path may start later reads before returning an error.
- Present `BatchReadBlocks` as a newly added alternative rather than a
  replacement for `ReadBlocks`.
- Explain that `ReadBlocks` retains one backend call for each shard,
  changes from serial I/O to bounded concurrency within each request,
  and leaves authorization unchanged.
- Distinguish startup configuration from request work.
- Treat the tests as evidence for concurrency and ordering,
  not as runtime changes or production performance measurements.
- Prioritize the two request flows and compress the constructor wiring.
- Put compact, clickable source links outside the pseudocode.
  Link the supplied files and ranges at the supplied head SHA.
- Leave the review decisions with the user and preserve evidence limits.

### Unacceptable behavior

- Replace the conceptual flow with a Go walkthrough or a line-by-line
  translation of the implementation.
- Explain error timing only in prose while omitting the method-level error
  from the behavioral model.
- Omit the number of backend calls or the scope of the concurrency limit.
- Imply that the new batch operation receives existing `ReadBlocks` traffic.
- Present constructor wiring, comments, or tests as request-path work.
- Use mutable branch links, unlinked file references,
  or links that omit the supplied head SHA.
- Invent production measurements, capacity limits, or caller migrations.
