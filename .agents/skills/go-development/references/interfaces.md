# Interfaces

## Interface compliance checks

Add compile-time assertions, except when type or interface cannot be imported
into the same file:

```go
var _ InterfaceName = (*TypeName)(nil)
```

## Accept interfaces, return structs

Prefer interfaces for inputs and concrete structs for results.
For varying consumed behavior, define the smallest useful interface near the
consumer owning the requirement, not beside the provider to mirror its methods.
This permits implementations, test doubles, and wrappers without a larger API dependency.

```go
func Parse(r io.Reader) (*Document, error) { ... }
```

Return exported concrete types by default.
Exported functions and methods must never return unexported types, including through
pointers, containers, or iterator elements: callers must be able to name results.
Callers can define interfaces at use sites.

```go
type Client struct {
    ...
}

func NewClient(cfg ClientConfig) *Client {
    return &Client{...}
}
```

Do not return interfaces merely to hide implementation;
adding methods breaks caller implementations, tests, and wrappers.
Do not introduce interfaces when substitution would not improve consumer design or tests.
Prefer concrete dependencies when their API is the relevant contract,
they are cheap to construct or pass, and callers need no behavior replacement.
Common examples include structured loggers, immutable configuration,
standard-library value types, and small stateless collaborators.
Producer-defined interfaces remain useful for multiple implementations,
a single operation, or commonly wrapped abstractions.

Put rich convenience APIs on concrete wrappers around small core interfaces;
do not require implementations to repeat derivable operations.
Include lifecycle methods only for consumers owning that responsibility:
a `Get` consumer need not require `Close`; the lifetime owner can close the concrete store.

## Optional capabilities

Extend established interfaces by detecting a separate capability
with a checked type assertion and retaining a working fallback:

```go
func WriteString(w io.Writer, s string) (int, error) {
	if sw, ok := w.(io.StringWriter); ok {
		return sw.WriteString(s)
	}
	return w.Write([]byte(s))
}
```

Both paths must satisfy the operation's contract.
If the original interface cannot implement the new behavior, make the requirement explicit.
Wrappers can hide methods: check both paths, including wrappers exposing only the
original interface; preserve capabilities explicitly when the wrapper contract requires them.
