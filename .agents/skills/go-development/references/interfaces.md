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

When callers need a rich API but implementations only need a few core operations,
put convenience methods on a concrete wrapper around the small interface.
Do not require every implementation to repeat operations derivable from that core.
Include lifecycle methods only in interfaces used by consumers
that own those lifecycle responsibilities.
A request handler that needs `Get` need not also require `Close`;
the component owning the store's lifetime can close the concrete store.

## Optional capabilities

To extend an established interface without requiring every implementation to change,
detect a separate capability with a checked type assertion
and retain a working fallback using the original interface:

```go
func WriteString(w io.Writer, s string) (int, error) {
	if sw, ok := w.(io.StringWriter); ok {
		return sw.WriteString(s)
	}
	return w.Write([]byte(s))
}
```

The capability and fallback must satisfy the operation's contract.
If the new behavior cannot be implemented through the original interface,
make the new requirement explicit rather than pretending it is optional.
Wrappers can conceal additional methods of the wrapped value.
Check both paths, including a wrapper exposing only the original interface;
preserve the capability explicitly when the wrapper's contract requires it.
