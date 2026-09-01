---
name: help-me-review
description: >
  Use when the user wants help understanding a code change and deciding where
  to focus their own review of a pull request, commit, or diff.
---

# Help me review

## Serve the reviewer

The user remains the reviewer.
Turn the change into a guided reading that helps the user understand its shape,
follow its consequential behavior,
and identify the choices that deserve judgment.
Do not substitute an approval decision or findings report for that guidance.

## Start from good code

Begin from the premise that the change is good code.
The user reviews code written by capable agents.
Unless the available evidence says otherwise,
assume the code builds, its tests pass,
and routine implementation details have been handled competently.

This premise changes where the guided review starts.
The work is to help the user understand and judge the important choices,
not to establish basic implementation competence.

Do not begin with a line-by-line hunt for small bugs.
An obvious material defect still matters when encountered,
but routine defensive mistakes, style issues,
and speculative edge cases are not the organizing questions.

The user's attention is scarce.
Use it to explain what behavior or contract changed,
where data came from and went,
what control flow or state transition appeared,
which assumptions became load-bearing,
and what consequences follow for callers and the system.

## Build the change model

Before presenting the change,
establish its purpose and trace its smallest coherent semantic path:

1. Establish the relevant prior behavior and the problem or purpose of the
   change.
2. Identify the definition, contract, operation, or ownership boundary being
   changed.
3. Find the conditions that determine when the change applies.
4. Follow the important transformation, decision, or state transition.
5. Find the observable effect and the callers or systems that experience it.
6. Distinguish a nearby unchanged path when it clarifies the change's scope.
7. Use changed tests as specifications of scenarios, stimuli, and outcomes;
   determine whether they establish the intended contract
   rather than merely agree with the implementation.

Reason across the whole change.
A line that appears mechanical in one file may reveal its purpose,
or a distinct consequence,
only when read with a definition, caller, test, or configuration elsewhere.
Inspect surrounding source when it can change the judgment
about what is load-bearing.
Do not investigate unrelated code merely to make the review feel exhaustive.
Treat a plausible failure as a question to resolve,
not as evidence that a defect exists.
When the governing contract or runtime evidence is unavailable,
preserve the uncertainty and explain what the answer would change.

## Allocate attention

Keep and examine the semantic anchors that expose a new contract,
condition, transformation, ownership boundary, lifecycle edge,
external effect, compatibility constraint,
or consequential algorithm or architecture choice.

Compress repetition after establishing equivalence.
One representative instance may stand for repeated setup,
generated output, call-site migrations, or equivalent cases
only after checking that the other instances do not differ in caller contract,
inputs, timing, ownership, failure behavior, lifecycle, or effect.
Treat a distinct context as a distinct review subject.

For example,
the same call added across many sites can be reviewed through one anchor
when every site has the same role.
It cannot be treated as mechanical when one site runs during shutdown,
under a different lock or task lifetime,
or across a different compatibility boundary.
The language changes how those facts are expressed,
not why they deserve attention.

When importance is uncertain,
preserve the code in the change model and inspect the uncertainty.
Do not use a compression target or finding count as a substitute for judgment.

## Guide the user's review

Account for every changed file and meaningful change group,
but organize the explanation around the semantic path rather than file order.
Confirm that each compressed group has a representative anchor
and no unexamined semantic outlier.

Lead with the change's purpose,
then contrast the relevant prior behavior with the changed behavior.
Introduce definitions, actors, ownership boundaries,
and other prerequisites before reasoning that depends on them.

When syntax exposes a relationship the user needs to judge,
show the smallest faithful code shape that preserves that relationship.
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

When several actors, states, branches, or ownership boundaries
would be harder to understand in linear prose or code,
use the smallest useful table, tree, sequence, flow, state view, or timeline.
Do not repeat the same relationship in multiple forms
unless each form answers a different review question.

For each review subject,
explain why it deserves attention and what the user should judge.
For a compressed group,
name what the representative anchor covers
and direct the user separately to each meaningful exception.

If building the guide exposes a material defect,
supported risk or design concern,
or missing contract or runtime evidence,
surface it where it affects the user's judgment.
Distinguish observed facts, supported inferences, and unresolved questions.
Do not hunt for findings,
manufacture small issues,
or turn a local concern into an approval decision for the whole change.

The guide is complete when the user can follow the consequential change,
locate the evidence behind it,
see what was compressed and why,
and identify the decisions or unanswered questions that remain theirs.
Before returning,
compare every code and diff shape with the source
and move any inserted annotation or explanation outside it.

## Tests

When changing this guidance,
read [tests/README.md](tests/README.md).
Run the relevant scenarios with fresh subagents that have empty context windows.
