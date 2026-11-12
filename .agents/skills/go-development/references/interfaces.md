# Interfaces

## Interface compliance checks

Add compile-time assertions where both names are already available, typically
with the consumer or at composition.
Go satisfaction is implicit.
Keep a provider independent of a consumer when it would otherwise import that
consumer solely to implement or assert an interface:

```go
var _ InterfaceName = (*TypeName)(nil)
```

## Accept interfaces, return structs

Accept interfaces for behavior supplied by the caller and return concrete structs.
Choose the input from the operations the consumer needs, including operations
required by functions it passes the input to.
If those functions already accept interfaces, reuse them.
Embed their interfaces when one input must satisfy several of those contracts.
The caller can still pass a concrete implementation.

Illustrative constructor forwarding to helpers that accept `io.ReaderAt`
and `io.WriterAt`.

```go
type ArchiveBacking interface {
    io.ReaderAt
    io.WriterAt
}

func NewArchive(backing ArchiveBacking) *Archive {
    return &Archive{reader: newReader(backing), writer: newWriter(backing)}
}
```

Define a new interface near the consumer when existing interfaces include
unrelated operations or express a different contract.
Its signatures can use types from their established owners.
Avoid mirroring an entire provider API.

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
Use concrete inputs for values such as immutable configuration or durations
and for collaborators whose concrete API is the contract, such as a structured
logger.
Requiring a concrete service client needs a reason tied to the consumer's
operation, such as a concrete-only guarantee or resource ownership.
One implementation at the composition site is insufficient reason.
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
