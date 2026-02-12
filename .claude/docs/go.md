# Go

## Viewing dependency source

To see source files from a Go dependency,
or to answer questions about a dependency,
run `go mod download -json MODULE`
and use the returned `Dir` path to read the files.
