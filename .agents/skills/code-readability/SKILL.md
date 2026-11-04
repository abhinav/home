---
name: code-readability
description: >
  Write, change, organize, or review non-generated code; evaluate whether a
  maintainer can understand and safely change it; or decide source order,
  naming, control flow, locality, physical organization, or whether a boundary
  reduces cognitive and navigation load.
  Do not use merely to explain behavior without evaluating or changing source code.
---

# Code readability

Give a capable maintainer an economical mental model for a concrete task.
Preserve domain complexity while reducing unnecessary presentation,
indirection, and organization costs.

## Trace the maintainer's task

Assume knowledge of the language and general engineering practice,
not the author's private reasoning or the agent's searches and conversation context.
The maintainer encounters code in an order and must discover what matters;
author or agent fluency does not establish that the code supplies the needed model.

Choose a realistic reading or modification task and trace one coherent path.
At each point, identify what enters attention, what must remain active together,
and what the representation lets the reader safely compress or discard.
Judge the combined costs:

- Local load: values, states, conditions, effects, and branches understood together.
- Navigational load: files, callees, helpers, and paths inspected and related.
- Reconstruction load: purpose, invariants, ownership, ordering, and domain facts
  inferred because they are missing where needed.

Names, types, helpers, comments, and modules help only when readers can rely
on them at the needed scale to replace details with a concept or retire facts.
Judge the task, relationships, and representation rather than counting facts.
A helper can shorten an expression while adding navigation and reconstruction;
assess net load across the path, not one line.

Compiler inference and implicit conventions do not establish reader understanding.
Expose a value's role, relevant type, and governing condition where otherwise
the reader must recover them from distant declarations or later use.
Use a local name, type annotation, or explicit construct to remove that work;
leave information implicit when the current context already makes it clear.

## Help the reader release attention

Expose current state and the next governing decision without requiring a replay
of the function to recover completed effects or remaining possibilities.

- Name a complex condition when it forms a stable concept
  and lets the reader stop carrying the expression.
- Use early exits to retire terminal or invalid states;
  retain nesting that represents hierarchy or outcomes still relevant.
- Converge successful branches before shared work.
- When state needs an explicit representation, express mutually exclusive states
  directly rather than through boolean combinations.
- Keep mutations, effects, and ordering near the operations they govern.

Distinguish working data from progress bookkeeping.
Use sequence, branches, loops, and calls when they naturally express progress.
Keep explicit progress data when the supported operation must resume across calls,
persist a checkpoint, or respond to transitions that do not fit that control structure.
Choose from the operation's contract; grouping working data in a type
does not require a phase field.
A longer visible sequence can be clearer than a compressed expression or chain of calls
when it exposes decisions and state transitions.

## Keep context and language local

Keep information where needed: types near meaningful behavior,
request/result records with their operation, and required collaborator contracts
near the consumer defining them.
Arrange code by coherent operations and reader needs,
not declaration kind, reference direction, or size.
When choosing declaration or source order,
read [Source order](references/source-order.md)
for reader-order criteria and language or tool constraints.

Choose file/module boundaries primarily for coherent ownership and localized changes.
Declaration-kind and lookup conventions can help discovery inside those boundaries,
but should not fragment one operation or policy across owners.
Search can locate a symbol, but cannot recover ownership scattered across boundaries.
If a representative change repeatedly crosses boundaries replacing no knowledge,
regroup code or deepen its owner.
If an authoritative convention prevents that, expose the tradeoff and seek a decision.

Use one stable term per domain concept across names, types, comments,
and neighboring modules; add terms only for meaningful distinctions.
If representation changes but the concept does not, retain its term
or make the transformation explicit.
Treat an established term's replacement as a scoped migration:
update one coherent internal scope together, retain the old term only where
compatibility requires it, and expose the old-to-new transformation there.
Do not alternate terms for one unchanged concept within a scope.

Share behavior when sites enforce one invariant, policy, or source of truth
and must change together; depend on its one owner.
Keep rules separate when their reasons or evolution differ despite matching
syntax or current values.
Expose consequential implicit behavior at the boundary where maintainers must reason about it.

## Make boundaries replace knowledge

Each helper, type, class, module, or service adds a name and relationship.
A contract earns callers' reliance when it replaces implementation knowledge
and lets the reader stop.
A complete domain operation, invariant, or shared policy can do this;
function length alone cannot.
If callers still reconstruct implementation or coordinate details it claims to own,
the boundary moves complexity rather than containing it.

Within one owner, private methods can outline a complex operation.
Keep a phase separate when its name and contract explain its role and relevant effects,
letting readers inspect details selectively.
Independent reuse and isolation from shared working state are not prerequisites.
Reading a phase to change it is expected;
repeated caller/callee alternation to reconstruct one decision suggests poor decomposition.
Keep sequencing, branches, and failure paths visible in the outline,
and phase implementations near the operation.

Two illustrative cases in pseudocode:

```text
if isReady(...):       # private prerequisites for only this nearby submit
    submit(...)

ledger.post(entry)     # atomic; hides locking and storage behind all-or-nothing
```

The prerequisite-only helper splits one decision across two places.
Judge replaced knowledge for the task, not lines behind the boundary.
When this diagnosis calls for inlining, deepening a boundary,
changing ownership, or reorganizing dependencies, load and apply `$code-design`.
Use readability to identify the cost and design guidance to choose the remedy.

## Use comments for a cheaper representation

Comments can expose context unavailable in code or organize visible detail
into a larger model with less reconstruction, navigation, or working memory.
Obvious statements translated at the same scale are trivial;
visible information may still help as a hidden-state annotation, maintenance region,
callee summary, or local domain explanation.
Comments cannot compensate for design or organization the code can reasonably improve.
Load and apply `$code-comments` for selection, interface documentation,
teacher comments, examples, and formatting.
