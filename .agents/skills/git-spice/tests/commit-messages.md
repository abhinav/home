# Commit-message scenarios

Each prompt distinguishes information preserved by the final tree
from run-local context that will disappear after the commit.
The runner decides which facts belong in the message;
the labels do not imply that every supplied fact should be retained.

Apply these formatting expectations to every scenario:

- Start each complete body sentence on a new physical line.
- Keep divisible body prose at or below 72 characters.
- Break longer sentences at meaningful grammatical or structural boundaries
  rather than filling lines mechanically.

## 01 Give a mechanical change a useful body

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- The dependency declaration selects `rivulet` 2.4.2 instead of 2.4.1.
- The checked-in lockfile contains the corresponding resolved version
  and checksum.

Run-local context:

- Repository maintenance policy takes each monthly patch release during
  scheduled refreshes.

### Expected behavior

- Use a subject that identifies the dependency and selected version.
- Preserve the maintenance policy that explains why this patch release
  belongs now.
- Keep the message proportional to what a future reader needs.

### Unacceptable behavior

- A subject-only message.
- A body that restates the version update or lockfile regeneration.
- A body that says only that a periodic refresh occurred.
- Invented behavior, compatibility, security, or reliability claims.

### Adjacent valid case

Add this run-local context:

- Version 2.4.1 can truncate the final journal record during recovery
  when the record ends at a block boundary.
- Version 2.4.2 preserves that record.

- Preserve the recovery failure and why version 2.4.2 was selected.
- Prefer that concrete decision context to a generic maintenance explanation.

### Nearby subject-only case

Replace the prompt facts with:

Final tree:

- The contributor guide corrects `recieve` to `receive` in one sentence.
- No identifier, link, command, example, or behavior changes.

Run-local context:

- No context beyond the spelling correction is available.

- A subject that identifies the spelling correction is sufficient.
- Do not manufacture a body from the absence of another change.

## 02 Preserve demonstrated causal evidence

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- Cache keys include tenant ID and object ID.
- A regression test uses two tenants with the same object ID.
- Cache reuse within one tenant is unchanged.

Run-local context:

- Before the implementation changed,
  the new regression test returned one tenant's cached response to the other.
- After the key changed,
  the same test returned each tenant's own response.
- The ordinary unit suite and formatting checks passed.

### Expected behavior

- Explain the isolation failure and the tenant-scoped key that corrects it.
- Preserve the observed before-and-after result
  and connect it to the isolation claim.
- Preserve unchanged within-tenant reuse as a material boundary.

### Unacceptable behavior

- A flat validation inventory or routine pass status.
- Treating the existence of a regression test as the evidence
  instead of the observed causal sequence.
- A generic claim that isolation or reliability improved.

## 03 Do not invent reproduction history

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- A parser now rejects an empty tenant identifier.
- A regression test covers the empty identifier.

Run-local context:

- The regression test passes with the final implementation.
- No result from running that test against the prior implementation
  is available.

### Expected behavior

- Explain the rejected input and resulting parser boundary.
- State no claim about a pre-fix reproduction.
- Keep the message useful without reporting routine pass status or missing
  evidence.

### Unacceptable behavior

- Saying or implying that the new test failed before the fix.
- Routine pass status, a coverage inventory, or an absence statement
  about unperformed validation.

## 04 Explain an architectural constraint

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- `checkout` defines a request-independent failure.
- The HTTP adapter translates that failure into its request error.
- `checkout` no longer imports the HTTP adapter.

Run-local context:

- The project intends adapters to depend on checkout logic,
  not checkout logic to depend on an adapter.
- The old direction prevented the batch adapter from reusing checkout logic.
- Runtime HTTP behavior and error text are unchanged.
- No localization files, database schema, or release notes changed.
- Routine tests passed.

### Expected behavior

- Preserve the intended dependency direction and the blocked reuse
  that motivate the refactor.
- Explain the resulting ownership boundary.
- Preserve unchanged HTTP behavior because moving error translation creates
  a reasonable question about that behavior.

### Unacceptable behavior

- Generic maintainability, cleanup, or decoupling claims without the
  architectural reason.
- Routine pass status.
- An inventory of unrelated localization, database, or release-note facts.

## 05 Locate the outcome in the subject

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the complete commit message for this change.
Do not modify files or run repository commands.

Repository context:

- The repository contains one product, the Quartz scheduler.
- All changed files are under `internal/leases/`.
- The affected product area is admission control,
  which decides whether a worker may accept a job.
- No repository-specific subject convention or nearby history is available.

Final tree:

- Admission control rejects a worker whose lease generation predates the
  active generation.
- Workers holding the active generation are unchanged.

Run-local context:

- A stale worker could previously accept jobs after ownership moved.

### Expected behavior

- Prefix the subject with `admission:` because admission control is the stable
  affected area in this single-project repository.
- Do not substitute `leases:` merely because the changed files live under
  `internal/leases/`.
- Keep the stale-worker result recognizable after the prefix.
- Use lowercase for the prefix and sentence case for the summary.
- Use an imperative subject no longer than 72 characters.

### Unacceptable behavior

- An unprefixed subject because the repository contains only one project.
- A `leases:` prefix derived mechanically from the file path.
- A prefix that displaces the distinguishing result.

### Pressure variant

The author says the diff is tiny, the project is obvious from the path,
and the message is needed immediately.

- Still use `admission:` in the subject.
- Do not treat urgency, diff size, or path visibility outside the message
  as reasons to omit the affected area from the stored subject.

### Monorepo project-wide case

Replace the repository context with:

- The repository contains the independently owned Quartz, Harbor,
  and Beacon projects.
- The change alters archive compatibility across all Quartz components.

- Use `quartz:` because the outcome is project-wide.
- Do not invent a narrower component.

### Monorepo component case

Replace the repository context with:

- The repository contains the independently owned Quartz, Harbor,
  and Beacon projects.
- The outcome specifically changes Quartz admission control.
- The changed files remain under `internal/leases/`.

- Use `quartz/admission:` to locate both the project and affected component.
- Do not use only `quartz:` when the stable component is known.
- Do not derive `quartz/leases:` mechanically from the file path.

### Prefix omission case

Replace the repository context with:

- The repository contains one small executable with no stable component
  boundaries.
- The change renames that executable in every supported surface.

- A plain imperative summary may omit a prefix when the summary names the
  executable and no narrower stable area exists.
- Do not invent a component solely to satisfy a mechanical prefix requirement.

## 06 Preserve the present boundary and its evidence

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- A restored snapshot becomes visible only after all referenced blocks arrive.
- Failed transfers remain retryable.

Run-local context:

- Previously, copying the manifest made an incomplete restore visible
  while blocks were still transferring.
- Transactional restore support belongs to later work.
- During an interrupted-transfer probe,
  readers continued using the prior snapshot.
- A later retry published the restored snapshot.

### Expected behavior

- Explain the reader-visible failure and the changed publication boundary.
- Keep later transactional work distinct from present behavior.
- Use the interrupted-transfer observation to support the publication claim.

### Unacceptable behavior

- Claiming that the commit implements or prepares a completed transactional
  restore system.
- Leading with helper, metadata, or file changes.
- Routine process status or a diff inventory.

## 07 Preserve motivating evidence at useful fidelity

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- Web routes load through dynamic imports instead of every page being included
  in the startup bundle.
- The application shell remains immediate.
- The final build emits multiple chunks below 500 kB.

Run-local context:

- Before the change, `mise run build` emitted this diagnostic:

  ```text
  [plugin builtin:vite-reporter]
  (!) Some chunks are larger than 500 kB after minification. Consider:
  - Using dynamic import() to code-split the application
  - Use build.rolldownOptions.output.codeSplitting to improve chunking
  - Adjust chunk size limit for this warning via build.chunkSizeWarningLimit.
  ```

- The diagnostic prompted the investigation and change.
- After the change, the warning is absent.
- Type checking, web tests, lint, and the production build pass.

### Expected behavior

- Explain the oversized startup bundle and lazy route loading.
- Preserve a self-contained verbatim excerpt of the motivating warning
  in a four-space indented code block.
- Connect the diagnostic to the changed bundle boundary.

### Unacceptable behavior

- Replacing the diagnostic with only a paraphrase of its threshold.
- Omitting the warning text that establishes the size threshold.
- Using a fenced code block for the warning.
- Including routine successful validation output.
- Treating every build message as equally durable evidence.

## 08 Preserve a causal sequence when it carries the explanation

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- Failover promotes the newest generation whose blocks are all present.
- Recovery verifies block presence before marking a generation recovered.
- Missing blocks remain eligible for retry.

Run-local context:

- The secondary copied generation 28's manifest without its final block.
- The primary lease expired and the secondary became primary.
- A reader selected generation 28 and failed although generation 27
  was complete.
- Repair trusted the copied manifest,
  marked the missing block recovered,
  and prevented retry.

### Expected behavior

- Preserve enough event ordering and actor handoff to make the failure
  understandable.
- State the resulting promotion and recovery invariants.
- Keep recurring actors and generations stable.
- Scale the sequence to the reader's need rather than forcing a template.

### Unacceptable behavior

- A vague reliability claim that loses the causal mechanism.
- A step-by-step inventory of every implementation operation.
- Invented evidence or routine validation status.

## 09 Explain the gap in a test-only change

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- The counter implementation is unchanged.
- New tests exercise `tick` while the counter is frozen.

Run-local context:

- A frozen counter must reject `tick` before changing its value.
- A discarded implementation experiment moved rejection after mutation
  and revealed that no test protected the ordering.
- The final tests pass.

### Expected behavior

- Explain the invariant and the previously unrepresented risk.
- Make clear that the implementation behavior is unchanged
  when that distinction helps the reader.
- Keep the explanation about the protected contract rather than test activity.

### Unacceptable behavior

- A subject or body that says only that tests or coverage were added.
- A list of test cases or routine pass status.
- Presenting the discarded experiment as part of the final implementation.

## 10 Preserve uncertainty that changes the boundary

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- The archive writer emits version 2 checksums.
- The archive reader continues to accept version 1 and version 2 checksums.

Run-local context:

- The oldest supported appliance emits version 1 archives.
- No archive fixture or reachable appliance was available to exercise that
  transition.
- Version 1 reader support remains until the transition is observed.
- Unit tests for locally generated version 1 and version 2 archives pass.

### Expected behavior

- Explain the version 2 writer change and retained version 1 reader boundary.
- Preserve the unverified appliance transition because it explains why the
  fallback remains and limits what compatibility can be claimed.
- Keep routine local pass status out of the message.

### Unacceptable behavior

- Claiming compatibility with the appliance transition was verified.
- Omitting the uncertainty while mentioning the retained fallback.
- A flat test or command inventory.

## 11 Expose the structure of a complex change

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- New session archives use format 3 and include the tenant identifier.
- Readers continue accepting format 2 and format 3 archives.
- The `session migrate` command rewrites a format 2 archive as format 3.
- Normal session startup never rewrites an archive.

Run-local context:

- Format 2 omitted the tenant identifier,
  so archives from two tenants could resolve to the same session identity.
- Existing format 2 archives remain supported during the transition.
- A migration probe rewrote a representative format 2 archive,
  preserved its session records,
  and produced distinct tenant-scoped identities after import.

### Expected behavior

- Make the identity failure and format 3 behavior understandable.
- Keep reader compatibility and explicit migration separate from normal
  startup behavior.
- Preserve the migration observation as evidence for the transition.
- Use paragraphs, short headings, or a useful list so a reader can locate
  the distinct behavior, compatibility boundary, and evidence.
- Let the conceptual structure determine the presentation;
  do not require particular heading names.

### Unacceptable behavior

- One dense paragraph that blends motivation, behavior, compatibility,
  migration, and evidence.
- A heading for every sentence or a fixed template unrelated to the ideas.
- A flat inventory of files, commands, or routine checks.

## 12 Format headings and nested code for plain-text scanning

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the complete commit message for this change.
Do not modify files or run repository commands.

Final tree:

- `archive repair` verifies the manifest and referenced blocks before
  publishing a recovered archive.
- Operators recover an incomplete archive in two ordered steps:
  scan it, then repair it.

Run-local context:

- Before the change, inspection produced this exact diagnostic:
  `manifest references missing block 7` followed by
  `archive marked recovered`.
- The durable recovery procedure uses these exact commands in order:
  `archive scan --input damaged.arc`, then
  `archive repair --input damaged.arc`.
- The problem and recovery procedure are distinct concerns
  that should remain easy to scan.

### Expected behavior

- Use short sentence-case section headings with matching hyphen underlines.
- Do not substitute colon-suffixed labels for those headings.
- Put the diagnostic in a top-level code block indented four spaces.
- Keep each recovery command with its ordered list item
  and indent every code line eight spaces from the left margin.
- Preserve the exact diagnostic and command text.

### Unacceptable behavior

- Bare section labels that do not have hyphen underlines.
- Colon-suffixed labels such as `Problem:` or `Recovery:`.
- ATX-style headings or fenced code blocks.
- Any indentation other than eight leading spaces
  for code nested under a top-level list item.
- Moving the commands outside their corresponding recovery steps.

## 13 Format added context in a replacement message

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`
and the git-spice skill at `<skill-path>/SKILL.md`.

An existing commit message is:

```text
Preserve tenant archive identity

Format 2 archives omit tenant identifiers,
so archives from different tenants can share one session identity.
```

The user asks to append this established context to the commit message:

- Format 3 stores the tenant identifier.
- Readers continue to accept format 2 during the transition.

Write the full replacement commit message only.
Do not propose or run commands.

### Expected behavior

- Preserve the original explanation and the added transition context.
- Keep the existing semantic line break.
- Start each added sentence on a new physical line.

### Unacceptable behavior

- Joining the added sentences on one physical line.
- Dropping or paraphrasing away the established explanation.
- Treating an append request as permission to replace only the added text.
## Omit process-only validation narration

### Prompt

Draft a commit message for this change:

- added a failing unit test for empty region identifiers;
- changed the parser to reject empty region identifiers;
- ran the focused test successfully; and
- observed no pre-change runtime failure, external symptom, or other evidence
  beyond the test-first development sequence.

### Expectations

- Explain the parser contract and why rejection belongs at that boundary.
- Omit the test-first chronology.
- Omit a `Validation` section.
- Do not treat writing or running routine tests
  as claim-bearing commit-message evidence.

### Pressure variant

The author asks for a `Validation` section
to prove that the work followed TDD.

- Still omit the section.
- Reject development-process narration
  that gives a future maintainer no evidence about the claimed behavior.

### Adjacent valid case

Before the change, a supported command with an empty region identifier
was observed to enqueue work in the default region.
After the change, the same command is rejected before enqueueing,
and the observed result directly supports the message's boundary claim.

- Include the pre-change failure and post-change observation
  when they materially support the causal explanation.
- A `Validation` section is optional;
  if used, include only the claim-bearing evidence and any material gap.
- Do not add routine test-writing chronology.

## Name the public surface needed to use and observe the change

### Prompt

Draft a commit message for a new archive recovery policy.

Callers select it with:

```rust
ArchiveReader::open_with_policy(RecoveryPolicy::CompleteBlocks)
```

They observe an incomplete archive through:

```rust
ArchiveStatus::WaitingForBlocks
```

The implementation uses private helpers
`scanRecoveryBlocks` and `markArchivePending`.

### Expectations

- Name the exact supported constructor syntax and observable status
  because readers need them to invoke and recognize the behavior.
- Explain the caller-visible contract those public surface areas establish.
- Omit private helper names and internal call sequencing.
- Do not replace actionable public syntax
  with a generic statement that recovery behavior changed.

### Pressure variant

The author asks to list every modified function
so reviewers can see the implementation work.

- Keep the message focused on the supported public surface.
- Omit private implementation inventory
  that does not help a reader use, observe, maintain, or recover the change.

### Adjacent valid case

The commit repairs only an internal recovery-index corruption
and changes no supported invocation, configuration, output, or status.

- Explain the internal ownership and failure mechanism
  needed by maintainers.
- Do not invent or force a public API name
  when no public surface changed.

## Reevaluate the complete message during revision

### Prompt

Revise this existing commit message after the implementation changed:

```text
Cache parsed policies globally

Build one process-wide policy cache so every client reuses parsed entries.

Validate policy syntax lazily on the first request.
```

The final implementation instead gives each client an owned cache
and validates all configured policies during client construction.
No process-wide cache or lazy request-time validation remains.

Return the complete revised commit message.

### Expectations

- Reevaluate the subject and every body claim against the final change.
- Replace the global-cache and lazy-validation explanation coherently.
- Explain client ownership and construction-time validation
  when those facts are supported and material.
- Preserve existing text only when it remains accurate and useful.
- Return one complete message,
  not local edits or an appended correction.

### Pressure variant

The author says only the final sentence is stale
and asks for the smallest textual edit.

- Rewrite the subject and body as needed
  so the complete message describes one coherent final design.
- Reject patch-like copyediting when earlier claims also became false.

### Adjacent valid case

A revision changes only the name of one supported configuration key.
The existing causal explanation and all other claims remain accurate.

- Update the affected public name wherever needed.
- Preserve supported, still-useful explanation.
- Do not rewrite unrelated parts merely because the message is being revised.
