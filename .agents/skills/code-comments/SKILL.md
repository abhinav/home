---
name: code-comments
description: >
  Use when writing, reviewing, revising, or deciding whether to add or remove
  code comments or in-code documentation; when introducing or changing domain
  concepts, non-obvious contracts, invariants, or representation boundaries;
  or when code's local model is not clear from its structure. Do not use for
  review feedback called comments or for prose outside source code.
---

# Code comments

Use this skill when writing, reviewing, or revising comments
and in-code documentation.

This skill governs what comments communicate and where they belong.

Documentation and implementation comments serve different readers.
Documentation is attached to a symbol, type, field, module, package, or API
and helps users of that interface use it without reading its implementation.
Implementation comments help maintainers understand, verify,
and safely change the code in front of them.

Both forms should reduce work for a concrete reader.
Write from the reader's task and available context,
not from the author's memory of the change.

## Choose the reader and representation

Assume an interface user can see the symbol name, signature, types,
and nearby module documentation.
Document the contract those elements do not carry.

Assume an implementation maintainer can read the statements in front of them.
Comment the local model that would otherwise require reconstruction,
navigation, mental simulation, or unfamiliar domain knowledge.

Choose the representation with the lowest net reading cost:

- Use names, types, and structure when they can express the meaning
  locally and reliably.
- Use documentation for the contract of a named boundary.
- Use an implementation comment for the model needed
  to reason about a coherent span of code.
- Use an external design note or authoritative specification
  when the full explanation spans several implementations;
  leave a local summary and route when readers still need them.

Do not ask only whether the information is visible in the code.
Ask whether the code presents it at a useful scale for the reader's task.
A comment may reveal unavailable context,
make hidden state visible,
compress several operations into one meaningful chunk,
or teach prerequisite knowledge.

A comment loses to clearer code
when a name, type, helper, or structural change expresses the same model
without adding navigation or indirection.
It loses to blank lines or existing structure
when they already make the same grouping apparent.
Improve locality instead of using navigation prose
to compensate for unrelated responsibilities sharing a file or block.

## Document interface contracts

Establish the contract from repository evidence:
the implementation, types, callers, tests, specifications,
and accepted design decisions.
Documentation and any rationale for its scope make evidence claims.
If the evidence does not establish a useful claim,
investigate or report the gap instead of writing plausible prose.
Do not strengthen a name or implementation observation
into a broader compatibility, safety, or lifecycle guarantee.

When writing, reviewing, or deciding whether to add interface documentation,
read `references/interface-documentation.md` for contract, package, module,
concept, and field documentation.

## Reduce implementation load with comments

When writing, reviewing, or deciding whether to add implementation comments,
read `references/implementation-comments.md` for context, working state,
primary-path guidance, and prerequisite knowledge.

## Delete or rewrite comments that do not help

Delete or rewrite a comment when:

- it translates one obvious statement at the same scale;
- its label costs as much to read as the covered code
  and adds no orientation;
- it duplicates a clear name, type, or nearby contract
  without serving a required discovery or orientation role;
- it is stale, inaccurate, or does not match the full span it describes;
- it exposes implementation detail in interface documentation; or
- it compensates for structure that should reasonably be made local or cohesive.

Do not delete a comment merely because it describes `what` the code does.
Keep it when the description exposes hidden state,
summarizes a larger span,
or supplies a model the code does not present at a useful scale.

```go
// BAD: translates the next statement.
// Increment the counter.
count++

// GOOD: explains how a visible mechanism controls behavior.
// A nil channel disables this select case while the buffer is empty.
processChan = nil
```

Stop and reconsider reasoning such as:

- "Private symbols do not need documentation."
- "Every named type needs documentation."
- "The code says what happens, so a `what` comment is always redundant."
- "The function is long, so every stage needs a heading."
- "More comments are safer."
- "The reviewer can recover the missing context from the conversation."

These use visibility, namedness, size, volume, or author context
as substitutes for the future reader's task.

## Write and format comments

Attach a comment to the smallest coherent span it explains.
Use stable names from the code
instead of introducing synonyms for the same concept.

Standalone comments are full sentences
that start with a capital letter and end with a period.
End-of-line comments are short fragments
when they annotate a value or state compactly.

```go
// Use an empty deadline so the transport waits indefinitely.
deadline := time.Time{}

deadline := time.Time{} // no deadline
```

If an end-of-line comment becomes multi-line,
move it above the code and write complete sentences.

In languages that support line comments,
use line comments such as `//` for multi-line explanations
rather than enclosing prose in `/* ... */`.
Follow the repository's established representation when it differs.

### Go documentation and struct fields

When documenting Go symbols or struct fields,
read `references/go-documentation.md` for GoDoc style and field spacing.
