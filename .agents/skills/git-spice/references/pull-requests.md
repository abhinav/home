# Pull Requests

Use `git-spice branch submit` for one branch.
Use multi-branch `--fill` only when every branch has exactly one commit.
Each commit message must be intended to become pull request metadata.
Use `git-spice stack submit --fill` for the whole stack
or `git-spice upstack submit --fill` for the current branch and its upstack.
Do not use `--fill` when any branch has multiple commits;
git-spice appends all of those commit messages into that pull request metadata.

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

When deriving a pull request body from a commit body,
carry over a well-structured single-commit body directly when there is no
repository template.
Use the complete commit body as the starting body.
Append new validation or risk information without replacing its existing
narrative.
Otherwise,
adapt without losing high-value structure.
Examples include headings, command blocks, before/after evidence, compatibility
notes, and verification sections.
Do not shorten the pull request body merely because the commit message already
has the details,
and do not preserve only verification while summarizing away the failure or
fixed behavior.
Reshape only as needed to fit a repository template.
Before submitting,
compare the final body with the commit body
and account for each omission or rewrite using a repository template,
a verified factual correction, or an explicit pull-request-specific
instruction.
If the draft invents a new heading structure without one of those reasons,
restore the direct carryover.

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
2. Fill placeholders.
3. Delete instruction text.
4. Include all relevant information from the commit message body.
