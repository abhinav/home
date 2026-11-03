---
name: writing-commit-messages
description: >
  Use when drafting, revising, reviewing, or evaluating a commit message,
  pull request title or description, or source text intended to become or
  supply a commit message or pull request metadata. Do not use for ordinary
  change explanations, changelogs, release notes, or planning documents that
  will not supply those artifacts.
---

# Writing commit messages

Apply `prose-writing` for explanation and representation choices
and `prose-formatting` for source conventions.
The artifact-specific rules here govern their application to commit and PR text.

## Build the explanation the reader needs

Give reviewers enough context to assess one coherent change
and future maintainers enough to find, evaluate, change, or revert it.
Both can inspect source; do not assume they repeated the investigation.
Supply the baseline behavior and causal relationships needed to evaluate the diff;
source availability is not the reader's prior knowledge.

Before drafting, recover the supported explanation from the request,
investigation, and discussion: affected behavior, motivating condition
and consequence, and how the final change addresses them within its limits.
Build the explanation from those relationships;
verify its accuracy and scope against the final diff.
Discard superseded proposals and conversation-specific material.

Use a body when the subject alone leaves the reader to reconstruct the problem,
mechanism, reason for the chosen behavior, or a material constraint, tradeoff,
compatibility boundary, or observation needed to understand and evaluate the outcome.
Relationships can earn space even when their component facts appear in the diff.
Otherwise use a subject-only message.
For mechanical changes, first check the request, issue, maintenance policy,
or history for purpose or selection criteria absent from the diff:
a dependency refresh may follow a release policy or address a particular failure.
Do not manufacture a body from edit inventories or unrelated non-changes.
If no coherent outcome fits, reconsider the commit boundary.

Lead the body with the needed consequence or reason.
Introduce the affected system, baseline behavior, actors, and unfamiliar terms
before reasoning from them.
Include context and unchanged behavior that explain the need for the change.
If an existing guarantee, limit, or safeguard appears to address the problem,
explain what it governs and how the motivating condition still occurs;
calling it insufficient does not explain why.
When order matters, retain actions and handoffs that explain how old behavior
causes the consequence and how the change addresses it.
A mechanism list or generic benefit cannot replace that explanation.

Choose the representation before compressing.
Retain a code shape, example, or comparison that still exposes a relationship
the new reader needs, adapting it to the destination's supported form.
Trim setup and repetition, preserving the relationship.
Do not replace useful explanation with labels merely to shorten it.
A short causal paragraph suffices when it carries the reader's task.

Include public names or readable syntax needed to discover, invoke, configure,
or observe behavior: commands, flags, keys, input forms, statuses, or errors.
Include internal names and details that explain a failure, constraint,
surprising choice, or review boundary.
Omit details whose removal leaves the causal explanation
and reader decisions intact.
Distinguish normal use from explicit maintenance, migration, or recovery
when it changes what readers should do or expect.
Locate this commit's responsibility in a larger effort only as needed;
distinguish future behavior from what this change implements.

Qualifications earn space when they limit a claim or change a reader's decision.
Remove unchanged-path disclaimers unless the text otherwise implies that path changed.
When evidence is missing, narrow the claim, retain material uncertainty,
or obtain context; do not invent a plausible story.

## Identify the outcome in the subject

A subject locates the change and states its outcome.
Use the form that matches the repository and affected area:

- In a single-project repository, use `component: Imperative summary`.
- In a multi-project repository,
  use `project: Imperative summary` for a project-wide change
  and `project/component: Imperative summary`
  for a component-specific change.

Use a lowercase prefix and sentence-case imperative summary.
First identify the area whose behavior changes;
use its concise, stable name as the prefix, establishing vocabulary
from architecture, repository instructions, and nearby history.
Changed paths only support this choice; when a path names a different area,
use the area owning the changed behavior.
Omit the prefix only when no narrower stable area exists
and the summary locates the affected system.

After the prefix, state the distinguishing result imperatively.
Use stable terms readers would search for in nearby history, including the affected
system, package, component, command, or user-facing behavior when it improves discovery.
The prefix cannot displace terms identifying the outcome.
A new name usually belongs in the summary, not the prefix;
readers could not have searched for it before this change.

Prefer a subject shorter than 50 characters
and keep it at or below 72 characters.
When shortening it, preserve the terms that distinguish this change
from nearby history.

## Keep evidence within the explanation

Commit and PR text explains the change; verification reporting and release
status belong in CI or the task handoff.
Do not add validation sections, test plans, or equivalent reporting blocks,
including when adapting a repository template or carrying forward a message.
Continue performing the checks required by the task.

Use observations within the explanation: an observed failure can establish
the problem, and a scoped measurement can quantify a design consequence.
Describe the system's behavior under the relevant conditions;
retain methods or environments only when they change what the result establishes.
When an observation supplies the problem or result,
use it instead of a generic account of that behavior,
so the reader encounters it once.
Omit observations that only confirm behavior already explained;
keep what the reader otherwise could not explain or assess.
Test-only changes should explain the invariant and previously unrepresented risk;
name cases only when they define that boundary.

When using raw input or output, regression comparisons, manual probes,
measurements, or uncertainty about behavior,
read [Behavioral evidence](references/evidence-and-validation.md)
for interpreting and preserving their evidentiary scope.
Retain the input, assertion, output, command, or link needed to assess the claim.

Omit test-coverage summaries and test, CI, formatter, linter, build,
deployment, and patch-hygiene status, including passed, failed, skipped, blocked,
pending, or deferred status and reasons checks could not run locally.
Omit command inventories and promises that CI will validate the change.
Renaming this reporting as evidence, confidence, or limitations does not qualify it.

## Prepare and review the complete artifact

A commit message stands alone for its change.
A PR description stands alone for the complete review scope:
a single-commit PR normally carries forward the commit's explanation;
a multi-commit PR synthesizes the aggregate outcome and context.
Adapt useful content to a repository template,
removing sections and placeholders that call only for excluded content.

For revisions, reassess the subject and entire body against the current change.
Preserve useful, supported explanation and replace stale claims
in one coherent replacement, rather than appending corrections.
Apply the same decisions when copying commit text into a PR
or revising metadata without code changes.

Before returning or supplying metadata to a tool,
read each artifact without the conversation or work notes.
Can the intended reader explain the motivating behavior,
why the previous behavior permits the problem,
how this change addresses it, and the material limits of that claim?
For another kind of change, can the reader explain the reason for the outcome?
Repair missing premises or representations before polishing the format.
Mentioning each topic is insufficient when their relationships remain implicit.
Remove evidence that adds no distinct support and excluded check reporting
wherever it appears, then verify subject and source formatting.

## Structure and format the message

Use the smallest structure that exposes the explanation.
A simple message may need one paragraph.
When several independent concerns matter,
use paragraphs, short headings, or a list so the reader can find them.
Format a heading as sentence-case text on its own line
with a matching hyphen underline and a blank line before the content:

    Recovery
    --------

Do not use a colon-suffixed label in place of a heading.

Use a list for an auditable set or for a sequence whose order matters,
not as a flat inventory of edits or commands.
One stable example can clarify a boundary;
additional examples should change what the reader understands.

Separate a body from the subject with a blank line.
Prefer body lines at or below 72 characters
and do not exceed 72 characters for divisible prose.
Start each complete body sentence on a new physical line.
Break a longer sentence at meaningful grammatical or structural boundaries,
not merely where the line becomes full.

Use inline code for identifiers, paths, flags, fields, and command names.
An indivisible identifier or link may exceed the line limit;
keep that exception local and wrap surrounding prose normally.
Indent every line of a code block four spaces from the left margin,
plus four per enclosing structure: a top-level block uses four,
a block within a top-level list item uses eight.
Use an indented block for a complete command needed to perform a procedure
or reproduce evidence, or for multi-line output whose original text
materially supports the problem or result.
Keep command names, flags, and partial syntax inline.
Place issue references and trailers after the explanatory body.
