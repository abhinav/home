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
