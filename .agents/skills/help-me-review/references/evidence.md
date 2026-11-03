# Evidence and navigation

## Collect the diff

Use supplied diffs in place and identify whether complete or excerpted.
Choose the method fitting the available source.

### GitHub

Use the PR URL so collection works outside a checkout:

```sh
gh pr diff "$PR_URL" --color never --allow-escape-sequences > work/change.diff
```

Or request the raw API diff:

```sh
gh api repos/OWNER/REPO/pulls/NUMBER \
  -H 'Accept: application/vnd.github.diff' --allow-escape-sequences > work/change.diff
```

Save unfiltered, uncolored output; `--allow-escape-sequences` preserves source characters.
See [gh pr diff](https://cli.github.com/manual/gh_pr_diff)
and [gh api](https://cli.github.com/manual/gh_api).

### Local comparison

Choose base and head to bound the requested work:
parent branch for one stacked branch, stack base for the whole stack,
parent commit for one commit, or merge base for changes since divergence.

```sh
git -C /path/to/repository diff --no-color --no-ext-diff --no-textconv \
  BASE HEAD -- > work/change.diff
```

For uncommitted work, collect requested staged, unstaged, or combined scope;
include requested untracked files separately.

Check command success, pagination, and truncation before claiming completeness.
Keep revision IDs with captured source;
reconcile advancing diff and metadata before associating them.
Only methods using local Git need local refs and commit objects.
Retrieve only needed callers, contracts, or tests through available provider or API access
or an existing checkout without changing Git state.
A diff cannot reveal unseen callers or the rest of a file;
state missing context and what it would establish.

## Open and link source

Use current host schemas.
In the Codex app, call `open_in_codex` with `placement: "right"`.

- Local branch: pass the selected base directly as `baseBranch`:

  ```json
  {
    "placement": "right",
    "target": {"type": "review", "baseBranch": "stack-parent"}
  }
  ```

  The base must resolve locally to a commit.
  The panel compares against the task repository's `HEAD`, which must match the reviewed head.
  `baseBranch` selects base, never another head.
  For another head or unavailable comparison, use saved diff or a task already attached
  to a matching checkout.
- Staged or unstaged local work: select that native scope without `baseBranch`.
- For a GitHub PR, open the saved diff as a file and link to its ordinary web
  page for PR identity and discussion. Use Flow web URLs for OpenAI PRs.
  When repository, path, and reviewed head SHA are established, link available immutable
  head-source ranges on the PR's GitHub host; on github.com:
  `https://github.com/OWNER/REPO/blob/HEAD_SHA/path#LSTART-LEND`.
  Use compact `file:line–line` labels and separate noncontiguous links.
  Use absolute saved-diff links for deleted or base-side source or unavailable reviewed head source.
- Standalone diff or source: open the file at its relevant physical line; no repository needed.

Opening or linking provides navigation, not synchronized scrolling or attached explanations.
Inline review comments are actionable feedback, not the reading map.
Use ordinary PR web URLs, never `codex://review` PR links.
Use absolute workspace or saved-source links:

```text
[Cleanup ordering](/absolute/path/change.diff:16)
```

Diff links use physical file lines, not old or new source numbers from hunk headers;
inspect with `nl -ba work/change.diff` when needed.
Name the real file and owner in labels or nearby prose;
state ranges in prose if links target only their first line.
