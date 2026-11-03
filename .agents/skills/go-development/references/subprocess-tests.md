# Subprocess tests

The Go test executable can stand in for external programs invoked through `os/exec`.
Keep this at the process adapter: it tests real process creation, arguments,
environment, working directory, output, and exit status against simulated behavior,
not the external program itself.

## Select helper behavior

Use `os.Executable`, checking its error, and an existing executable or command seam;
avoid expanding a public API solely for this test.
Choose by caller control:

| Available control | Selector |
| --- | --- |
| Child environment | Dedicated variable in `Cmd.Env`. |
| Command arguments after creation | Alternate name in `Cmd.Args[0]`. |
| Executable path only | Symlink to test binary under an alternate name. |
| Bare program found through `PATH` | Temporary directory containing that program name on the lookup path. |

### Environment dispatch

Dispatch before normal tests:

```go
func TestMain(m *testing.M) {
	if mode := os.Getenv("TEST_HELPER_MODE"); mode != "" {
		os.Exit(runHelper(mode))
	}
	m.Run()
}
```

`runHelper` validates modes and returns status; unknown modes must fail,
not silently succeed or run the suite.
Keep cleanup inside `runHelper` so its defers run before `os.Exit`.
Normal execution calls `m.Run`; returning afterward preserves its result.
Prefer setting only the child's environment when the command seam supports it:

```go
ctx, cancel := context.WithTimeout(t.Context(), 5*time.Second)
t.Cleanup(cancel)
cmd := exec.CommandContext(ctx, testExe, "inspect")
cmd.Dir = t.TempDir()
cmd.Env = append(cmd.Environ(), "TEST_HELPER_MODE=inspect")
```

For inheritance, use `cmd.Environ()` after setting `Dir`.
Non-nil `Cmd.Env` replaces inherited environment; preserve the production contract.
If only process environment is configurable, use `t.Setenv`;
neither that test nor its ancestors may be parallel.

### Executable-name dispatch

When environment selection is unavailable or the name is the natural selector,
use `filepath.Base(os.Args[0])` in `TestMain`; for example, reserve helper-name prefixes:

```go
func TestMain(m *testing.M) {
	name := filepath.Base(os.Args[0])
	if strings.HasPrefix(name, "test-helper-") {
		os.Exit(runHelper(name))
	}
	m.Run()
}
```

Validate names in `runHelper`, rejecting unknown ones; match platform executable suffixes.
Use one dispatch scheme unless the fixture needs both.
With command customization, no filesystem alias is needed.
Using the bounded context above:

```go
cmd := exec.CommandContext(ctx, testExe, "inspect")
cmd.Args[0] = "test-helper-inspect"
```

`Cmd.Path` selects the OS executable; `Args[0]` changes only the child's observed name.
For executable-path-only seams, prefer a `t.TempDir()` symlink to the test binary
under the alternate name and invoke that path.
Dispatch from `os.Args[0]`, not `os.Executable`, which may resolve the original path.
Copy only when symlinks are unavailable, preserving executable permissions and platform naming.

For fixed bare names, place that name in a temporary directory and prepend its directory to `PATH`
using `filepath.ListSeparator`.
Set lookup environment before `exec.Command`, which resolves the name at construction;
changing `Cmd.Env` later does not change lookup.
Keep parent-`PATH` tests using `t.Setenv` nonparallel.
This cannot redirect a fixed absolute executable path.
