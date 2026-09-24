# Subprocess tests

When testing code that invokes external programs through `os/exec`,
the Go test executable can stand in for the external program.
This exercises real process creation, arguments, environment, working directory,
output, and exit status while letting the test choose the child's behavior.
Keep this machinery at the process adapter;
it verifies the adapter against simulated behavior, not the external program itself.

## Select the helper behavior

Get the test executable with `os.Executable`, checking the error.
Use the existing executable or command configuration seam;
avoid expanding a public API solely for this test.
Choose the selector from what the caller can control:

| Available control | Selector |
| --- | --- |
| Child environment | A dedicated variable in `Cmd.Env`. |
| Command arguments after creation | Set `Cmd.Args[0]` to an alternate program name. |
| Executable path, but no environment or command customization | Invoke a symlink to the test executable under an alternate name. |
| Program is found through `PATH` | Put the alternate executable name in a temporary directory on the lookup path. |

### Environment dispatch

Dispatch before running the normal tests:

```go
func TestMain(m *testing.M) {
	if mode := os.Getenv("TEST_HELPER_MODE"); mode != "" {
		os.Exit(runHelper(mode))
	}
	m.Run()
}
```

`runHelper` validates the selected behavior and returns an exit status.
Unknown modes must fail instead of silently succeeding or running the test suite.
Keep helper cleanup inside that function so its defers run before `os.Exit`.
The ordinary branch must call `m.Run`;
returning from `TestMain` after that preserves the test result.

Prefer setting only the child's environment when the command seam supports it:

```go
ctx, cancel := context.WithTimeout(t.Context(), 5*time.Second)
t.Cleanup(cancel)
cmd := exec.CommandContext(ctx, testExe, "inspect")
cmd.Dir = t.TempDir()
cmd.Env = append(cmd.Environ(), "TEST_HELPER_MODE=inspect")
```

Use `cmd.Environ()` after setting `Dir` when inheriting the environment is intended.
A non-nil `Cmd.Env` replaces the inherited environment;
preserve the production environment contract when constructing it.
If only the process environment is configurable, use `t.Setenv`.
Such tests cannot use `t.Parallel` or have a parallel ancestor.

### Executable-name dispatch

When environment selection is unavailable or the program name is the natural selector,
dispatch on `filepath.Base(os.Args[0])` in `TestMain`.
For example, reserve a prefix for test helper names:

```go
func TestMain(m *testing.M) {
	name := filepath.Base(os.Args[0])
	if strings.HasPrefix(name, "test-helper-") {
		os.Exit(runHelper(name))
	}
	m.Run()
}
```

Validate recognized names inside `runHelper`, including failure for unknown names.
Match platform executable suffixes when applicable.
Use one dispatch scheme for a fixture unless it needs both.

If the caller lets the test customize the command, no filesystem alias is needed.
Using a bounded context as above:

```go
cmd := exec.CommandContext(ctx, testExe, "inspect")
cmd.Args[0] = "test-helper-inspect"
```

`Cmd.Path` still selects the executable;
changing `Args[0]` changes the name seen by the child, not what the OS runs.

If only the executable path is configurable,
create a symlink in `t.TempDir()` to the test executable under the alternate name
and invoke the symlink path.
Dispatch from `os.Args[0]`, not from `os.Executable`,
which may resolve to the original executable.
Prefer a symlink to copying the binary where the platform permits it.
Copying is a fallback when symlinks are unavailable;
preserve executable permissions and the platform's executable naming rules.

For a fixed program name resolved through `PATH`,
put that name in a temporary directory and prepend it to the lookup path.
Use `filepath.ListSeparator` when assembling `PATH`.
Go's `exec.Command` resolves a bare program name when creating the command,
so changing `Cmd.Env` later does not change that lookup.
When changing the parent `PATH` with `t.Setenv`, keep the test nonparallel.
This technique does not redirect a fixed absolute executable path.
