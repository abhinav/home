# Code comments

## Overview

Use this guide when writing, reviewing, or revising comments
and in-code documentation.

Documentation is attached to a symbol, module, package, or API
and is for users of that interface,
whether the interface is public or private.
Comments may appear beside a statement, block, or function
or stand at file level,
and are for maintainers reading or changing the implementation.
Both should spare the reader from reverse-engineering context
or carrying fragile mental state
that the code cannot show directly.

Apply theory of mind for the reader's task:
write documentation for what a user of the interface needs to know,
and write comments for what a maintainer of the implementation
needs to understand.
Do not write either from the author's memory of the change.

## Choose The Reader

Before adding, keeping, deleting, or rewriting text in code,
identify the target reader:

- Documentation is for callers, importers, integrators, and API users.
  It explains what the symbol promises,
  how to use it,
  and which constraints matter at the boundary.
  For a private symbol,
  these users include maintainers navigating the implementation
  through its call graph and named operations.
- Comments are for maintainers changing the implementation.
  They compact the implementation into the purpose, state, relationships,
  or constraints a maintainer needs while reading and changing it.

Do not make callers read implementation comments
to understand the interface contract.
Do not make maintainers infer hidden implementation constraints
from interface documentation alone.
An implementation comment inside a private symbol
does not replace documentation of the symbol's responsibility and contract.

For documentation,
assume the reader can see the symbol name, signature, types,
and nearby package or module overview.
Explain contract details the signature does not show:
valid values, units, ownership, lifetime, side effects,
ordering requirements, concurrency behavior, error meanings,
and external systems or domain concepts.

For comments,
assume the maintainer can read the statements in front of them.
Explain implementation context the code does not show:
hidden state, external behavior, fixture purpose, expensive setup,
performance constraints, compatibility requirements,
ordering constraints, domain background,
and why an obvious simplification would be wrong.
When several visible details create cognitive load,
compact how they fit together instead of restating each one.

## Decision Checklist

Before adding or keeping documentation or a comment,
ask whether the text does at least one of these jobs:

- explains what a user of the symbol needs to know
  to call it correctly
- explains why the implementation exists
- identifies an invariant that must be preserved
- marks a representation or system boundary
- documents a named concept
  that would otherwise need to be reverse-engineered
  from fields, call sites, or lower-level representations
- explains a large block's intent or expensive setup
  without narrating each line
- reduces the work needed to understand code
  that depends on hidden state, external systems,
  ordering constraints, or non-obvious setup
- lowers the reader's mental bookkeeping
  in dense code by compacting multiple conditions, variables,
  state transitions, phases, or domain facts into a smaller number
  of meaningful chunks

If the answer is no,
delete the text or improve the code instead.

Use comments to explain a coherent design,
not to compensate for unrelated responsibilities
sharing a file or block.
When structure obscures responsibility,
improve locality before adding navigation prose.

## When To Add Documentation

Add or keep documentation when a symbol's users need to know:

- what the symbol represents or promises
- how to call it correctly or preserve the operation it owns
- valid values, units, ownership, or lifetime rules
- side effects, state transitions, concurrency behavior, ordering,
  or error and return-value meanings
- the algorithm, policy, or cohesive implementation stage it owns
- the external system, protocol, file format, or domain concept it models

Apply these criteria to public and private types, fields, functions, methods,
and callbacks alike.
Visibility, caller count, body length,
and documentation on a surrounding public API
do not determine whether a private symbol needs documentation.
A private symbol needs documentation when it owns meaningful behavior,
state, or invariants that maintainers must preserve.
A mechanical private helper does not need documentation
when its name, signature, and immediately visible behavior
fully express everything its users need to know.

Documentation should describe the interface contract well enough
that users can treat the symbol as a black box
and use it correctly without reading its implementation.
Do not put implementation algorithms in symbol documentation
unless users of the symbol must rely on that behavior.

## Document Packages And Modules In Isolation

Write package and module documentation for a reader who begins at that
boundary.
Do not assume the reader has inspected sibling modules,
followed the implementation history,
or seen the change that introduced the abstraction.

Give the reader enough context to understand:

- the responsibility the package or module owns
- where it fits in the larger system
- what it deliberately leaves to callers or neighboring abstractions
- the important contracts and invariants it enforces
- what its dependencies represent at the boundary
- how callers are expected to enter the abstraction

The documentation does not need to restate every exported symbol.
It should provide the context that makes those symbols coherent as one API.
If the package cannot be explained without narrating several neighboring
packages,
that may indicate either missing context or an unclear boundary.

## When To Add Comments

Add or keep implementation comments when maintainers need to know:

- why a non-obvious decision was made
- which invariant must be preserved
- which representation or system boundary is being crossed
- what a named domain concept means
- why a large block is organized the way it is
- what state or setup the surrounding code is trying to create
- what behavior the surrounding code is isolating or protecting
- how a cohesive phase groups work
  that maintainers must reason about or change together
- what a call or block does
  when that lets the reader follow the primary path without opening another implementation
- what surprising behavior future readers must not simplify away
- what hard-to-reconstruct state the reader should track
- what domain fact, protocol rule, or algorithm case
  the surrounding code depends on
- how several conditions, variables, or state transitions fit together
  when following them directly would overload the reader's working memory

Comments may explain why non-obvious code is shaped a particular way.
They may also give a higher-level account of what a block does
when that account compacts several implementation details
into one useful concept.
A useful comment operates at a higher level than the statements it covers;
it does not translate each statement back into prose.

Treat comment writing as an analysis step.
If the comment cannot state the relevant purpose, relationship,
contract, invariant, or state transition clearly,
the code or model may need more design work before the comment is ready.

```go
// BAD: narrates the loop.
// Start workers.
for i := 0; i < numWorkers; i++ {
    go worker()
}

// GOOD: explains the ordering invariant.
// Workers must be spawned before sending the first event
// or there will be a deadlock.
for i := 0; i < numWorkers; i++ {
    go worker()
}
```

## Reduce Mental Bookkeeping

Treat comments as compaction of code.
A useful comment gives the maintainer a smaller representation
of the code needed for the current reading task.
It lets the maintainer reason about one purpose, phase, relationship,
or state summary instead of keeping every underlying detail
in working memory.

Add this assistance when reading a block requires tracking
several conditions, variables, state transitions, phases,
or other facts at once.
The facts do not have to be hidden or individually confusing.
The comment earns its place when their combination creates cognitive load
and the compact representation makes the block easier to verify or change.

Good candidates include:

- stack, register, cursor, or parser state
  after calls to an API that hides that state
- phases in a long routine
  where future edits should remain grouped with related operations
- algorithm cases that match a preceding explanation
- compact domain background needed to understand the implementation

These comments still need to earn their place.
The compact representation should cost less to read
than reconstructing the same meaning from the code.
It must remain consistent with the code
and should not decorate a simple block that already reads as one chunk.

```go
emit.LoadLocal(userID)    // stack: userID
emit.LoadConst(limit)     // stack: userID, limit
emit.Call("withinQuota")  // stack: allowed
```

The comments are useful only because the operand stack is hidden state
that every following call depends on.

```go
// Flush queued writes before detaching transport state.
if conn.hasBufferedWrites() {
    conn.flush()
}
conn.stopWritePump()

// Detach timers while the connection still owns its callbacks.
conn.cancelIdleTimer()
conn.cancelRetryTimer()
```

The comments are useful when the surrounding function is long enough
that the section boundaries help maintainers place future cleanup work.
They would be noise in a short function
where the grouping is already obvious.

## When To Delete Or Rewrite

Do not add or keep comments that do not add value.

Delete or rewrite text when:

- the code is self-explanatory
- the text merely restates a small obvious operation
- the text duplicates a clear name or type
- the text is stale or incorrect
- the text narrates a single obvious operation
- reading the text costs as much as reading the code
  and provides no additional orientation
- documentation exposes implementation detail
  that belongs near the private implementation

Keep or add text when it prevents a reader
from having to reconstruct hidden state,
non-obvious setup,
the boundary that makes the code meaningful,
or the domain context needed to reason about the implementation.

Examples of comments to delete:

```go
// Close the channel.
close(ch)

// Start the worker.
go worker()

// Increment counter.
count++
```

Examples of comments to keep:

```go
// Workers must be spawned before sending the first event
// or there will be a deadlock.
for i := 0; i < numWorkers; i++ { go worker() }

// Use a nil channel to disable this select case when buffer is empty.
processChan = nil
```

## Document Named Concepts

Document a named concept when it owns meaning, behavior,
or constraints not carried by its name, structure,
or immediately visible use.
A mechanical representation does not need documentation
when those sources fully explain its role.

For structs and records,
also assume each field needs documentation or a comment
unless the field's meaning, units, source,
and valid values are obvious from the field name and type.

Private concepts are not exempt.
If a private type translates from another representation,
carries invariants,
or prevents the rest of the code from depending on a lower-level shape,
document the concept for maintainers.

When an implementation follows an external specification,
link to the authoritative reference when available
so readers can verify conformance.

When a named type establishes a concept,
document the meaning and constraints
that readers would otherwise have to reconstruct
from fields and call sites.

Weak:

```go
type deliveryPlan struct {
    id       string
    lanes    []string
    priority int
    active   bool
}
```

The type hides what a delivery plan is,
where the data came from,
what the lanes represent,
and what active controls.

Better:

```go
// deliveryPlan is the scheduler's normalized view of one delivery request.
//
// It is built at the API boundary so scheduling code does not depend on the
// wire-format request shape.
type deliveryPlan struct {
    // id identifies the delivery request in scheduler logs.
    id string

    // lanes lists the allowed transport lanes in preference order.
    //
    // For example, []string{"ground", "rail"} means the scheduler should try
    // ground transport before rail.
    lanes []string

    // priority controls scheduling order.
    //
    // Lower values are scheduled first.
    priority int

    // active is false when the request should be retained but not scheduled.
    active bool
}
```

## Standalone And Inline Comments

Standalone comments are full sentences
that start with a capital letter
and end with a period.

```go
// BAD
// Start dispatcher

// GOOD
// Start the dispatcher.
```

Inline comments appear at the end of a line of code.
They are fragments starting with a lowercase letter.

```go
deadline := time.Time{} // no deadline
```

If an inline comment has to become multi-line,
convert it to a standalone comment
and make it a full sentence.

```go
// Use an empty deadline so the transport waits indefinitely.
deadline := time.Time{}
```

## Multi-Line Comment Style

In languages that support line comments,
multi-line explanatory comments must use line comments such as `//`,
not block comments such as `/* ... */`.

Apply semantic line breaks to long comments and documentation
when the repository expects prose wrapping.

```go
// This is a multi-line comment.
// It uses line comment syntax.
```

## Go: GoDoc And Struct Fields

When writing comments for exported functions, types, variables,
or fields in Go,
use GoDoc style:
start the documentation comment with the exported name.

```go
// BAD
// This function starts the dispatcher.
func StartDispatcher() { ... }

// GOOD
// StartDispatcher starts the dispatcher.
func StartDispatcher() { ... }
```

When documenting struct fields,
separate each documented field from the previous field
with an empty line.
This keeps multi-field structs scannable
and makes each field's comment visually attach
to only that field.

```go
type Report struct {
    // Name identifies the report.
    Name string

    // Format selects the report renderer.
    Format ReportFormat
}
```

## Red Flags

Stop and revise when you catch yourself thinking:

- "The type is private, so it does not need a concept comment."
- "The method has one caller, so it does not need documentation."
- "The public API documentation already covers the private operation."
- "The method is short, so an implementation comment is enough."
- "The field names are probably clear enough."
- "The type comment already covers the fields."
- "This comment translates only the next line into prose."
- "The reviewer already has the conversation context."
- "The caller can inspect the implementation to figure it out."
- "The maintainer will know why this cannot be simplified."
- "More comments are safer."
- "This is too small to apply the comment guidance."

These usually mean the text is aimed at the author,
or at volume of comments,
not at the future reader.

## Tests

When changing this guide,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
