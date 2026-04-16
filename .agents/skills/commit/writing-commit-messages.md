# Writing commit messages

## Instructions

Commit messages MUST follow the following format:

```
<subject>

<body>
```

### `<subject>`

This is in one of the following formats:

```
<summary>
<scope>: <summary>
<kind>(<scope>): <summary>
```

Where:

- `<kind>` is the type of change being made.
  It is one of: feat, fix, docs, style, refactor, test, chore.
- `<scope>` identifies the area of the codebase affected.
  This is the name of a module, component, feature, or project.
- `<summary>` is a concise summary of the changes made in the commit.
- `<summary>` MUST use the imperative mood.
  For example, use "Add feature" instead of "Added feature" or "Adds feature".

`<subject>` SHOULD be fewer than 50 characters, and MUST be fewer than 72.
If the subject would exceed 72 characters, omit the `<kind>`.
If it still exceeds 72 characters, omit the `<scope>`.
If it still exceeds 72 characters, rethink the `<summary>` to shorten it.

### `<body>`

- Add a detailed description of the changes made in the commit.
- DO NOT use itemized lists just to enumerate changes made in the commit.
  Anything that is obvious from looking at the diff
  MUST NOT be included in the commit message.
- NEVER use an empty body.
  There MUST ALWAYS be a body to the commit message.
- Commit message body MUST NOT have lines longer than 72 characters.
- Apply semantic line breaks formatting.
- Treat commit messages as Markdown documents:
  - Use backticks for inline code (function names, variables, file paths)
  - Use other Markdown formatting (bold, lists, etc.) judiciously
  - Maintain semantic line breaks
- Use objective, factual tone:
  - Avoid subjective embellishments like "critical issue", "serious problem"
  - Focus on what the code does and why, not value judgments
- If the commit resolves an issue,
  add a final line in the body using the form `Resolves #123`.

## Explain why the change is necessary

Commit messages should explain the reason for the change,
not only describe the diff.

This matters most when the code change is small but the reason is not obvious,
such as allowlist updates, policy exceptions, configuration changes,
feature flags, migrations, generated files, or dependency updates.

A good commit body should answer the relevant questions:

- What constraint, failure, dependency, or product requirement made this change
  necessary?
- Why is this change the right place to address it?
- What broader workflow or user-visible behavior does this support?
- If this unblocks other work, what depends on it?

When a change responds to a concrete failure,
include a short error excerpt or a link to the failed run when that context
would help reviewers understand the change.
Keep quoted errors short enough to be useful.

When a change is part of a larger sequence,
include concise references to related commits, PRs, issues, or rollout steps
when that helps explain why this commit must exist separately.

## Formatting

The `<subject>` SHOULD be fewer than 50 characters,
and MUST be fewer than 72 characters.

The `<body>` MUST NOT have lines longer than 72 characters.

Commit messages MUST ALWAYS be formatted with semantic line breaks.

## Providing feedback on commit messages

When reviewing or providing feedback on commit messages:

- Organize feedback using Markdown headings (##, ###)
  when there are multiple distinct issues or sections
- Use fenced code blocks (```) when:
  - Providing examples of problematic code
  - Showing diffs or comparisons
  - Demonstrating technical examples
- Apply the same factual tone guidelines as commit messages themselves

## Common mistakes

### Not using semantic line breaks

NEVER write commit messages without semantic line breaks.

**Solution**:
Apply semantic line breaks formatting to commit messages.

### Using itemized lists of changes in the commit

DO NOT just enumerate the changes in the commit message.

**Why**:
Any information that is obvious from looking at the `git diff`
does not need to be present in the commit message.

**Solution**:
Focus on *why* the changes were made,
not *what* changes were made.

### Using single-line commit messages

NEVER use single-line commit messages.

**Solution**:
There MUST ALWAYS be a body to the commit message.
