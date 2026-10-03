---
name: prose-writing
description: >
  Use for substantive explanations, comparisons, proposals, and multi-part
  answers in conversational chat; or when writing or substantially revising
  reader-facing prose outside the current conversation, including
  documentation, design documents, incident reports, pull request
  descriptions, commit messages, release notes, application copy, generated
  reports, and substantive documentation or implementation comments. Comment
  length does not determine whether this applies. Do not use for
  formatting-only edits, bare factual lookups, or trivial same-scale comments.
---

# Prose writing

Write so the reader understands the point on the first reading
and can use it for the task at hand.
Plain English may need more words than compressed prose.
Clarity depends on what the reader can recover, not on how polished the text sounds.

For durable artifacts or chat that requests source-style prose,
load `$prose-formatting` for source conventions.
Apply any provided artifact-specific guidance for the type of prose you write.

## Establish the reader's contract

Before drafting, identify the intended reader, what the reader already knows,
what the reader needs to decide, do, explain, or predict, and the boundary of the artifact.

Write for that observable outcome.
An on-call handoff should establish current service health, what remains unknown,
and the evidence needed for the next decision.
A reviewer-facing explanation should establish the affected behavior,
why it changes, and what remains unchanged.
Application copy should identify the user's task
and provide the information or action the user needs next.

For an artifact read outside the conversation,
include the context needed to understand it independently of the discussion,
the writer's investigation, and unstated implementation history.
For a chat follow-up, build on the established context
and answer the remaining question.
Reintroduce context only when needed to interpret that answer or its limits.
Omit background that does not affect the reader's task.

Scale the explanation to that task.
A release note may need one sentence;
a design document may need alternatives, constraints, and consequences.
When revising, preserve the author's useful voice as well as the facts.
Warmth, humor, and directness can serve the reader;
generic praise and reassurance need a reason to remain.

## Match the medium to the structure

Choose the representation before drafting.
Use a form that lets readers see the relationships they need
without assembling them from separate passages.

Identify what the reader must recover, then choose the smallest useful form:

| Reader's task | Useful form |
| --- | --- |
| Understand one claim and its reason or qualification | A sentence or short paragraph |
| Scan independent findings, requirements, or actions | A short unordered list |
| Follow a serial procedure where order matters | Numbered steps |
| Compare common fields, alternatives, or condition/action mappings | A table |
| Inspect a named code entity, usage, or executable logic | A faithful code shape or demonstration |
| Trace handoffs, branches, state changes, hierarchy, or dependencies | A diagram, timeline, or tree |
| Assess quantities, trends, or variation | A chart when the data supports it; a table for individual values |

For a comparison or condition/action mapping,
align the shared dimensions so the reader can inspect each case in one place.
For a process whose explanation depends on branches or handoffs across actors,
show those relationships together in a sequence, flow, or state representation.
When a decision depends on where normal and exceptional behavior diverge,
show that divergence and carry each relevant path through to its consequence.
A short, single-path sequence can use numbered steps.
Draft that structure first, then write the prose needed to interpret it.
Use prose alone when it carries the relationship directly
and another form would add decoding effort or ceremony.
There is no visual quota, and a short answer can be complete as one sentence.
Honor the reader's requested format and the destination's capabilities.

Use supporting prose for the answer, interpretation, conditions,
and evidence the representation does not convey.
Remove narration the chosen form replaces,
and prefer a compact form when it shows the same relationship.
Add a separate representation only for a separate reader question.
A policy table explains which action applies to a state;
a sequence explains how the system reaches that state.
Use both when the reader needs both answers and one form cannot expose them.

When the task involves named code structure, executable logic,
tables, lists, diagrams, or a change to an established shape,
read [Technical representations](references/technical-representations.md)
for faithful construction, format constraints, and revision.
The code-shape requirements there still apply under brevity pressure.

On a substantive revision, choose whether to keep, replace, simplify,
or remove each representation according to the reader's task.
Restructure passages whose relationships remain buried;
preserve useful code, tables, lists, or diagrams and trim prose that duplicates them.
Existing paragraph form is not a format requirement unless the user makes it one.
When adapting a chat explanation into an external artifact,
carry forward the useful explanatory structure, supply the new reader's context,
and use a form the destination can render.

## Lead with the useful answer

Begin with the conclusion, observed behavior, decision, or practical consequence the reader needs.
Then introduce the context required to evaluate that conclusion.

For a causal explanation, use the applicable elements of this arc:

1. Identify the relevant system and the motivating problem.
2. Establish the prior behavior or baseline.
3. Show the causal sequence that produces the important consequence.
4. Explain the changed behavior or proposed decision.
5. State material scope, tradeoffs, exceptions, and unchanged behavior.
6. Present evidence and material verification gaps.

Treat the arc as a selection tool, not a required sequence of headings or paragraphs.
Combine elements when a sentence can carry the reader's entire task.

## Introduce prerequisites before using them

Introduce the actors, baseline behavior, terms, units, inputs,
or invariants the reader needs before reasoning from them.
Explain an unfamiliar prerequisite's role and relevant limits.
Use the naming rules below for its name and definition.

## Keep names stable and the prose plain

Start with established names and common words.
Keep an established technical name when it identifies a code entity, state,
operation, protocol, or domain distinction
that the reader must connect to the source or another representation.
Preserve its spelling and use it consistently.
When the same thing remains the subject, reuse its name or a clear pronoun;
do not rename it with a synonym, role, behavior, or generic noun
merely to vary the prose.
Check what a general noun such as "the result" or "this change" refers to
in its paragraph or the one before it.
Repeat the name when a reader would have to search farther back,
including in a section that readers may reach directly.

Use another technical term only when the reader must use or search for it,
common words would lose a material distinction,
or a term familiar to the intended reader
helps them explain, predict, or compare the behavior.
When a needed technical term is unfamiliar to the reader,
do not make it the subject of the opening sentence.
First explain the behavior or relationship in common words,
then give its established name.
When the question asks about that name,
or the reader must locate or use it before the behavior can be explained,
lead with the name and define it immediately in common words.
Do not import properties or consequences that the source does not establish.
Audience expertise, artifact type, and incidental source jargon
do not justify it by themselves.
Define an unfamiliar acronym, unit, or term in common words on first use.

State the source claim with its plain actors, actions, timing, and results.
Keep the source's plain nouns and verbs when they already carry the relationship.
Build understanding by connecting those facts in common words when useful.
Do not replace a plain source verb with a technical verb,
turn the relationship into a category,
infer a purpose, or strengthen the claim.
Prefer `Only five uploads run at once` and
`` `Retry` returns the existing upload`` to
`upload concurrency` and `idempotent retry semantics`.

When no stable name exists or the name does not matter,
describe the precise role or behavior instead of inventing a label.

Check each rewritten sentence against its source before accepting it.
Compare who acts, what happens, to which object, under which conditions,
and with what scope and consequence.
Include conditions introduced by headings, list introductions,
and table labels in that comparison.
Check whether the source states a fact, possibility, permission,
requirement, or proposal; preserve that force when changing grammar or format.
A smoother sentence can change the instruction or strengthen the claim.
Keep distinct actors, states, destinations, and established names distinct.
If a missing fact prevents a faithful rewrite, retain the uncertainty
or identify the information needed; do not complete the story by inference.

## Make causes and boundaries visible

Explain what initiates a behavior, which actor performs each action,
how state changes, and what consequence the reader can observe.
Show a boundary through the established actors and actions on each side.
Call it a boundary only when that is an established name
or the reader must name or compare it.
Keep event ordering and actor handoffs clear.
For a sequence, first draft one clause for each distinct action.
Each clause names its known, relevant actor and affected object,
keeps a condition with the action it governs,
and uses the established name for the resulting state or destination.
Only then shorten details that do not affect the reader's task.

When an example helps establish that sequence, use one small representative example throughout.
Keep its actor names, identifiers, inputs, units, and meanings stable.
Change one relevant condition at a time
so that the reader can attribute the changed outcome to its cause.

Identify which operation, caller, component, or lifecycle the behavior applies to.
State a nearby unchanged path
when the distinction affects the reader's decision.
Describe a proposed or future behavior as such;
do not present it as already implemented or observed.

## Manage cognitive load

Give each paragraph one job.
Each sentence should help the reader understand, act, or connect with the author.
Make sentences easy to follow on the first reading.
Keep the subject and its action close enough to recognize together,
and place a condition or modifier next to the action or object it describes.
Split distinct thoughts or nested conditions into separate sentences,
while keeping closely related ideas together.
Use words such as "because," "so," and "if"
when they make the relationship easier to follow.
Judge brevity by the reader's effort, not just the word count;
keep a few more words when they make the meaning easier to recover.

Prefer syntax that shows a relationship over a label that merely implies it.
Use a compound modifier only when readers will recognize it
as a familiar or established term;
do not coin one merely for brevity or technical tone.
When a modifier obscures who acted, the source used, what was compared,
who receives the result, which object is protected,
or what condition or limit applies,
put the main noun early and state the relationship with a verb or preposition.
During revision, replace unfamiliar compounds
and remove any modifier whose relationship a clause already states.
Do not treat a modifier as established merely because it appears in a draft.

Every precision or emphasis word must alter the claim.
Remove one when deleting it leaves the claim's scope,
strength, and required correspondence unchanged.
Retain it when it identifies a required match with a value,
order, path, quotation, identifier, or another stated constraint.

Choose implementation specificity by its effect on the reader's task.
Include a method, helper, library call, algorithm,
or other low-level mechanism
when the reader must understand, evaluate, reproduce,
or safely change that detail.
Otherwise explain the behavior, contract, invariant,
input, output, or user-visible effect
and omit the lower-level mechanism.

After a dense sequence, state a consequence only if it answers
a question the sequence leaves unresolved.
Keep an already clear consequence or recommendation
in one place with its conditions.
When a requested limit cannot preserve the claim,
keep the required meaning and state the constraint conflict
instead of silently changing the claim.

## Match evidence to the claim

State what each retained observation establishes.
Distinguish an observed fact, a supported inference, a recommendation,
a simulated test, and live operational behavior.

Describe the verification boundary accurately.
A passing unit test establishes the behavior it exercises;
it does not establish a production rollout or live recovery.
A deployment submission does not establish service readiness.
State a missing validation, unknown cause, or unspecified owner
when it materially affects the decision.

For a measure such as "high," "fast," or "significant,"
give the number, comparison, or condition that makes it useful.
If none is established, state what was observed.
Attribute an opinion when the reader needs that person's judgment;
do not turn it into a measurement or repeat it merely to add emphasis.

Include evidence when it reduces a relevant uncertainty.
Omit command inventories, routine validation, speculative alternatives,
and unrelated investigation history
unless they change what the reader should conclude or do.

## Review the finished explanation

Check each sentence against its source and nearby context
using the meaning and naming rules above.
Then read the whole draft as the intended reader:
can they find the point, follow the causes, compare the cases,
and act without reconstructing missing context?
Check that the chosen representations still expose the required relationships
and that the author's useful voice survived the edit.

Remove phrases that add only a tone of importance or completion:
stock openers, generic praise, a closing claim of value,
or a summary that repeats an already clear point.
Keep a contrast when the reader needs to distinguish real alternatives
or correct a plausible misunderstanding.
Otherwise state the claim directly.
A sentence that could appear unchanged in an unrelated document
needs a specific subject and reason to remain.
Apply the same test to headings, bold labels, lists, and tables:
each should help the reader find, compare, or use information.

For a long draft, inspect repeated content words and short phrases in context.
Remove repeated ideas and replace catch-all nouns with what they name.
Keep established names stable; repeated names are often useful.
If the text is already clear, specific, and faithful, leave it alone.
Return the requested prose first, with an editing note only when
missing evidence or an unresolved meaning affects its use.
