# Pull Requests

Use `git-spice branch submit` for all push,
publish,
review submission,
pull request creation,
and pull request branch update operations.

Do not use:

- `git push`
- `git push -u origin <branch>`
- `git push --force-with-lease`
- `gh pr create`

Exception:
use `gh pr edit` only to edit title or body metadata on an existing pull
request,
because `git-spice branch submit` does not update existing PR metadata.

## Detect existing pull requests

Use `git-spice ls` to check whether a branch already has a pull request.
Branches with open pull requests show a number after the branch name:

```text
┣━□ feature-branch (#42069)
┣━□ another-branch
```

When the pull request number is needed,
read it from `git-spice ls`;
the number appears after the branch name as `(#123)`.

## Create pull requests

Before creating a pull request,
prepare:

1. A pull request title.
2. A pull request body.

For a single-commit pull request,
the title must match the commit subject.
For multiple commits,
summarize the overall change.
Keep the title at or below 72 characters.

For a new pull request:

```bash
git-spice branch submit --title '<title>' --body '<body>'
```

For a draft pull request:

```bash
git-spice branch submit --draft --title '<title>' --body '<body>'
```

To request reviewers while creating or submitting:

```bash
git-spice branch submit --reviewer user1 --reviewer user2 --title '<title>' --body '<body>'
```

Never run `git-spice branch submit` without `--title` and `--body`
when creating a new pull request.

Treat pull request titles and bodies as shell data.
Use the same single-quote escaping rules as commit messages
for generated `--title` and `--body` values.

## Update existing pull requests

Update an existing pull request branch with:

```bash
git-spice branch submit
```

For an existing pull request,
`git-spice branch submit` does not update title or body metadata.
After submitting the branch,
edit metadata with:

```bash
gh pr edit <number-or-url> --title '<title>' --body '<body>'
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
