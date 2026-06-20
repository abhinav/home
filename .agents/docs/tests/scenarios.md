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
