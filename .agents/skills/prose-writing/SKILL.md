---
name: prose-writing
description: >
  Use for conversational explanations of how or why something works, happened,
  changed, or follows from evidence; or when writing or substantially revising
  reader-facing prose outside the current conversation, including
  documentation, design documents, incident reports, pull request
  descriptions, commit messages, release notes, application copy, generated
  reports, and substantive documentation or implementation comments. Comment
  length does not determine whether this applies. Do not use for
  formatting-only edits, fact-only answers, or trivial same-scale comments.
---

# Prose writing

Use this skill when writing or substantially revising a prose artifact
for readers outside the current conversation.
This includes documentation, design documents, incident reports,
pull request descriptions, commit messages, release notes,
application copy, generated reports,
and substantive documentation or implementation comments.
Also use it for a conversational explanation
when the user is trying to understand how or why something works,
happened, changed, or follows from the available evidence.
Comment length does not determine whether the guide applies.
A trivial same-scale comment does not load this guide merely because it is prose.

Load `$prose-formatting` for formatting conventions,
and apply any provided artifact-specific guidance
for the type of prose you are writing.

A formatting-only edit does not require this guide.

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

The reader does not have access to the conversation, the writer's investigation,
or unstated implementation history.
Include the context needed to understand the artifact independently.
Omit background that does not affect the reader's task.

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
Use an ordered timeline when several actors, state transitions,
or events are needed to explain the outcome.

## Introduce prerequisites before using them

Identify the concepts the reader must understand
before an explanation or decision becomes meaningful.
Useful prerequisites can include an actor, the relevant system boundary, baseline behavior,
a lifecycle phase, a domain term, a unit, an input, or an established invariant.

Introduce only the prerequisites needed for the reader's task.
Present each prerequisite before reasoning that depends on it.
When an important prerequisite is unfamiliar,
explain its role and material limits before reasoning from it.
Apply the naming rule below to its name and definition.

## Keep names stable and the prose plain

Start with established names and common words.
Keep an established technical name when it identifies a code entity, state,
operation, protocol, or domain distinction
that the reader must connect to the source or another representation.
Preserve its spelling and use it consistently.
When the same thing remains the subject, reuse its name or a clear pronoun;
do not rename it with a synonym, role, behavior, or generic noun
merely to vary the prose.

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

For example, write `` `Builder.Read` reads the configuration and returns steps;
`Runner.Run` later runs them without reading it again.``
Do not rename the steps as a `result` or `handle`, or call this
`configuration-bound planning and plan-governed execution`,
unless the reader must use or compare that term.

When no stable name exists or the name does not matter,
describe the precise role or behavior instead of inventing a label.

Treat the source claim as a correctness constraint.
Before simplifying, identify each material actor, action, object, condition,
scope, modality, consequence, state, and destination.
An actor is material when different actors perform actions
or own outcomes that the reader must distinguish.
A rewrite is correct only when the reader can recover those distinctions
from the artifact and the context available at its reading site,
without relying on the writer's unstated intent.
Keep an established name when a synonym or grammatical transformation
would change the represented entity, state, destination, or boundary.

Before returning, replace each added technical phrase or summary
that does not meet a reason above with an established actor and common action.
Remove an opening or closing classification
when the direct relationship already explains it.

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

## Match the medium to the structure

Choose the medium that preserves the structure
the reader must understand, verify, or use.

When explaining a named code entity whose syntax carries relevant structure,
demonstrating executable logic,
showing relationships or state changes,
or comparing changes to an established shape,
read `references/technical-representations.md` for code shapes,
executable demonstrations, visualizations, and structural diffs.

## Manage cognitive load

Give each paragraph one explanatory job.
Use concrete subjects and actions
that identify what changes and who changes it.

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

Introduce new information progressively.
Keep directly related context near the claim it supports.
Use a short list to group related items
when their execution relationship is not the point
and the reader does not need aligned comparison, mapping, or repeated fields.

Choose implementation specificity by its effect on the reader's task.
Include a method, helper, library call, algorithm,
or other low-level mechanism
when the reader must understand, evaluate, reproduce,
or safely change that detail.
Otherwise explain the behavior, contract, invariant,
input, output, or user-visible effect
and omit the lower-level mechanism.

After a dense sequence, state the consequence or reusable mental model
with established names and common words.
After retaining each required code shape, executable demonstration,
and visualization,
remove remaining implementation details, repeated claims, and process narration
that do not help the reader's decision.
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

Include evidence when it reduces a relevant uncertainty.
Omit command inventories, routine validation, speculative alternatives,
and unrelated investigation history
unless they change what the reader should conclude or do.

## Scale the explanation to the artifact

Choose the length and structure required by the reader's task:

- A release note can state one observable change in one sentence.
- A short answer can give the decision and its material qualification.
- A reviewer explanation can establish prior behavior, changed behavior, scope,
  and useful evidence.
- An incident handoff can state current health,
  the causal sequence, recovery evidence, and remaining unknowns.
- A design document can explain the problem, decision, material alternatives,
  constraints, and consequences.

Add background, examples, chronology, or additional structure
only when they improve that artifact.
Follow the requested format, the established reader context,
and the applicable artifact-specific contract.

## Review the finished explanation

Before returning external prose, check that the reader can:

- identify the answer, decision, or observed consequence;
- understand necessary terms before the explanation relies on them;
- follow important causes, actor handoffs, and state transitions;
- identify which behavior changed and which relevant behavior did not;
- distinguish observed evidence from inference or future work;
- find each code shape, executable demonstration, visualization,
  and established technical name needed for the reader's task;
- understand what each retained representation establishes
  through stable names and plain surrounding prose;
- recognize any material uncertainty, exception, or validation gap;
- confirm that simplification preserved the claim's material distinctions;
- recover each material relationship
  without unpacking a coined modifier
  or ignoring a clearer clause that already states it;
- find no precision or emphasis word
  whose deletion would leave the claim unchanged;
- use the explanation without access to the conversation; and
- apply its central conclusion to the reader's task.

Remove requirements that do not apply to the artifact.
A concise, accurate answer is sufficient
when it already establishes what the reader needs.
