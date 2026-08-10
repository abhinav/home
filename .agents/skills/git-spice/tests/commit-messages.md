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

## 05 Make the subject useful in history

### Prompt

Use the commit-message reference at
`<skill-path>/references/writing-commit-messages.md`.

Write the commit message for this change.

Final tree:

- The repository contains several configuration parsers.
- The `gateway` configuration loader preserves every repeated `header` entry
  in declaration order instead of keeping only the first entry.

Run-local context:

- Gateway users can intentionally configure several values for one header.

### Expected behavior

- Make the affected stable area and distinguishing result recognizable
  from the subject alone.
- Use an imperative subject no longer than 72 characters.
- Preserve only the context needed to understand why repeated entries matter.

### Unacceptable behavior

- A vague subject such as `Fix parser bug` or `Update configuration`.
- A scope or prefix that displaces the terms needed to find the change.
- A body that inventories files or parser helpers.

### Adjacent established-scope case

Add this run-local context:

- Repository history consistently uses the existing `gateway` scope for
  commits owned by the gateway team.

- Use the established scope because it improves routing and discovery.
- Keep the repeated-header result recognizable in the subject.
- Do not replace useful behavior terms merely to fit the scope.

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

## 07 Preserve a causal sequence when it carries the explanation

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

## 08 Explain the gap in a test-only change

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

## 09 Preserve uncertainty that changes the boundary

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

## 10 Expose the structure of a complex change

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

## 11 Format added context in a replacement message

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
