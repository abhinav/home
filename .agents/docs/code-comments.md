# Code comments

## Overview

Use this guide when writing, reviewing, or revising comments
and in-code documentation.

Documentation is for users of a symbol, module, package, or public API.
Comments are for maintainers reading or changing the implementation.
Both should spare the reader from reverse-engineering context
that the code cannot show by itself.

Write for the reader's task,
not from the author's memory of the change.

## Choose The Reader

Before adding, keeping, deleting, or rewriting text in code,
identify the target reader:

- Documentation is for callers, importers, integrators, and API users.
  It explains what the symbol promises,
  how to use it,
  and which constraints matter at the boundary.
- Comments are for maintainers changing the implementation.
  They explain why the code is shaped this way,
  what invariant must hold,
  and what would break if simplified.

Do not make callers read implementation comments
to understand the public contract.
Do not make maintainers infer hidden implementation constraints
from public documentation alone.

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
ordering constraints, and why an obvious simplification would be wrong.

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

If the answer is no,
delete the text or improve the code instead.

## When To Add Documentation

Add or keep documentation when a symbol's users need to know:

- what the symbol represents or promises
- how to call it correctly
- valid values, units, ownership, or lifetime rules
- side effects, concurrency behavior, ordering, or error behavior
- the external system, protocol, file format, or domain concept it models

Documentation should describe the public contract.
Do not put private implementation algorithms in public documentation
unless callers must rely on that behavior.

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
- what surprising behavior future readers must not simplify away

When available,
explain the "why" behind non-obvious code,
not just the "what".

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

## When To Delete Or Rewrite

Do not add or keep comments that do not add value.

Delete or rewrite text when:

- the code is self-explanatory
- the text merely restates what the code does
- the text duplicates a clear name or type
- the text is stale or incorrect
- the text narrates a single obvious operation
- documentation exposes implementation detail
  that belongs near the private implementation

Keep or add text when it prevents a reader
from having to reconstruct hidden state,
non-obvious setup,
or the boundary that makes the code meaningful.

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

When introducing a new type, struct, enum, record, state object,
interface, alias, or domain-specific value,
assume it needs concept documentation or a concept comment
unless it is purely mechanical
and obvious from an immediately adjacent function.

For structs and records,
also assume each field needs documentation or a comment
unless the field's meaning, units, source,
and valid values are obvious from the field name and type.

Private concepts are not exempt.
If a private type translates from another representation,
carries invariants,
or prevents the rest of the code from depending on a lower-level shape,
document the concept for maintainers.

A named type is a claim that a concept exists.
If the concept is not documented,
readers must reverse-engineer the model from fields and call sites.
That makes refactors fragile
and hides important invariants at the boundary
where the code was supposed to become clearer.

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
eventChan chan *Event // channel for events
```

If an inline comment has to become multi-line,
convert it to a standalone comment
and make it a full sentence.

```go
// Channel for events received from the network.
eventChan chan *Event
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
- "The field names are probably clear enough."
- "The type comment already covers the fields."
- "This comment says what the next line does."
- "The reviewer already has the conversation context."
- "The caller can inspect the implementation to figure it out."
- "The maintainer will know why this cannot be simplified."
- "More comments are safer."
- "This is too small to apply the comment guidance."

These usually mean the text is aimed at the author,
or at volume of comments,
not at the future reader.
