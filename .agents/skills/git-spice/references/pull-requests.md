# Pull Requests

Use `git-spice branch submit` for one branch.
Use multi-branch `--fill` only when every branch has exactly one commit.
Each commit message must be intended to become pull request metadata.
Use `git-spice stack submit --fill` for the whole stack
or `git-spice upstack submit --fill` for the current branch and its upstack.
Do not use `--fill` when any branch has multiple commits;
git-spice appends all of those commit messages into that pull request metadata.
Choose publication, navigation, browser, and other optional flags
only for effects the user currently requests.
`--no-publish` already implies push-only behavior;
otherwise preserve configured defaults, including stack-navigation comments.

Do not use:

- `git push`
- `git push -u origin <branch>`
- `git push --force-with-lease`
- `gh pr create`

## Detect existing pull requests

Use the ordinary stack listing:

```bash
git-spice ls --no-prompt
```

An associated pull request number appears beside the branch name.
Use that number to choose the existing-pull-request workflow.

## Create pull requests

Before creating a pull request,
prepare:

1. A pull request title.
2. A pull request body.

Prepare the title and body as a distinct external artifact
before composing any surrounding chat response or handoff.
Apply the pull request rules in full
even when publication is only one step in a larger task.
Derive the metadata from the branch's commit history,
the repository pull request template,
and user instructions that explicitly govern the pull request metadata.
Keep constraints on other outputs scoped to those outputs.

For a single-commit pull request,
the title must match the commit subject.
For multiple commits,
summarize the overall change.
Keep the title at or below 72 characters.

Before preparing a pull request body,
read and apply `writing-commit-messages.md`.
A pull request body follows the same content and representation guidelines
as a commit-message body,
except where a repository template supplies the structure.
For a single-commit pull request without a repository template,
normalize the commit body under those guidelines before carrying it over,
even when its wording or formatting is already approved.
For a multi-commit pull request,
synthesize the commits' aggregate review contract.
When a repository template exists,
adapt the body to its structure.

Preserve the relevant purpose, changed behavior, boundaries,
and evidence from the commit bodies.
Omit or rewrite that information only for the aggregate pull request scope,
the repository template, a verified factual correction,
or an explicit pull-request-specific instruction.

For a new pull request:

```bash
git-spice branch submit --title '<title>' --body '<body>' --no-prompt
```

For a draft pull request:

```bash
git-spice branch submit --draft --title '<title>' --body '<body>' --no-prompt
```

To request reviewers while creating or submitting:

```bash
git-spice branch submit --reviewer user1 --reviewer user2 --title '<title>' --body '<body>' --no-prompt
```

Never run `git-spice branch submit` without `--title` and `--body`
when creating a new pull request.

For multi-branch creation, use `--fill` only when every branch has exactly one
commit and every commit message is intended to be that branch's pull request
title and body:

```bash
git-spice stack submit --fill --no-prompt
git-spice upstack submit --fill --no-prompt
```

Otherwise, prepare explicit metadata for each branch and submit the branches
individually from the bottom-most branch to the topmost branch.
Each branch's remote base must exist before that branch is submitted.
Sibling branches may be submitted in either order after their shared base.

```bash
git-spice branch submit --branch '<branch>' --title '<title>' --body '<body>' --no-prompt
```

Preserve the requested creation state on every branch submission.
Add `--draft` for draft pull requests or `--no-draft` for ready pull requests.

Treat pull request titles and bodies as shell data.
Use the single-quoted argument form from the main skill.
For an embedded single quote, close the argument, append `\''`, and reopen it.
Pull request submission has no title-file or body-file flag.

## Update existing pull requests

Update an existing pull request branch with:

```bash
git-spice branch submit --no-prompt
```

For an existing pull request,
`git-spice branch submit` does not update title or body metadata.
After submitting the branch,
edit metadata with:

```bash
gh pr edit '<number-or-url>' --title '<title>' --body '<body>'
```

Use `gh pr edit` only for metadata edits.
Do not use `gh pr create`.

## Merge pull requests

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

## Pull request templates

Look for pull request templates in these locations:

- `.github/pull_request_template.md`
- `docs/pull_request_template.md`
- `pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE/<name>.md`
- `docs/PULL_REQUEST_TEMPLATE/<name>.md`
- `PULL_REQUEST_TEMPLATE/<name>.md`

File names are case-insensitive.

If the repository has a pull request template:

1. Follow the template format.
2. Replace placeholders with substantive content.
   Preserve requested section or list structure,
   but never retain literal tokens such as `<command>` or `<result>`.
3. Delete instruction text.
4. Include all relevant information from the commit message body.

The template governs structure;
apply the commit-message guidelines within that structure.
Preserve the template's heading representation
rather than converting its headings to the commit-message heading form.
Reshape field contents as needed to satisfy those guidelines.
Preserve a complete, claim-bearing validation invocation
as an indented code block within the template section.
Placeholder syntax does not create a formatting exception.
If a required section has neither material evidence nor a supported material
gap,
stop only when completing it would require an unsupported assertion.
