# Code readability

Use this guide when writing, organizing, or reviewing code.
It explains how readily a capable maintainer can understand and safely change
a coherent part of a system.

Readable code gives that maintainer an economical mental model
for a concrete task.
It preserves complexity inherent to the domain
while reducing presentation, indirection, and organization costs
that do not help complete the task.

## Model the maintainer

Judge readability from the maintainer's position,
not from the agent's ability to inspect and retain the repository.
The agent may already have search results, conversation context,
and several files in its active window.
The maintainer encounters code in an order
and must discover which surrounding information matters.

Model an intelligent reader who knows the language and general engineering
practice but does not know the author's private reasoning.
Familiarity with a codebase can make a complicated local model feel simple.
Do not treat the author's or agent's fluency as evidence
that another capable maintainer receives the needed model from the code.

## Trace the reader's mental model

Choose a realistic reading or modification task
and follow one coherent path through the code.
At each point, identify the information that enters the reader's attention,
what must remain active together,
and what the representation lets the reader safely compress or discard.

Cognitive load comes from:

- Local load: values, states, conditions, effects, and branches
  that must be understood together.
- Navigational load: the files, callees, helpers, and paths
  the reader must inspect and relate.
- Reconstruction load: purpose, invariants, ownership, ordering,
  and domain facts the reader must infer because they are unavailable
  where needed.

A readable representation lets the reader replace several details
with one trustworthy concept or retire facts that no longer matter.
A name, type, helper, comment, or module helps only when the reader
can rely on it at the needed scale.
Do not count facts mechanically:
the task, relationships between facts, and quality of the representation
determine the cost.

These costs interact.
A helper may shorten a local expression while adding navigation
and another relationship to reconstruct.
Judge the net load across the coherent path,
not the apparent improvement at one line.

## Help the reader release attention

Make the current state and the next governing decision visible.
The reader should not have to replay the entire function
to determine which effects have occurred or which possibilities remain.

- Give a complex condition a meaningful name
  when the name forms a stable concept
  and lets the reader stop carrying the expression.
- Use early exits when they retire terminal or invalid states.
  Keep nesting when it directly represents a hierarchy
  or several outcomes that remain relevant.
- Converge successful branches before work they share.
- Represent mutually exclusive states directly
  instead of encoding them as combinations of booleans.
- Keep mutations, effects, and ordering near the operations they govern.

A longer visible sequence can be easier to understand
than a compressed expression or chain of calls
when it makes decisions and state transitions explicit.

## Keep context and language local

Place information near the code that needs it.
A reader should not have to cross unrelated declarations, files, or packages
to reconstruct one concept or operation.

Keep a type near the behavior that gives it meaning.
Keep request and result records with their operation.
When code defines the behavior it requires from a collaborator,
keep that contract near the consumer.
Arrange code around coherent operations
and in the order a reader needs to understand them,
not by declaration kind, reference direction, or arbitrary size.

Source order should let a maintainer form a stable summary
before asking them to descend into detail.
For an operation, that summary is its purpose and input/output boundary.
Once the reader has both, the reader can decide
whether to inspect the implementation or continue to the next contract.
Minimize the scrolling and context switching needed to reach that point.

Identify the primary abstraction or operation
that explains why the surrounding declarations exist.
For a compact contract declaration such as an interface or trait,
place that contract first
and its supporting declarations after it in first-need order.
The reader can absorb the contract and its related records
without scrolling through implementation.

For a function or method whose body would otherwise
separate the operation from its request and result records,
place its request and result records immediately before the implementation.
That order lets the reader absorb the inputs and outputs
before scrolling through the body.
When a compact implementation keeps its boundary and records visible together,
place the implementation first
and its request and result records after it in first-need order.
Place other supporting declarations after the primary code in first-need order.

Do not treat a name appearing in a signature, field, or bound
as a source-order prerequisite.
Do not choose an order from declaration category or reference direction alone.
An actual language, compiler, generator, or other tool constraint
may further restrict the order.

Check that a maintainer can see the purpose and input/output boundary
without first scrolling through an unexplained support inventory
or an implementation body.

Physical organization is part of the code's representation.
Optimize file and module boundaries primarily for coherent ownership
and the changes that ownership should localize.
Declaration-kind and lookup conventions can improve discovery
within those meaningful boundaries,
but they should not fragment one operation or policy across several owners.
Search can locate a symbol;
it cannot recover ownership scattered across boundaries.
When a representative change repeatedly crosses boundaries
that replace no knowledge,
regroup the code or deepen the owner.
If an authoritative convention prevents that,
expose the tradeoff and seek a decision.

Use one stable term for one domain concept
across names, types, comments, and neighboring modules.
Introduce another term only for a meaningful distinction.
When a representation changes but the concept does not,
retain the domain term or make the transformation explicit.
Treat a change to an established term as a scoped migration:
update one coherent internal scope together,
keep the old term only where compatibility requires it,
and make the old-to-new transformation explicit at that boundary.
Do not alternate the terms for one unchanged concept within a scope.

Share behavior when several sites enforce one invariant, policy,
or source of truth and must change together;
make them depend on its one owner.
Keep rules separate when only their syntax or current values match
and their reasons or evolution differ.
Make consequential implicit behavior discoverable
at the boundary where a maintainer must reason about it.

## Make boundaries reduce what the reader must know

Every helper, type, class, module, or service boundary introduces a name
and a relationship the reader may need to understand.
A boundary earns its place when its contract replaces implementation knowledge
and lets the reader stop.
A complete domain operation, invariant, or shared policy
can provide such a contract.
Function length alone cannot.

When understanding the caller still requires reading the boundary's body,
or when coordination remains distributed across both sides,
the boundary has moved complexity rather than contained it.

For example, a private `isReady` helper that only holds the prerequisites
for one nearby `submit` call makes a maintainer inspect two places
to change one decision.
An atomic `ledger.post(entry)` operation instead lets the caller rely
on an all-or-nothing contract without learning its locking and storage work.
The useful distinction is whether the contract replaces details
for the reader's task, not the number of lines behind it.

When this diagnosis calls for inlining, deepening a boundary,
changing ownership, or reorganizing dependencies,
read and apply `~/.agents/docs/code-design.md`.
Use this guide to identify the cognitive cost
and design guidance to choose the remedy.

## Use comments to supply a better representation

Comments improve readability when they give the reader a cheaper representation
for the current task.
They may expose context the code cannot express
or reorganize visible detail into a larger-scale model
that requires less reconstruction, navigation, or working memory.

A same-scale translation of an obvious statement is trivial.
Visible information is not automatically redundant:
a hidden-state annotation, maintenance region, callee summary,
or local domain explanation may let the reader reason at a useful scale.

Comments cannot compensate for design or organization
that the code can reasonably improve.
Read and apply `~/.agents/docs/code-comments.md`
for comment selection, interface documentation,
teacher comments, examples, and formatting.
