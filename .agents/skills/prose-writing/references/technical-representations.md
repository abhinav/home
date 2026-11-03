# Technical representations

## Code shapes

When a named code entity is material to an explanation, recommendation,
or comparison and established syntax conveys relevant structure,
lead with the smallest faithful code shape.
Retain established names, types, parameters, results, fields,
relationships, and ownership boundaries the reader must distinguish;
visibly elide unrelated or unestablished parts.
Under that condition prose alone is incomplete:
even under a prose word limit, elide more rather than enumerate the shape in prose.
Use prose alone only when syntax exposes no relevant relationship.

Use a declaration, type fragment, call site, or configuration fragment
in the established language and syntax.
For existing code, preserve evidence-backed names, spelling, and types;
do not substitute invented aliases or pseudocode.
For a partially established shape, show its supported fragment
and mark unknown or unrelated parts with a language-native comment.
Immediately label proposed or illustrative fragments, such as `Proposed shape:`.
Do not invent syntax for an unestablished language or API.

Use prose for semantics, constraints, rationale, consequences,
and behavior the shape does not express, applying the main skill's naming rules.
Do not expose mechanisms merely because code exists;
when readers need the contract instead, state it in prose.

## Executable demonstrations

Use a demonstration to follow usage, branches, loops, or state changes,
or show a verbatim input, output, or failure, instead of narrating each step.
Use concrete code when implementation syntax is established.
When executable logic matters but syntax is irrelevant or unestablished,
use clearly labeled pseudocode as a behavioral model,
not an imitation of an unchosen language.
Use stable domain names, one action or decision per line,
and indentation for branches, loops, and returns.
Use a corresponding visualization when readers must distinguish several actors,
states, ownership boundaries, or structural alternatives;
do not force those relationships into pseudocode.

Choose the smallest useful demonstration,
which may be illustrative, partial, or intentionally incomplete.
Omit setup, boilerplate, unchanged branches, and other details
only when irrelevant to its point.
Use visible elision when omissions could be mistaken for complete code.
Identify non-runnable demonstrations and limits affecting interpretation or use.
For claims about actual behavior, use real names and evidence-backed results.
Introduce prerequisites first and keep inputs and identifiers consistent
with the explanation.

Place demonstrations near their claims.
Interleave nearby code blocks with prose when progression helps explain behavior;
preserve identifiers, state, and execution order across them,
and mark skipped steps or discontinuities that materially affect their relationship.
Explain the expected observation, why it answers the question,
and what it does not establish.
Fence multiline code with a language tag and distinguish invocation from output.
Include credentials or sensitive values only when independently authorized
and necessary for the reader's task.

## Tables and lists

Give each table one comparison or lookup task,
with common dimensions across peers and short, parallel cells.
Keep conditions with their actions and shared prerequisites beside the table,
not buried later.
Leave unknowns visibly unknown.
A cell needing a separate causal explanation usually belongs beside the table
as prose or a sequence; retain qualifications needed to interpret the cell.
Use bullets for independent items, one scannable point each,
and numbered steps for required order rather than enumerating peers.
Bullet markers do not reduce the effort of reading paragraphs.

## Diagrams

For diagrams selected under the main skill's medium decision,
choose the form exposing the required relationship:

| Form | Relationship |
| --- | --- |
| Call tree | Nested runtime control flow from one entry point |
| Component tree | UI containment and relevant state or module boundaries |
| Shallow file tree | Responsibility, containment, or broad refactor location |
| Sequence | Actor handoffs and causal order |
| Flow | Branching control or data movement |
| State | Lifecycle phases and allowed transitions |
| Timeline | Operational events and recovery |

Use position, connection, or enclosure to carry relationships,
with labels short enough to follow paths rather than paragraphs inside boxes.
Show alternate outcomes as alternatives, not successive events.
Mark unknown or proposed connections; arrows assert relationships like sentences.
Keep names, boundaries, and ordering consistent with the explanation
and show only relevant actors, states, and relationships.
Introduce unfamiliar notation and explain what readers should learn.
Use text labels and accompanying prose
so meaning does not depend on appearance or color alone.
Place each visualization next to its claim.

Mermaid is available by default only in conversational chat.
In external or durable artifacts, use it only when the user explicitly requests
Mermaid for that artifact; a general diagram request does not suffice.
When Mermaid is not permitted, use plain-text diagrams
or an established non-Mermaid artifact format.
If a chosen format does not render, replace it with a compatible form
preserving the relationships and return the explanation with it in place.
Return only the visual when that is the requested scope.

## Changes to established shapes

When the point is a change to an established code shape, executable demonstration,
or visualization,
use a `diff` of the relevant structure.
Keep the nearest unchanged owner identifying the changed elements:
the operation, call entry, parent component, or parent directory.
Show the complete relevant shape instead when most is new,
when omissions would hide ownership or order, or when readers need a copyable target.
