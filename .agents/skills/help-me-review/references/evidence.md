# Evidence and navigation

## Collect the diff

Use a supplied diff in place and identify whether it is complete or an excerpt.
For collection, choose the method that fits the available source:

- For a GitHub PR, use its URL so `gh` works outside a checkout:

  ```sh
  gh pr diff "$PR_URL" --color never --allow-escape-sequences > work/change.diff
  ```

  Or request the raw diff through the API:

  ```sh
  gh api repos/OWNER/REPO/pulls/NUMBER \
    -H 'Accept: application/vnd.github.diff' --allow-escape-sequences > work/change.diff
  ```

  Save unfiltered diff output without terminal colors.
  `--allow-escape-sequences` preserves source characters in the saved file.
  See the [gh pr diff](https://cli.github.com/manual/gh_pr_diff) and
  [gh api](https://cli.github.com/manual/gh_api) command references.
- For a local comparison, choose the base and head that bound the requested work.
  For one branch in a stack, use its parent branch as the base;
  for the whole stack, use the stack's base.
  Use the parent commit for a single commit,
  or the merge base when the requested scope is changes since divergence.

  ```sh
  git -C /path/to/repository diff --no-color --no-ext-diff --no-textconv \
    BASE HEAD -- > work/change.diff
  ```

  For uncommitted work, collect the requested staged, unstaged, or combined scope
  and include any requested untracked files separately.

Check command success and any provider pagination or truncation before claiming
complete coverage.
Retain available revision IDs with captured source;
if the PR changes during collection, reconcile the diff and metadata before
associating those IDs with the saved evidence.
Local refs and commit objects are needed only for methods that use local Git.

For supporting context beyond the diff,
retrieve only the needed caller, contract, or test through provider or API
access already available to the task,
or read it from an existing checkout without changing Git state.
Do not clone, fetch, pull, check out, switch branches, create a worktree,
or otherwise acquire or change a repository to fill a context gap.
When the available sources cannot provide the context,
preserve the uncertainty and explain what the missing evidence would establish.
A diff supplies its included context; it cannot expose unseen callers or the
rest of a file on its own.

## Open and link the source

In the Codex app, use `open_in_codex` with `placement: "right"`:

- For a local branch, pass the selected base directly as `baseBranch`.
  For example, to review the current branch against `stack-parent`:

  ```json
  {
    "placement": "right",
    "target": {"type": "review", "baseBranch": "stack-parent"}
  }
  ```

  The base must resolve locally to a commit.
  The panel compares with the task repository's `HEAD`, which must match the
  reviewed head; `baseBranch` selects the comparison base, not another head.
  For a different head or an unavailable comparison, open the saved diff
  or use a task already attached to a matching checkout.
- For staged or unstaged local changes, select the corresponding native review
  scope without `baseBranch`.
- For a GitHub PR, open the saved diff as a file and link to its ordinary web
  page for PR identity and discussion. Use Flow web URLs for OpenAI PRs.
  When the repository, path, and reviewed head SHA are established,
  link available head-source ranges through immutable blob URLs on the PR's
  GitHub host.
  On `github.com`, use
  `https://github.com/OWNER/REPO/blob/HEAD_SHA/path#LSTART-LEND`.
  Use a compact `file:line–line` label.
  Use separate links for noncontiguous ranges.
  Use absolute saved-diff links for deleted or base-side source,
  or when the reviewed head source is unavailable.
- For a standalone `.diff` or saved source file, open it as a file at the
  relevant physical line.
  This needs no repository.

Use the host's current tool schema for navigation arguments.
Opening or linking evidence provides navigation;
it does not synchronize scrolling or attach arbitrary explanations to the diff.
Inline review comments are for actionable code feedback, not the reading map.

Use ordinary web URLs for PR links; do not generate `codex://review` PR links.
Use ordinary absolute file links for workspace or saved source:

```text
[Cleanup ordering](/absolute/path/change.diff:16)
```

A `.diff` file link uses its physical line number,
not the old or new source-file number in a hunk header.
Inspect those coordinates with `nl -ba work/change.diff` when needed.
Name the real file and owner in the link label or nearby prose.
Give a range in prose when the host's link can target only its first line.
