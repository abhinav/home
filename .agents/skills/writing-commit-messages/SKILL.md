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
and source text intended to supply those artifacts.
Apply `prose-writing` for explanation and representation choices
and `prose-formatting` for source conventions.
The artifact-specific rules here govern their application to commit and PR text.

## Build the explanation the reader needs

A reviewer must decide whether one coherent change makes sense.
A future maintainer must be able to find, evaluate, change, or revert it.
Both can inspect the source; neither has necessarily repeated the investigation.
The message supplies the understanding needed to evaluate the diff.
That includes baseline behavior and causal relationships that source inspection
could eventually reveal: source availability is not the reader's prior knowledge.

Before drafting, recover the supported explanation from the request,
investigation, and existing discussion.
Establish the affected behavior, the motivating condition and consequence,
and how the final change addresses them within its limits.
Use those relationships to build the explanation;
use the final diff to verify its accuracy and scope.
Discard superseded proposals and conversation-specific material.

Decide whether the subject alone gives the reader enough context
to understand and evaluate the outcome.
Use a body when the reader would otherwise have to reconstruct the problem,
its mechanism, the reason for the chosen behavior,
or a material constraint, tradeoff, compatibility boundary, or observation.
A relationship can earn space even when its component facts appear in the diff.
Use a subject-only message when no such explanation is needed.
For a mechanical change, first check the request, issue, maintenance policy,
or history for purpose or selection criteria that the diff does not express.
A dependency refresh may follow a release policy or address a particular failure.
Do not manufacture a body from an edit inventory or unrelated non-changes.
If no coherent outcome fits, reconsider the commit boundary.

Lead the body with the consequence or reason the reader needs.
Introduce the affected system, baseline behavior, actors, and unfamiliar terms
before reasoning that depends on them.
Choose context by what explains the need for the change,
including relevant behavior that remains unchanged.
When an existing guarantee, limit, or safeguard appears to address the problem,
explain what it actually governs and how the motivating condition still occurs.
Stating that it is insufficient leaves the reader to reconstruct the reason.
When order matters, preserve enough of the actions and handoffs
for the reader to explain why the old behavior leads to the consequence
and why the change addresses it.
A list of mechanisms or a generic benefit cannot supply that explanation.

Choose the representation before compressing the explanation.
Carry forward a useful code shape, example, or comparison
when it still exposes a relationship the new reader needs;
adapt it to the destination's supported form.
Trim setup and repetition while preserving the relationship.
Do not turn a useful explanation into labels merely to shorten the message.
A short causal paragraph is sufficient when it carries the reader's task.

Include public names or readable syntax needed to discover, invoke, configure,
or observe the behavior: commands, flags, keys, input forms, statuses, or errors.
Include internal names and implementation details when they explain the failure,
a constraint, a surprising choice, or the review boundary.
Omit details whose removal leaves the causal explanation
and the reader's decisions intact.
Distinguish normal use from explicit maintenance, migration, or recovery
when that changes what the reader should do or expect.
Locate this commit's responsibility within a larger effort only as needed;
keep future behavior distinct from what the change implements.

A qualification earns space when it limits a claim the explanation makes
or changes the reader's decision.
Remove an unchanged-path disclaimer if the text would not otherwise imply
that path changed.
When evidence is missing, narrow the claim, retain a material uncertainty,
or obtain the missing context rather than invent a plausible story.

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

## Select evidence that changes the assessment

Keep observations that resolve a material uncertainty about the changed behavior.
For each observation, identify its relevant input or condition,
what happened, and what claim that outcome supports.
For each additional observation, ask what uncertainty it resolves
that the explanation and retained evidence leave open.
Omit repetitions and test mechanics that establish no additional behavior.
A test-only change should explain the invariant and previously unrepresented risk;
case names belong only when they define that boundary.

When using raw input or output, regression comparisons, manual probes,
measurements, or uncertainty about behavior,
read [Behavioral evidence](references/evidence-and-validation.md)
for interpreting and preserving their evidentiary scope.
Keep the problem and design explanation in the main body.
Put selected concrete verification in a separate `Validation` section
or the repository template's equivalent.
Retain the input, assertion, output, command, or link needed to assess the claim.
Omit the section when no material verification remains.

Routine test, CI, formatter, linter, build, and patch-hygiene status
never explains the change, including passed, failed, skipped, blocked,
pending, or deferred status and reasons checks could not run locally.
Omit command inventories and promises that CI will validate the change.
Renaming this reporting as evidence, confidence, or limitations does not qualify it.
Keep operational status in CI or the task handoff;
continue performing the checks required by the task.

## Prepare and review the complete artifact

A commit message stands alone for its change.
A PR description stands alone for the complete review scope:
a single-commit PR normally carries forward the commit's explanation;
a multi-commit PR synthesizes the aggregate outcome and context.
Adapt useful content to a repository template,
removing sections and placeholders that call only for excluded content.

For a revision, reassess the subject and entire body against the current change.
Keep supported, useful explanation, replace stale claims,
and produce one coherent replacement rather than append corrections.
Apply the same content decisions when copying commit text into a PR
or revising metadata without changing code.

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
