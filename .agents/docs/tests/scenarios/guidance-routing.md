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
