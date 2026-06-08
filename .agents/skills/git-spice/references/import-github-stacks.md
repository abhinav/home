# Import GitHub Pull Request Branches And Stacks

Use this reference when the user asks to import an existing GitHub pull request
branch or pull request stack into a local repository
so git-spice can operate on it.

The goal is to recreate local branch heads and git-spice stack topology.
This workflow can also load existing pull request metadata into git-spice.

Fork pull requests are not supported by this workflow.
If a pull request is from a fork,
stop and report that git-spice cannot import it.

Do not use `git-spice branch create` for these branches.
The branch already exists on GitHub.
Raw Git may fetch and materialize the existing branch locally,
then git-spice owns stack tracking and metadata.

## Required Inputs

Identify every pull request that belongs to the import.
For each pull request,
query the GitHub head branch and base branch:

```bash
gh pr view <pr> --json number,url,headRefName,headRefOid,baseRefName,baseRefOid,isCrossRepository,state
```

If `isCrossRepository` is true,
stop because fork pull requests are not supported.

Use the returned `headRefName` as the GitHub branch name.
Use `baseRefName` to determine topology:

- If `baseRefName` is trunk,
  the pull request branch is a stack root based on trunk.
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
git config --get-all remote.origin.fetch
```

If the repository already fetches all branch heads from the relevant remote,
fetch normally:

```bash
git fetch origin
```

If the repository does not fetch the needed branch head,
add a branch-specific refspec for that branch and fetch it:

```bash
git config --add remote.origin.fetch '+refs/heads/<remote-branch>:refs/remotes/origin/<remote-branch>'
git fetch origin
```

After fetching,
verify every required remote-tracking ref:

```bash
git show-ref --verify refs/remotes/<remote>/<remote-branch>
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
git switch -c <local-branch> --track <remote>/<remote-branch>
```

If `git switch --track` cannot create the branch because the remote and local
names differ,
use:

```bash
git switch -c <local-branch> <remote>/<remote-branch>
```

If the local branch already exists,
inspect it before moving it.
Do not overwrite local commits or user work just to make the import easy.
If the branch has no local-only commits and should match the remote head,
fast-forward or reset it only with explicit user approval.
If the local branch exists and does not match the remote-tracking branch,
do not assume git-spice can find the pull request by branch name alone.
This may be a conflicting local branch name.
If the user decides to keep that local branch name for the imported pull
request,
set the local branch's upstream explicitly to the fetched pull request branch:

```bash
git branch --set-upstream-to=<remote>/<remote-branch> <local-branch>
```

Then use a forced dry-run submit when loading pull request metadata.
The explicit upstream tells git-spice which GitHub branch to match:

```bash
git-spice branch submit --dry-run --force --no-prompt --branch <local-branch>
```

## Track Stack Topology

After all local branches exist,
track from each topmost branch in the imported topology:

```bash
git-spice downstack track --no-prompt <topmost-branch>
git-spice ls
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
git-spice branch track --no-prompt --base <base-branch> <branch>
git-spice ls
```

Then rerun downstack tracking from the affected topmost branch.
Prefer explicit `git-spice branch track --base <base> <branch>` for import
ambiguity.
Do not use topology-changing or history-changing commands to coerce import
topology,
including `git-spice branch onto`, `git-spice upstack onto`,
restack commands, rebase commands, or branch split commands.
Import must record the intended topology directly with tracking commands.

All mutating git-spice tracking commands require escalated filesystem
privileges in sandboxed Codex sessions.

## Load Existing Pull Request Metadata

Tracking recreates the local stack shape.
It does not import pull request metadata.
After the stack is tracked,
run a dry-run submit so git-spice can match branch names to open pull
requests and load metadata:

```bash
git-spice stack submit --dry-run --no-prompt
```

If only one branch was imported,
or if you need to load metadata branch by branch,
run:

```bash
git-spice branch submit --dry-run --no-prompt --branch <branch>
```

If the local branch already existed and does not match its upstream pull
request branch,
first set the local branch's upstream to the fetched remote-tracking branch,
then run:

```bash
git branch --set-upstream-to=<remote>/<remote-branch> <branch>
git-spice branch submit --dry-run --force --no-prompt --branch <branch>
```

Do not invent pull request titles or bodies for imported branches.
If the dry-run cannot match a branch to an existing open pull request,
stop and report which branch did not match.

Inspect the final stack with:

```bash
git-spice ls
```

## Common Import Shapes

Single pull request branch:

```bash
gh pr view <pr> --json number,url,headRefName,baseRefName,isCrossRepository,state
git config --get-all remote.origin.fetch
git fetch origin
git show-ref --verify refs/remotes/origin/<remote-branch>
git switch -c <local-branch> --track origin/<remote-branch>
git-spice downstack track --no-prompt <local-branch>
git-spice branch submit --dry-run --no-prompt --branch <local-branch>
git-spice ls
```

Linear stack `A` based on trunk,
`B` based on `A`,
and `C` based on `B`:

```bash
gh pr view <pr-a> --json number,url,headRefName,baseRefName,isCrossRepository,state
gh pr view <pr-b> --json number,url,headRefName,baseRefName,isCrossRepository,state
gh pr view <pr-c> --json number,url,headRefName,baseRefName,isCrossRepository,state
git fetch origin
git switch -c A --track origin/A
git switch -c B --track origin/B
git switch -c C --track origin/C
git-spice downstack track --no-prompt C
git-spice stack submit --dry-run --no-prompt
git-spice ls
```

Two topmost branches `A` and `B` both based on `C`,
where `C` is based on trunk:

```bash
git fetch origin
git switch -c C --track origin/C
git switch -c A --track origin/A
git switch -c B --track origin/B
git-spice downstack track --no-prompt A
git-spice downstack track --no-prompt B
git-spice stack submit --dry-run --no-prompt
git-spice ls
```

Replace `A`, `B`, and `C` with the actual GitHub `headRefName` values.
