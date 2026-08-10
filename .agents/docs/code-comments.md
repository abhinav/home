# Code comments

Use this guide when writing, reviewing, or revising comments
and in-code documentation.

This guide governs what comments communicate and where they belong.

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

Documentation should let a user treat a symbol as a black box.
Treat the name, signature, and types as information the reader already has.
A useful comment resolves a material uncertainty
so the user can predict or decide something
without opening the implementation.

Establish the contract from repository evidence:
the implementation, types, callers, tests, specifications,
and accepted design decisions.
Documentation and any rationale for its scope make evidence claims.
If the evidence does not establish a useful claim,
investigate or report the gap instead of writing plausible prose.
Do not strengthen a name or implementation observation
into a broader compatibility, safety, or lifecycle guarantee.

Describe the evidence-backed transitions that affect use:

- Connect each input or precondition to the success or failure it selects,
  including recognizable errors and unchanged state.
- Connect success to what the returned value represents
  and which effects become visible.
- State how ownership, mutation, lifetime, ordering, concurrency,
  units, valid values, or limits change the caller's choices.

Keep each condition joined to its consequence.
A list of correct facts still leaves the user to reconstruct the contract
when it does not explain which situation produces which outcome.

Relationships often carry the contract.
`SaveOrder atomically saves an order` does not identify the atomic unit.
If the order and its dispatch record are all-or-nothing,
say that they commit together
or that failure of either write leaves neither visible.
The relationship a caller can rely on matters;
the qualifier or implementation mechanism does not.

When space is constrained,
preserve the transitions that change a caller's decision:
conditions and outcomes,
success and committed effects,
failure and recognizable errors or unchanged state.
Drop an obvious operation summary or implementation detail first.
Compress by removing lower-value detail,
not by replacing an exact condition with familiar shorthand
whose meaning is broader or narrower.
If the material contract does not fit clearly,
use more space rather than erase part of it.
When repository policy requires documentation for every exported symbol,
use a short orienting comment for a self-explanatory boundary
rather than inventing a larger contract.
An operation summary is not sufficient when material behavior exists.

Apply the same boundary test to public and private symbols.
Visibility, caller count, and body length do not decide the need.
A private orchestration method, callback, or normalized type needs documentation
when it owns meaningful behavior, state, or invariants
that its users in the internal call graph must preserve.
A mechanical forwarding method or plainly represented record does not.

When a private boundary needs documentation,
an implementation comment inside it
does not replace documentation of its responsibility and contract.
Likewise,
interface documentation does not replace a local comment
when maintainers need an implementation invariant or transition
at the code that enforces it.

### Document packages and modules in isolation

Write package and module documentation for a reader
who begins at that boundary.
Establish:

- the responsibility the package or module owns;
- where it fits in the larger system;
- what it leaves to callers or neighboring abstractions;
- the important contracts and invariants it enforces; and
- how callers enter the abstraction.

Do not assume the reader has inspected sibling modules
or seen the change that introduced the abstraction.
Do not restate every exported symbol.
Provide the context that makes those symbols coherent as one interface.

### Document named concepts and fields

Document a named concept when it owns meaning, behavior,
or constraints not carried by its name, structure,
and immediately visible use.
Explain the need it addresses,
what it represents,
its source or representation boundary,
the behavior it controls,
and material limits.
Include only the parts the concept's users need.

Private concepts are not exempt.
A private type often needs documentation when it normalizes another shape,
prevents lower-level representations from leaking,
or carries a whole-value invariant.
A mechanical type does not need prose invented to justify its name.

Inspect each field separately.
A type comment does not replace field-specific meaning,
and a descriptive identifier does not necessarily establish units,
source, valid values, ordering, or ownership.
Document those facts with the field that owns them.
Omit a field comment when the name and type make its complete meaning obvious.

Put a relationship among fields at type scope
and keep each field's individual contract with that field.
Do not repeat field descriptions in the type comment
unless the repetition establishes a whole-value relationship.

When an interface implements an external specification,
link the authoritative source at the conformance boundary
and state the locally relevant contract.
A link should support verification,
not replace the explanation needed to read the code.

## Reduce implementation load with comments

An implementation comment should give a maintainer
a cheaper representation of the covered code.
It commonly does one of four jobs.

### Explain context

Explain a purpose, cause, invariant, compatibility constraint,
or reason an apparent simplification would be wrong.
Place the comment beside the smallest coherent span that owns the constraint.

```go
// Workers must exist before the first event is sent;
// otherwise the unbuffered handoff deadlocks.
for i := 0; i < numWorkers; i++ {
    go worker()
}
```

Treat comment writing as an analysis step.
If the comment cannot state the purpose, relationship,
invariant, or transition clearly,
the implementation or model may need more design work.

### Expose working state

Make a stack, cursor, parser position, ownership state,
protocol phase, or other hidden state visible
when later operations depend on it.
These comments may describe what each call does
because the useful result is the otherwise invisible state after the call.

```go
emit.LoadLocal(userID)    // stack: userID
emit.LoadConst(limit)     // stack: userID, limit
emit.Call("withinQuota")  // stack: allowed
```

The comments save the reader from replaying every stack mutation
or repeatedly consulting another API.
Introduce the notation once when its direction or omitted context is unclear.

### Guide the primary path

Give several visible operations one meaningful phase or maintenance region,
or summarize a callee so the reader can stay at the current level.
A guide comment may add no hidden fact;
its value can be division, rhythm, confirmation,
or showing where related maintenance belongs.

Judge the comment together with the span it covers.
A label over one obvious statement is usually narration.
A precise label over several operations may let the reader
treat them as one unit while scanning, verifying, or changing the routine.
The label still loses when blank lines, names, or structure
already provide the same orientation at lower cost.

When a phase has a meaningful transition,
orient the reader with the incoming state,
the operation or constraint,
and the resulting state or consequence.
Preserve stable names across adjacent phase comments.

```go
// Release request-scoped allocations.
freeQueryBuffer(c)
freeParsedArguments(c)
releaseRequestArena(c)

// Leave shared registrations.
unsubscribeTopics(c)
unwatchResources(c)
releaseTracking(c)
```

The calls already show each operation.
The comments earn their place in a longer cleanup routine
because they turn the calls into two maintenance regions.
They would be noise in a short routine
that already reads as one chunk.

### Teach prerequisite knowledge

A teacher comment explains domain knowledge
that the implementation depends on
but a capable maintainer may not know or recall.
Use one when that knowledge is necessary to verify or change the code
and names, types, or structure cannot carry it.

Teach only the model used here:

1. State the implementation goal.
2. Introduce the minimum prerequisite concept.
3. Explain the relationship, state transition, or case split the code uses.
4. Map stable terms and labels in the explanation to names in the code.
5. State the material limit or exceptional case.

Do not stop at naming an algorithm or linking background material.
The reader should be able to use the explanation
to predict the non-obvious conditions, updates, or cases in the code.
For an accumulated quantity or state machine,
state what the value represents,
what moves it in each direction,
and why each threshold selects its corresponding transition.
Naming an `error`, `score`, `phase`, or `state`
without explaining that causal role does not teach the model.

Use a small plain-text visualization
when shape, ownership, ordering, or a transition
would take more effort to reconstruct from prose.
Introduce the notation,
show only the relationships used by the implementation,
and reuse the code's names in the diagram and explanation.

```go
// Ownership is the clockwise interval (start, end].
// A wrapped interval contains the high and low ends of the ring:
//
//     0 === owned === end ... start === owned === max
//
// The two comparisons below test those low and high segments.
return token <= end || token > start
```

In a teacher comment,
use paragraphs or section labels only when they separate distinct parts
of the model the reader must learn,
not as a fixed template.

If the full lesson applies to several implementations,
put it in an owned design note or reference.
Keep enough local explanation and routing
for a reader to understand how this code maps to that model.

## Delete or rewrite comments that do not help

Delete or rewrite a comment when:

- it translates one obvious statement at the same scale;
- its label costs as much to read as the covered code
  and adds no orientation;
- it duplicates a clear name, type, or nearby contract
  without serving a required discovery or orientation role;
- it is stale, incorrect, or broader than the code it describes;
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

For exported Go functions, types, variables, and fields,
use GoDoc style and begin with the exported name.

```go
// StartDispatcher runs workers until ctx is canceled.
// It blocks until every worker has stopped.
func StartDispatcher(ctx context.Context) { ... }
```

When documenting Go struct fields,
separate each documented field from the previous field with an empty line.
This keeps multi-field structs scannable
and visually attaches each comment to one field.

```go
type Report struct {
    // GeneratedAt records when source collection finished, in UTC.
    GeneratedAt time.Time

    // Format selects the renderer; an empty value uses the account default.
    Format ReportFormat
}
```

## Tests

When changing this guide,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents
that have empty context windows.
