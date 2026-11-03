# Property-based testing

## Choose a useful property

Check behavioral relationships over input families or operation histories
alongside examples explaining particular behavior, published formats,
or important regressions.
Prefer bounded checks in ordinary unit or integration suites at the relevant boundary;
longer searches can run separately.

Choose a property when the contract supplies a meaningful relationship,
independent checking is possible, and generating and replaying useful cases
has a reasonable cost.
Examples include preserved content, search partitions of ordered collections,
accounting across histories, or optimized results matching a simpler computation.
The relationship and missing evidence justify the test, not the function's name.

Add a property for an uncovered relationship or combination of behaviors.
Strengthen existing properties whose assertions or inputs miss the risk;
retain existing evidence already protecting the promise at a useful boundary.
Prefer concrete examples for small finite behavior already fully exercised,
and owning static detectors for their guarantees.
Resolve unclear contracts before asserting plausible laws.
An expensive or difficult-to-replay boundary may favor a smaller boundary
or different evidence.

## Separate the claim from the search

The domain defines supported inputs; the property states the promised relationship.
An oracle judges it through a predicate, observation, or reference.
Generators supply domain cases, randomly or by bounded enumeration;
shrinking searches for a simpler case that still fails.
Randomness does not make the relationship useful.

Finite passing runs establish only exercised checks, not the universal claim.
Assess property strength and generation separately:
excellent generation cannot strengthen a weak claim,
and a strong claim can miss defects when generated inputs rarely reach them.

## Choose how to search

Property testing and fuzzing can share semantic assertions:
coverage-guided fuzzers can check postconditions, round trips, or models;
merely calling an operation checks a narrower failure condition.
Choose by useful distributions and execution budget.
Typed generators often make constrained values and operation histories easier
to construct and shrink during ordinary tests;
fuzzing suits fast repeatable checks benefiting from corpus mutation and coverage.
Structured adapters can combine them; compare their cost and rejection rate
with generating valid values directly.
Neither engine supplies an independent oracle.

Check what the normal test command executes.
Replaying saved inputs provides regression evidence, not proof of fresh search.
Make the generation or campaign command and its budget explicit.
Use relevant development guidance for library APIs, language integration,
adapters, and commands.

## Derive relationships from the contract

Start with caller observations and the promised domain.

| Family | What to check | What it can miss |
| --- | --- | --- |
| Postconditions and invariants | Results satisfy ordering, bounds, validity, or state constraints. | A valid result can still contain the wrong data. |
| Preservation | Content, multiplicity, totals, or meaning survive a transformation. | A set comparison loses duplicate counts; semantic equality may omit format promises. |
| Round trips | Applying an inverse recovers the supported value or meaning. | Both operations may share a format mistake. |
| Algebraic laws | A promised identity, idempotence, associativity, or commutativity holds. | A law alone may permit constant or unchanged output. |
| Metamorphic relations | A controlled input change implies a relationship between outputs. | The relationship may require conditions the generated inputs do not satisfy. |
| Reference comparison | Results agree with a simpler computation or independent implementation. | Shared assumptions can make both wrong together. |
| Stateful properties | Observations agree with the promised transitions across a history. | Isolated calls can miss interactions and identifier reuse. |

Derive laws rather than borrowing them from operation names.
Floating-point addition need not satisfy real-number associativity.
A feasible added choice cannot worsen a true optimum, but a heuristic may not promise this.
Use contract equality: lossy conversion or canonical representation may preserve
meaning without preserving original bytes.

## Give the oracle different failure modes

Independence means a different check derived from the contract,
not a ban on computing expectations.
Direct predicates, elementary exhaustive checks of small inputs, or simple abstract
models may be more trustworthy than another fast algorithm.
Justify reference semantics and independence; age or a separate function is insufficient.
Avoid copying production branches, private helpers, and assumptions
the test is meant to challenge.

`lower_bound(xs, value)` returns the first insertion position in a nondecreasing
integer list.
This pseudocode checks that contract without copying binary search:

```text
for each generated nondecreasing integer list xs and integer value:
    position = lower_bound(xs, value)

    assert 0 <= position <= length(xs)
    assert every item in xs[0:position] is less than value
    assert every item in xs[position:length(xs)] is at least value
```

Empty lists, repetitions, and targets below, within, and above the list
exercise different parts of the claim.
Repetitions distinguish the first valid position from later matches.

Ask which wrong implementation could satisfy the property.
`normalize(normalize(x)) == normalize(x)` admits constant functions;
pair stability with independent preservation checks or specified examples
when the contract promises them.
`decode(encode(value)) == value` detects loss, but matching errors in the encoder
and decoder can still violate a published format.
Retain independent format examples or another justified compatibility check.
Renaming an observer using the same faulty production parser does not make it independent.

## Generate inputs that exercise the relationship

Separate the supported domain from the size and execution budgets of a run.
Construct valid constrained inputs directly when filtering would mostly reject
attempts or leave mostly trivial cases.
Generate invalid inputs separately when rejection is contractual.
Justify assumptions from the domain: they restrict the claim.
Do not exclude supported counterexamples to make a property pass.

Generate relationships as well as values: empty and singleton structures, duplicates,
shared identifiers, boundaries and neighbors, nested structures,
and combinations that cross branches of the contract.
Independent random identifiers almost never revisit objects;
choose existing identifiers when checking reuse or mutation.

Inspect meaningful categories actually executed.
Case counts and line coverage do not establish that the test attempted
an overwrite, crossed a boundary, or compared different outputs.
Check for vacuous passes from rejection, skipped assertions, or empty collections.
Keep important boundaries deterministic through examples or required property inputs.

## Check histories with a small model

Generate action sequences and compare public observations
with a simple model of the promised state.
Start every sequence with fresh system and model state.
Omit storage layout, caches, scheduling, and other machinery callers do not observe.
A key-value store's associations can use a plain mapping:

```text
for each generated sequence of Put, Get, and Remove:
    store = fresh_store()
    expected = empty_mapping()
    touched_keys = empty_set()

    for each action in sequence:
        add action.key to touched_keys
        if action is Put(key, value):
            store.put(key, value)
            expected[key] = value
        if action is Get(key):
            assert store.get(key) == expected.lookup_or_missing(key)
        if action is Remove(key):
            store.remove(key)
            remove key from expected if present

        for each key in touched_keys:
            assert store.get(key) == expected.lookup_or_missing(key)
```

This example assumes observational reads and valid removal of absent keys.
Revisit keys, overwrite with different values, and interleave different keys;
otherwise a store discarding writes could appear correct.
The map expresses public associations simply; copying storage algorithms would not.

Derive action preconditions from the contract.
Include rejected actions when failure behavior is specified,
and verify failure preserves promised state.
During shrinking, replay each candidate history from fresh state
and recompute expectations:
removed actions can change later outcomes.
Preserve validity and useful relationships among shared identifiers.
An operation need not retain an earlier setup action
when the contract permits that operation on absent state.
Sequential histories establish no claim about concurrent interleavings.

## Validate detection and preserve failures

Name a credible defect, the generated input exposing it, and the failing assertion.
Consider lost duplicates, empty output, unchanged state, incorrect boundaries,
and errors shared with the oracle where relevant.
Use a small deliberate mutation when it resolves uncertainty about detection;
a separate mutation-testing framework is not required.

Control relevant state, time, randomness, and external effects for replay.
Record actual failing values or action traces plus framework replay information.
Shrinking seeks simpler failures, not necessarily globally smallest ones;
custom generators and shrinkers can be wrong.

Treat failures as disagreements: check the property, input, oracle,
and implementation against the contract before assigning fault.
Retain important discoveries as explicit regressions or a durable corpus;
a seed or local cache alone may not survive changes to the generator or framework.
Keep domain, operation, and relationship visible in the test body,
and counterexamples readable enough to explain the failed promise.

## Further reading

- [Hughes, How to Specify It!](https://research.chalmers.se/publication/517894/file/517894_Fulltext.pdf)
  compares property families and what their counterexamples reveal.
- [Claessen and Hughes, QuickCheck](https://www.cs.tufts.edu/~nr/cs257/archive/john-hughes/quick.pdf)
  explains generated checks, input distributions, and constrained generation.
- [MacIver, Testing as a Complete Specification](https://hypothesis.works/articles/tests-as-complete-specifications/)
  separates the strength of a specification from the search for counterexamples.
- [MacIver, Testing performance optimizations](https://hypothesis.works/articles/testing-performance-optimizations/)
  illustrates comparison with an independently simpler computation.
