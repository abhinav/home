# Modules and dependencies

Use Go commands, not hand edits, to change `go.mod`:

| Change | Command and effect |
| --- | --- |
| Module path or replacement | `go mod edit -module=PATH` or `go mod edit -replace=OLD=NEW`; edits directives without resolving the graph. |
| Select a module version | `go get MODULE@VERSION`, accounting for other modules' constraints. |
| Change Go version | `go get go@VERSION`, accounting for other modules' constraints. |

After import or directive changes, run `go mod tidy`; let it remove unneeded requirements.
Use `go get MODULE@none` only for deliberate removal: it can change other selected versions.
Review `go.mod` and `go.sum`, then run relevant tests.

To inspect dependency source or answer questions about it,
run `go mod download -json MODULE` and read files at the returned `Dir`.

Declare command dependencies with a `tool` directive rather than blank-import `tools.go`:
add with `go get -tool PACKAGE@VERSION`, run with `go tool NAME`,
and use the full package path when the short name is ambiguous.
The module's `require` directive records the version.
See [Go tool dependencies](https://go.dev/doc/modules/managing-dependencies#tools)
for syntax and command behavior.
