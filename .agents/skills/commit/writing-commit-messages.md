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

- Summarize the review contract:
  what behavior reviewers should expect after the patch,
  why that behavior belongs in this commit,
  and which named external contracts changed.
- Lead with the operational or product intent before implementation details.
  Explain the workflow, failure mode,
  or user need that makes the change necessary.
- Name the user-facing behavior that changed.
  Keep implementation details out of the body
  unless they explain a boundary, migration, compatibility concern,
  or surprising design choice.
- Avoid itemized lists that merely mirror the file diff.
  Prefer itemized lists when they make changed contracts easier to audit.
  This is especially important when a change adds or updates multiple
  user-facing interface items.
  User-facing interface surface includes CLI flags, subcommands, config keys,
  environment variables, API fields, file formats, protocol fields,
  visible error text, documented command syntax, and more.
- For interface-heavy changes, mention the exact public names.
  If there are multiple flags, keys, fields, or commands,
  group them by role when grouping improves scanability.
  Use labels sparingly, such as `New flags:` or `Examples:`;
  do not force every commit into a template.
- For code examples, use four-space-indented command blocks.
  Keep examples short and representative.
- Mention tests only when they clarify the contract or guarantee reviewers
  should trust. Do not enumerate test files, fixture types,
  or every covered mode.
  Prefer a concise guarantee-oriented sentence,
  such as "Unit tests cover the new parser contract
  and the dry-run no-mutation guarantee."
- For manual testing, state what was verified and how.
  When commands help, place short four-space-indented command blocks
  directly below the relevant claim.
  This should give reviewers evidence of the work performed,
  not just a loose list of commands.
- Omit test details entirely when they do not add review context.
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

Commit bodies should describe the work itself,
not treat an issue ID as the subject of the change.

Write the narrative in terms of the system behavior,
operational need,
prior context,
and the change being made now.
Use the issue ID only as a reference for traceability,
not as the thing that requires,
performs,
or explains the change.

Use separate paragraphs for distinct ideas,
such as:

- why the change is being made,
- what context the reviewer needs,
- what this commit changes.

If an issue reference is needed,
put it in a final reference line such as `Refs ABC-123`
or `Resolves ABC-123`.
Avoid overusing the issue number in the commit message;
usually one use is enough.

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

### Using itemized lists as diff inventories

DO NOT use itemized lists merely to enumerate files,
helpers,
or implementation details from the diff.

**Why**:
Any information that is obvious from looking at the `git diff`
does not need to be present in the commit message.
However,
lists are useful when they make changed external contracts easier to audit,
such as multiple CLI flags, config keys, API fields, or documented forms.

**Solution**:
Focus on the review contract:
why the change exists,
what user-facing behavior changes,
and which named external contracts reviewers need to see.

### Using single-line commit messages

NEVER use single-line commit messages.

**Solution**:
There MUST ALWAYS be a body to the commit message.
