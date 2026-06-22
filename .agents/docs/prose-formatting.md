# Prose formatting

Use this guide when writing or editing external prose artifacts.
External prose artifacts include long-form comments, commit messages,
Markdown files, documentation, design documents, pull request descriptions,
changelogs, issues, release notes, and generated output files.

Conversational chat messages to the user are not external prose artifacts.
Format chat messages for the chat surface,
not for maintainable source-file line structure.

If a user explicitly asks for normal prose in chat,
do not apply semantic line breaks to the chat response.

## Semantic line breaks

Semantic line breaks are source-file line breaks placed at logical points
in the text.
Good break points expose the sentence structure:
sentences, clauses, list boundaries, hyperlinks, and markup boundaries.

Semantic line breaks optimize prose for source editing, diff review,
and future maintenance.
Each line should carry a coherent unit of meaning
so that small text edits do not rewrap unrelated prose
or hide the meaningful change in a noisy diff.

Semantic line breaks are required when writing new external prose artifacts
or when reflowing prose as part of the requested change.

When editing an existing artifact,
match the local source-line style of the text being changed.
If the surrounding text uses one complete paragraph per physical line,
keep a narrow edit in that paragraph on one physical line
unless the user asked for reflowing,
the paragraph is already being substantially rewritten,
or the existing line structure would make the result invalid.
Do not reflow paragraph-per-line text only to satisfy this guide;
that turns a small content change into unrelated diff churn.

When adding a new paragraph to a paragraph-per-line artifact,
use one physical line for that new paragraph
so the addition follows the artifact's existing structure.
When adding a new section,
file,
or block that does not have an established local style,
use semantic line breaks.

### Required breaks

Break after each complete sentence.
A complete sentence is punctuated by
a period (`.`), exclamation mark (`!`), or question mark (`?`).

```markdown
This is an example of a semantic line break.
Here is another sentence following the break.
```

Never break within a hyphenated word.
Treat the hyphenated word as one unit,
and break before or after the whole word if needed.

### Preferred breaks

Prefer a break after an independent clause
when punctuation marks the clause boundary.
Commas, semicolons, colons, and em dashes can signal useful break points,
but they are not commands to break after every occurrence.

```markdown
This is an example of a semantic line break,
which improves readability by separating clauses.
Multiple lines make it easier to read and maintain.
```

Prefer a break before an enumerated or itemized list.

```markdown
The following items are important:
(a) First item; (b) Second item; and (c) Third item.
```

### Optional breaks

Use a break after a dependent clause
when it clarifies the grammatical structure
or keeps the line within the relevant limit.

```markdown
Semantic line breaks are not strictly required here
but using them can enhance the clarity of the text
and keep lines within recommended length limits.
```

Use breaks around hyperlinks when the link would dominate the line
or force the line past the limit.
A hyperlink may stand on its own line.

Use breaks before inline markup when the markup is the next logical unit
or when keeping the markup attached to earlier prose
would make the line too long.

## Inline lists

Inline lists favor compact, readable units.
Do not split a short inline list merely because commas appear.
Before breaking inside an inline list, first check whether the whole list
and its immediate grammar fit within the applicable line-length limit.
If they fit, keep that list segment together.
For Markdown prose,
use the absolute line-length limit when needed
to avoid an inferior inline-list break.
If the whole sentence containing the inline list fits comfortably
and remains readable,
keep the sentence on one line.
When wrapping is required, prefer readable groups
that keep adjacent short items together.
Do not optimize for visually equal line lengths.
For a three-item list,
do not put only the first item on its own line
when the first two items fit together.
Do not use a one-item, one-item, one-item layout for a short inline list
when any adjacent pair fits on one line.
When a trailing clause follows the list,
keep the trailing clause with the final item if that grouping fits.
Break between list items, not in the middle of an item.
Do not split every item onto its own line
unless the list is intentionally formatted as an itemized list.
It is acceptable to move the final conjunction with the last list item
when doing so makes a balanced, readable group.
If an item is too long to fit on one line, apply the regular splitting rules,
then continue with normal list splitting rules
for the remaining list items.
When a list is followed by another clause, prefer a break at the clause boundary
over attaching the next clause to the final list item
only if the sentence already needs to wrap.

Do not add, remove, or move conjunctions to make wrapped lines look balanced.
The text must keep the same grammar and meaning after reflowing.

Bad:

```markdown
When alpha,
beta,
gamma,
or delta
appears, run the fallback.
```

Good:

```markdown
When alpha, beta, gamma, or delta appears, run the fallback.
```

Bad:

```markdown
The cache key includes tenant,
region,
and checksum,
then stores those fields as
`tenant_id`,
`region_id`,
and `digest`.
```

Good:

```markdown
The cache key includes tenant, region, and checksum,
then stores those fields as `tenant_id`, `region_id`, and `digest`.
```

Also good:

```markdown
The parser accepts alpha, beta, gamma, delta, epsilon, and zeta modes,
then normalizes them to `A`, `B`, `G`, `D`, `E`, and `Z`
before dispatch.
```

Bad:

```markdown
Before publishing, verify title,
summary,
and owner.
```

Good:

```markdown
Before publishing, verify title, summary,
and owner.
```

Bad:

```markdown
Assign reviews to Alice,
Ben, or Casey
when the draft is ready.
```

Good:

```markdown
Assign reviews to Alice, Ben,
or Casey when the draft is ready.
```

Bad:

```markdown
Send notices to the review channel,
release channel, or support channel
when the incident starts.
```

Good:

```markdown
Send notices to the review channel, release channel,
or support channel when the incident starts.
```

## Line length

Semantic line breaks are required,
but they do not override line-length limits.
When a semantic boundary would exceed the absolute limit,
choose the nearest word boundary that preserves meaning.

| Target | Preferred upper limit | Absolute upper limit |
| --- | ---: | ---: |
| Commit message title | 50 characters | 72 characters |
| Commit message body | 72 characters | 72 characters |
| Code comments | 80 characters | 100 characters |
| Markdown prose | 80 characters | 100 characters |

A line may exceed the absolute limit only when needed for hyperlinks,
code elements, or other markup that would become less useful or invalid
if broken.
Markdown tables may always exceed the absolute limit.
Markdown tables must remain valid Markdown tables.

## Decision procedure

When deciding where to break a line,
use the first applicable boundary in this order:

1. End of sentence.
2. Boundary before a list, block quote, code block, table, or other block.
3. Independent clause boundary.
4. Dependent clause boundary that improves readability.
5. Boundary before or after a hyperlink or inline markup.
6. Readable grouping boundary inside a long inline list.
7. Nearest word boundary needed to satisfy the absolute line limit.

Before using steps 3 through 7, check whether the proposed break
would split a compact inline list.
If it would, prefer keeping the inline list and its immediate grammar together.

Do not use mechanical wrapping as the primary strategy.
A line break should usually explain the prose structure
to the next person editing the file.

## Red flags

Treat these statements as signs that the formatting needs another pass:

| Statement | Correct response |
| --- | --- |
| "The formatter wrapped it." | Reflow by meaning, then check line length. |
| "It is just documentation." | External prose still needs semantic breaks. |
| "The line is only slightly long." | Meet the absolute limit unless markup requires otherwise. |
| "Each list item gets its own line." | Preserve compact lists when they remain readable. |
| "Balanced means the lines should be visually even." | Use available line length to keep adjacent short items together; do not optimize for equal-looking lines. |
| "The sentence has commas, so each comma is a semantic break." | Keep compact inline-list sentences together when they fit and remain readable. |
| "The conjunction can never start the next line." | Permit a final conjunction to start the next line when it creates a balanced, readable group. |
| "Semantic breaks mean every clause gets its own line." | Keep short dependent clauses with their governing sentence when the combined line is readable and within limits. |
| "Chat should look like files." | Format chat for chat unless asked otherwise. |
| "This paragraph is already one line, but this guide requires semantic breaks." | Preserve paragraph-per-line style for narrow edits to existing text. |

## Examples

### Multiple sentences

Bad:

```markdown
All human beings are born free and equal in dignity and rights. They are endowed with reason and conscience and should act towards one another in a spirit of brotherhood.
```

Good:

```markdown
All human beings are born free and equal in dignity and rights.
They are endowed with reason and conscience
and should act towards one another in a spirit of brotherhood.
```

### Long sentences

Bad:

```markdown
The quick brown fox jumps over the lazy dog, demonstrating agility and speed in
a single bound, which is a testament to its evolutionary adaptations and
survival skills.
```

Good:

```markdown
The quick brown fox jumps over the lazy dog,
demonstrating agility and speed in a single bound,
which is a testament to its evolutionary adaptations and survival skills.
```

### Hyperlinks

Bad:

```markdown
For more information, visit our documentation at <https://example.com/documentation/getting-started> to get started.
```

Good:

```markdown
For more information, visit our documentation at
<https://example.com/documentation/getting-started>
to get started.
```

Also good:

```markdown
For more information,
visit our documentation at <https://example.com/documentation/getting-started>
to get started.
```

### Itemized lists

Bad:

```markdown
The following items are important: (a) First item; (b) Second item; and (c) Third item.
```

Good:

```markdown
The following items are important:
(a) First item; (b) Second item; and (c) Third item.
```

Also good:

```markdown
The following items are important:
(a) First item;
(b) Second item; and
(c) Third item.
```

## Common repairs

### A line exceeds the limit

Look for sentence, clause, phrase, hyperlink, markup, or list boundaries
earlier in the line.
If no suitable semantic boundary exists,
break at the nearest word boundary that satisfies the line limit.

### A hyphenated word would need to wrap

Keep the hyphenated word intact.
Move the whole word to the next line,
or choose an earlier break point.

### A formatter produced mechanical wrapping

Reflow the paragraph manually.
Place breaks where the sentence structure changes,
then verify the line-length limit.
