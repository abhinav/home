# Reduce implementation load with comments

Give maintainers a cheaper representation of the covered code.
The four common jobs below may apply independently.

## Explain context

Explain a purpose, causal relationship, invariant, compatibility requirement,
or performance constraint that changes evaluation of the visible operations.
This can include fixture/setup purpose, how a local mechanism produces observable
behavior, and why simplification would break a required property.
Place it beside the smallest span owning the constraint.

```go
// Workers must exist before the first event is sent;
// otherwise the unbuffered handoff deadlocks.
for i := 0; i < numWorkers; i++ {
    go worker()
}
```

Comment writing is analysis: inability to explain the purpose, relationship,
invariant, or transition clearly may indicate the model or implementation needs
more design work.

## Expose working state

Expose hidden stack, cursor, parser, ownership, or protocol state that later
operations depend on.
Describing what a call does is useful when it reveals the otherwise invisible
resulting state:

```go
emit.LoadLocal(userID)    // stack: userID
emit.LoadConst(limit)     // stack: userID, limit
emit.Call("withinQuota")  // stack: allowed
```

This saves replaying mutations or consulting another API.
Introduce notation once if its direction or omitted context is unclear.

## Guide the primary path

Group several operations into one accurate phase or maintenance region,
or summarize a callee for reasoning at the current level.
Changing reading scale can help even without revealing a hidden fact.

The label and full covered span make one claim: every operation must fit it.
If the span is too broad, narrow, or mixed, adjust the label/span,
regroup or split code, or delete the comment.
A label over one obvious statement is usually narration;
it also loses when names, blank lines, or structure orient at lower cost.
For a meaningful transition, connect incoming state, operation/constraint,
and resulting state/consequence, using stable names across phases.

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

These labels can orient maintenance in a longer cleanup routine,
but add noise when the routine already reads as one chunk.

## Teach prerequisite knowledge

Teach unfamiliar domain premises needed to verify or change the code when names,
types, and structure cannot carry them.
Guide comments organize operations; teaching explains what the domain permits,
a representation means, or a mechanism causes.
A clear path can still have missing premises; evaluate that need separately.

Across the requested span, identify unfamiliar premises behind its decisions,
check those already established by code or explanations, and teach each missing
premise where the implementation relies on it.
Keep explanations supplying the needed model; omit new ones when the reader can
already predict the decision.
Coverage means the reader can explain the remaining decisions,
not a comment or phase count.

Teach only the model used here: goal, minimum prerequisite concept,
relationship/transition/case split, mapping to code names, and material limits
or exceptional cases.
An algorithm name or background link alone is insufficient.
The reader should be able to predict non-obvious conditions, updates, and cases.
For an accumulated quantity or state machine, explain what its value represents,
what moves it each way, and why each threshold selects its transition;
naming an error, score, phase, or state does not explain that causal role.

Use a small plain-text visualization when shape, ownership, ordering, or transitions
would be harder to reconstruct from prose.
Introduce notation, show only relationships used here, and reuse code names:

```go
// Ownership is the clockwise interval (start, end].
// A wrapped interval contains the high and low ends of the ring:
//
//     0 === owned === end ... start === owned === max
//
// The two comparisons below test those low and high segments.
return token <= end || token > start
```

Use paragraphs or section labels only for distinct parts the reader must learn,
not a fixed template.
If the lesson spans implementations, place it in an owned design note/reference;
retain enough local explanation and routing to map this code to that model.
