# Import GitHub pull request branches and stacks

Recreate local heads and git-spice topology for existing GitHub PRs
and load their existing PR metadata.
This exception permits raw fetch configuration, fetching and materializing existing heads,
and upstream settings below, not raw commits, rewrites, pushes, or PR creation.
Do not use `branch create` for branches already existing on GitHub.

## Establish repository and topology

Identify every requested PR and its hosting remote; do not assume `origin`.
Resolve the repository owner and name from that remote URL and confirm it explicitly:

```bash
git remote -v
git remote get-url '<remote>'
gh repo view '<owner/repo>' --json nameWithOwner
gh pr view '<pr>' --repo '<owner/repo>' --json number,url,headRefName,baseRefName,isCrossRepository
```

Query every PR; stop on `isCrossRepository: true` because forks are unsupported.
Use the chosen remote and repository consistently.
Before import mutation, inspect:

```bash
git cat-file -p refs/spice/data:repo
```

Legacy `remote` names both upstream and push remote.
With `remotes`, `upstream` must match the selected remote and `push` the intended destination.
If upstream is absent or different, or push is wrong, stop and ask whether to reinitialize:

```bash
git-spice repo init --no-prompt --trunk '<trunk>' --upstream '<remote>' --remote '<push-remote>'
```

Import does not authorize reinitialization, which can change trunk or remotes.

Use returned `headRefName` for the GitHub branch and `baseRefName` for topology:

- Trunk base: bottom-most branch.
- Another imported head: base on that imported branch.
- Base outside the import: stop and ask whether to import it or use an already-local base.

Import every topologically required branch before tracking.

## Fetch and materialize heads

Inspect fetch coverage:

```bash
git config --get-all 'remote.<remote>.fetch'
```

Request escalation before changing fetch configuration or fetching:
both mutate repository state.
Fetch normally when required heads are covered:

```bash
git fetch '<remote>'
```

For missing heads, add each branch-specific refspec, then fetch:

```bash
git config --add 'remote.<remote>.fetch' '+refs/heads/<remote-branch>:refs/remotes/<remote>/<remote-branch>'
git fetch '<remote>'
```

Verify every required remote ref:

```bash
git show-ref --verify 'refs/remotes/<remote>/<remote-branch>'
```

Preserve GitHub branch names unless the user explicitly requests different local names;
new-branch normalization does not apply.
Request escalation before local creation or upstream changes.
For absent local branches:

```bash
git switch -c '<local-branch>' --track '<remote>/<remote-branch>'
```

Different local and remote names are supported.
If tracked creation fails, stop and diagnose; do not retry without `--track`.
Inspect existing locals before movement; never overwrite local commits or work for convenience.
If there are no local-only commits and the branch should match the remote head,
fast-forward or reset it only with explicit user approval.
Do not assume mismatched local and remote heads match a PR by name.
Verify the fetched-branch upstream whenever names differ.
If the user keeps that local name for the imported PR, set its upstream explicitly:

```bash
git branch --set-upstream-to='<remote>/<remote-branch>' '<local-branch>'
```

For an existing local differing from its upstream PR branch, use that explicit upstream
and the forced dry run when loading metadata:

```bash
git-spice branch submit --dry-run --force --no-prompt --branch '<local-branch>'
```

## Track, then load metadata

Once all locals exist, track from each imported topmost branch:

```bash
git-spice downstack track --no-prompt '<topmost-branch>'
git-spice ls --no-prompt
```

Topmost means no other imported branch uses it as `baseRefName`.
Track every topmost branch independently; if `A` and `B` share base `C`, track from both.
If base inference fails, use GitHub metadata to track explicitly,
then rerun downstack tracking from the affected top:

```bash
git-spice branch track --no-prompt --base '<base-branch>' '<branch>'
git-spice ls --no-prompt
```

Record topology through tracking, not `onto`, restack, rebase, or split to coerce history.
Tracking, dry-run submit, and `ls` mutate metadata and require escalation
in sandboxed Codex sessions.

Tracking alone does not import PR metadata.
Afterward, load every branch explicitly, not one stack submission across siblings:

```bash
git-spice branch submit --dry-run --no-prompt --branch '<branch>'
```

Use the explicit upstream and forced dry-run procedure above
for existing mismatched local branches.
Do not invent titles or bodies; if an existing open PR cannot be matched,
stop and identify the unmatched branch.
Finish with `git-spice ls --no-prompt`.
