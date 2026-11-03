# Pull request merges

Map requested PRs to tracked local branches and inspect topology:

```bash
git-spice ls --all --json --no-prompt
```

A selector is a branch supplied through `--branch`.
The effective merge set contains all branches reached by the operation's selector expansion.
Group selectors using the same operation and expansion semantics;
run one invocation per operation group.

| Requested outcome | Operation | Expansion |
| --- | --- | --- |
| Explicit dependency-complete set of named PRs | `branch merge` | Each selector alone; combined selectors must include every selected branch's full non-trunk path to trunk. Selector order is immaterial. |
| Named stacked heads with tracked dependencies | `downstack merge` | Each head plus every branch below it to trunk; multiple heads combine paths. |
| Named anchors' downstack paths and upstack subtrees | `stack merge` | Each anchor's path to trunk plus its rooted upstack subtree; multiple anchors combine stacks. |

For one named stacked PR, use its branch as a `downstack merge` head,
including the full tracked dependency path.
Stop and explain if the user explicitly excludes a required tracked base:
the requested PR cannot merge first.
For multiple PRs, group selectors by their requested expansion semantics.
Put all selectors in a group in one command with repeated `--branch`;
do not split groups for progress reporting or failure isolation.
Do not combine different expansion semantics if doing so changes either merge set.
Independent siblings and upstack remain excluded unless the operation includes them.

By default, invoke the requested groups after mapping and topology inspection;
git-spice applies configured readiness policy.
If asked to identify what is mergeable, query current forge readiness and form
candidate dependency-complete paths.
Choose only paths whose every required branch is affirmatively ready;
exclude blocked or unknown paths.

Use explicit selectors, never an implicit checked-out branch:

```bash
git-spice branch merge --branch '<branch-a>' --branch '<branch-b>' --no-prompt
git-spice downstack merge --branch '<head-a>' --branch '<head-b>' --no-prompt
git-spice stack merge --branch '<anchor-a>' --branch '<anchor-b>' --no-prompt
```

Report each operation group and effective merge set before mutation.
