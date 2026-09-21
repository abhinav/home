# Errors and diagnostics

## Program exits

Never call `log.Fatal`, `os.Exit`,
or similar hard-exit functions outside `main()`.
Return errors and let the caller decide.

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
