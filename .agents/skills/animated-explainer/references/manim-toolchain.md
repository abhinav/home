# Manim toolchain

Use current local CLI help and Manim Community documentation for available flags;
do not copy version-sensitive commands from older animation projects.

## Select the environment

Check for the workspace's configured Manim:

```sh
mise exec -- manim --version
```

If it succeeds, prefix every Manim command with `mise exec --` to use that version.
When Manim is not configured, prefer a one-off environment without project or
global configuration changes:

```sh
mise x conda:manim@latest -- manim --version
mise x conda:manim@latest -- manim -qm scene.py SceneName
```

The conda backend supplies Manim and native rendering dependencies in isolation.
Use `mise use conda:manim@<version>` only for a requested durable, pinned project
environment; keep its `mise.toml` with the source.

If acquisition fails on a native library or executable, report the missing dependency.
Do not switch to global Python or install system packages without authority to
change that environment.

## Render

Use medium quality for the representative scene during iteration:

```sh
mise exec -- manim -qm scene.py SceneName
```

For one-off acquisition, retain the `mise x conda:manim@latest --` prefix.
Select final resolution and frame rate from the installed CLI help;
quality presets can vary by version.
MP4 is the default.
Use another supported format only when delivery requires it.
When the installed CLI supports GIF, use `--format=gif`.
