# Domain modeling

Model the facts, behavior, and constraints needed for the software's decisions,
not every real-world relationship or stored field.
Invest most where misunderstanding changes product outcomes;
straightforward data maintenance may need only a validated record and direct operation.

## Discover meaning through scenarios

Walk through an operation with the people owning its rules,
or their requirements, examples, and operational evidence.
Identify the actor, starting facts, requested change, permitted result,
and why a similar request is rejected.
Vary one relevant condition to reveal its rule;
include lifecycle transitions and interruptions when they affect outcomes.

Use the same terms in explanations, operations, and tests.
This ubiquitous language tests understanding: different explanations of one term
at different calls may conceal separate concepts or a missing distinction.
Refine language and implementation together as evidence changes the model;
unexplained table names and vendor vocabulary do not establish meaning.

Separate confirmed rules, assumptions, and unresolved decisions.
An agent can propose a model, not establish business rules by naming them.
Obtain missing decisions affecting observable behavior before committing to it;
continue independent design work meanwhile.
The model should predict representative cases and expose questions,
not merely supply a glossary.

## Establish where meaning holds

A concept has one meaning within a scope, called a bounded context.
Contexts may share an identifier for correlation while differing in attributes,
lifecycle, rules, and mutation authority.
For example, fulfillment completes an order on delivery;
billing completes it when payment obligations end.
Keep these meanings with their owners and define exchanged facts;
a universal completion flag would lose information.
Sharing a representation can suit one agreed rule and compatibility owner.

Before sharing a model, establish who can change its meaning
and which consumers must coordinate.
Shared rules and evolution can justify the model's coordination cost.
Translate foreign assumptions that would otherwise govern local decisions;
adopt them directly when they suit the local purpose,
and avoid integration the outcome does not require.
These meaning and ownership choices do not prescribe separate services
or conversion at every package boundary.

Check a likely rule change and an exception:
terms should identify the correct owner, and one context's rule change
should not silently change another's meaning.
