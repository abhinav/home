# Errors and diagnostics

## Program exits

Keep `log.Fatal`, `os.Exit`, and similar hard exits at process entry points:
application `main`, or `TestMain` when it owns the test process's exit status.
Reusable helpers return errors or a status to that entry point.
For helper-process dispatch from `TestMain`,
read [Subprocess tests](subprocess-tests.md).

```go
// BAD: hard exit buried in a helper.
func connect(addr string) net.Conn {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	return conn
}

// GOOD: return the error.
func connect(addr string) (net.Conn, error) {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		return nil, fmt.Errorf("dial %q: %w", addr, err)
	}
	return conn, nil
}
```

## Structured logging

One `slog.Logger` can send records to several handlers:

```go
logger := slog.New(slog.NewMultiHandler(jsonHandler, diagnosticHandler))
```

Each handler retains its own level filtering,
and `WithAttrs` and `WithGroup` propagate to both.
Keep filtering that differs between destinations on the child handlers;
an outer filter can suppress a record wanted by either destination.

## Error handling

### Error contracts

Choose an error representation by how callers can respond:

- Use `errors.New` or `fmt.Errorf` when callers only need to propagate
  or report the failure.
- Use a sentinel such as `var ErrClosed = errors.New("session is closed")`
  when callers need to recognize a condition without additional fields.
  Prefix sentinel names with `Err`.
- Use a structured error when callers need information such as a field name
  or source location to respond.
  Suffix the type name with `Error` and use a pointer receiver for `Error()`.

Match conditions with `errors.Is` and extract error values with `errors.AsType`:

```go
if errors.Is(err, fs.ErrNotExist) {
	// Apply the supported missing-file fallback.
}
if pathErr, ok := errors.AsType[*fs.PathError](err); ok {
	// Use pathErr.Path to identify the affected file.
}
```

These operations traverse wrapped errors;
string matching and direct type assertions do not preserve that behavior.
Use `errors.As` when the supported Go version predates `AsType`,
or when matching an interface that does not implement `error`.
See [errors](https://pkg.go.dev/errors) for matching contracts.

When a custom structured error wraps a cause that callers should match,
provide `Unwrap` as well as `Error`:

```go
func (e *DecodeError) Unwrap() error { return e.Err }
```

Handle only failures for which this caller has a meaningful response;
propagate the others with context.

### Formatting variable values

Use `%q` (not `"%s"`) when interpolating variable strings
into error messages.
`%q` makes empty strings, whitespace,
and special characters visible in the output.

```go
// BAD: empty name produces a confusing message —
//   "open config : no such file"
return fmt.Errorf("open config %s: %w", name, err)

// GOOD: empty name is obvious —
//   "open config \"\": no such file"
return fmt.Errorf("open config %q: %w", name, err)
```

### Wrapping errors

Add context with `fmt.Errorf` and `%w`
instead of bare `return err`.
Context should describe the immediate sub-operation being performed
without "failed to" or "error doing" prefixes.
Do not repeat the surrounding function's responsibility.
Each caller may add its own context,
so repeating outer context creates noisy error chains.

```go
func LoadSettings(path string) (*Settings, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		// GOOD: this return site failed while reading.
		return nil, fmt.Errorf("read %q: %w", path, err)
	}

	var settings Settings
	if err := yaml.Unmarshal(data, &settings); err != nil {
		// GOOD: this return site failed while decoding YAML.
		return nil, fmt.Errorf("unmarshal YAML: %w", err)
	}

	if settings.Name == "" {
		// GOOD: this return site failed while validating one field.
		return nil, errors.New("name is required")
	}

	return &settings, nil
}
```

Avoid wrapping with the current function's name
or broad operation:

```go
// BAD: duplicates LoadSettings' responsibility.
return nil, fmt.Errorf("load settings %q: read: %w", path, err)

// BAD: duplicates LoadSettings' responsibility.
return nil, fmt.Errorf("load settings %q: unmarshal YAML: %w", path, err)
```

For loops,
describe the item-specific child operation,
not the whole loop:

```go
for _, target := range targets {
	if err := build(target); err != nil {
		// GOOD: the failed sub-operation is building this target.
		return fmt.Errorf("build %q: %w", target.Label, err)
	}
}
```

### Error variables

Use `err` for operation errors.
Reuse it for sequential operations,
and shadow it in a narrower scope
when no earlier error must remain available there.

Introduce separately named error variables only when multiple errors
must remain independently readable at the same time.
An error that is immediately combined with `err`
does not require another variable.

```go
responseBody, err := io.ReadAll(res.Body)
err = errors.Join(err, res.Body.Close())
if err != nil {
	return fmt.Errorf("read response: %w", err)
}
```
