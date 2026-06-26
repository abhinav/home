# Code readability

Use this guide when writing, organizing, or reviewing code.
It explains how readily a capable maintainer can understand and safely change it.

Readability measures extraneous cognitive load:
how much a capable maintainer must carry
to understand and change a coherent section of code.

Evaluate readability relative to a concrete reading task and a coherent code path.
Preserve complexity inherent to the domain.
Reduce presentation, indirection, and organization costs
that do not help the reader complete the task.

## Evaluate cognitive load

Read code from the perspective of a capable maintainer.
Identify the information the maintainer must keep active
while answering a specific question or making a realistic change.

Cognitive load comes from:

- Local load: values, states, conditions, and branches that must be understood together.
- Navigational load: the distance between related code
  and the files, callees, helpers, or paths the reader must inspect.
- Reconstruction load: purpose, invariants, ownership, ordering, and domain facts
  the reader must infer because they are not available where needed.

These costs interact.
A helper can reduce local expression complexity
while adding navigation and another abstraction to understand.
Judge the net load across the coherent path,
not the apparent improvement at one line.

## Keep control flow easy to follow

A reader should be able to identify the current state
and the conditions governing the next action.
The reader should not have to replay the entire function
to learn which effects have already occurred.

Keep the primary path visible and reduce the facts that must remain active at the same time.

- Give a complex condition a meaningful intermediate name
  when that lets the reader treat the expression as one fact.
- Use early exits for invalid or failure states
  when they let the reader discard those states and continue with the primary path.
- Converge successful branches before work they share.
- Represent mutually exclusive states directly
  instead of encoding them as combinations of booleans.
- Keep mutations and ordering near the operations they affect.

A longer sequence can be more readable than a compressed expression
when it makes decisions and state transitions visible.

## Keep related context local

Place information near the code that needs it.
A reader should not have to cross files, packages, or unrelated declarations
to reconstruct one concept or operation.

Keep a type near the behavior that gives it meaning.
Keep request and result records with the operation that consumes or produces them.
When code defines the behavior it requires from a collaborator,
keep that contract near the consumer.
Move a concept into a shared location only for genuine reuse.
The operations must share the same meaning and contract.

Arrange code around coherent operations and in the order a reader needs it.
Avoid grouping declarations by kind
when that separates concepts from their behavior.
Within a file, make the primary path visible
and place supporting details where the reader encounters the need for them.

A module can own one cohesive domain responsibility
without placing all of its code in one file.
Within a module, use files or nested modules as the language permits
to keep coherent subdomains and operations readable in isolation.
Choose those internal boundaries by responsibility or operation,
not declaration kind or arbitrary size.

## Use one term for one concept

Use one term consistently for one domain concept
across names, types, comments, and neighboring modules.
Introduce another term only when it represents a meaningful distinction.

Do not alternate synonyms for variety or rename a concept as it passes through layers.
When a representation changes but the domain concept does not,
retain the stable domain term or make the transformation explicit.

**Why**: Each term becomes an entry in the reader's mental model.
Synonyms force the reader to determine whether two names mean the same thing.
They can also hide relationships between code that belongs together.

When an established term must change,
update the coherent scope together or make the compatibility boundary explicit.
Do not leave old and new terms interleaved without explaining their distinction.

## Make helpers and indirection earn their place

A new helper or abstraction introduces another name and relationship
that the reader may need to understand.
This cost applies at every scale, from a private helper to a class or module.
Do not extract code only to shorten a function or meet a size target.

Keep straightforward single-use logic inline when it is clearest in context.
A visible sequence is often easier to understand
than a series of calls whose implementations the reader must inspect.

A descriptive name does not by itself reduce cognitive load.
A helper or abstraction earns its place only when its boundary removes information
that the reader would otherwise need to track.
For example, it may:

- hide substantial complexity behind a narrow contract
- own a complete domain operation and its coordination
- protect an invariant or centralize policy used by several paths
- enable genuine reuse without coupling unrelated code

When understanding the caller requires reading a helper's implementation,
the boundary may have moved complexity rather than hidden it.
Prefer to deepen the boundary or return the logic to the call site.

## Use comments to reduce cognitive load

Comments improve readability
when they reduce context the reader must reconstruct or navigation the reader must perform.

Use implementation comments to:

- explain purpose, invariants, ordering, or domain facts not encoded in the code
- introduce the stages of a long operation and provide landmarks
- summarize a call or block
  when that lets the reader follow the primary path without opening another implementation
- record obligations that nearby code must preserve when it changes

A comment may overlap with the visible operation
when it gives the reader useful structure or confirms the role of a larger block.

Trivial comments are forbidden.
A comment is trivial
when reading it costs as much as reading the code and provides no additional orientation.

Comments cannot compensate for design or organization
that the code can reasonably improve.
Read and apply `~/.agents/docs/code-comments.md`
when deciding which comments to add, keep, revise, or remove.

## Use architecture to contain cognitive load

Readable code depends partly on the boundaries around it.
A well-designed module owns a meaningful operation from input to outcome.
It hides coordination and infrastructure the caller does not need
behind a narrow contract.

A useful boundary lets the reader stop at its contract.
A boundary that only forwards calls or redistributes the same sequence
adds navigation instead of hiding complexity.

Local cleanup cannot make a system readable
when multiple callers must coordinate the same policy or reconstruct the same state transition.
That loss of locality is architectural.
Difficulty organizing code into coherent local units may also indicate
that the current responsibilities are not cohesive.

When a readability problem requires changing ownership, dependencies, or boundaries,
read and apply `~/.agents/docs/code-design.md`.
Use readability guidance to identify the cognitive cost and design guidance to choose the remedy.
