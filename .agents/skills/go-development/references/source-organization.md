# Source organization

## Import aliases

Avoid import aliases unless Go requires them
or the local project already uses an alias for that package.
Do not invent an alias merely to describe the package's directory,
layer,
transport,
owner,
or relationship to the current package.

```go
// BAD: the alias only labels a package whose natural selector is usable.
import remoteconfig "example.com/project/config"

// GOOD: the imported package name is still usable as the selector.
import "example.com/project/config"
```

The current file's package name is also not a conflict
with an imported package selector.

```go
package ledger

// BAD: this file's package name does not require an alias.
import ledgerdb "example.com/project/storage/ledger"

// GOOD: the imported package selector is still usable.
import "example.com/project/storage/ledger"
```

Use an alias only for a real naming constraint:
two imported packages with the same package name in one file,
an imported package whose declared name differs from its path,
or an established local convention such as generated protobuf packages.

## Names and scope

Use the shortest name that remains clear at its ordinary use sites.
As a declaration's scope and the number of competing symbols grow,
add domain or role context to distinguish it.

Unexported package-level declarations are visible across every file
in the package and can be shadowed by local declarations.
Give unexported package-level types, functions, variables, and constants
enough context to distinguish their package-wide roles
and leave natural short names available to local code.

```go
// BAD: generic names occupy the package block.
type state struct{ /* ... */ }
type result struct{ /* ... */ }
type app struct{ /* ... */ }
var failures metric.Counter

// GOOD: each name identifies its package-wide role.
type manifestParseState struct{ /* ... */ }
type resourceComparison struct{ /* ... */ }
type reconcileApplication struct{ /* ... */ }
var applyFailureCounter metric.Counter
```

Use the smallest meaningful qualifier.
Do not lengthen names with declaration mechanics
such as `global`, `private`, or `internal`.

## Symbol ordering

Go package declarations can generally refer to declarations
that appear later in the package.
A type named by a function, method, or interface
is therefore not a source-order prerequisite.
Apply the reader-order rule in `$code-readability`.
Place an interface before the request and result types used by its methods.
Place request and result types immediately before a function or method
when its body would otherwise force the reader
to scroll past the implementation to reach those records.
When the implementation and records remain visible together,
place the function or method first
and the request and result types after it in first-need order.

Keep declarations for one cohesive type or operation together.
When a type is the primary abstraction, keep its declarations in one cluster:
the type declaration, its constructors, then its methods.
Order constructors and methods for readability within their part of the cluster.
Request and result types may appear immediately before the method they frame
inside that receiver's cluster.
Methods on one receiver share its state and invariants.
Keeping those methods together lets the reader retain that mental model.
Do not interleave methods from different receiver types
unless the reader's task genuinely treats those types as one operation
and separate clusters would make that operation harder to understand.

## File organization

Organize files within a package by domain responsibility,
not by declaration kind.
A file should contain a concept and the behavior that makes the concept useful.
Keep a type near its constructors,
methods,
private interfaces,
and closely related helpers.

Avoid package layouts that collect every type,
service,
constant,
or command implementation into a declaration-kind file.
Such files separate concepts from their behavior
and make readers reconstruct relationships across the package.
Apply the same rule to adapter and command packages;
they are not exempt because their code sits near an entry point.

Create a shared file only when its contents are genuinely package-wide.
Dependencies or helpers used by one abstraction belong with that abstraction.
When splitting a file,
choose boundaries that let each resulting file explain a coherent part of the
package rather than targeting a particular line count.
