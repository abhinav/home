# Writing commit messages

## Instructions

Commit messages MUST follow the following format:

```
<subject>

<body>

## LLM Assistance

<llm-assistance>

<trailers>
```

The `## LLM Assistance` section and `<trailers>` are conditional.
See the LLM Assistance and Trailers sections below
for when to include each.

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

### LLM Assistance

Include an `## LLM Assistance` section in the commit message
whenever an LLM contributed to the change itself —
code generation, refactoring, bug identification,
test writing, etc.

Omit the section if the LLM only wrote the commit message
and was not involved in producing the change.

Format the section as:

- An `## LLM Assistance` heading after the body.
- One to three factual sentences
  describing how the LLM was involved.
- Use the LLM's name (e.g., "Claude Code", "Amp").
- Apply semantic line breaks; 72-character line max.

**Examples:**

```
## LLM Assistance

Claude Code generated the initial implementation
and test cases for the new validation logic.
```

```
## LLM Assistance

Amp identified the off-by-one error in the loop
and suggested the fix.
```

```
## LLM Assistance

Claude Code refactored the handler functions
from callback style to async/await.
```

### Trailers

Include a `Co-Authored-By` trailer
only when the LLM wrote code in the commit.

```
Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: Amp <amp@ampcode.com>
```

Do not include a `Co-Authored-By` trailer
for suggestions, bug identification,
or commit-message-only involvement.

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

### Missing LLM Assistance section

When an LLM helped produce the change,
the commit message MUST include
the `## LLM Assistance` section.

**Solution**:
Add the section describing how the LLM contributed.
See the LLM Assistance subsection above.
