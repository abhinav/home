# Prose writing

Use this guide when writing or substantially revising a prose artifact
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

Use `prose-formatting.md` for formatting conventions,
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

### Code shapes

When a named code entity is a material subject
of an explanation, recommendation, or comparison,
and established syntax conveys structure relevant to the reader,
lead with the smallest faithful code shape.
Treat established names, types, parameters, results, fields,
and their relationships as code structure
when the reader must distinguish them.
In that case, retain the relevant structure
and visibly elide unrelated or unestablished parts.
When this condition holds, prose alone is incomplete;
under brevity pressure, including a prose word limit,
elide more rather than replacing the shape with a prose enumeration.
Use prose alone only when syntax would expose
no relationship relevant to the reader.

Use a declaration, type fragment, call site,
or configuration fragment in the established language and syntax.
Retain relevant ownership boundaries.
Use real, evidence-backed names when describing existing code.
Preserve the source spelling and types of retained elements;
do not replace them with invented aliases or pseudocode.
When only part of a shape is established,
show the evidence-backed fragment
and mark the unknown or unrelated remainder with a language-native comment.
Introduce a proposed or illustrative fragment with a short label,
such as `Proposed shape:`, immediately before it.
Do not invent syntax for a language or API that is not established.

Use prose with the shape to explain semantics, constraints,
rationale, consequences, and other behavior the syntax does not express.
Apply the stable-name and plain-prose rule to that explanation.
Do not expose a lower-level mechanism merely because code exists for it.
When the reader needs the contract rather than the mechanism,
state the contract in prose.

### Executable demonstrations

Use an executable demonstration when the reader needs to follow usage,
branching, looping, or state-changing logic,
or see the verbatim representation of an input, output, or failure.
Preserve that executable shape instead of narrating each step in prose.
Use concrete code when the implementation syntax is established.
Use clearly labeled pseudocode
when the reader needs to follow executable logic
but implementation syntax is irrelevant or not established.
Treat pseudocode as a behavioral model,
not as an imitation of an unchosen programming language.
Use stable domain names,
one action or decision per line,
and indentation to expose branches, loops, and returns.
When the reader needs to distinguish several actors,
states, ownership boundaries, or structural alternatives,
use the corresponding visualization rather than forcing them into pseudocode.

Choose the smallest useful demonstration.
It may be illustrative, partial, or intentionally incomplete.
Omit setup, boilerplate, unchanged branches, or other details
only when they do not affect the demonstration's point.
Use an obvious elision marker
when an omission would otherwise be mistaken for complete code.
Identify non-runnable demonstrations.
State any limit that affects
how the reader can interpret or use the demonstration.

When a concrete demonstration makes a claim about actual behavior,
use real names and evidence-backed results.
Introduce necessary prerequisites before the demonstration.
Keep the same inputs and identifiers as the surrounding explanation.

Place the demonstration near the claim it establishes.
A demonstration may continue across nearby code blocks with prose between them
when that progression helps the reader follow the behavior.
Preserve identifiers, state, and execution order across those blocks
so their continuity is apparent.
Mark skipped steps or discontinuities
when they materially affect how the fragments relate.
Explain what the reader should observe
and why that observation answers the question,
and what the demonstration does not establish.
Use a language-tagged fenced block for multi-line code
and distinguish an invocation from its output.
Include credentials or sensitive values only when independently authorized
and necessary for the reader's task.

### Visualizations

Use a visualization when relationships,
state changes, ownership, or sequence
would be harder to evaluate in linear prose.
Identify the specific relationship the reader must recover,
then choose the smallest representation that exposes it:

- Use a table to compare repeated fields, mappings, or alternatives.
- Use a call tree to show nested runtime control flow from one entry point.
- Use a component tree to show UI containment
  and only the state or module boundaries relevant to that structure.
- Use a shallow file tree to show responsibility, containment,
  or the intended location of a broad refactor.
- Use a sequence diagram to show actor handoffs and causal order.
- Use a flow diagram to show branching control or data movement.
- Use a state diagram to show lifecycle phases and allowed transitions.
- Use a timeline to show operational events and recovery.

Mermaid is available by default only in conversational chat.
In an external or durable artifact,
use Mermaid only when the user explicitly requests Mermaid for that artifact.
A general request for a diagram does not supply that request.
When Mermaid is not permitted,
express the selected structure in plain text diagrams
or an established non-Mermaid artifact format.

Keep names, boundaries, and ordering consistent with the explanation.
Show only the actors, states, and relationships relevant to the question.
Introduce unfamiliar notation and explain what the reader should learn.
Use text labels and accompanying prose
so the meaning does not depend on color or appearance alone.
Place each visualization next to the claim it supports.
Do not repeat the same relationship in several visual forms
unless each form answers a distinct reader question.
When revising, retain an existing diagram or table only while it remains
the smallest useful representation and is easier to evaluate than prose.
Simplify the prose around a retained structure instead of flattening it.

### Changes to established shapes

When the point is what changes in an established code shape,
executable demonstration, or visualization,
use a `diff` view of the relevant structure.
Keep the nearest unchanged owner that identifies the changed elements:
the containing operation, call entry point, parent component,
or parent directory.

Show the complete relevant shape instead
when most of it is new,
when omitted context would hide ownership or order,
or when the reader needs a copyable target.

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

## Tests

When changing this guide, read [tests/README.md](tests/README.md).
Run the applicable prose-writing scenarios with fresh subagents
that have empty context windows.
