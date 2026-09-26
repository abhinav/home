# Domain modeling

Build a model that explains the decisions this software must make.
A model selects the relevant facts, behavior, and constraints of its subject;
it need not reproduce every real-world relationship or stored field.
Invest most where misunderstanding a rule would change the product's outcome.
Straightforward data maintenance may need only a small validated record
and a direct operation.

## Discover meaning through scenarios

Walk through a representative operation with the people who own its rules,
or with their requirements, examples, and operational evidence.
Identify the actor, starting facts, requested change, permitted result,
and the reason a similar request would be rejected.
Vary one relevant condition to discover the rule behind the example.
Include lifecycle transitions and interruptions when they change the outcome.

Use the same terms in that explanation, the operation names, and the tests.
This shared language, called ubiquitous language in domain-driven design,
is a way to test understanding: a term that needs a different explanation
at every call site may hide several concepts or a missing distinction.
Refine the language and implementation together as evidence changes the model.
An unexplained table name or a vendor's vocabulary does not establish meaning.

Keep confirmed rules separate from assumptions and unresolved decisions.
An agent can propose a model, but cannot establish a business rule by naming it.
When a missing rule changes observable behavior, obtain the decision
before committing to that behavior; continue independent design work meanwhile.
The useful result is a model that predicts the representative cases
and makes the remaining questions visible, not a glossary alone.

## Establish where a meaning holds

A concept has one meaning within a particular scope, called a bounded context.
Two contexts may describe the same real-world thing for different purposes.
Sharing its identifier permits correlation;
it does not require shared attributes, lifecycle, rules, or mutation authority.

For example, fulfillment may treat an order as complete when it is delivered,
while billing treats it as complete when payment obligations end.
A universal completion flag would lose information.
Keep those meanings with their owners and define the facts they exchange.
If both areas instead use the same agreed rule with one compatibility owner,
sharing the representation can be appropriate.

When deciding whether to share a model, establish who can change its meaning
and which consumers must coordinate that change.
A shared model earns its coordination cost when those parties actually share
the rule and its evolution.
Translate when a foreign model's assumptions would otherwise control local
decisions; adopt it directly when those assumptions suit the local purpose.
Avoid integration when the requested outcome does not require it.
These are choices about meaning and ownership, not instructions to deploy
separate services or introduce a type conversion at every package boundary.

Check the candidate against a likely rule change and an exception case.
The terms should still identify the correct owner,
and changing one context's rule should not silently change another's meaning.
