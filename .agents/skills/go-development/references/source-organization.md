# Source organization

## Import aliases

Avoid aliases unless Go requires one or the project already uses it for that package.
Do not invent aliases to label directory, layer, transport, owner, or relationship.

```go
// BAD: the alias only labels a package whose natural selector is usable.
import remoteconfig "example.com/project/config"

// GOOD: the imported package name is still usable as the selector.
import "example.com/project/config"
```

The current file's package name does not conflict with an imported selector:

```go
package ledger

// BAD: this file's package name does not require an alias.
import ledgerdb "example.com/project/storage/ledger"

// GOOD: the imported package selector is still usable.
import "example.com/project/storage/ledger"
```

Use aliases only for real naming constraints: two imports with the same name in one file,
a declared name differing from the path, or established conventions such as protobuf aliases.

## Names and scope

Use the shortest clear name at ordinary use sites; add domain or role context
as scope and competing symbols grow.
Unexported package declarations span all package files and can be shadowed by locals.
Give unexported package-level types, functions, variables, and constants enough role context
to distinguish them and leave natural short names for local code.

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

Use the smallest meaningful qualifier, not mechanics such as `global`, `private`, or `internal`.

## Symbol ordering

Go declarations generally allow forward references.
Apply `$code-readability`'s type grouping and reader order.
Request and result records may frame their method inside its receiver's unit.

## File organization

Organize by domain responsibility: keep concepts with their useful behavior,
including constructors, methods, private interfaces, and closely related helpers.
Avoid declaration-kind files collecting all types, services, constants, or commands;
adapter and command packages are not exempt by being near an entry point.
Create shared files only for genuinely package-wide content;
keep dependencies or helpers used by one abstraction with it.
Split into coherent parts, not by a line-count target.
