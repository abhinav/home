# JSON

## JSON

Use `encoding/json/v2` for new JSON code.
Its `Marshal` and `Unmarshal` functions accept options,
and `MarshalWrite` and `UnmarshalRead` work directly with writers and readers.
The v2 defaults reject duplicate object names and invalid UTF-8.
They also encode nil maps and slices as empty objects and arrays,
so preserve an existing wire contract deliberately when changing established code.

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

For a field whose zero value should be absent from JSON,
use `omitzero` instead of a custom marshaler or `omitempty`.
Unlike `omitempty`, it omits a zero `time.Time`:

```go
type Event struct {
	At time.Time `json:"at,omitzero"`
}
```

See [JSON v2](https://pkg.go.dev/encoding/json/v2)
for options and representation details.
