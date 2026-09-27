# Filesystem and native representations

## Preserve native representation

Keep filesystem paths as `Path`/`PathBuf`,
OS names and arguments as `OsStr`/`OsString`, and arbitrary content as bytes.
Require Unicode only when the receiving contract requires text:

```rust
/// Reads the input without imposing a text encoding on its name or contents.
fn read_input(path: &std::path::Path) -> std::io::Result<Vec<u8>> {
    std::fs::read(path)
}
```

Reserve lossy conversion for display;
it must not become an operational path, identity key, or persisted round trip.
`OsStr::to_str` can reject a native name,
while `to_string_lossy` can replace characters.

## Match path access to the required authority

At a trust boundary, distinguish a filename, a relative path,
and an unrestricted path before choosing validation.
`root.join(input)` does not confine access to `root`.
Checking only `!input.is_absolute()` also admits platform-specific rooted
or prefixed forms that may violate a child-path contract.

Validate the permitted syntax,
then use filesystem operations whose resolution and access guarantees satisfy
any required confinement despite untrusted filesystem changes.
A lexical prefix check, a canonicalized pathname,
or a directory handle by itself does not establish those guarantees.
A later lookup can resolve a different object after a check.
Prefer operations that enforce the needed boundary during access,
and retain open handles when subsequent operations must target the same object.

Use canonicalization when resolved names are required;
do not require it for ordinary creation or treat it as a durable authorization.
Resolve the platform and library guarantees when confinement matters,
without imposing a sandbox abstraction on ordinary trusted paths.
