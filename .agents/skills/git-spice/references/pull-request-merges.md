# Pull request merges

Translate the user's requested pull requests or stacks
into one or more operation groups.
An operation group contains selectors that use the same merge operation
and the same expansion semantics.
Run one Git Spice invocation per operation group.

First map pull request identifiers to tracked local branches and inspect the
stack topology:

```bash
git-spice ls --all --json --no-prompt
```

Use these terms consistently:

- A **selector** is a branch supplied through `--branch`.
- The **effective merge set** is every branch selected
  after the operation expands its selectors through the tracked topology.

Choose the operation from the user's outcome and the observed topology:

| Requested outcome | Command selection |
| --- | --- |
| Merge named pull requests by explicitly listing a dependency-complete branch set | Use `git-spice branch merge`; every branch in the effective merge set is a selector. |
| Merge one or more named stacked heads and expand their tracked dependencies | Use `git-spice downstack merge`; the named downstack heads are selectors. |
| Merge one or more named branches' downstack paths and upstack subtrees | Use `git-spice stack merge`; the named stack anchors are selectors. |

Interpret each `--branch` selector according to the chosen operation:

| Operation | Effective merge set represented by each selector |
| --- | --- |
| `branch merge` | That branch alone. The combined selectors must contain each selected branch's complete non-trunk path to trunk; selector order is immaterial. |
| `downstack merge` | That branch as a head plus every branch below it to trunk. Multiple selectors combine dependency paths. |
| `stack merge` | That branch's path down to trunk plus the upstack subtree rooted at that branch. Multiple selectors combine those stacks. |

For a request to merge one named stacked pull request,
use the named branch as a `downstack merge` head selector.
That selector expands to the complete tracked path to trunk,
which is the effective merge set.
If the user explicitly excludes a required tracked base,
stop and explain that the requested pull request cannot merge first.
For a request naming multiple pull requests,
form operation groups from selectors with the same expansion semantics.
Put every selector in one operation group
into the same invocation with repeated `--branch` arguments.
Do not split an operation group into separate merge commands
for per-branch progress reporting or failure isolation.
Do not combine selectors with different requested expansion semantics
when doing so would change either effective merge set.
Upstack branches and independent siblings remain outside the effective merge
set unless the selected operation includes them.

By default,
invoke Git Spice for the requested operation groups
after mapping the pull requests and inspecting topology.
Git Spice applies the configured readiness policy.
When the user asks to identify what is mergeable,
query current forge readiness and form each candidate's dependency-complete
path.
Select only paths whose required branches are all affirmatively ready;
exclude any path containing a blocked or unknown branch.

Pass every operation-specific selector explicitly
rather than relying on the checked-out branch:

```bash
git-spice branch merge --branch '<branch-a>' --branch '<branch-b>' --no-prompt
git-spice downstack merge --branch '<head-a>' --branch '<head-b>' --no-prompt
git-spice stack merge --branch '<anchor-a>' --branch '<anchor-b>' --no-prompt
```

Before mutation,
report each operation group and its effective merge set.
