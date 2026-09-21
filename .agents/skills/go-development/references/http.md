# HTTP

## HTTP routing

`http.ServeMux` accepts method and path-wildcard patterns.
Read a matched segment with `r.PathValue`:

```go
mux.HandleFunc("GET /items/{id}", func(w http.ResponseWriter, r *http.Request) {
	serveItem(w, r, r.PathValue("id"))
})
```
