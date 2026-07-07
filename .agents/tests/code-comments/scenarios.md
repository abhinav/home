# Code Comments Scenarios

## 01 Automatically Load Guidance For Named Concepts

### Prompt

Run this prompt where the repository `AGENTS.md` applies.
Do not mention the code comments guide in the prompt.

A teammate needs a production-quality TypeScript patch sketch.
Introduce a private `QueueClaim` interface built from an AMQP reply tuple.
The tuple contains an opaque receipt,
an absolute deadline in Unix seconds,
a zero-based partition number,
and an integer acknowledgement policy where `0` rejects acknowledgement
and `1` permits it.
Downstream workers must consume the interface instead of the AMQP tuple.
Return code only.
Keep the patch small and avoid extra ceremony.

Do not modify files or external state.

### Expectations

- The subagent reads and applies `~/.agents/docs/code-comments.md`
  before drafting.
- The output documents the named boundary concept for maintainers.
- The output documents field semantics that names and types do not establish,
  including units, indexing, valid values, and representation changes.
- The output avoids comments that only narrate the code.
- The subagent does not treat code-only output,
  small scope,
  or private visibility as exemptions from the trigger.

### Pressure Variant

The user adds:

The review window closes in ten minutes.
A staff engineer says the implementation is obvious,
the code is already drafted,
and comments can be handled later if anyone asks.

- The subagent still reads and applies the guide before returning the output.
- The subagent does not use time, authority, sunk cost,
  or small-change pressure to defer the documentation decision.

### Adjacent Valid Case

The same task introduces a local tuple alias
used only within one immediately adjacent conversion expression.
The alias adds no domain concept, invariant, or boundary of its own.

- The subagent reads the guide before deciding whether comments add value.
- The subagent may omit a concept comment when the alias is purely mechanical
  and obvious from the adjacent expression.

## 02 Compact High-Cognitive-Load Blocks

### Prompt

Run this prompt where the repository `AGENTS.md` applies.
Do not mention the code comments guide in the prompt.
Do not modify files or external state.

A production patch contains one linear routine that:

- skips expired work items
- defers retry-gated items while tracking the earliest retry time
- admits remaining items while tracking count and byte limits
- derives whether the batch is saturated or blocked from the accumulated state

The conditions and variable names are individually clear.
The routine stays together so maintainers can inspect classification order,
four pieces of accumulated state,
and the derived result in one place.

Decide whether implementation comments would help,
describe where they belong and what they should convey,
and explain the decision.

### Expectations

- The subagent reads and applies `~/.agents/docs/code-comments.md`
  before making the comment decision.
- The subagent evaluates the combined cognitive load of the block,
  not only whether each statement or condition is understandable in isolation.
- The subagent recommends a block-level comment
  that compacts several details into a higher-level purpose, phase,
  relationship, or state summary for the maintainer.
- The subagent recognizes that a higher-level account of what the block does
  can be useful and does not restrict comments to hidden reasons or invariants.
- The subagent avoids line-by-line narration
  and comments that cost as much to read as the code.

### Pressure Variant

A reviewer says:
"The names are clear, so comments can only repeat the code.
We should reserve comments for tricky Boolean expressions."

- The subagent still evaluates how many facts the maintainer must track
  across the whole block.
- The subagent does not treat individually clear statements
  as proof that a compact block-level comment has no value.

### Adjacent Valid Case

The routine contains one guard clause and one clearly named operation,
with no accumulated state or relationship among multiple facts to track.

- The subagent may omit a comment because the code already reads
  as one compact chunk.
- The subagent does not add a comment merely to increase comment coverage.

## 03 Distinguish Documentation From Comments

### Prompt

Read `~/.agents/docs/code-comments.md`.
Do not modify files or external state.

A patch adds a private helper used by three callers in one package.
Its callers need to know that it returns the first healthy replica
in priority order and returns no value when none are healthy.
Its body is a long scan that tracks a fallback candidate,
preferred-zone state,
and whether a stickiness token still applies.

Decide what prose belongs with the helper symbol,
what prose belongs inside the implementation,
and identify the reader for each.

### Expectations

- The subagent treats the helper's caller-facing contract as documentation
  even though the helper is private.
- The subagent writes symbol documentation for users of the helper
  and implementation comments for maintainers changing the scan.
- The implementation comments compact state or relationships
  that maintainers must track through the body.
- The subagent does not put implementation mechanics
  into the caller-facing contract unless callers rely on them.

### Pressure Variant

A reviewer says:
"Private symbols only need comments for maintainers;
documentation is only for public APIs."

- The subagent keeps the reader boundary based on use,
  not symbol visibility.
- The subagent does not merge caller documentation
  and implementation commentary into one undifferentiated comment.

### Adjacent Valid Case

A local helper has one call site,
and its name, signature, and adjacent expression completely establish its use.
Its body contains one obvious operation.

- The subagent may omit both documentation and an implementation comment
  when neither reader needs information beyond the code.
