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
