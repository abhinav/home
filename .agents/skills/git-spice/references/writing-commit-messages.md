# Writing commit messages

## Instructions

Commit messages MUST follow the following format:

```text
<subject>

<body>
```

NEVER use an empty body.
There MUST ALWAYS be a body to the commit message.

Before returning a commit message,
verify the hard gates:
the subject is imperative and under 72 characters,
the body is present,
every body line is 72 characters or shorter,
and the message uses semantic line breaks.

When writing, reviewing, or revising a commit message,
optimize the body for the reader's review task.
Preserve accurate facts and avoid unsupported claims,
but do not preserve draft structure that hides why the change exists,
where the change fits, what behavior changes, or what evidence proves.

### `<subject>`

The subject is in one of the following formats:

```text
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

The subject SHOULD be fewer than 50 characters, and MUST be fewer than 72.
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

The body summarizes the review contract:
what behavior reviewers should expect after the patch,
why that behavior belongs in this commit,
and which named external contracts changed.

When revising a draft,
first extract the review contract from the draft and supplied context:
purpose,
changed behavior,
boundaries or non-goals,
and evidence.
Preserve the draft structure only after those required facts are represented.
Treat supplied phrases such as "only",
"does not",
or "not yet" as boundary signals;
include the boundary or decide explicitly that it is redundant or unsupported.

Every body sentence should add reviewer value that is not already available
from the diff, repository policy, or routine process.
Useful sentences explain changed behavior, changed external contracts,
compatibility or migration context, non-obvious design rationale,
risk boundaries, or focused verification evidence.

#### Purpose And Boundary

Lead with the operational or product intent before implementation details.
Explain the workflow, failure mode,
or user need that makes the change necessary.

When the purpose or boundary is not obvious from the diff,
establish the intended behavior or capability before implementation details.
A dependency, packaging, build, or test obstacle is supporting rationale,
not the purpose,
unless that obstacle is itself the behavior users or operators observe.

When the commit is one part of a larger path,
explain the larger path only enough to identify this commit's responsibility.
Describe the larger sequence as context for this commit's boundary,
not as a promise that future work already exists.
State important non-goals when the diff cannot demonstrate the final behavior
by itself.

Describe the normal consumer path before exceptional machinery.
State what normal users, tests, operators, or callers observe,
then identify any privileged, networked, expensive, stateful,
migration-only, or maintenance-only operation that sits outside that path.

When a change crosses a meaningful boundary,
explain what crosses that boundary,
what does not cross it,
and why that boundary belongs in this commit.
Boundaries can include projects, services, packages, storage systems,
build systems, ownership areas, protocols, user workflows, or operations.

Consult context outside the diff when the diff does not show the purpose,
rejected alternatives, boundary decisions, or validation evidence.
Useful sources include issues, plans, experiment notes, rollout notes,
prior messages, logs, and validation records.
Keep only the context needed to understand and evaluate this commit.

Write the narrative in terms of the system behavior,
operational need,
prior context,
and the change being made now.
Use issue IDs only as references for traceability,
not as the thing that requires, performs, or explains the change.
If an issue reference is needed,
put it in a final reference line such as `Refs ABC-123`
or `Resolves ABC-123`.
If the commit resolves an issue,
add a final line in the body using the form `Resolves #123`.

#### Changed Contracts And Details

Name the user-facing behavior that changed.
Keep implementation details out of the body
unless they explain a boundary, migration, compatibility concern,
or surprising design choice.

Avoid itemized lists that merely mirror the file diff.
Prefer itemized lists when they make changed contracts easier to audit.
This is especially important when a change adds or updates multiple
user-facing interface items.
User-facing interface surface includes CLI flags, subcommands, config keys,
environment variables, API fields, file formats, protocol fields,
visible error text, documented command syntax, and more.

For interface-heavy changes, mention the exact public names.
If there are multiple flags, keys, fields, or commands,
group them by role when grouping improves scanability.
Use labels sparingly, such as `New flags:` or `Examples:`;
do not force every commit into a template.

Mention support artifacts only when the commit changes that artifact's
reviewed contract,
such as user-facing wording, format, migration guidance,
compatibility notice, or documentation behavior.
Including a file in the commit and explaining the file in the message are
separate decisions.

Remove sentences whose only purpose is to say that a file exists,
a generated artifact changed, a required repository convention was followed,
a routine command ran, or the diff contains an expected support file.
Treat sentences shaped like "`X` is included so...",
"`X` is included as required...",
or "`X` was updated to keep artifacts aligned" as red flags:
they usually describe commit packaging,
not the review contract.

Use short Markdown headings or simple labels when a body has multiple
independent parts that reviewers need to scan separately,
such as public interface, compatibility rationale, migration behavior,
examples, and verification.
Do not add headings to simple one-part changes.

For code examples, use four-space-indented command blocks.
Keep examples short and representative.
When the exact command, flag combination, config stanza,
or request shape is meant to be copied later,
preserve it exactly in a block instead of paraphrasing it in prose.
Inline flag lists are not a substitute for a copyable invocation
when the invocation is the operational contract.

#### Evidence

Mention tests only when they clarify the contract or guarantee reviewers
should trust.
Do not enumerate test files, fixture types, or every covered mode.
Prefer a concise guarantee-oriented sentence,
such as "Unit tests cover the new parser contract
and the dry-run no-mutation guarantee."

When a regression test is used as evidence for a bug fix,
make clear what failed before the patch and what passes after it.
If the proof comes from strengthening an existing test,
say what old failure shape the changed test reproduces.

When a concrete failing command,
error excerpt,
or before/after invocation is the shortest way to understand the value
of the patch,
put that evidence near the start of the body before broader explanation.
Use a short command block and explain immediately below it why it failed
and how the patch changes that behavior.

For bug fixes where the ordering of events matters,
explain the failure sequence before the implementation.
Prefer a short numbered list or timeline when the reader would otherwise
have to reconstruct several state transitions from prose.
The restriction on diff-inventory lists does not apply to ordered failure
narratives.

For manual testing, state what was verified and how.
When commands help,
place short four-space-indented command blocks directly below the relevant
claim.
This should give reviewers evidence of the work performed,
not just a loose list of commands.

When the body mentions several validation signals,
map each signal to the claim it supports.
Distinguish current implementation evidence from downstream, historical,
manual, or follow-on evidence.
Do not make reviewers infer from a flat command list which risk each check
reduces.

Filter verification to evidence that helps reviewers understand or trust
the change,
even when a prompt, reviewer, or prior draft asks for all verification.
Focused reproducers, before/after output, migration probes,
compatibility checks, and end-to-end workflow checks are usually useful.
Routine hygiene belongs in the handoff unless it is the contract being
changed.
NEVER write a `Verified with` sentence or block that lists `git diff --check`,
formatter commands, lint commands,
or broad default test commands as generic proof.
Do not mention those routine checks under equivalent wording
or any generic "commands/checks run" sentence.
If a focused test is worth mentioning,
state the behavior guarantee it provides instead of pairing it with routine
checks.

Omit test details entirely when they do not add review context.

#### Formatting And Tone

Treat commit messages as Markdown documents:
use backticks for inline code,
use other Markdown formatting judiciously,
and maintain semantic line breaks.
Backticks are for code, commands, flags, paths, API fields, config keys,
and other literal technical syntax.
Do not wrap PR numbers, issue numbers, ticket IDs,
or commit hashes in backticks when they are references in prose.
Prefer plain text such as PR #123, ABC-456, or abc1234
unless the value appears inside a command, code block, or quoted tool output.

Use objective, factual tone.
Avoid subjective embellishments like "critical issue" or "serious problem".
Focus on what the code does and why,
not value judgments.

Preserve uncertainty when the change is tentative, exploratory,
or changes behavior that was previously intentional.
State the known prior contract,
the reason for the current patch,
and any explicit TODO or follow-up question instead of presenting the change
as a settled product decision.

Use separate paragraphs for distinct ideas,
such as why the change is being made,
what context the reviewer needs,
and what this commit changes.

## Explaining Or Reviewing Commit-Message Choices

When reviewing, rewriting, or explaining commit messages:

- Use Markdown headings when the answer covers multiple independent aspects,
  such as the subject, body, replacement text, examples, or rationale.
  Keep headings short,
  and skip them for genuinely one-part answers.
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
- Keep structure proportional to the answer.
  Clarity is the goal, not ceremony.
- Apply the same factual tone guidelines as commit messages themselves.

## Common Mistakes

### Not Using Semantic Line Breaks

NEVER write commit messages without semantic line breaks.

Solution:
apply semantic line break formatting to commit messages.

### Using Itemized Lists As Diff Inventories

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

### Dumping The Verification Transcript

NEVER turn the commit body into a transcript of every command that ran.

Why:
routine whitespace checks, formatter checks, lint commands,
and broad default test commands are handoff details unless they are the
contract being changed.
Listing them makes the important proof harder to find.

Solution:
include only the verification that explains or proves the change,
such as a focused reproducer, before/after output,
a migration probe,
or an end-to-end workflow check.
If a focused test is worth mentioning,
state the behavior it proves.
Do not pair it with routine hygiene commands.

### Repeating Non-Review Signals

DO NOT use the commit body to repeat information that reviewers can already
get from the diff, repository policy, or routine process.

Why:
those details do not tell reviewers what behavior changed,
why the commit exists,
or which contract they need to evaluate.
Repository process compliance belongs in the handoff,
even when the user asks to mention it,
unless the commit changes the reviewed contract of that process artifact.

Solution:
describe the behavior, workflow, compatibility contract,
or operational reason that made the change necessary.
Mention support files, generated output, changelog entries,
release-note fragments, formatter runs, and similar details only when their
reviewed contract is what reviewers need to evaluate.
Do not justify routine support artifacts as aligned with the real change;
that still repeats the file inventory instead of explaining the review
contract.
If the user asks to mention a routine support artifact,
keep that explanation in the handoff.
The commit message should still describe the behavior, contract,
or rationale that reviewers need.

### Using Single-Line Commit Messages

NEVER use a single-line commit message.

Solution:
write a subject and a non-empty body.
The body should explain why the change exists
and what contract reviewers should expect.
