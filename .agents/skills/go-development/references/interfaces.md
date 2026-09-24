# Interfaces

## Interface compliance checks

Add compile-time assertions to verify that a type implements an interface:

```go
var _ InterfaceName = (*TypeName)(nil)
```

Skip this when the type or the interface can't be imported into the same file.

```go
// BAD: no compile-time check.
// A method signature typo won't be caught
// until the value is used as the interface.
type Handler struct{}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {}

// GOOD: the compiler rejects this immediately
// if *Handler doesn't satisfy http.Handler.
type Handler struct{}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {}

var _ http.Handler = (*Handler)(nil)
```

## Accept interfaces, return structs

Prefer accepting interfaces
and returning concrete structs.

When a type or function consumes behavior that may vary,
define the smallest useful interface at the consumption boundary.
Keep the interface near the consumer that owns the requirement,
not beside the provider merely to mirror the provider's methods.
This lets callers provide real implementations,
test doubles,
or wrappers without coupling the consumer to a larger API.

```go
func Parse(r io.Reader) (*Document, error) { ... }
```

When a package produces an abstraction,
return a concrete exported type by default.
Exported functions and methods must never return unexported types,
including through pointers, containers, or iterator element types.
Their callers must be able to name the result types in their own declarations.
Callers can define their own interfaces
at the point of use if they need one.

```go
type Client struct {
    ...
}

func NewClient(cfg ClientConfig) *Client {
    return &Client{...}
}
```

Avoid returning an interface
just to hide an implementation.
Adding methods to that interface later
will break callers with their own implementations,
including tests and wrappers.

Do not introduce an interface when substituting the dependency
would not improve the consumer's design or tests.
Concrete dependencies are appropriate when their API is already the relevant
contract,
they are cheap to construct or pass,
and callers do not need to replace their behavior.
This commonly includes structured loggers,
immutable configuration values,
standard-library value types,
and small stateless collaborators.
Prefer the concrete dependency in these cases
instead of creating a one-implementation interface for uniformity.

Producer-defined interfaces are still useful
when the package has multiple implementations,
when the interface represents a single operation,
or when callers commonly wrap the abstraction.
