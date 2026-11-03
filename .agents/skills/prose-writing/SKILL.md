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
Judge clarity and brevity by what the reader can recover and the effort required,
not polish or word count; keep more words when they make meaning easier to recover.
For durable artifacts or source-style chat, load `$prose-formatting`.
Apply provided guidance for the artifact type.

## Establish the reader's task

Before drafting, identify the intended reader, prior knowledge,
what they need to decide, do, explain, or predict, and the artifact's boundary.
Write for that observable outcome:

| Artifact | Reader needs |
| --- | --- |
| On-call handoff | Current health, unknowns, and evidence for the next decision |
| Reviewer explanation | Affected behavior, why it changes, and unchanged behavior |
| Application copy | The user's task and the information or action needed next |

Outside the conversation, supply context independent of the discussion,
the investigation, and unstated implementation history.
In chat follow-ups, answer the remaining question using established context;
reintroduce context only to interpret the answer or its limits.
Omit background that does not affect the task.
Scale detail accordingly: a release note may need one sentence;
a design document may need alternatives, constraints, and consequences.
When revising, preserve facts and the author's useful voice.
Warmth, humor, and directness may serve the reader;
generic praise and reassurance need a reason to remain.

## Choose and revise the representation

Before drafting, choose the smallest useful form that exposes the relationships
without requiring readers to assemble separate passages:

| Reader's task | Useful form |
| --- | --- |
| Understand one claim and its reason or qualification | A sentence or short paragraph |
| Scan independent findings, requirements, or actions | A short unordered list |
| Follow a serial procedure where order matters | Numbered steps |
| Compare common fields, alternatives, or condition/action mappings | A table |
| Inspect a named code entity, usage, or executable logic | A faithful code shape or demonstration |
| Trace handoffs, branches, state changes, hierarchy, or dependencies | A diagram, timeline, or tree |
| Assess quantities, trends, or variation | A chart when data supports it; a table for individual values |

Align shared dimensions for comparisons and condition/action mappings.
Show branches or handoffs across actors together in a sequence, flow,
or state representation.
When a decision depends on normal and exceptional behavior diverging,
show each relevant path through its consequence.
A short single-path sequence can use numbered steps.
Draft the structure first, then supporting prose for the answer, interpretation,
conditions, and evidence it does not convey.
Remove narration the form replaces.
Use prose alone when it conveys the relationship directly
and another form adds decoding effort or ceremony.
There is no visual quota; one sentence can be complete.
Honor the requested format and destination capabilities.

Add another representation only for another reader question.
A policy table shows the action for a state;
a sequence shows how that state is reached.
Use both when the reader needs both and one form cannot expose them.
Prefer a compact form when it shows the same relationship.

For named code structure, executable logic, tables, lists, diagrams,
or changes to established shapes, read
[Technical representations](references/technical-representations.md)
for faithful construction, format constraints, and revision.
Its code-shape requirements apply under brevity pressure.

On substantive revision, keep, replace, simplify, or remove each representation
according to the reader's task.
Restructure buried relationships; preserve useful code, tables, lists, and diagrams,
and trim duplicative prose.
Existing paragraphs are not a format requirement unless the user makes them one.
When adapting chat to an external artifact, carry forward useful structure,
supply the new reader's context, and use a form the destination renders.

## Lead with the answer and expose causes

Begin with the needed conclusion, observed behavior, decision,
or practical consequence, then the context needed to evaluate it.
For causal explanations, select the applicable elements:

1. Relevant system and motivating problem.
2. Prior behavior or baseline.
3. Causal sequence producing the important consequence.
4. Changed behavior or proposed decision.
5. Material scope, tradeoffs, exceptions, and unchanged behavior.
6. Evidence and material verification gaps.

This is a selection tool, not a required heading or paragraph sequence.
Combine elements when one sentence carries the task.
Before reasoning from actors, baselines, terms, units, inputs, or invariants,
introduce what the reader needs, including unfamiliar prerequisites' roles and limits.
Use the naming rules below for names and definitions.

Show what initiates behavior, who acts on what, how state changes,
and what consequence the reader observes.
Show boundaries through established actors and actions on each side;
use the word "boundary" only when established or needed for naming or comparison.
Keep event order and actor handoffs clear.
For a sequence, first draft one clause per distinct action,
naming its known relevant actor, affected object, governing condition,
and established resulting state or destination.
Only then shorten details irrelevant to the task.

When an example helps establish a sequence, use one small representative example
throughout, with stable actors, identifiers, inputs, units, and meanings.
Change one relevant condition at a time
so readers can attribute changed outcomes to their causes.
Identify the operation, caller, component, or lifecycle to which behavior applies.
State a nearby unchanged path when that distinction affects the decision.
Label proposed or future behavior; do not present it as implemented or observed.

## Preserve names and source meaning

Start with established names and common words.
Keep the spelling of a technical name identifying a code entity, state, operation,
protocol, or domain distinction the reader must connect to a source or representation.
For the same subject, reuse its name or a clear pronoun;
do not substitute a synonym, role, behavior, or generic noun merely for variety.
A general noun such as "the result" must refer clearly within its paragraph
or the preceding one.
Repeat the name if readers would search farther back,
including sections they may enter directly.
When no stable name exists or matters, describe the precise role or behavior
rather than inventing a label.

Use another technical term only if the reader must use or search for it,
common words lose a material distinction,
or a familiar term helps the intended reader explain, predict, or compare behavior.
For a needed unfamiliar term, explain the behavior in common words first,
then give its established name; do not make it the opening sentence's subject.
If the question asks about the name,
or readers must locate or use it before the behavior can be explained,
lead with it and immediately define it in common words.
Define unfamiliar acronyms, units, and terms on first use.
Audience expertise, artifact type, or incidental source jargon alone
does not justify introducing a technical term.
Do not import properties or consequences absent from the source.

Keep the source's plain nouns and verbs when they carry the relationship.
State its actors, actions, timing, and results,
connecting those facts in common words when useful.
Do not replace a plain source verb with a technical one,
turn relationships into categories,
infer purposes, or strengthen claims.
Prefer `Only five uploads run at once` and
`` `Retry` returns the existing upload`` to
`upload concurrency` and `idempotent retry semantics`.

Before accepting each rewrite, compare its source's actor, action, object,
conditions, scope, and consequence,
including conditions from headings, list introductions, and table labels.
Preserve whether it is a fact, possibility, permission, requirement, or proposal
when changing grammar or form.
Keep distinct actors, states, destinations, and established names distinct.
If missing facts prevent a faithful rewrite, retain uncertainty
or identify the needed information; do not complete the story by inference.

## Reduce reading effort

Give each paragraph one job and each sentence a purpose:
help the reader understand, act, or connect with the author.
Keep subject and action recognizably close,
and modifiers or conditions beside the actions or objects they govern.
Split distinct thoughts or nested conditions into separate sentences,
while keeping related ideas together.
Use "because," "so," or "if" when they clarify relationships.

Prefer syntax exposing relationships to labels implying them.
Use compound modifiers only when familiar or established to readers,
never coined for brevity or technical tone.
If a modifier hides who acted, the source, comparison, recipient, protected object,
or applicable limit, put the main noun early
and express the relationship with a verb or preposition.
Replace unfamiliar compounds and remove modifiers duplicating a clause.
Appearance in a draft does not establish a modifier as familiar.

Remove precision or emphasis words when deletion leaves scope, strength,
and required correspondence unchanged.
Retain them for required matches with values, order, paths, quotations,
identifiers, or other stated constraints.
Include low-level methods, helpers, calls, or algorithms
when the reader must understand, evaluate, reproduce, or safely change them.
Otherwise explain behavior, contracts, invariants, inputs, outputs,
or user-visible effects and omit the mechanism.

After a dense sequence, add a consequence only to answer a remaining question.
Keep an already clear consequence or recommendation in one place with its conditions.
If a requested limit cannot preserve the claim,
keep the meaning and state the conflict rather than silently changing it.

## Match evidence to claims

State what retained observations establish.
Distinguish observations, supported inferences, recommendations,
simulated tests, and live behavior.
A unit test establishes exercised behavior, not rollout or live recovery;
deployment submission does not establish readiness.
State missing validation, unknown causes, or unspecified owners
when material to the decision.

For measures such as "high," "fast," or "significant,"
give a useful number, comparison, or condition.
If none is established, state what was observed.
Attribute opinions when the reader needs that person's judgment;
do not convert them to measurements or repeat them for emphasis.
Include evidence that reduces relevant uncertainty.
Omit command inventories, routine validation, speculative alternatives,
and unrelated investigation history unless they change the conclusion or action.

## Review the explanation

Check each sentence against its source and nearby context
using the meaning and naming rules above.
Read the whole draft as its reader:
can they find the point, follow causes, compare cases,
and act without reconstructing context?
Check that representations still expose required relationships
and the author's useful voice survives.

Remove stock openers, generic praise, closing claims of value,
and summaries when they add only importance, completion, or repetition.
Keep contrasts needed to distinguish real alternatives or correct plausible
misunderstandings; otherwise state the claim directly.
A sentence that could appear unchanged in an unrelated document
needs a specific subject and reason to remain.
Apply that test to headings, bold labels, lists, and tables:
each should help readers find, compare, or use information.

For long drafts, inspect repeated content words and short phrases in context.
Remove repeated ideas and replace catch-all nouns with their subjects;
keep useful repetition of established names.
Leave clear, specific, faithful text alone.
Return the requested prose first;
add an editing note only when missing evidence or unresolved meaning affects use.
