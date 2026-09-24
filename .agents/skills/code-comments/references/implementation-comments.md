# Reduce implementation load with comments

An implementation comment should give a maintainer
a cheaper representation of the covered code.
It commonly does one of four jobs.

## Explain context

Explain a purpose, causal relationship, invariant,
compatibility requirement, or performance constraint
that changes how a maintainer should evaluate the visible operations.
This can include why setup or fixture data exists,
how a local mechanism produces externally observable behavior,
or why an apparent simplification would violate a required property.
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

## Expose working state

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

## Guide the primary path

Use a guide comment when it lets a maintainer treat several visible operations
as one accurate phase or stable maintenance region,
or rely on a callee summary while reasoning at the current level.
Its value is the change in reading scale;
it need not reveal a hidden fact.

The label and the span it covers make one claim.
Every covered operation must support the concept the label names.
When the span is too broad, too narrow, or mixes separate regions,
rewrite the label, regroup or split the code, adjust the span,
or delete the comment.
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

## Teach prerequisite knowledge

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
