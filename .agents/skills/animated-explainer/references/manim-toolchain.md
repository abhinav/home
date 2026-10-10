# Manim toolchain

Use the current local CLI help and Manim Community documentation as the
authority for available flags.
Do not copy version-sensitive commands from an older animation project.

## Select the mise environment

First check whether the current workspace already declares Manim through
`mise`:

```sh
mise exec -- manim --version
```

When that succeeds, run every Manim command through `mise exec --` so the
workspace selects the configured version.

When Manim is not configured, prefer a one-off `mise` environment that does not
write project or global configuration:

```sh
mise x conda:manim@latest -- manim --version
mise x conda:manim@latest -- manim -qm scene.py SceneName
```

The `conda` backend supplies Manim and its native rendering dependencies in an
isolated environment.
Use `mise use conda:manim@<version>` only when the requested work includes a
durable, pinned project environment; retain the resulting `mise.toml` with the
animation source.

If acquisition fails because a native library or system executable is missing,
report the exact missing dependency.
Do not substitute a global Python installation or add system packages without
the authority to change that environment.

## Render

Render a representative scene at medium quality during iteration:

```sh
mise exec -- manim -qm scene.py SceneName
```

For a one-off environment, retain the `mise x conda:manim@latest --` prefix.
Use the installed CLI help to select final resolution and frame rate rather than
assuming what a quality preset means in another Manim version.

Manim writes MP4 by default.
Use another supported format only when the requested delivery requires it; for
example, current Manim releases accept `--format=gif` for GIF output.

## Inspect

Show the rendered animation in Codex and watch it from beginning to end.
Inspect the states before, during, and after each important transition at the
delivered size.
Check that the text fits, the visual identities remain stable, and the final
state stays visible long enough to understand.
