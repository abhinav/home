# Git-Spice Internals

Use this reference only when debugging git-spice metadata itself.
Do not use internal metadata inspection as part of ordinary branch,
stack,
pull request,
or import workflows.

Git-spice stores branch metadata under `refs/spice/data`.
To inspect one branch's stored metadata:

```bash
git cat-file -p refs/spice/data:branches/<branch>
```

Treat this as a read-only diagnostic surface.
Do not edit `refs/spice/data` directly.
