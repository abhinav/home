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
<kind>: <summary>
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

#### Choosing scope

Use scope as a reviewer routing signal.

In large repositories,
a scoped subject is usually preferred when the changed files belong to
an identifiable project, sub-project, package, service, component,
or user-facing area.
The scope should help reviewers quickly decide whether the commit is
relevant to them.

A scope MUST name something that already exists before the commit.
When adding a new module, feature, package, or command,
scope the subject to the existing system receiving it,
and name the new thing in the summary.

For example,
use `foo: Add bar module`,
not `foo/bar: Add new module`,
when `bar` is introduced by the commit.

Omit scope when it would not improve reviewer routing,
such as repository-wide changes,
purely mechanical updates,
or root documentation/configuration changes where no owning subsystem
is clearer than the change kind.
Do not invent a scope only to make the subject look structured.

### `<body>`

- Summarize the review contract:
  what behavior reviewers should expect after the patch,
  why that behavior belongs in this commit,
  and which named external contracts changed.
- Lead with the operational or product intent before implementation details.
  Explain the workflow, failure mode,
  or user need that makes the change necessary.
- When a concrete failing command,
  error excerpt,
  or before/after invocation is the shortest way to understand the value of
  the patch,
  put that evidence near the start of the body before broader explanation.
  Use a short command block and explain immediately below it why it failed
  and how the patch changes that behavior.
- For bug fixes where the ordering of events matters,
  explain the failure sequence before the implementation.
  Prefer a short numbered list or timeline when the reader would otherwise
  have to reconstruct several state transitions from prose.
  The restriction on diff-inventory lists does not apply to ordered failure
  narratives.
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
- Use short Markdown headings or simple labels when a body has multiple
  independent parts that reviewers need to scan separately,
  such as public interface,
  compatibility rationale,
  migration behavior,
  examples,
  and verification.
  Do not add headings to simple one-part changes.
- For code examples, use four-space-indented command blocks.
  Keep examples short and representative.
  When the exact command,
  flag combination,
  config stanza,
  or request shape is meant to be copied later,
  preserve it exactly in a block instead of paraphrasing it in prose.
  Do this even when the command feels visually bulky;
  inline flag lists are not a substitute for a copyable invocation when the
  invocation is the operational contract.
- Mention tests only when they clarify the contract or guarantee reviewers
  should trust. Do not enumerate test files, fixture types,
  or every covered mode.
  Prefer a concise guarantee-oriented sentence,
  such as "Unit tests cover the new parser contract
  and the dry-run no-mutation guarantee."
  When a regression test is used as evidence for a bug fix,
  make clear what failed before the patch and what passes after it.
  If the proof comes from strengthening an existing test,
  say what old failure shape the changed test reproduces.
- For manual testing, state what was verified and how.
  When commands help, place short four-space-indented command blocks
  directly below the relevant claim.
  This should give reviewers evidence of the work performed,
  not just a loose list of commands.
- Filter verification to evidence that helps reviewers understand or trust
  the change,
  even when a prompt,
  reviewer,
  or prior draft asks for all verification.
  Focused reproducers,
  before/after output,
  migration probes,
  compatibility checks,
  and end-to-end workflow checks are usually useful.
  Routine hygiene belongs in the handoff unless it is the contract being
  changed.
  NEVER write a `Verified with` sentence or block that lists `git diff --check`,
  formatter commands,
  lint commands,
  or broad default test commands as generic proof.
  Do not mention those routine checks under equivalent wording or any generic
  "commands/checks run" sentence.
  If a focused test is worth mentioning,
  state the behavior guarantee it provides instead of pairing it with routine
  checks.
- Omit test details entirely when they do not add review context.
- NEVER use an empty body.
  There MUST ALWAYS be a body to the commit message.
- Commit message body MUST NOT have lines longer than 72 characters.
- Apply semantic line breaks formatting.
- Treat commit messages as Markdown documents:
  use backticks for inline code,
  use other Markdown formatting judiciously,
  and maintain semantic line breaks.
  Backticks are for code, commands, flags, paths, API fields, config keys,
  and other literal technical syntax.
  Do not wrap PR numbers, issue numbers, ticket IDs,
  or commit hashes in backticks when they are references in prose.
  Prefer plain text such as PR #123, ABC-456, or abc1234
  unless the value appears inside a command, code block, or quoted tool output.
- Use objective, factual tone.
  Avoid subjective embellishments like "critical issue" or "serious problem".
  Focus on what the code does and why, not value judgments.
- Preserve uncertainty when the change is tentative,
  exploratory,
  or changes behavior that was previously intentional.
  State the known prior contract,
  the reason for the current patch,
  and any explicit TODO or follow-up question instead of presenting the change
  as a settled product decision.
- If the commit resolves an issue,
  add a final line in the body using the form `Resolves #123`.

## Explain why the change is necessary

Commit messages should explain the reason for the change,
not only describe the diff.

This matters most when the code change is small but the reason is not obvious,
such as allowlist updates, policy exceptions, configuration changes,
feature flags, migrations, generated files, or dependency updates.

A good commit body should answer the relevant questions:

- What constraint, failure, dependency,
  or product requirement made this change necessary?
- Why is this change the right place to address it?
- What broader workflow or user-visible behavior does this support?
- If this unblocks other work, what depends on it?

When a change responds to a concrete failure,
include a short error excerpt or a link to the failed run
when that context would help reviewers understand the change.
Keep quoted errors short enough to be useful.

When a change is part of a larger sequence,
include concise references to related commits,
pull requests, issues, or rollout steps
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

## Explaining or reviewing commit-message choices

When reviewing,
rewriting,
or explaining commit messages:

- Use Markdown headings
  when the answer covers multiple independent aspects,
  such as the subject, body, replacement text, examples, or rationale.
  Keep headings short, and skip them for genuinely one-part answers.
- Use short fenced code blocks when showing rewritten commit messages,
  before-and-after examples, representative message shapes,
  or compact syntax examples.
  Prefer a small concrete example over a prose-only description
  when the example will make the rule easier to understand.
- Use compact visualizations only when they clarify structure
  that would be harder to follow as prose alone,
  such as a decision path, timeline, comparison, state transition,
  or other compact relationship between ideas.
  Prefer a plain text diagram when the idea fits comfortably in text.
  Do not add a visualization for simple linear explanations.
- Keep structure proportional to the answer. Clarity is the goal, not ceremony.
- Apply the same factual tone guidelines as commit messages themselves.

## Common mistakes

### Not using semantic line breaks

NEVER write commit messages without semantic line breaks.

Solution:
apply semantic line breaks formatting to commit messages.

### Using itemized lists as diff inventories

DO NOT use itemized lists merely to enumerate files,
helpers,
or implementation details from the diff.

Why:
any information that is obvious from looking at the `git diff`
does not need to be present in the commit message.
However,
lists are useful when they make changed external contracts easier to audit,
such as multiple CLI flags, config keys, API fields, or documented forms.

Solution:
focus on the review contract:
why the change exists,
what user-facing behavior changes,
and which named external contracts reviewers need to see.

### Dumping the verification transcript

NEVER turn the commit body into a transcript of every command that ran.

Why:
routine whitespace checks,
formatter checks,
lint commands,
and broad default test commands are handoff details unless they are the
contract being changed.
Listing them makes the important proof harder to find.

Solution:
include only the verification that explains or proves the change,
such as a focused reproducer,
before/after output,
a migration probe,
or an end-to-end workflow check.
If a focused test is worth mentioning,
state the behavior it proves.
Do not pair it with routine hygiene commands.

### Using single-line commit messages

NEVER use a single-line commit message.

Solution:
write a subject and a non-empty body.
The body should explain why the change exists
and what contract reviewers should expect.
