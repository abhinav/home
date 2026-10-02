# Technical representations

## Code shapes

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

## Executable demonstrations

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

## Tables and lists

Give a table one comparison or lookup task.
Use the same dimensions across peer rows and short, parallel cell contents.
Keep a condition with the action it limits.
Put a shared prerequisite beside the table when it governs several rows;
do not bury it in a later section.
Keep unknown values visibly unknown rather than filling them by inference.

A cell that needs a separate causal explanation usually belongs beside
the table as a short explanation or sequence.
Retain the qualification needed to interpret the cell itself.
Use bullets for independent items, with one scannable point per item.
Use numbered steps for required order, not merely to enumerate peers.
Paragraphs with bullet markers still impose the same reading work.

## Diagrams

For a diagram selected under the main skill's medium decision,
choose the form that exposes its specific relationship:

- Use a call tree to show nested runtime control flow from one entry point.
- Use a component tree to show UI containment
  and only the state or module boundaries relevant to that structure.
- Use a shallow file tree to show responsibility, containment,
  or the intended location of a broad refactor.
- Use a sequence diagram to show actor handoffs and causal order.
- Use a flow diagram to show branching control or data movement.
- Use a state diagram to show lifecycle phases and allowed transitions.
- Use a timeline to show operational events and recovery.

Use position, connection, or enclosure to carry a relationship.
Keep labels short enough to follow the path;
placing the original paragraphs inside boxes does not expose their structure.
Show alternate outcomes as alternatives, not as successive events.
Mark an unknown or proposed connection as such;
an arrow asserts a relationship just as a sentence does.

Mermaid is available by default only in conversational chat.
In an external or durable artifact,
use Mermaid only when the user explicitly requests Mermaid for that artifact.
A general request for a diagram does not supply that request.
When Mermaid is not permitted,
express the selected structure in plain text diagrams
or an established non-Mermaid artifact format.
When a chosen format does not render, replace it with a compatible form
that preserves the relationships.
Return the requested explanation with the replacement in place;
return only the visual when that is the requested scope.

Keep names, boundaries, and ordering consistent with the explanation.
Show only the actors, states, and relationships relevant to the question.
Introduce unfamiliar notation and explain what the reader should learn.
Use text labels and accompanying prose
so the meaning does not depend on color or appearance alone.
Place each visualization next to the claim it supports.

## Changes to established shapes

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
