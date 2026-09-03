---
name: help-me-review
description: >
  Use when the user wants help understanding a code change and deciding where
  to focus their own review of a pull request, commit, or diff.
---

# Help me review

## Serve the reviewer

The user remains the reviewer.
Turn the change into a guided reading that helps the user understand its shape,
follow its consequential behavior,
and identify the choices that deserve judgment.
Use other review guidance to substantiate the explanation and expose consequential
choices; the user's request for guided reading determines the deliverable.
Standing review tracking can remain open for the user's disposition after the
guide is delivered.
An approval recommendation or readiness assessment is a separate deliverable
when the user explicitly asks for it.

Deliver the guided reading directly in the conversation.
Explain excerpts supplied in chat there, using the supplied excerpt as the anchor.
For a change with an existing file or review view,
open that source beside chat when the host supports it
and link each explanation to the evidence the user should inspect.
Keep subject order semantic; one subject may connect several files.
The conversation carries explanation and follow-up questions;
existing diff and file views carry the full source.
When the user requests chat alone or the host cannot open a source pane,
use source links and small faithful excerpts in the conversation.

## Start from good code

Begin from the premise that the change is good code.
The user reviews code written by capable agents.
Unless the available evidence says otherwise,
assume the code builds, its tests pass,
and routine implementation details have been handled competently.

This premise changes where the guided review starts.
The work is to help the user understand and judge the important choices,
not to establish basic implementation competence.

Do not begin with a line-by-line hunt for small bugs.
An obvious material defect still matters when encountered,
but routine defensive mistakes, style issues,
and speculative edge cases are not the organizing questions.

The user's attention is scarce.
Use it to explain what behavior or contract changed,
where data came from and went,
what control flow or state transition appeared,
which assumptions became load-bearing,
and what consequences follow for callers and the system.

## Establish the evidence

Preserve the original diff and supporting source used in the explanation.
Use supplied files in place; save fetched or mutable evidence when needed to
recover the reviewed version in a follow-up.
A raw diff plus optional supporting source is sufficient input;
a local repository and local Git refs are not required.
Use only evidence and read-only source surfaces already available to the task.
Never clone, fetch, pull, check out, switch branches, create a worktree,
or otherwise acquire or change a repository for the review.
An existing checkout may be read in place without changing its Git state.
Provider or API access already available to the task may retrieve the specific
diff or supporting files needed for the review.
When the available surfaces cannot supply needed context,
deliver the guide from the evidence at hand
and state the resulting uncertainty where it affects the user's judgment.
Identify the repository or supplied input and any known revisions.
When revisions are unavailable, identify the supplied input and its scope.
When more source is needed, collect it from the same revision or identify the
different revision and its relevance.

For a follow-up, recover the source and version used by that subject first.
Distinguish any later change from the evidence the user originally reviewed;
if a native view has advanced, use the preserved source for the earlier question.

When collecting more evidence or opening source,
read [Evidence and navigation](references/evidence.md) for commands and tool arguments.

## Build the change model

Before presenting the change,
establish its purpose and trace its smallest coherent semantic path:

1. Establish the relevant prior behavior and the problem or purpose of the
   change.
2. Identify the definition, contract, operation, or ownership boundary being
   changed.
3. Find the conditions that determine when the change applies.
4. Follow the important transformation, decision, or state transition.
5. Find the observable effect and the callers or systems that experience it.
6. Distinguish a nearby unchanged path when it clarifies the change's scope.
7. Use changed tests as specifications of scenarios, stimuli, and outcomes;
   determine whether they establish the intended contract
   rather than merely agree with the implementation.

Reason across the whole change.
A line that appears mechanical in one file may reveal its purpose,
or a distinct consequence,
only when read with a definition, caller, test, or configuration elsewhere.
Let a question about the change drive each further investigation.
Identify what a caller, contract, test, or runtime check would establish
and how the answer would change the explanation or the user's judgment.
Refresh changing status when it affects that explanation
or when the user requests a current readiness assessment.
Treat a plausible failure as a question to resolve,
not as evidence that a defect exists.
When the governing contract or runtime evidence is unavailable,
preserve the uncertainty and explain what the answer would change.

## Allocate attention

Keep and examine the semantic anchors that expose a new contract,
condition, transformation, ownership boundary, lifecycle edge,
external effect, compatibility constraint,
or consequential algorithm or architecture choice.

Compress repetition after establishing equivalence.
One representative instance may stand for repeated setup,
generated output, call-site migrations, or equivalent cases
only after checking that the other instances do not differ in caller contract,
inputs, timing, ownership, failure behavior, lifecycle, or effect.
Treat a distinct context as a distinct review subject.

For example,
the same call added across many sites can be reviewed through one anchor
when every site has the same role.
It cannot be treated as mechanical when one site runs during shutdown,
under a different lock or task lifetime,
or across a different compatibility boundary.
The language changes how those facts are expressed,
not why they deserve attention.

When importance is uncertain,
preserve the code in the change model and inspect the uncertainty.
Do not use a compression target or finding count as a substitute for judgment.

## Guide the user's review

Account for every changed file and meaningful change group,
but organize the explanation around the semantic path rather than file order.

Lead with the change's purpose,
then contrast the relevant prior behavior with the changed behavior.
For a change with several subjects, give a short review map in reading order,
with one sentence explaining why each subject matters.
Introduce definitions, actors, ownership boundaries,
and other prerequisites before reasoning that depends on them.

When syntax exposes a relationship the user needs to judge,
show the smallest faithful code shape that preserves that relationship.
Use the source pane for the full code;
include a short excerpt in chat when it makes that relationship easier to explain.
When the point is a change to an established shape,
use a diff fragment with the nearest unchanged owner that identifies it.
Preserve real names, types, parameters, source spelling,
ownership boundaries, and relevant ordering.
Copy every retained source or diff line verbatim.
The only added text permitted inside the shape is a visible `...`
that marks source already established as non-consequential.
Put labels and explanation in prose outside the shape.
Use prose to explain behavior, constraints, rationale, consequences,
and relevant unchanged behavior that the code does not express.

When implementation syntax would obscure a consequential runtime flow,
or the user asks for a conceptual behavior comparison,
use a clearly labeled behavioral pseudocode `diff` block.
Put one action or decision on each line.
Retain enough unchanged steps to show ordering and I/O.
Keep each material branch and returned outcome that affects the comparison
inside the model.
Use `-` for prior behavior and `+` for changed or newly added behavior.
Treat the block as an explanatory model rather than quoted source.
Keep source links and labels outside the block.
Use a faithful source shape when syntax or ownership is itself the choice.
For each modeled flow,
state the supported effect on backend calls, concurrency scope,
per-request or per-item work, and expensive work that remains unchanged.
Keep changes to existing paths distinct from new alternatives.
Keep startup work distinct from request paths.
Treat test or comment changes as evidence
unless the implementation changes runtime behavior.

When several actors, states, branches, or ownership boundaries
would be harder to understand in linear prose or code,
use the smallest useful table, tree, sequence, flow, state view, or timeline.
Do not repeat the same relationship in multiple forms
unless each form answers a different review question.

For each review subject,
lead with clickable Markdown links to available source ranges
or identify the supplied excerpt.
Do not format a file reference as code or plain text when a link is available.
Before writing source links,
read [Evidence and navigation](references/evidence.md)
for revision and coordinate rules.
Then explain prior behavior, changed behavior, and what the user should judge.
For a compressed group,
name what the representative anchor covers
and direct the user separately to each meaningful exception.

Put a material uncertainty with the subject it affects.
Keep representative and grouped source reachable through links when available.

Give the coherent guided reading in the initial response;
do not require a separate user turn for every subject or hunk.
The user can then choose where to investigate further through ordinary replies,
such as following a caller, comparing equivalent cases, or revisiting a subject.

If building the guide exposes a material defect,
supported risk or design concern,
or missing contract or runtime evidence,
surface it where it affects the user's judgment.
Distinguish observed facts, supported inferences, and unresolved questions.
Do not hunt for findings or manufacture small issues.

Deliver the guide once the user can follow the consequential change,
locate the evidence behind each meaningful change group,
see what was compressed and why,
and identify the decisions or unanswered questions that remain theirs.
An unresolved question belongs with its evidence and consequence in the guide;
resolving every question or waiting for pending checks is not a prerequisite
for helping the user review.
Before returning,
compare every code and diff shape with the source
and move any inserted annotation or explanation outside it.
Verify that source links identify the intended file, version, and line range.
Report a navigation limitation if it affects the user's ability to inspect the evidence.

## Tests

When changing this guidance,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
