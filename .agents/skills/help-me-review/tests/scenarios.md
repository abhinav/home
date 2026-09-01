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
