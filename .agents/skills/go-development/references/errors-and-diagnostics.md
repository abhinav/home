# Errors and diagnostics

## Program exits

Keep hard exits (`log.Fatal`, `os.Exit`, etc.) at application `main`,
or at `TestMain` when it owns the test process's exit status.
Reusable helpers return errors or a status.
For helper dispatch, read [Subprocess tests](subprocess-tests.md).

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

Construct the logger at the entry point and pass it to code that logs.
Use the explicit logger for startup and exit diagnostics too.
Package-level `log` and `slog` logging calls use a shared process logger.
For multiline calls, put each key and value on one line and close on its own line.

```go
logger.ErrorContext(ctx, "refresh account",
    "account", accountID,
    "error", err,
)
```

## Metrics

Bind instruments when the registry and labels become stable and retain the handles
for that lifetime.
Record outcomes at the operation that owns their meaning and reporting.
Keep telemetry-only counts out of operation results.
When an executable owns export and shutdown, flush before exit and handle
any returned flush error according to its effect on the command contract.

One `slog.Logger` can send records to several handlers:

```go
logger := slog.New(slog.NewMultiHandler(jsonHandler, diagnosticHandler))
```

Each handler keeps its level filter; `WithAttrs` and `WithGroup` propagate to both.
Keep destination-specific filtering on child handlers:
an outer filter can suppress records either destination wants.

## Error handling

### Error contracts

Choose by caller response:

- `errors.New` or `fmt.Errorf` for propagation or reporting only.
- A sentinel such as `var ErrClosed = errors.New("session is closed")`
  for recognizable conditions without fields; prefix names with `Err`.
- Structured errors for actionable fields or locations; suffix types with `Error`
  and use pointer receivers for `Error()`.

Match through wrappers with `errors.Is` and `errors.AsType`:

```go
if errors.Is(err, fs.ErrNotExist) {
	// Apply the supported missing-file fallback.
}
if pathErr, ok := errors.AsType[*fs.PathError](err); ok {
	// Use pathErr.Path to identify the affected file.
}
```

String matching and direct type assertions do not preserve wrapped matching.
Use `errors.As` for Go versions predating `AsType`, or matching interfaces not implementing `error`.
See [errors](https://pkg.go.dev/errors).
Provide `Unwrap` alongside `Error` when callers should match a wrapped cause:

```go
func (e *DecodeError) Unwrap() error { return e.Err }
```

Handle only failures with a meaningful response; propagate others with context.
Keep returned errors bounded as the amount of input or work grows.
If you log an individual failure, return only a distinct summary or status
the caller needs.
Use structured results when callers need to act on individual outcomes.

### Formatting variable values

Use `%q` for variable strings that are safe to include in the error
so empty strings, whitespace, and special characters remain visible.

```go
// BAD: empty name produces a confusing message —
//   "open config : no such file"
return fmt.Errorf("open config %s: %w", name, err)

// GOOD: empty name is obvious —
//   "open config \"\": no such file"
return fmt.Errorf("open config %q: %w", name, err)
```

### Wrapping errors

Add context through `fmt.Errorf` and `%w` instead of bare `return err`.
Describe the immediate sub-operation without "failed to" or "error doing" prefixes
or repeating the current function's responsibility.
Start error text with a lowercase word.
Put capitalized provider names after the operation when they are needed.
Callers may add context; repeating it creates noisy chains.

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

Avoid the current function name or broad operation:

```go
// BAD: duplicates LoadSettings' responsibility.
return nil, fmt.Errorf("load settings %q: read: %w", path, err)

// BAD: duplicates LoadSettings' responsibility.
return nil, fmt.Errorf("load settings %q: unmarshal YAML: %w", path, err)
```

In loops describe the item-specific child operation, not the whole loop:

```go
for _, target := range targets {
	if err := build(target); err != nil {
		// GOOD: the failed sub-operation is building this target.
		return fmt.Errorf("build %q: %w", target.Label, err)
	}
}
```

### Cleanup on error

When an operation owns a change or resource that must be undone on failure,
register cleanup when that obligation starts.
Use a named `retErr` result if a defer needs to observe the returned error.
Leave cleanup that runs on success and failure unconditional.
Preserve the original error if cleanup also fails.
Use `errors.Join` when callers need both causes.

Illustrative cleanup after two successful setup steps.

```go
func install() (retErr error) {
    dir, err := stageFiles()
    if err != nil { return err }
    defer func() {
        if retErr != nil { retErr = errors.Join(retErr, removeStage(dir)) }
    }()

    slot, err := reserveSlot()
    if err != nil { return err }
    defer func() {
        if retErr != nil { retErr = errors.Join(retErr, releaseSlot(slot)) }
    }()

    return activate(dir, slot)
}
```

Each defer is registered after its own acquisition.
If activation fails, both cleanups run in reverse order.

### Error variables

Use `err`, reusing it sequentially or shadowing narrowly
when no earlier error must remain available.
Name errors separately only when multiple errors must remain independently readable together;
immediate combination with `err` needs no extra variable.

```go
responseBody, err := io.ReadAll(res.Body)
err = errors.Join(err, res.Body.Close())
if err != nil {
	return fmt.Errorf("read response: %w", err)
}
```
