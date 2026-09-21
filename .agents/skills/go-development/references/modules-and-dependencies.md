# Modules and dependencies

## Module files

Use Go commands to update `go.mod` rather than editing its text by hand.
For directive changes such as a module path or replacement,
use `go mod edit -module=PATH` or `go mod edit -replace=OLD=NEW`.
It changes the file without resolving the module graph.
Use `go get MODULE@VERSION` when selecting a module version,
and `go get go@VERSION` when changing the Go version;
these commands account for constraints from other modules.

After changing imports or module directives,
run `go mod tidy` to reconcile requirements and checksums
with the packages in the module.
Let tidy remove requirements that are no longer needed.
Use `go get MODULE@none` only when deliberately removing a module;
it can also change the versions selected for other modules.
Review the resulting `go.mod` and `go.sum` changes,
then run the relevant tests.

## Viewing dependency source

To see source files from a Go dependency,
or to answer questions about a dependency,
run `go mod download -json MODULE`
and use the returned `Dir` path to read the files.

## Tool dependencies

Declare Go command dependencies with a `tool` directive in `go.mod`.
This keeps generators and linters in the module graph
without a blank-import `tools.go` file.
Use `go get -tool PACKAGE@VERSION` to add one,
then run it with `go tool NAME`.
Use the full package path if the short name is ambiguous.
The module's `require` directive records the selected version.

See [Go tool dependencies](https://go.dev/doc/modules/managing-dependencies#tools)
for the module syntax and command behavior.
