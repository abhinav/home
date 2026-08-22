# Guidance routing behavioral tests

## Select explanation and formatting guidance together

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

## Route prose embedded in code

### Prompt

A user asks you to write the exact Go documentation comment for this method:

```go
func (p *Pool) Capacity() int
```

The complete contract is:
`Capacity` returns the currently available units.

Choose the user-level guides you would read before writing.
Explain the responsibility of each selected guide.
Do not modify files.

### Quality bar

- Evaluation mode: judgment.
- Treat the comment as prose as well as in-code documentation.
- Select guidance from the artifact and language together.

### Expectations

- Select `prose-writing.md` for the comment's wording.
- Select `prose-formatting.md` for its source representation.
- Select `code-comments.md` for the documentation decision.
- Select `go.md` for the target language.

### Adjacent valid case

The user instead asks an ordinary conversational question
without requesting a persisted artifact or source-style prose.

- Do not select `prose-formatting.md`.

## Route code by the decision it reaches

### Prompt

A user asks for code only:
design a new private Go type named `normalizedSchedule`
that isolates scheduling logic from an external API payload.
The type owns stable task ordering,
UTC-normalized start times,
and uniqueness of task IDs.
Callers must not depend on API field names or payload ordering.

Choose the user-level guides you would read before designing the type.
Explain the responsibility of each selected guide.
Do not implement the type or write comments.

### Quality bar

- Evaluation mode: judgment.
- Route from the representation and reader decisions reached by the work,
  even though the request asks only for code.
- Do not treat every code change as a design or documentation decision.

### Expectations

- Select `code-readability.md` for the non-generated code.
- Select `code-design.md` for the new ownership and representation boundary.
- Select `code-comments.md` to decide how the named concept and invariants
  should be exposed to readers.
- Select `go.md` for the target language.

### Adjacent valid case

The user instead asks to rename one local Go variable from `x` to `remaining`.
The rename changes no behavior, comments, tests, APIs, ownership,
boundaries, contracts, or representations.

- Select `code-readability.md` and `go.md`.
- Do not select `code-design.md` or `code-comments.md`.
## Route test-evidence decisions before test edits

### Prompt

Available user-level guidance includes:

- `code-readability.md` for writing or changing non-generated code;
- `code-design.md` for ownership, contract, and representation decisions;
- `code-comments.md` for non-obvious concepts and invariants;
- `code-testing.md` for deciding what test evidence a change needs
  and for test artifacts;
- `code-review.md` for reviewing a code change; and
- `go.md` for Go code.

A user asks you to implement a Go refactor
that replaces two private boolean fields with a private enum
so invalid combinations cannot be represented.
Public behavior must remain unchanged,
and existing public tests cover every supported mode.
The user asks you to carry the change and its validation to completion
but does not mention adding or editing tests.

Choose the user-level guides you would read before acting.
Explain the responsibility of each selection.
Do not implement the refactor.

### Quality bar

- Evaluation mode: judgment.
- Route from the test-evidence decision reached by the work,
  not only from whether the prompt explicitly requests a test edit.
- Preserve the separate representation, readability,
  comment, language, and test-evidence responsibilities.

### Expectations

- Select `code-readability.md` for the non-generated code change.
- Select `code-design.md` for the representation and invariant change.
- Select `code-comments.md` to decide how the new concept and invariant
  should be exposed to maintainers.
- Select `code-testing.md` to decide whether the existing detectors
  are sufficient and what validation the refactor needs.
- Select `go.md` for the target language.
- Do not require an explicit request to add or modify tests
  before loading `code-testing.md`.
- Do not select `code-review.md` for implementation alone.

### Pressure variant

#### Prompt addition

The user adds:
"Do not add tests unless the existing suite exposes a real gap."

#### Expected behavior

- Keep `code-testing.md` selected because it owns the decision
  to add, retain, replace, or omit test evidence.
- Do not treat the instruction against unnecessary tests
  as a reason to skip testing guidance.

### Adjacent valid case

#### Prompt addition

The user instead asks what a supplied Go compiler error means.
They do not ask to change code,
choose validation evidence, or inspect a test artifact.

#### Expected behavior

- Select `go.md` for the language-specific explanation.
- Do not select `code-testing.md` merely because compilation
  can serve as a detector in other tasks.

## Route commit-message review through the commit skill

### Prompt

Available user-level guidance includes:

- a commit skill for commit operations and commit-message work;
- prose-writing guidance for explanatory prose;
- prose-formatting guidance for durable prose artifacts; and
- code-review guidance for reviewing code changes.

A user provides an existing commit title and body.
They ask you to review the message for accuracy,
remove stale explanation,
and return the complete revised message.
They do not ask you to amend a commit or change repository state.

Choose the user-level guidance you would load before reviewing the message.
Explain the responsibility of each selection.
Do not revise the message or run commands.

### Quality bar

- Evaluation mode: judgment.
- Route from the commit-message artifact,
  not only from whether the task mutates repository state.
- Preserve the distinction between message-content authority
  and general prose support.

### Expectations

- Select the commit skill for reviewing and revising the commit message.
- Select applicable prose-writing and prose-formatting guidance.
- Do not exclude the commit skill merely because no Git mutation is requested.
- Do not select code-review guidance solely because the user says `review`;
  the artifact is a commit message rather than a code change.

### Pressure variant

The user adds:
"This is only copyediting.
Please avoid loading any Git-related workflow."

- Keep the commit skill selected because it owns commit-message content.
- Do not infer authority to mutate repository state.

### Adjacent valid case

The user instead asks to review and revise a release-note paragraph.
No commit message or commit operation is involved.

- Select the applicable prose guidance.
- Do not select the commit skill for unrelated durable prose.

## Route comments by the explanation their reader needs

### Prompt

A user asks for the exact Go documentation comment for:

```go
func (q *Queue) Pending() int
```

The comment must explain that the count includes delayed entries
but excludes entries already leased to workers.

Choose the user-level guides you would read before writing.
Explain the responsibility of each selection.
Do not draft the comment or modify files.

### Quality bar

- Evaluation mode: judgment.
- Route from the API reader's explanatory need,
  not from the comment's expected line count.
- Combine prose, comment, formatting, and language guidance
  without treating every comment as a substantial prose artifact.

### Expectations

- Select `prose-writing.md` for the reader-facing behavioral distinction.
- Select `prose-formatting.md` for the durable source representation.
- Select `code-comments.md` for the documentation contract.
- Select `go.md` for Go documentation conventions.
- Do not exclude prose-writing because the result may be short.

### Pressure variant

A reviewer says the final comment should fit on one physical line.

- Keep prose-writing selected when the behavioral distinction remains material.
- Let artifact scale affect the amount of prose,
  not whether the reader contract applies.

### Adjacent valid case

The user instead asks whether to keep this private implementation comment:

```go
// Increment i.
i++
```

- Select `code-comments.md` to evaluate the comment.
- Do not select prose-writing merely because the artifact contains prose.
- Permit deletion when the comment is only a same-scale translation.

## Route conversational explanations through prose writing

### Prompt

Available user-level guidance includes:

- `prose-writing.md` for prose artifacts read outside the current conversation
  and for conversational explanations the user is trying to understand;
- `prose-formatting.md` for durable prose source representation;
- `code-design.md` for designing or changing ownership and contracts; and
- `go.md` for Go-specific work.

A user asks in conversational chat:
"Help me understand why a Go constructor owns `RetryPolicy`
instead of receiving retry settings on every method call."
They do not request a durable artifact or a design change.

Choose the user-level guides you would read before answering.
Explain the responsibility of each selection.
Do not answer the Go question itself.

### Quality bar

- Evaluation mode: judgment.
- Select guidance for the requested explanation and its language
  without treating chat as a durable source artifact or a design change.
- Skipping explanatory guidance merely because the answer is conversational
  misses the bar.

### Expectations

- Select `prose-writing.md`
  for the explanation the user is trying to understand.
- Select `go.md` for the language-specific subject.
- Do not select `prose-formatting.md` for ordinary conversational chat.
- Do not select `code-design.md` when the user asks only to understand
  an established ownership decision.

### Adjacent valid case

#### Prompt addition

The user instead says:
"The configured retry limit is `5`.
Return only the value."

#### Expected behavior

- Do not select `prose-writing.md` for the fact-only response.
- Do not select `prose-writing.md` merely because the answer is written text.

## Route prose artifacts by artifact

### Prompt

Available user-level guidance includes:

- `prose-writing.md` for prose artifacts and conversational explanations;
- `prose-formatting.md` for durable prose source representation.

Choose the applicable guidance for each task
and explain the responsibility of each selection.
Do not perform the tasks.

1. Write a one-sentence public release note saying
   that policy names may no longer be blank.
2. Write the user-facing validation message displayed
   when a policy name is blank.

### Quality bar

- Evaluation mode: judgment.
- Select prose guidance from the reader-facing artifact,
  not from whether the artifact needs a causal explanation.
- Treating a short release note or application copy
  as too simple for prose guidance misses the bar.

### Expectations

- Select `prose-writing.md` for both prose artifacts.
- Select `prose-formatting.md` for both durable source artifacts.
- Let artifact scale control the amount of prose,
  not whether `prose-writing.md` applies.

### Pressure variant

#### Prompt addition

The release note and validation message must each be one sentence,
and neither needs to explain a cause or cite evidence.

#### Expected behavior

- Keep `prose-writing.md` selected for both artifacts.
- Do not use explanatory complexity as the selection gate.

### Adjacent valid case

#### Prompt addition

The user instead asks only to repair line wrapping
in an existing design document without changing any words.

#### Expected behavior

- Select `prose-formatting.md` for the source-only edit.
- Do not invent a prose-writing task when the explanation is unchanged.

## Format pull request references for the message surface

### Prompt

A user asks for a Slack message to a teammate saying that pull request 73
in the single repository currently under discussion is ready for review.
The repository is `openai/relay`.

Write only the message.

### Quality bar

- Evaluation mode: conformance.
- Use the shortest unambiguous linked pull request label
  supported by the destination.
- Preserve the OpenAI Flow destination and GitHub fallback.
- Apply the outbound-message signature.

### Expectations

- Use `#73` as the visible pull request identity
  because one repository is in context.
- Link the label to the OpenAI Flow pull request URL.
- Include a compact GitHub fallback link.
- End the Slack message with `-abg-bot` on its own line.
- Do not replace the linked label with a bare descriptive URL.

### Pressure variant

The user requests the same message as a GitHub reply,
then as a link-capable email.

- Preserve the shortest unambiguous linked label on both surfaces.
- Preserve the outbound-message signature.
- Do not limit the pull request convention to conversational chat.

### Adjacent valid case

The destination is a deployment pager field
that strips Markdown and cannot render hyperlinks.

- Use the destination's supported plain-text representation.
- Keep the pull request identity unambiguous.
- Do not emit broken Markdown merely to preserve the linked form.
