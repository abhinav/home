# Guidance routing behavioral tests

## Select explanation and formatting guidance together

### Prompt

Available user-level guidance:

- the `prose-writing` skill explains reader context, causal structure,
  boundaries, examples, and evidence.
- the `prose-formatting` skill governs headings, semantic line breaks,
  and line lengths.
- the `code-comments` skill governs documentation and implementation comments
  in code.

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

- Select the `prose-writing` skill for the incident explanation.
- Select the `prose-formatting` skill for the Markdown artifact.
- Do not select the `code-comments` skill for a Markdown-only report.

### Pressure variant

The user emphasizes that the report is short
and must use semantic line breaks.

- Select both applicable prose guides.
- Preserve the distinction between explanatory content and formatting.

### Adjacent valid case

The user asks only to repair line breaks in existing Markdown
without changing its explanation.

- Select the `prose-formatting` skill.
- Do not invent a new explanation or unnecessary prose-writing task.

## Route prose embedded in code

### Prompt

A user asks you to write the verbatim Go documentation comment for this method:

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

- Select the `prose-writing` skill for the comment's wording.
- Select the `prose-formatting` skill for its source representation.
- Select the `code-comments` skill for the documentation decision.
- Select the `go-development` skill for the target language.

### Adjacent valid case

The user instead asks an ordinary conversational question
without requesting a persisted artifact or source-style prose.

- Do not select the `prose-formatting` skill.

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

- Select the `code-readability` skill for the non-generated code.
- Select the `code-design` skill for the new ownership and representation
  boundary.
- Select the `code-comments` skill to decide how the named concept and invariants
  should be exposed to readers.
- Select the `go-development` skill for the target language.

### Adjacent valid case

The user instead asks to rename one local Go variable from `x` to `remaining`.
The rename changes no behavior, comments, tests, APIs, ownership,
boundaries, contracts, or representations.

- Select the `code-readability` and `go-development` skills.
- Do not select the `code-design` or `code-comments` skills.

## Route test-evidence decisions before test edits

### Prompt

Available user-level guidance includes:

- the `code-readability` skill for writing or changing non-generated code;
- the `code-design` skill for ownership, contract, and representation
  decisions;
- the `code-comments` skill for non-obvious concepts and invariants;
- the `code-testing` skill for deciding what test evidence a change needs
  and for test artifacts;
- the `performing-code-review` skill for independently reviewing a code change
  and producing findings; and
- the `go-development` skill for Go code.

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

- Select the `code-readability` skill for the non-generated code change.
- Select the `code-design` skill for the representation and invariant change.
- Select the `code-comments` skill to decide how the new concept and invariant
  should be exposed to maintainers.
- Select the `code-testing` skill to decide whether the existing detectors
  are sufficient and what validation the refactor needs.
- Select the `go-development` skill for the target language.
- Do not require an explicit request to add or modify tests
  before loading the `code-testing` skill.
- Do not select the `performing-code-review` skill for implementation alone.

### Pressure variant

#### Prompt addition

The user adds:
"Do not add tests unless the existing suite exposes a real gap."

#### Expected behavior

- Keep the `code-testing` skill selected because it owns the decision
  to add, retain, replace, or omit test evidence.
- Do not treat the instruction against unnecessary tests
  as a reason to skip testing guidance.

### Adjacent valid case

#### Prompt addition

The user instead asks what a supplied Go compiler error means.
They do not ask to change code,
choose validation evidence, or inspect a test artifact.

#### Expected behavior

- Select the `go-development` skill for the language-specific explanation.
- Do not select the `code-testing` skill merely because compilation
  can serve as a detector in other tasks.

## Route commit-message review through writing-commit-messages

### Prompt

Available user-level guidance includes:

- the `writing-commit-messages` skill for commit-message content;
- a commit skill that serves as a shortcut for commit-message work and commit
  operations;
- the `prose-writing` skill for explanatory prose;
- the `prose-formatting` skill for durable prose artifacts; and
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

- Select `writing-commit-messages` for reviewing and revising the commit
  message.
- Select the applicable `prose-writing` and `prose-formatting` skills.
- The commit skill may also be selected as a shortcut,
  but it must not displace `writing-commit-messages`
  or imply a commit operation.
- Do not select code-review guidance solely because the user says `review`;
  the artifact is a commit message rather than a code change.

### Pressure variant

The user adds:
"This is only copyediting.
Please avoid loading any Git-related workflow."

- Keep `writing-commit-messages` selected because it owns commit-message
  content.
- The commit shortcut remains optional when no commit operation is requested.
- Do not infer authority to mutate repository state.

### Adjacent valid case

The user instead asks to review and revise a release-note paragraph.
No commit message or commit operation is involved.

- Select the applicable prose guidance.
- Do not select `writing-commit-messages` or the commit skill for unrelated
  durable prose.

## Route comments by the explanation their reader needs

### Prompt

A user asks for the verbatim Go documentation comment for:

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

- Select the `prose-writing` skill for the reader-facing behavioral distinction.
- Select the `prose-formatting` skill for the durable source representation.
- Select the `code-comments` skill for the documentation contract.
- Select the `go-development` skill for Go documentation conventions.
- Do not exclude the `prose-writing` skill because the result may be short.

### Pressure variant

A reviewer says the final comment should fit on one physical line.

- Keep the `prose-writing` skill selected
  when the behavioral distinction remains material.
- Let artifact scale affect the amount of prose,
  not whether the reader contract applies.

### Adjacent valid case

The user instead asks whether to keep this private implementation comment:

```go
// Increment i.
i++
```

- Select the `code-comments` skill to evaluate the comment.
- Do not select the `prose-writing` skill
  merely because the artifact contains prose.
- Permit deletion when the comment is only a same-scale translation.

## Route conversational explanations through prose writing

### Prompt

Available user-level guidance includes:

- the `prose-writing` skill for prose artifacts read outside the current conversation
  and for conversational explanations the user is trying to understand;
- the `prose-formatting` skill for durable prose source representation;
- the `code-design` skill for designing or changing ownership and contracts;
  and
- the `go-development` skill for Go-specific work.

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

- Select the `prose-writing` skill
  for the explanation the user is trying to understand.
- Select the `go-development` skill for the language-specific subject.
- Do not select the `prose-formatting` skill for ordinary conversational chat.
- Do not select the `code-design` skill when the user asks only to understand
  an established ownership decision.

### Adjacent valid case

#### Prompt addition

The user instead says:
"The configured retry limit is `5`.
Return only the value."

#### Expected behavior

- Do not select the `prose-writing` skill for the fact-only response.
- Do not select the `prose-writing` skill
  merely because the answer is written text.

## Route prose artifacts by artifact

### Prompt

Available user-level guidance includes:

- the `prose-writing` skill for prose artifacts
  and conversational explanations;
- the `prose-formatting` skill for durable prose source representation.

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

- Select the `prose-writing` skill for both prose artifacts.
- Select the `prose-formatting` skill for both durable source artifacts.
- Let artifact scale control the amount of prose,
  not whether the `prose-writing` skill applies.

### Pressure variant

#### Prompt addition

The release note and validation message must each be one sentence,
and neither needs to explain a cause or cite evidence.

#### Expected behavior

- Keep the `prose-writing` skill selected for both artifacts.
- Do not use explanatory complexity as the selection gate.

### Adjacent valid case

#### Prompt addition

The user instead asks only to repair line wrapping
in an existing design document without changing any words.

#### Expected behavior

- Select the `prose-formatting` skill for the source-only edit.
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
