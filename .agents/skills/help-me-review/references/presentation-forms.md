# Presentation forms

## Source shapes

Show the smallest faithful shape when syntax exposes a relationship to judge.
Full code stays in the source pane; include short chat excerpts when useful.
For changes to an established shape, use a diff with the nearest unchanged owner identifying it.
Preserve real names, types, parameters, source spelling, ownership boundaries, and relevant order.
Copy retained source or diff lines verbatim; the only addition inside a shape is visible `...`
for source already established as non-consequential.
Keep labels and explanations outside.
Use prose for behavior, constraints, rationale,
consequences, and relevant unchanged behavior the code does not express.

## Behavioral pseudocode

When syntax obscures consequential runtime flow or conceptual comparison is requested,
use a clearly labeled behavioral pseudocode `diff` block.
Put one action or decision per line, retain unchanged steps needed for ordering and I/O,
and keep every material branch and returned outcome affecting the comparison inside the model.
Use `-` for prior and `+` for changed or new behavior.
This is an explanatory model, not quoted source; links and labels stay outside.
Use source shapes when syntax or ownership is the choice.
For each modeled flow, state supported effects on backend calls, concurrency scope,
work per request or item, and expensive work remaining unchanged.
Distinguish changes to existing paths from new alternatives, and startup from request work.
Test and comment changes are evidence unless implementation changes runtime behavior.

## Visualizations

For several actors, states, branches, or ownership boundaries harder to understand linearly,
use the smallest useful table, tree, sequence, flow, state view, or timeline.
Repeat relationships in multiple forms only when each answers a different review question.
