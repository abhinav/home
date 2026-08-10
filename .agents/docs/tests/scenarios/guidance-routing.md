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
