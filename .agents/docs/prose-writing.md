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
When an important concept is unfamiliar, explain the need it answers, give its stable name,
show what it represents or does, and state its material limits.

## Keep referents stable

The writer and reader should both be able to identify
what each sentence refers to.
Reuse a stable, real name when the same entity remains the subject.
Repetition is preferable to a synonym, generic title,
or polished variation that makes identity ambiguous.

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

## Make causes and boundaries visible

Explain what initiates a behavior, which actor performs each action,
how state changes, and what consequence the reader can observe.
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
under brevity pressure, shorten the shape by eliding more
rather than replacing it with a prose enumeration.
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
Do not expose a lower-level mechanism merely because code exists for it.
When the reader needs the contract rather than the mechanism,
state the contract in prose.

### Executable demonstrations

Use an executable demonstration when the reader needs to follow usage,
branching, looping, or state-changing logic,
or see the exact representation of an input, output, or failure.
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
Identify the exact relationship the reader must recover,
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
Define an unfamiliar acronym, unit, or term on first material use.

Introduce new information progressively.
Keep directly related context near the claim it supports.
Use a short list to group related items
when their execution relationship is not the point.

Choose implementation specificity by its effect on the reader's task.
Include a method, helper, library call, algorithm,
or other low-level mechanism
when the reader must understand, evaluate, reproduce,
or safely change that detail.
Otherwise explain the behavior, contract, invariant,
input, output, or user-visible effect
and omit the lower-level mechanism.

After a dense sequence, state the consequence or reusable mental model.
Remove remaining implementation details, repeated claims, and process narration
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
- understand what each retained code shape, executable demonstration,
  or visualization establishes;
- recognize any material uncertainty, exception, or validation gap;
- confirm that simplification preserved the claim's material distinctions;
- use the explanation without access to the conversation; and
- apply its central conclusion to the reader's task.

Remove requirements that do not apply to the artifact.
A concise, accurate answer is sufficient
when it already establishes what the reader needs.

## Tests

When changing this guide, read [tests/README.md](tests/README.md).
Run the applicable prose-writing scenarios with fresh subagents
that have empty context windows.
