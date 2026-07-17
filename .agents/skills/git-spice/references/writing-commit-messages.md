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
verify these hard gates:

- The subject is imperative and at most 72 characters.
- The body is present.
- Every body line is 72 characters or shorter.
- The message uses semantic line breaks.

Apply all of these guidelines to every revision,
including constrained edits to existing drafts.
Before revising a draft,
apply `Evidence` to every validation claim
and `Code Formatting` to every inline-code span.
Do this before preserving the draft's structure or requested edit scope.

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

The subject SHOULD be fewer than 50 characters,
and MUST be 72 characters or fewer.
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
purpose, changed behavior, boundaries or non-goals, and evidence.
Preserve the draft structure only after those required facts are represented.
Treat supplied phrases such as "only", "does not", or "not yet" as boundary
signals;
include the boundary or decide explicitly that it is redundant or unsupported.

Every body sentence should add reviewer value that is not already available
from the diff, repository policy, or routine process.
Useful sentences explain changed behavior, changed external contracts,
compatibility or migration context, non-obvious design rationale,
risk boundaries, or focused verification evidence.

#### Purpose And Boundary

For a non-trivial change, use this default review arc:

1. State the motivating user or operational need.
2. Establish the prior behavior that makes the change necessary.
3. Describe the observable behavior after the change.
4. State the important boundary, exception, or non-goal.
5. Present evidence that supports the changed behavior.

Combine adjacent stages for a simple change.
Keep implementation details subordinate to the behavior they explain.

Lead with the reader-visible consequence in ordinary language.
Before explaining its cause,
identify what the reviewer must know to evaluate a non-obvious change,
such as the affected actor, prior contract, lifecycle phase, domain term,
unit, configuration source, or system boundary.
Define each unfamiliar domain term or unit at first use,
before describing the behavior that relies on it.
Introduce other necessary prerequisites before relying on them.
Omit prerequisites that do not change the review decision.

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

For bug fixes where the ordering of events matters,
explain the failure sequence before the implementation.
Use a short numbered list or timeline when reviewers would otherwise have to
reconstruct several state transitions from prose.
Keep recurring actors and state names stable,
preserve handoffs between actors or systems,
and group adjacent transitions when their relationship remains clear.
End with the user-visible failure,
then state the resulting behavior or invariant before validation.
Ordered causal narratives are not diff-inventory lists.

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

When an example or reproducer helps explain a change,
use one short, representative example across prior behavior, changed behavior,
and validation evidence.
Keep names, inputs, and units stable,
and change one relevant factor at a time so reviewers can attribute the result
to the behavioral change.
Use blocks for copyable examples such as config stanzas and request shapes.
Omit unrelated debugging examples.

#### Evidence

Routine automated check status is not evidence worth reporting.
Do not list commands or results from tests, CI, formatters, linters,
or repository hygiene merely to report routine pass status.
Never mention `git diff --check`.
When the change modifies one of those systems,
describe its changed contract and material evidence at the behavior level.
When test coverage is added or strengthened,
it may be described in `Validation`.
For bug fixes,
name the old failure shape it reproduces and the behavior it protects.
Do not report test commands, execution status, or pass results.
Unchanged existing coverage is not validation content.
If the change strengthens existing coverage,
state the previously unprotected failure shape.

When a concrete failing command,
error excerpt,
or before/after invocation is the shortest way to understand the value
of the patch,
put that evidence near the start of the body before broader explanation.
Explain why it failed and how the patch changes that behavior.

Use a `Validation` section when non-routine evidence adds review context.
Qualifying evidence includes added or strengthened test coverage,
a manual workflow, reproducer, migration or compatibility probe,
end-to-end workflow, real-boundary check, or soak result.
State what was verified and what the observation established.
Apply the `Code Formatting` rules below to any retained commands.

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
Preserve a specific validation gap when it materially affects reviewer
confidence, rollout risk, or required metadata,
and explain why the gap remains.
Do not infer such a gap from the absence of other validation.

Section requirements do not change what qualifies as evidence.
When there is neither qualifying evidence nor a material validation gap,
omit `Validation` instead of filling it with an absence statement.

#### Formatting And Tone

Treat commit messages as Markdown documents:
use other Markdown formatting judiciously,
and maintain semantic line breaks.

##### Code Formatting

Use backticks for inline code,
including command names, flags, paths, API fields, and config keys.
Before returning the message,
scan every inline-code span.
Move each complete command invocation to an indented code block,
including invocations inherited from existing text or templates.
Preserve the invocation exactly.

##### Tone

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
