# Pull request submission

This workflow overrides default PR metadata and publication workflows.
For metadata drafting, revision, review, creation, or updates,
load and apply `writing-commit-messages`.
Titles and descriptions carry the branch commits' established review context.

## Select the publication operation

Leave optional flags unset unless the user requests their effect.
`--draft` controls review readiness; navigation comments link stack changes.
Pass `--nav-comment` only when the user specifies how those links should be posted.

Use branch submission for one branch's committed history;
`--no-publish` suffices for pushing without PR creation.
For already-committed changes, submit from an existing checkout and preserve its current branch.
Only additional file work, tests, or conflict resolution needs a target-branch checkout;
PR creation and updates alone need no checkout or worktree acquisition.
Inspect committed history, files, or templates without switching:

```bash
git log '<base>..<branch>'
git show '<branch>:<path>'
```

Do not use raw pushes (`git push`, `-u`, or `--force-with-lease`), `gh pr create`,
or multi-step GitHub CLI workflows for pushing or creating PRs.

Detect existing PRs through the number beside a branch in:

```bash
git-spice ls --no-prompt
```

## Prepare new PR metadata

Prepare title and body as a distinct external artifact before surrounding chat or handoff,
even when publishing is a side task.
Derive them from commit history, repository template, and explicit PR-metadata instructions;
keep constraints on other outputs scoped to those outputs.
Single-commit titles must match the commit subject; multi-commit titles summarize
the overall change. Maximum length is 72 characters.

Bodies follow commit-body content and representation guidelines, with repository templates
supplying structure.
For one commit without a template, normalize its body before carryover,
even when wording or formatting was approved.
For multiple commits, synthesize the aggregate review contract.
Preserve relevant purpose, changed behavior, boundaries, and evidence from commit bodies;
omit or rewrite only for aggregate PR scope, a repository template, verified factual correction,
explicit PR-specific instruction, or `writing-commit-messages` exclusions.

Use explicit metadata for creation:

```bash
git-spice branch submit --branch '<branch>' --title '<title>' --body '<body>' --no-prompt
```

For requested draft or ready creation, preserve that state on every branch
using `--draft` or `--no-draft`, respectively.
Reviewers can be requested during creation or submission:

```bash
git-spice branch submit --branch '<branch>' --reviewer 'user1' --reviewer 'user2' \
  --title '<title>' --body '<body>' --no-prompt
```

Never create a PR with branch submission lacking `--title` and `--body`.
For multiple branches, `--fill` is allowed only when every branch has one commit
and every message is intended as its PR metadata.
With multiple commits, git-spice appends all their messages into that PR's metadata.

```bash
git-spice stack submit --fill --no-prompt
git-spice upstack submit --fill --no-prompt
```

These select the whole stack or current branch plus upstack, respectively.
Otherwise prepare explicit metadata per branch and submit bottom to top,
with each remote base present first; siblings may follow their shared base in either order.
Quote generated titles and bodies using the main skill's single-quoted shell form;
git-spice submission has no title-file or body-file flag.

## Update existing PRs

Metadata-only requests authorize no repository mutation, submission, or publication.
Publish committed branch updates with:

```bash
git-spice branch submit --branch '<branch>' --no-prompt
```

This does not change existing title or body metadata.
For metadata-only work, edit directly without submission:

```bash
gh pr edit '<number-or-url>' --title '<title>' --body '<body>'
```

Use `gh pr edit` only for metadata, never `gh pr create`.

## Repository templates

Look for these files; filenames are case-insensitive:

- `.github/pull_request_template.md`
- `docs/pull_request_template.md`
- `pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE/<name>.md`
- `docs/PULL_REQUEST_TEMPLATE/<name>.md`
- `PULL_REQUEST_TEMPLATE/<name>.md`

Apply `writing-commit-messages` to select content and omit excluded sections,
even during direct commit carryover.
Adapt retained content to remaining template structure, preserving its heading representation
rather than converting to commit-message headings.
Replace placeholders with substantive content and delete instructions;
placeholder syntax grants no content or formatting exception.
Preserve relevant commit purpose, changed behavior, and boundaries.
The template organizes; `writing-commit-messages` owns evidence and representation.
