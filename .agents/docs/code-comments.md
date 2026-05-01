# Code comments

Use this guide when writing, reviewing, or revising code comments.

## Decision checklist

Before adding or keeping a comment, ask:

- Does this comment explain why the code exists,
  what invariant it protects,
  what boundary it represents,
  or what non-obvious behavior readers must preserve?
- Does this comment document a named concept
  that would otherwise need to be reverse-engineered from fields,
  call sites,
  or lower-level representations?
- Does this comment help readers understand a large block's intent
  without narrating each line?

If the answer is no,
delete the comment or improve the code instead.

## When to add comments

Comments are there to provide additional context
that is not obvious from the code itself.

Use comments to explain:

- why a non-obvious decision was made
- which invariant must be preserved
- which representation or system boundary is being crossed
- what a named domain concept means
- why a large block is organized the way it is
- what surprising behavior future readers must not simplify away

When available,
explain the "why" behind non-obvious code,
not just the "what".

```
BAD
// Start workers.
for i := 0; i < numWorkers; i++ {
    go worker()
}

GOOD
// Workers must be spawned before sending the first event
// or there will be a deadlock.
for i := 0; i < numWorkers; i++ {
    go worker()
}
```

## When to delete comments

Do not add or keep comments that do not add value.

Delete comments when:

- the code is self-explanatory
- the comment merely restates what the code does
- the comment is out of date or incorrect
- the comment narrates a single obvious operation

Examples of comments to delete:

```
// Close the channel.
close(ch)

// Start the worker.
go worker()

// Increment counter.
count++
```

Examples of comments to keep:

```
// Workers must be spawned before sending the first event
// or there will be a deadlock.
for i := 0; i < numWorkers; i++ { go worker() }

// Use a nil channel to disable this select case when buffer is empty.
processChan = nil
```

## Document named concepts

When introducing a new type, struct, enum, record, state object,
or domain-specific alias,
assume it needs a concept comment
unless it is purely mechanical
and obvious from an immediately adjacent function.

For structs,
also assume each field needs a comment
unless the field's meaning, units, source,
and valid values are obvious from its name and type.

This is required even for private types
when the type translates from another representation,
carries invariants,
or exists to keep the rest of the code
from depending on a lower-level shape.

**Why**: A named type is a claim that a concept exists.
If the concept is not documented,
readers must reverse-engineer the model from fields and call sites.
That makes refactors fragile
and hides important invariants at the boundary
where the code was supposed to become clearer.

```
BAD

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

```
GOOD

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

## Standalone vs inline comments

Standalone comments are full sentences
that start with a capital letter
and end with a period.

```
BAD
// Start dispatcher

GOOD
// Start the dispatcher.
```

Inline comments appear at the end of a line of code.
They are fragments starting with a lowercase letter.

```
BAD
eventChan chan *Event // Channel for events

GOOD
eventChan chan *Event // channel for events
```

If an inline comment has to become multi-line,
convert it to a standalone comment
and make it a full sentence.

```
BAD
eventChan chan *Event // channel for events
                      // received from the network

GOOD
// Channel for events received from the network.
eventChan chan *Event
```

## Multi-line comment style

In languages that support it,
multi-line comments must use `//`,
not `/* ... */`.

Apply semantic line breaks to long comments.

```
BAD
/*
 This is a multi-line comment.
 It uses block comment syntax.
*/

GOOD
// This is a multi-line comment.
// It uses line comment syntax.
```

## Go: GoDoc and struct fields

When writing comments for exported functions, types, or variables in Go,
always use the GoDoc style,
starting with the name of the item being documented.

```
BAD
// This function starts the dispatcher.
func StartDispatcher() { ... }

GOOD
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
