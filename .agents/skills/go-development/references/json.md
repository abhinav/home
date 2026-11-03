# JSON

Use `encoding/json/v2` for new JSON code.
`Marshal` and `Unmarshal` accept options; `MarshalWrite` and `UnmarshalRead`
work directly with writers and readers.
Defaults reject duplicate names and invalid UTF-8, encode nil maps as empty objects,
and encode nil slices as empty arrays.
Deliberately preserve established wire contracts when changing code.

```go
import "encoding/json/v2"

data, err := json.Marshal(record)
if err != nil {
	return fmt.Errorf("marshal record: %w", err)
}
if err := json.Unmarshal(data, &decoded); err != nil {
	return fmt.Errorf("unmarshal record: %w", err)
}
```

When zero-valued fields should be absent, use `omitzero` rather than a custom
marshaler or `omitempty`; it also omits zero `time.Time` values:

```go
type Event struct {
	At time.Time `json:"at,omitzero"`
}
```

See [JSON v2](https://pkg.go.dev/encoding/json/v2) for options and representations.
