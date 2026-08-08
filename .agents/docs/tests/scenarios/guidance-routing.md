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

