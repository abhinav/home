# Code comments

## Core Rules

- Standalone comments MUST be full sentences,
  starting with a capital letter and ending with a period.
- Inline comments SHOULD be lowercase fragments.
- If inline comments become multi-line,
  convert to standalone comments.
- Multi-line comments MUST use `//`, never `/* ... */`.
- Apply semantic line breaks to long comments.
- Explain "why", not "what".
- DELETE comments that do not add value.

## Standalone vs Inline Comments

Standalone comments are full sentences:

```
BAD
// Start dispatcher

GOOD
// Start the dispatcher.
```

Inline comments (appearing at the end of a line of code)
are fragments starting with a lowercase letter:

```
BAD
eventChan chan *Event // Channel for events

GOOD
eventChan chan *Event // channel for events
```

If an inline comment has to become multi-line,
it MUST be converted to a standalone comment
and become a full sentence.

```
BAD
eventChan chan *Event // channel for events
                      // received from the network

GOOD
// Channel for events received from the network.
eventChan chan *Event
```

## Multi-Line Comment Style

Multi-line comments MUST use `//`, not `/* ... */`.

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

## Explain "Why", Not "What"

When available, explain the "why" behind non-obvious code,
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

## Go: GoDoc Style

When writing comments for exported functions, types, or variables in Go,
ALWAYS use the GoDoc style,
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

## Document Named Concepts

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

## Avoiding Unnecessary Comments

Do not add comments that do not add value.
Consider:

- Is the code self-explanatory?
  If yes, DELETE the comment.
- Does the comment just restate what the code does?
  If yes, DELETE the comment.
- Is the comment out of date or incorrect?
  If yes, UPDATE or DELETE the comment.

Examples of comments to DELETE:

```
// Close the channel
close(ch)

// Start the worker
go worker()

// Increment counter
count++
```

Examples of comments to KEEP:

```
// Workers must be spawned before sending the first event
// or there will be a deadlock.
for i := 0; i < numWorkers; i++ { go worker() }

// Use a nil channel to disable this select case when buffer is empty.
processChan = nil
```

The key insight is:

- Comments are NOT there to narrate the code.
- Comments are there to:
  - provide additional context and explanation
    that is not obvious from the code itself
  - for large code blocks,
    allow readers to quickly grasp the intent
    without reading every line of code.
