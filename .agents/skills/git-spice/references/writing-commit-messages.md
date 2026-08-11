# Writing commit messages

## The message preserves durable context

A commit message addresses two readers:
a reviewer deciding whether the change makes sense now
and a future maintainer encountering it through history, blame, or bisect.
It preserves the durable explanation for one coherent change.

The subject helps those readers find and distinguish the change.
The body preserves the problem, decision, constraint, or boundary
that the final tree cannot explain by itself.
A useful message contains the context whose loss would make the change
harder to evaluate, modify, revert, or rediscover.

## Write for the reader in history

Start by identifying the change as one outcome rather than a collection
of edited files.
The subject should name a stable area when that helps discovery
and state the distinguishing result in imperative form.
Repository-local prefixes and scopes can help readers route or search,
but they cannot substitute for a meaningful result.

Use a scope that already identifies the affected system, package, component,
or user-facing area.
A newly introduced name usually belongs in the summary rather than the scope
because readers could not have searched for it before this change.
When no scope improves discovery, a plain imperative summary is sufficient.

Prefer a subject shorter than 50 characters
and keep it at or below 72 characters.
When shortening a subject, preserve the terms a future reader would use
to recognize the affected behavior and distinguish this change from nearby
history.

The body should give the reader the information needed to understand
why the outcome belongs in the repository.
Expect to write a body because a subject rarely preserves both the outcome
and why it belongs now.
Depending on the change, that may be the prior condition and its consequence,
the behavior or invariant that now holds,
a non-obvious design constraint or tradeoff,
or a boundary that prevents the reader from drawing a broader conclusion.
These are possible parts of one explanation, not required sections.

The information-loss test determines what belongs:
if the body disappeared while the reader retained the final diff and
surrounding code, what important knowledge would be lost?
When the answer appears to be nothing material,
first determine whether the change's purpose or decision context is missing.
The issue, request, or repository history often explains why a seemingly
mechanical change belongs now.
A subject-only message is complete only when the subject and final tree
already preserve the purpose, consequence, and decision context.
A body earns its place by adding that context,
not merely by satisfying a format.

Compare two dependency updates with the same version diff.
For a scheduled refresh governed by a patch-adoption policy,
the body can preserve that selection criterion without narrating the lockfile.
If the version was selected to avoid a particular corruption bug,
the body instead preserves that failure and why the selected version matters.
The mechanics are alike;
the decision that future readers need is different.

Lead the body with the consequence or reason the reader needs.
Introduce the affected system, baseline behavior, actors, and unfamiliar terms
before reasoning that depends on them.
Include implementation details when they expose a constraint, compatibility
concern, surprising choice, or review boundary;
otherwise let the diff carry them.

Issues, plans, experiments, logs, and prior history can establish motivation
or constraints that the diff omits.
Retain only what this commit needs to remain self-contained;
an issue reference supports traceability but cannot supply the explanation.

If the change is one step in a larger effort,
describe the larger path only far enough to locate this commit's responsibility.
Intended follow-up work remains context rather than present behavior.
Supplied facts earn space because the reader needs them,
not merely because they were available to the writer.
The message is not a record of every risk category the writer considered.
A boundary carries information when it narrows a claim the message already
makes.
Read the explanation without the boundary:
if the remaining message would not support the broader interpretation,
the negation has no claim to limit and preserves no durable context.
When the available evidence does not establish the motivation or boundary,
preserve the uncertainty or ask for the missing context rather than inventing
a plausible story.

Difficulty describing one coherent outcome can reveal a commit-boundary
problem and is a signal to re-examine the boundary,
not to manufacture a broad narrative for unrelated changes.

## Preserve evidence that history cannot reconstruct

Evidence belongs in a commit message when it preserves something the final
change cannot show and materially changes how a reader evaluates the claim.
The useful question is not what commands ran,
but what the investigation established that would otherwise be lost.

Preserve evidence at the fidelity needed to carry that durable context.
When compact observed input or output motivated the change,
preserve it verbatim instead of reducing it to a summary.
Its original form retains authoritative wording and searchable evidence
that the final tree cannot provide.
When raw evidence is long, noisy, or sensitive,
keep the smallest safe, self-contained portion that preserves material
wording, structure, thresholds, and search terms.
Paraphrase when the evidence's exact form adds nothing to the conclusion.

A final regression test shows that coverage exists.
It does not show that the test reproduced the original failure before the fix.
When that before-and-after sequence establishes the causal connection,
preserve it beside the behavior it supports.
Measurements, real-boundary observations, and material validation gaps earn
space for the same reason when they change the reader's conclusion.

Evidence controls the strength of the claim the message can make.
When an observation is unavailable,
omit or narrow the unsupported claim rather than turning the missing
observation into an activity report.
An absence belongs in the message only when the unresolved uncertainty itself
changes how a reader should evaluate, use, or continue the change.
Without a pre-fix regression result,
the message simply has no reproduction claim to preserve.
The shape of a material gap is the unresolved claim and its consequence.
Lower-level checks already visible in the final tree do not define that gap
merely by contrast.

Routine successful results describe the final development state rather than
durable context for the change.
Listing tests, formatters, linters, or patch-hygiene commands records activity
without explaining the outcome.
Evidence should appear near the claim it establishes.

For a test-only commit,
the useful explanation is the behavior or invariant the test protects
and the previously unrepresented risk it makes visible.
The number or names of added cases matter only when they define that boundary.

## Keep the message proportional and self-contained

Readers scan the body for the reason, changed behavior, boundaries, and evidence
before reading every sentence.
Structure maps those ideas rather than decorating them or imposing a template.
Each paragraph should make one meaningful change to the reader's model.
When a body carries several independent concerns,
short headings can make each concern findable,
and lists can expose an auditable set or a sequence whose order matters.
A simple message may need only one paragraph;
a dense paragraph that hides several concerns is not simpler for its reader.
After a dense causal sequence,
state the resulting behavior or invariant the reader should retain.
One stable example can clarify a causal boundary;
additional examples should change what the reader understands.

Use objective language and stable names.
Distinguish observed behavior from inference,
and preserve meaningful limitations or unresolved questions.
Generic benefits such as reliability, cleanup, or maintainability add no
meaning when the message cannot identify the concrete behavior or constraint
they name.

## Format stored messages

Separate a body from the subject with a blank line.
Use inline code for identifiers, paths, flags, fields, and command names.
Put a complete command invocation in a code block when the invocation itself
is evidence the reader may need to reproduce.
Put multi-line output in a fenced code block when its exact text is durable
evidence for the problem or result.
Place issue references and trailers after the explanatory body.
