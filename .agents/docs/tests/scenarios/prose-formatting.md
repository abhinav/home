# Prose formatting behavioral tests

## Preserve paragraph-per-line edits

### Prompt

Read the guidance at `~/.agents/docs/prose-formatting.md`.
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
- Explain that edits inherit the surrounding representation
  unless reformatting is requested or required for correctness.
- Avoid treating the paragraph-per-line style as invalid
  only because the guidance prefers semantic line breaks elsewhere.
- Avoid reflowing untouched paragraphs.

### Pressure variant

The user adds:
"This is a small edit in a review window,
but another reviewer quoted the semantic-line-break rule
and asked you to clean up the whole touched paragraph while you are there."

- Preserve the narrow edit's paragraph-per-line structure.
- Reject the rationale that a nearby formatting preference justifies unrelated diff churn.

### Adjacent valid case

The existing Markdown file uses mixed formatting.
The section being edited uses semantic line breaks,
and the requested change adds a new sentence to that section.

- Use semantic line breaks for the new sentence.
- Inherit the surrounding section's representation
  rather than a different representation used elsewhere in the file.

### Adjacent paragraph-per-line addition

The existing Markdown file uses one complete paragraph per physical line.
The requested change adds one sentence to an existing paragraph
and one new paragraph.

- Keep the expanded existing paragraph on one physical line.
- Put the new paragraph on one physical line.
- Treat the surrounding representation as authoritative for both additions.

### Adjacent heading-capitalization case

The existing Markdown file uses title case for its headings.
The requested change adds a section named `Review the Source Representation`.

- Write the heading as `## Review the source representation`.
- Use sentence case even though the surrounding headings use title case.

## Keep short inline lists compact

### Prompt

Read the guidance at `~/.agents/docs/prose-formatting.md`.
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

### Pressure variant

The user adds:
"A reviewer pointed to the preferred comma and clause break rules
and asked you to make the semantic structure more visible."

- Keep the full sentence on one physical line.
- Reject the rationale that commas alone require line breaks.

### Adjacent valid case

The sentence contains a long inline list
that would exceed the Markdown absolute line-length limit
if left on one physical line.

- Wrap the sentence at readable grouping boundaries.
- Keep related list items together when possible.
- A short final item may occupy its own line
  when that break preserves a coherent semantic grouping.
- Do not move items between lines merely to balance their visual lengths.
- Prefer a clause boundary after the list when that boundary gives both lines
  clearer roles than attaching following prose to the final list item.

### Width-pressure variant

Replace the supplied sentence with:

```markdown
The cache key includes tenant, region, checksum, deployment generation, compatibility schema, and protocol version, then stores those values before dispatch so retries can recover the same request identity without recomputing configuration.
```

- Stay within the Markdown absolute width for every divisible line.
- Break before the boundary after the complete list because waiting for it
  would exceed the absolute width.
- Keep the coordinated list in readable adjacent groups.
- Judge each break by the roles of the lines on both sides.

## Do not turn inline lists into mechanical item-per-line layouts

### Prompt

Read the guidance at `~/.agents/docs/prose-formatting.md`.
Do not modify files.

A draft uses physical line breaks after every coordinated inline-list item:

```markdown
Before deployment, confirm
tenant isolation,
quota enforcement,
checksum verification,
and rollback readiness.
```

Choose the exact Markdown representation you would use.
Explain the role of each retained line break.

### Expectations

- Treat the supplied items as one inline coordinated list
  rather than an implicit block list.
- Recombine and wrap the sentence at coherent semantic boundaries
  instead of mechanically placing each item on its own line.
- Permit `and rollback readiness` to occupy a short final line
  when that break preserves a coherent preceding group.
- Do not rebalance lines solely to make their visual lengths similar.

### Pressure variant

A reviewer says one item per line exposes the list structure
and makes future insertions easier.
They ask you to preserve every existing break.

- Keep the inline list readable as prose rather than a mechanical column.
- Reject edit convenience as sufficient reason to simulate a block list.

### Adjacent valid case

Each item is an independently actionable deployment check with
an owner, a status, and separate evidence,
and readers scan or update the checks independently.

- Use a true Markdown block list
  because the items have independent reader and maintenance roles.
- Keep each complete block-list item together
  rather than treating block structure as inline-list wrapping.

### Adjacent indivisible case

A required destination URL is longer than the Markdown absolute width
and cannot be broken without changing it.

- Keep the URL intact even though its line exceeds the width.
- Keep surrounding divisible prose within the width.

