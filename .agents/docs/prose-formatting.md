# Prose formatting

Use this guide when writing or editing durable prose artifacts,
including Markdown, documentation, design documents, commit messages,
pull request descriptions, changelogs, issues, release notes,
code comments, and generated prose artifacts.

Conversational chat is read on the chat surface rather than maintained as a
source artifact.
Format chat for that surface unless the user asks for source-style prose.

## Make the source express the thought

Durable prose has two reading surfaces:
the rendered artifact and the source that writers and reviewers edit.
Physical lines should expose meaningful units of thought.
That representation makes prose changes easier to review:
a changed idea produces a local, interpretable diff
instead of rewrapping unrelated prose or hiding the change in noise.

A useful source line carries an identifiable role in its paragraph's thought.
Line breaks reveal sentences, clauses, list groupings,
and transitions between prose and block structures,
but they do not change the grammar or meaning of the text.
Formatting should not add, remove, or move words merely to make lines look
balanced.

## Preserve established representation

New artifacts and content without an established local representation
follow this guide.
Edits and additions inherit the surrounding representation
unless reformatting is requested or required for correctness.
A content change alone does not justify reformatting.

Use semantic line breaks when this guide governs the representation.
Start each complete sentence on a new physical line.
If a sentence fits within its width limit,
keep it together when doing so remains readable.

Heading capitalization follows sentence case
even when surrounding headings use title case.
Preserve the capitalization of proper nouns, acronyms, product names,
and code identifiers.

## Choose coherent lines within the width

Width limits apply when this guide governs the representation;
they do not require reflowing preserved prose.
Width and semantic structure constrain the line together.
Stay within the applicable maximum whenever the content can be divided safely.
Within that space,
choose a break that leaves each line carrying a coherent part of the thought.

Prefer stronger boundaries when they fit:

1. the end of a sentence or the boundary of a block;
2. an independent clause;
3. a dependent clause, phrase, inline-list grouping, or markup boundary; and
4. a word boundary.

Words and indivisible elements remain intact.
This ordering describes the value of a boundary,
not permission to wait past the width limit for an ideal one.
When the next strong boundary would exceed the limit,
break earlier at the best available weaker boundary.
The width limit is a ceiling, not a target.
Choose the break that gives both resulting lines coherent roles.
When a compact grammatical unit does not fit on the current line,
keep it intact on the next line.
Do not split the unit merely to fill the current line,
or move earlier material merely to balance the resulting lengths.

Keep a compact grammatical unit together when it fits:
a short introductory or transitional phrase with the clause it frames,
a short inline list with its surrounding grammar.
When the unit does not fit,
divide it into the largest readable groups that do.
An inline list is one coordinated unit.
When it must span lines,
divide it into the largest readable groups of adjacent items.
An item boundary is a possible weak break,
not a reason to start every item on a new line.
A short remaining group, even one item,
may stand alone when it is a coherent part of the sentence.
When each item needs its own line for clarity,
use a real block list instead.

| Target | Preferred upper limit | Absolute upper limit |
| --- | ---: | ---: |
| Commit message title | 50 characters | 72 characters |
| Commit message body | 72 characters | 72 characters |
| Code comments | 80 characters | 100 characters |
| Markdown prose | 80 characters | 100 characters |

The preferred limit is where a natural earlier break should usually occur.
The absolute limit is binding for divisible prose.
A URL, indivisible code or markup, a table,
or another indivisible unit may exceed the limit when breaking the content
would make it invalid or less useful.
Keep the exception local.
When surrounding prose can wrap normally,
let the indivisible element occupy its own line.

## See the model at its boundaries

A compact sentence is one coherent line:

```markdown
When alpha, beta, gamma, or delta appears, run the fallback.
```

A longer sentence uses the strongest boundaries available before the limit:

```markdown
The cache key includes tenant, region, checksum,
deployment generation, and protocol version,
then stores those values before dispatch
so retries can recover the same request identity.
```

The first break divides the coordinated list into readable adjacent groups;
the number of items on each line is not the governing property.
The next breaks separate the action and its consequence
without carrying an earlier line past its width.
The commas inside the compact list do not create separate thoughts.

## Review the source representation

Before returning the artifact,
check that new or intentionally reflowed prose stays within its applicable
width except for indivisible content.
Each retained break should expose the thought more clearly than a nearby
alternative,
and each compact unit kept together should fit comfortably.
Confirm that narrow edits preserve local representation
and that formatting did not alter the prose's grammar or meaning.
