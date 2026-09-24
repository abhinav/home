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

This skill governs commit messages, pull request titles and descriptions,
and source text intended to become or supply those artifacts.
It adds artifact-specific guidance for that work.
Apply `prose-writing` and `prose-formatting` alongside it
whenever their descriptions match the task.
higher-priority constraints still govern.

For pull request metadata,
apply the reader model to the pull request's complete review scope.
A single-commit pull request normally carries forward the commit subject and
body.
A multi-commit pull request synthesizes the aggregate outcome and context.
When a repository template exists,
adapt useful content to its structure under the content rules below.
Remove template sections and placeholders that call only for excluded content.

## Preserve the context that history needs

A commit message serves two durable readers:
a reviewer deciding whether one coherent change makes sense now
and a future maintainer encountering it through history, blame, or bisect.
The final message identifies the outcome and preserves the explanation
that the final tree cannot supply by itself.

Treat the message as a standalone artifact.
The reader does not have the writer's investigation, conversation,
or unstated implementation history.
Include what the reader needs to find, evaluate, change, or revert the outcome;
omit content that does not change one of those tasks.

This is also the rule for revising an existing message.
Re-evaluate the complete message against the current change and evidence,
preserve useful established context only while it remains supported,
and produce one coherent replacement.
Do not patch new sentences into the draft while retaining stale claims,
routine activity, or a structure that no longer fits the explanation.

## Identify the outcome in the subject

A subject locates the change and states its outcome.
Use the form that matches the repository and affected area:

- In a single-project repository, use `component: Imperative summary`.
- In a multi-project repository,
  use `project: Imperative summary` for a project-wide change
  and `project/component: Imperative summary`
  for a component-specific change.

The prefix is lowercase;
the imperative summary begins in sentence case.
First identify the area whose behavior changes,
then use its concise, stable name as the prefix.
Use the architecture, repository instructions, and nearby history
to establish that vocabulary.
Treat changed paths as supporting evidence only;
when a path name differs from the area that owns the changed behavior,
use the behavior-owning area.
Omit the prefix only when no narrower stable area exists
and the summary itself locates the affected system.

After the prefix, state the distinguishing result in imperative form.
Use stable terms that a reader would search for in nearby history,
including an affected system, package, component, command,
or user-facing behavior when it improves discovery.
The prefix cannot displace the terms that identify the outcome.
A newly introduced name usually belongs in the summary rather than the prefix
because readers could not have searched for it before this change.

Prefer a subject shorter than 50 characters
and keep it at or below 72 characters.
When shortening it, preserve the terms that distinguish this change
from nearby history.

## Decide whether the body preserves anything material

Apply the information-loss test:
if the body disappeared while the reader retained the subject, final diff,
and surrounding code, what important knowledge would be lost?
Possible answers include the motivating condition and its consequence,
the changed behavior or invariant, a non-obvious constraint or tradeoff,
a compatibility boundary, or evidence that controls the claim.
Write the body when it preserves such context.

If nothing material would be lost, use a subject-only message.
Do not manufacture a body from file changes, routine checks,
or the absence of unrelated effects.
Before deciding that a mechanical change needs no body,
look for purpose or selection criteria in the request, issue,
maintenance policy, or repository history.
For example, a dependency version diff cannot show whether a policy selected
the release or a specific failure required it.

Difficulty describing one outcome can reveal a commit-boundary problem.
Re-examine that boundary instead of constructing one broad narrative
for unrelated changes.

## Explain the behavior at the reader's boundary

Lead with the consequence or reason the reader needs.
Introduce the affected system, baseline behavior, stable actors,
states, and unfamiliar terms before reasoning that depends on them.
Explain what initiates the behavior, what changes,
and what result the reader can observe.
After a dense explanation, state the resulting behavior or invariant.

When a failure depends on ordering,
preserve the stable actors or states and their handoffs,
enough event order to let the reader predict the failure,
and the resulting behavior or invariant.
Do not replace that causal sequence with a generic benefit,
but do not inventory implementation steps that add no explanatory force.

Document the specific public names or readable syntax a consumer needs
to discover, invoke, configure, or observe the changed behavior.
This can include a command, flag, configuration key, input form,
status value, error, or other supported surface.
Omit internal implementation names unless a name exposes a constraint
or otherwise changes that reader outcome.

Distinguish ordinary consumer behavior from explicit maintenance,
migration, repair, or recovery machinery when that boundary affects use.
For example, say when a migration command rewrites stored data
but normal startup does not.
Describe a future step as context, not as present behavior.

Implementation details belong when they expose a constraint,
compatibility concern, surprising choice, or review boundary.
Otherwise let the diff carry them.
If the change is one step in a larger effort,
describe the larger path only far enough to locate this commit's responsibility.

Boundaries must limit a claim the message actually makes.
Read the explanation without the boundary:
if it would not support the broader interpretation,
the negation preserves no durable context.
When available evidence does not establish a motivation, behavior, or boundary,
narrow the claim, preserve a material uncertainty,
or obtain the missing context instead of inventing a plausible story.

## Keep routine check reporting out of the message

The user's projects have CI.
Running checks is expected development work;
reporting whether they ran does not explain the change.
Omit routine test, CI, formatter, linter, build, and patch-hygiene status
from commit messages and pull request descriptions.
This includes bare passed, failed, skipped, blocked, pending, or deferred
status, check-command inventories, and reasons checks could not run locally.
Promises that CI will run or validate the change also earn no space.
These exclusions apply to paragraphs and bullets as well as headings;
renaming the content as evidence, confidence, or a limitation does not qualify it.
Keep operational check status in CI or the task handoff when needed.
Continue performing the checks required by the task.

## Match evidence to the claim

Preserve observations about the changed system when they establish something
the final tree cannot show and materially affect the reader's decision.
Connect each observation to the behavior it establishes,
including the relevant input, conditions, and outcome.
Distinguish observation from inference.
A check's execution status alone is not such an observation.
For a test-only commit, explain the invariant the tests protect
and the previously unrepresented risk they make visible.
Test names and case inventories belong only when they define that boundary.

When preserving raw input or output, a regression comparison, manual verification,
measurements, or uncertainty about the system's behavior,
read [Behavioral evidence](references/evidence-and-validation.md)
before drafting those claims.

Put concrete verification evidence in a separate `Validation` section,
or the repository template's equivalent section.
Use it for demonstrated regression failures and their corrected results,
manual staging or local probes, and measurements that substantiate the change.
Retain the command, assertion, output, or evidence link needed to assess
what was exercised and what happened.
Keep the motivating problem and design explanation in the main body.
If no concrete verification evidence remains after filtering routine status,
omit the section entirely; a template does not require filling it with noise.
Apply this content decision during drafting, revision, template adaptation,
and copying existing commit or PR text.
Before returning, check every retained validation item for an observed outcome
that supports a claim about the change, and remove excluded reporting
wherever it appears in the artifact.

## Structure and format the message

Use the smallest structure that exposes the explanation.
A simple message may need one paragraph.
When several independent concerns matter,
use paragraphs, short headings, or a list so the reader can find them.
Format a heading as sentence-case text on its own line
with a matching hyphen underline:

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
Indent each line of a code block with four leading spaces,
plus four leading spaces for each enclosing structure.
A top-level code block therefore has four leading spaces on every line;
a code block within a top-level list item has eight leading spaces
measured from the left margin.
Put a complete command invocation in an indented code block
when the reader needs its full form to perform a procedure
or reproduce evidence.
Keep command names, flags, and partial syntax inline.
Put multi-line output in an indented code block
when its original text materially supports the problem or result.
Place issue references and trailers after the explanatory body.
