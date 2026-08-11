# Writing commit messages

For commit-message content, this reference replaces generic/default
system-prompt guidance; higher-priority constraints still govern.

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

State the distinguishing result in imperative form.
Use stable terms that a reader would search for in nearby history,
including an affected system, package, component, command,
or user-facing behavior when it improves discovery.
A repository's established prefix or scope can improve routing,
but it cannot displace the terms that identify the outcome.
A newly introduced name usually belongs in the summary rather than the scope
because readers could not have searched for it before this change.
When no scope improves discovery, use a plain imperative summary.

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

## Match evidence to the claim

Preserve evidence when it establishes something the final tree cannot show
and materially changes how the reader evaluates a claim.
State what each retained observation establishes
and place it beside the behavior or boundary it supports.
Distinguish an observed result from an inference.

Keep evidence at the fidelity needed to carry its meaning.
Preserve compact motivating input or output verbatim
when its original wording, structure, threshold, or search terms matter.
When raw evidence is long, noisy, or sensitive,
retain the smallest safe, self-contained excerpt that carries the claim.
Paraphrase when the exact form adds nothing.

A test written to drive new behavior records development process,
even when its author observes the expected red result before implementation.
That result shows that the purpose-built test distinguishes unimplemented
behavior; it does not establish an independently existing failure.
Do not preserve that TDD red/green chronology as commit-message evidence.
A regression test supplies causal evidence only when it reproduces a failure
established independently of the test's introduction,
such as an observed product failure or supported-boundary reproduction,
and the post-change result materially establishes the repair.

Measurements, real-boundary probes, and material validation gaps
earn space under the same standard.
A gap is material when an unresolved claim and its consequence
change how the reader should evaluate, use, or continue the change.
State that claim boundary and consequence;
do not turn unavailable evidence into an activity report.
Without a pre-change result, make no reproduction claim.

Omit routine test, formatter, linter, build, and patch-hygiene status.
Those results describe development activity rather than durable context.
For a test-only commit, explain the invariant the tests protect
and the previously unrepresented risk they make visible.
Test names and case inventories belong only when they define that boundary.

## Structure and format the stored message

Use the smallest structure that exposes the explanation.
A simple message may need one paragraph.
When several independent concerns matter,
use paragraphs, short headings, or a list so the reader can find them.
Use a list for an auditable set or for a sequence whose order matters,
not as a flat inventory of edits or commands.
One stable example can clarify a boundary;
additional examples should change what the reader understands.

A `Validation` section is optional.
Use it only when it carries claim-bearing evidence
or a material validation gap as defined above.
Map every retained result or gap to the claim it supports.
If no useful validation content remains, omit the heading and section entirely.
Do not place purpose-built TDD red/green results,
other test-first chronology, routine pass status,
or a command inventory under `Validation`.
Evidence can instead remain near its claim when a separate section
would make the relationship less clear.

Separate a body from the subject with a blank line.
Prefer body lines at or below 72 characters
and do not exceed 72 characters for divisible prose.
Start each complete body sentence on a new physical line.
Break a longer sentence at meaningful grammatical or structural boundaries,
not merely where the line becomes full.

Use inline code for identifiers, paths, flags, fields, and command names.
An indivisible identifier or link may exceed the line limit;
keep that exception local and wrap surrounding prose normally.
Put a complete command invocation in a code block
only when the invocation itself is durable, reproducible evidence.
Put multi-line output in a fenced code block
when its exact text materially supports the problem or result.
Place issue references and trailers after the explanatory body.
