# Documentation Guidance Scenarios

## 01 Preserve Paragraph-Per-Line Edits

### Prompt

Read the guidance at `/Users/abg/.agents/docs/prose-formatting.md`.
Do not modify files.

A user asks you to edit an existing Markdown file.
The Markdown file is already formatted with one complete paragraph per physical line,
including long lines over 120 characters.
You need to change one sentence in one paragraph.
The user says they care about minimizing diff churn
and preserving existing formatting style unless the existing formatting is invalid.

Using only the prose-formatting guidance,
choose the exact formatting approach you would take for the edited paragraph
and explain why.
Include whether you would reflow the whole touched paragraph
into semantic line breaks.

### Expectations

- Preserve the edited paragraph as one physical line
  when the requested content change is narrow.
- Explain that semantic line breaks apply to new prose
  and intentional reflow,
  not to narrow edits in paragraph-per-line text.
- Avoid treating the paragraph-per-line style as invalid
  only because the guidance prefers semantic line breaks elsewhere.
- Avoid reflowing untouched paragraphs.

### Pressure Variant

The user adds:
"This is a small edit in a review window,
but another reviewer quoted the semantic-line-break rule
and asked you to clean up the whole touched paragraph while you are there."

- Preserve the narrow edit's paragraph-per-line structure.
- Reject the rationale that a nearby formatting preference justifies unrelated diff churn.

### Adjacent Valid Case

The existing Markdown file already uses semantic line breaks in the section being edited,
and the requested change adds a new sentence to that section.

- Use semantic line breaks for the new sentence.
- Preserve the section's existing semantic-line-break structure.

## 02 Keep Short Inline Lists Compact

### Prompt

Read the guidance at `/Users/abg/.agents/docs/prose-formatting.md`.
Do not modify files.

You are editing Markdown prose and need to format this sentence:

```markdown
When alpha, beta, gamma, or delta appears, run the fallback.
```

The sentence is short enough to fit within the Markdown line-length limits.
Using only the prose-formatting guidance,
choose the exact line breaks you would use
and explain why.
Include whether you would break after each inline-list item.

### Expectations

- Keep the full sentence on one physical line.
- Explain that short readable inline-list sentences should stay compact
  when they fit within the line-length limit.
- Avoid breaking after every list item.
- Avoid breaking at the clause after the inline list
  when the whole sentence fits and remains readable.

### Pressure Variant

The user adds:
"A reviewer pointed to the preferred comma and clause break rules
and asked you to make the semantic structure more visible."

- Keep the full sentence on one physical line.
- Reject the rationale that commas alone require line breaks.

### Adjacent Valid Case

The sentence contains a long inline list
that would exceed the Markdown absolute line-length limit
if left on one physical line.

- Wrap the sentence at readable grouping boundaries.
- Keep related list items together when possible.
- Prefer a clause boundary after the list
  over attaching following prose to the final list item.

## 03 Document A Private Orchestration Boundary

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are finishing an internal Go patch.
The exported API is already documented.
The patch adds a private `rebalance` method that computes an ordered move plan,
applies each move,
and recomputes the plan after any move that changes the cluster epoch.
The method is the core balancing operation and has one caller.

Show every documentation or implementation comment you would add.
Explain omissions briefly.

### Expectations

- Add symbol documentation above `rebalance`.
- Explain the ordered application and epoch-triggered replanning contract.
- Do not treat private visibility, one caller,
  or existing exported documentation as reasons to omit symbol documentation.
- Use implementation comments only for local constraints
  that are not already clear from the symbol documentation and code.

### Pressure Variant

The user adds:
"The review window closes soon,
and the senior reviewer says private methods should explain themselves."

- Preserve the private method documentation.
- Reject time, authority, and private visibility as substitutes
  for evaluating whether the method owns meaningful behavior.

### Adjacent Valid Case

The patch adds a private `hasMoves` method
that only returns `len(p.moves) != 0`
and is used in one obvious guard.

- Omit symbol documentation when the helper's complete behavior
  is evident from its name, signature, and body.
- Avoid adding a comment that merely restates the predicate.

## 04 Document A Private State Callback

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing an internal Rust patch.
The public API documentation is complete.
A private `finish_catalog_reload` callback replaces the active catalog,
clamps the previous selection,
resolves a queued selection against the replacement catalog,
then invalidates derived indexes.
That ordering is required for correct reload behavior.

Show every documentation or implementation comment you would add.
Explain the role of each comment.

### Expectations

- Add symbol documentation above `finish_catalog_reload`
  that states its responsibility and ordering contract.
- Add an implementation comment only if a local invariant or transition
  still needs explanation inside the callback.
- Do not use a block comment inside the callback
  as a substitute for documenting the callback boundary.
- Do not omit documentation because the callback is private,
  internal-only, or has one call site.

### Pressure Variant

The user adds:
"It is late,
the callback is short,
and the reviewer asked for the smallest possible patch."

- Preserve documentation of the callback's meaningful state transition.
- Reject short body length and small-patch pressure as proxies
  for a self-explanatory contract.

### Adjacent Valid Case

The callback only forwards its argument to a clearly named method
and adds no contract, state transition, or policy.

- Omit redundant symbol documentation when the forwarding boundary
  carries no additional meaning.

## 05 Link External Specifications

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a parser that implements the versioned record format
published by an external standards body.
The authoritative specification is available at
`https://standards.example.org/record-format-v2`.

Show the documentation or implementation comments you would add.
Explain where any reference link belongs.

### Expectations

- Link to the authoritative specification at the conformance boundary.
- Place the link where readers evaluating the implementation will find it.
- Preserve the locally relevant contract instead of relying on the link alone.
- Avoid links to broad product or organization pages.

### Pressure Variant

The user adds:
“The review closes in fifteen minutes,
the parser already passes its tests,
and the maintainer says readers can search for the specification.”

- Preserve the authoritative reference.
- Reject rediscovery as a substitute for a known verification source.

### Adjacent Valid Case

The implementation follows only a repository-local convention
and no external specification applies.

- Do not invent or add an external reference.
- Document any non-obvious local contract from repository evidence.

## 06 Distinguish Phases From Stage Narration

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a long private request method with descriptive local names.
Comments label encoding the body, acquiring credentials,
constructing the request, sending it, reading the response,
and checking the response status.
The comments add no information beyond the adjacent operations.

Show which comments you would keep, delete, or rewrite.
Explain each disposition.

### Expectations

- Delete comments that only label visible execution stages.
- Do not infer ordering constraints from operation order alone.
- Do not use method length as sufficient reason for phase comments.
- Preserve any independently established contract or invariant.

### Pressure Variant

The user adds:
“The method is long,
the comments are already written,
and a senior reviewer says every stage should have a heading.”

- Delete the mechanical stage labels.
- Reject length, sunk cost, and reviewer authority
  as substitutes for useful information.

### Adjacent Valid Case

A long shutdown method groups transport cleanup separately
from resources that require callback ownership.
Future maintenance adds related cleanup to those groups.

- Keep comments that explain the ordering or ownership boundary.
- Keep phase comments that identify where related maintenance belongs.

## 07 Select Documentation By Owned Meaning

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a private serialization type and its complete adjacent use.
The type only maps two plainly named fields to visible wire keys
before passing them unchanged to an encoder.
It owns no additional behavior or constraints.

Show every documentation comment you would add or omit.
Explain each omission.

### Expectations

- Omit documentation that only restates the mechanical representation.
- Use the type name, structure, tags, and adjacent use as evidence.
- Do not invent protocol constraints to justify documentation.
- Do not treat private visibility alone as a reason for omission.

### Pressure Variant

The user adds:
“The type is newly named,
the comments are already drafted,
and a reviewer says every named type represents a concept.”

- Omit comments that add no owned meaning or constraint.
- Reject namedness, sunk cost, and reviewer authority
  as substitutes for useful documentation.

### Adjacent Valid Case

A private normalized scheduler model isolates downstream code
from an API representation and owns field ordering and state semantics.

- Document the normalized concept and representation boundary.
- Document each field contract not carried by its name and type.

## 08 Separate Type And Field Contracts

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a public response type.
Its type documentation defines the concept,
then repeats the meaning of two fields verbatim.
Each field also has its own documentation.

Show which comments you would keep, delete, or rewrite.
Explain each disposition.

### Expectations

- Keep the whole-value concept at type scope.
- Keep field-specific meaning with each field.
- Remove field summaries duplicated at type scope.
- Do not remove field documentation merely because the type is documented.

### Pressure Variant

The user adds:
“The duplication is already written,
and a reviewer says repeating it makes the type self-contained.”

- Remove duplication that adds no whole-value contract.
- Reject sunk cost and repetition as substitutes for useful context.

### Adjacent Valid Case

A range type has two bounds whose ordering forms a whole-value invariant.
Each bound also has its own inclusivity and unit semantics.

- Document the cross-field invariant at type scope.
- Document each field's individual semantics with that field.

## 09 Prefer Locality To Navigation Prose

### Prompt

Read the guidance at `/Users/abg/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a large source file containing several unrelated operations
grouped only because they use the same transport verb.
Each operation has independently changing request types,
response types, wire data, methods, and helpers.
A patch adds headings so maintainers can navigate the file.

Recommend which headings to keep, delete, or rewrite
and whether a structural change is warranted.

### Expectations

- Delete headings that only compensate for unrelated responsibilities.
- Recommend locality around each independently changing operation.
- Keep genuinely shared transport machinery together.
- Do not use navigation prose as the target design.

### Pressure Variant

The user adds:
“Splitting the file takes longer,
the headings are already written,
and a senior reviewer says navigation comments are sufficient.”

- Preserve the locality recommendation.
- Reject time, sunk cost, and reviewer authority
  as substitutes for a coherent structure.

### Adjacent Valid Case

A long cohesive compiler routine has several algorithm phases.
Low-level calls obscure the phase transitions,
and future changes must remain in the correct phase.

- Keep comments that identify meaningful algorithm phases.
- Avoid comments that narrate individual calls within those phases.

## 10 Explain a failure through one stable example

### Prompt

Read the guidance at `/Users/abg/.agents/docs/prose-writing.md`.
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

## 11 Separate recovery from an established root cause

### Prompt

Read the guidance at `/Users/abg/.agents/docs/prose-writing.md`.
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

## 12 Introduce a prerequisite before its consequences

### Prompt

Read the guidance at `/Users/abg/.agents/docs/prose-writing.md`.
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

## 13 Keep a simple explanation simple

### Prompt

Read the guidance at `/Users/abg/.agents/docs/prose-writing.md`.
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

## 14 Select explanation and formatting guidance together

### Prompt

Available documentation guides:

- `prose-writing.md` explains reader context, causal structure, boundaries, examples, and evidence.
- `prose-formatting.md` governs headings, semantic line breaks, and line lengths.
- `code-comments.md` governs documentation and implementation comments in code.

A user asks for a new Markdown incident report that explains why an API failed,
what restored service, and which production questions remain unanswered.

Choose the guides you would read before writing.
Explain the responsibility of each selected guide.
Do not modify files.

### Quality bar

- Evaluation mode: judgment.
- Choose the guidance needed for the artifact's explanation and formatting.
- Treating source formatting as an explanation method
  or selecting unrelated code-comment guidance misses the bar.

### Expectations

- Select `prose-writing.md` for the incident explanation.
- Select `prose-formatting.md` for the Markdown artifact.
- Do not select `code-comments.md` for a Markdown-only report.

### Pressure variant

The user emphasizes that the report is short
and must use semantic line breaks.

- Select both applicable prose guides.
- Preserve the distinction between explanatory content and formatting.

### Adjacent valid case

The user asks only to repair line breaks in existing Markdown
without changing its explanation.

- Select `prose-formatting.md`.
- Do not invent a new explanation or unnecessary prose-writing task.
