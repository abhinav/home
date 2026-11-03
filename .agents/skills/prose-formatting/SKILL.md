---
name: prose-formatting
description: >
  Use when writing or editing prose other than ordinary conversational chat,
  including formatting-only edits, or when the user requests source-style
  prose in chat.
---

# Prose formatting

Format durable prose for both its rendered surface and the source that writers
and reviewers edit:
Markdown, documentation, design documents, commit messages, pull request
descriptions, changelogs, issues, release notes, code comments,
and generated prose artifacts.
Format conversational chat for its chat surface
unless the user requests source-style prose.

## Preserve the surrounding representation

New artifacts and content without an established local representation
follow this guide.
Edits and additions inherit surrounding source conventions
unless reformatting is requested or required for correctness.
A content change alone does not justify reformatting.
Preserve an output format the user explicitly requires.

This skill governs source layout, including wrapping and line breaks.
For substantive explanation revisions, use `$prose-writing` to choose paragraphs,
lists, tables, code, or diagrams; write that form using surrounding conventions.
Heading capitalization follows sentence case even among title-case headings;
preserve proper nouns, acronyms, product names, and code identifiers.

## Give each line a coherent role

When this guide governs the representation, use semantic line breaks
so a changed idea produces a local, interpretable diff.
Start each complete sentence on a new physical line;
keep a sentence together when it fits its width limit and remains readable.
Breaks should expose sentences, clauses, inline-list groups,
and transitions to block structures without changing grammar or meaning.
Do not add, remove, or move words merely to balance lines.

Width and semantic structure constrain the line together.
Within the applicable width, prefer boundaries in this order:

1. Sentence end or block boundary.
2. Independent clause.
3. Dependent clause, phrase, inline-list grouping, or markup boundary.
4. Word boundary.

Keep words and indivisible elements intact.
If the next strong boundary exceeds the limit,
break earlier at the best available weaker boundary.
The limit is a ceiling, not a target;
choose a break giving both resulting lines coherent roles.

Keep compact grammatical units together when they fit:
a short introductory or transitional phrase with the clause it frames,
or a short inline list with its surrounding grammar.
Move a unit intact to the next line when it cannot fit the current line;
do not split it to fill space or move earlier material to balance lengths.
When the unit cannot fit within the width,
divide it into the largest readable groups that do.

Treat an inline list as one coordinated unit.
If it must span lines, use the largest readable groups of adjacent items.
An item boundary permits a weak break; it does not require one item per line.
A short remaining group, even one item, may stand alone when coherent.
If clarity requires a line for every item, use a real block list.

## Apply widths where this guide governs

These limits do not require reflowing preserved prose.
Stay within the absolute maximum whenever content can be divided safely;
the preferred limit is where a natural earlier break should usually occur.

| Target | Preferred upper limit | Absolute upper limit |
| --- | ---: | ---: |
| Commit message title | 50 characters | 72 characters |
| Commit message body | 72 characters | 72 characters |
| Code comments | 80 characters | 100 characters |
| Markdown prose | 80 characters | 100 characters |

The absolute limit is binding for divisible prose.

A URL, indivisible code or markup, table, or other indivisible unit may exceed
the maximum when breaking it would make it invalid or less useful.
Keep the exception local: when surrounding prose can wrap normally,
put the indivisible element on its own line.

## See the boundaries

A compact sentence stays together:

```markdown
When alpha, beta, gamma, or delta appears, run the fallback.
```

A longer sentence groups adjacent list items,
then separates the action and consequence within the width:

```markdown
The cache key includes tenant, region, checksum,
deployment generation, and protocol version,
then stores those values before dispatch
so retries can recover the same request identity.
```

The commas do not create separate thoughts,
and the number of items per line does not govern the breaks.

## Review the source representation

Before returning the artifact,
check that new or intentionally reflowed prose stays within its applicable
width except for indivisible content.
Each retained break should expose the thought more clearly than a nearby
alternative,
and each compact unit kept together should fit comfortably.
Confirm that narrow edits preserve local representation
and that formatting did not alter the prose's grammar or meaning.
