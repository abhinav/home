# Import GitHub Pull Request Branches And Stacks

Use this reference when the user asks to import an existing GitHub pull request
branch or pull request stack into a local repository
so git-spice can operate on it.

The goal is to recreate local branch heads and git-spice stack topology.
This workflow can also load existing pull request metadata into git-spice.

This workflow is an explicit exception to the normal raw-Git boundary.
It permits raw Git to update fetch configuration, fetch and materialize
existing remote branches, and set upstreams as described below.
The exception does not permit raw commits or history rewrites.
It also does not permit pushes or pull request creation.

Do not use `git-spice branch create` for these branches.
The branch already exists on GitHub.
Raw Git may fetch and materialize the existing branch locally,
then git-spice owns stack tracking and metadata.

## Required Inputs

Identify every pull request that belongs to the import.
Identify the Git remote that hosts those pull requests.
Do not assume the remote is named `origin`:

```bash
git remote -v
git remote get-url '<remote>'
gh repo view '<owner/repo>' --json nameWithOwner
```

Resolve `<owner/repo>` from the selected remote URL and confirm it with the
explicit `gh repo view` argument.
Use `<remote>` and `<owner/repo>` consistently in the commands below.
For each pull request, query the GitHub head branch and base branch:

```bash
gh pr view '<pr>' --repo '<owner/repo>' --json number,url,headRefName,baseRefName,isCrossRepository
```

If `isCrossRepository` is true,
stop because fork pull requests are not supported.

Inspect the git-spice repository configuration before mutating import state:

```bash
git cat-file -p refs/spice/data:repo
```

The legacy `remote` field names both the upstream and push remote.
When the `remotes` object is present, its `upstream` field must match
`<remote>` and its `push` field must name the intended push remote.
Stop and ask whether to reinitialize git-spice when the selected upstream is
absent or different.
Do the same when the push remote is not the intended push destination:

```bash
git-spice repo init --no-prompt --trunk '<trunk>' --upstream '<remote>' --remote '<push-remote>'
```

Reinitialization mutates repository metadata and may change the configured
trunk or remotes, so do not infer authorization from the import request.

Use the returned `headRefName` as the GitHub branch name.
Use `baseRefName` to determine topology:

- If `baseRefName` is trunk,
  the pull request branch is the bottom-most branch in a stack based on trunk.
- If `baseRefName` is another imported pull request's `headRefName`,
  that pull request branch is based on the matching imported branch.
- If `baseRefName` names a branch outside the requested import,
  stop and ask whether that branch should also be imported or used as an
  already-local base.

Import every branch whose topology is needed before tracking the stack.

## Remote Tracking Refs

Before creating local branches,
verify that the repository can fetch the needed GitHub branch heads.

Inspect the existing fetch refspecs:

```bash
git config --get-all 'remote.<remote>.fetch'
```

Request escalated filesystem privileges before changing fetch configuration
or fetching.
`git config --add` writes repository configuration.
`git fetch` uses the network and updates refs.

If the repository already fetches all branch heads from the relevant remote,
fetch normally:

```bash
git fetch '<remote>'
```

If the repository does not fetch the needed branch head,
add a branch-specific refspec for that branch and fetch it:

```bash
git config --add 'remote.<remote>.fetch' '+refs/heads/<remote-branch>:refs/remotes/<remote>/<remote-branch>'
git fetch '<remote>'
```

After fetching,
verify every required remote-tracking ref:

```bash
git show-ref --verify 'refs/remotes/<remote>/<remote-branch>'
```

## Local Branches

Create or update the local branch corresponding to each imported head branch.
Use the exact branch name from GitHub unless the user explicitly asks for a
different local name.
The normal git-spice branch-name normalization rule for new branches does not
apply to imported existing branches.

If the local branch does not exist,
create it from the fetched remote-tracking ref:

```bash
git switch -c '<local-branch>' --track '<remote>/<remote-branch>'
```

`git switch --track` supports different local and remote branch names.
If tracked creation fails, stop and diagnose it;
do not retry without `--track` and silently discard the upstream relationship.

Request escalated filesystem privileges before creating a local branch or
changing its upstream.

If the local branch already exists,
inspect it before moving it.
Do not overwrite local commits or user work just to make the import easy.
If the branch has no local-only commits and should match the remote head,
fast-forward or reset it only with explicit user approval.
If the local branch exists and does not match the remote-tracking branch,
do not assume git-spice can find the pull request by branch name alone.
This may be a conflicting local branch name.
Verify that the local branch tracks the fetched pull request branch whenever
the local and remote names differ.
If the user decides to keep that local branch name for the imported pull
request,
set the local branch's upstream explicitly to the fetched pull request branch:

```bash
git branch --set-upstream-to='<remote>/<remote-branch>' '<local-branch>'
```

Then use a forced dry-run submit when loading pull request metadata.
The explicit upstream tells git-spice which GitHub branch to match:

```bash
git-spice branch submit --dry-run --force --no-prompt --branch '<local-branch>'
```

## Track Stack Topology

After all local branches exist,
track from each topmost branch in the imported topology:

```bash
git-spice downstack track --no-prompt '<topmost-branch>'
git-spice ls --no-prompt
```

A topmost branch is an imported branch that no other imported branch uses as
its `baseRefName`.
If the imported shape has multiple independent topmost branches,
run `git-spice downstack track --no-prompt <topmost-branch>`
once for each topmost branch.

For example,
if branches `A` and `B` are both based on `C`,
and `C` is based on trunk,
run downstack tracking once from `A` and once from `B`.

If `git-spice downstack track` cannot infer a base,
track the ambiguous branch explicitly using the GitHub base metadata:

```bash
git-spice branch track --no-prompt --base '<base-branch>' '<branch>'
git-spice ls --no-prompt
```

Then rerun downstack tracking from the affected topmost branch.
Prefer explicit `git-spice branch track --base <base> <branch>` for import
ambiguity.
Do not use topology-changing or history-changing commands to coerce import
topology,
including `git-spice branch onto`, `git-spice upstack onto`,
restack commands, rebase commands, or branch split commands.
Import must record the intended topology directly with tracking commands.

Tracking, dry-run submission, and `git-spice ls` can all update git-spice
metadata.
Request escalated filesystem privileges before these commands in sandboxed
Codex sessions.

## Load Existing Pull Request Metadata

Tracking recreates the local stack shape.
It does not import pull request metadata.
After topology is tracked, load metadata for every imported branch explicitly:

```bash
git-spice branch submit --dry-run --no-prompt --branch '<branch>'
```

Repeat that command for each imported branch.
Do not rely on one stack submission when the imported topology has sibling
topmost branches.

If the local branch already existed and does not match its upstream pull
request branch,
follow the upstream and forced-dry-run procedure in
[Local Branches](#local-branches).

Do not invent pull request titles or bodies for imported branches.
If the dry-run cannot match a branch to an existing open pull request,
stop and report which branch did not match.

Inspect the final stack with:

```bash
git-spice ls --no-prompt
```
