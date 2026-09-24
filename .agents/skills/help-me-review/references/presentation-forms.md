# Presentation forms

## Source shapes

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

## Behavioral pseudocode

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

## Visualizations

When several actors, states, branches, or ownership boundaries
would be harder to understand in linear prose or code,
use the smallest useful table, tree, sequence, flow, state view, or timeline.
Do not repeat the same relationship in multiple forms
unless each form answers a different review question.
