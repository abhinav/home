# Filesystem

## Filesystem boundaries

`os.OpenRoot` opens a directory for operations confined to it.
Use its `os.Root` methods for paths supplied from outside the trust boundary;
they reject paths that escape the root through `..` or symbolic links.
String prefix checks on cleaned paths do not provide that guarantee.

```go
root, err := os.OpenRoot(baseDir)
if err != nil {
	return fmt.Errorf("open root %q: %w", baseDir, err)
}
defer root.Close()

file, err := root.Open(name)
if err != nil {
	return fmt.Errorf("open %q: %w", name, err)
}
defer file.Close()
```
