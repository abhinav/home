# git-spice internals

Inspect internal metadata only to debug that metadata, not during ordinary
branch, stack, or PR workflows.
[GitHub import](import-github-stacks.md) separately permits a read-only repo-remote check.
Branch metadata lives under `refs/spice/data`:

```bash
git cat-file -p 'refs/spice/data:branches/<branch>'
```

This is read-only diagnostics; never edit `refs/spice/data` directly.
