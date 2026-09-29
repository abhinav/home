# Property-based testing

## Choose a useful property

A property-based test checks a behavioral relationship over a family of inputs
or operation histories.
It can expose interactions that a few named examples leave unexplored.
Use it alongside examples that explain particular behavior,
pin down a published format, or preserve an important regression.
Prefer bounded checks in the ordinary unit or integration suite
at the relevant boundary; longer searches can run separately.

Choose a property when the contract supplies a meaningful relationship,
the test can check it independently,
and generating and replaying useful cases has a reasonable cost.
For example, transformations can preserve content,
search results can partition an ordered collection,
and stateful operations can preserve accounting across many histories.
An optimized implementation may admit a slower, simpler reference computation.
The relationship and the missing evidence justify the test;
a function's name alone does not.

Add a property for an uncovered relationship or combination of behaviors.
Strengthen an existing property when its assertion or inputs miss the risk.
Keep existing evidence when it already protects the promise at a useful boundary.
Prefer concrete examples for a small finite behavior already fully exercised,
and use the owning static detector for guarantees it establishes.
Resolve an unclear contract before turning a plausible law into an assertion.
An expensive or difficult-to-replay boundary may favor a smaller test boundary
or different evidence.

## Separate the claim from the search

The domain defines the inputs the claim concerns.
The property states the promised relationship;
the oracle is the predicate, observation, or reference used to judge it.
The generator supplies cases from that domain.
Shrinking searches for a simpler case that still fails.
Generation may be randomized or enumerate a bounded domain.
Randomness is not what makes the relationship useful.

```text
claim: for every input in the supported domain,
       the promised relationship holds

test run:
    for each generated input:
        observe the operation
        assert the promised relationship
    if a case fails:
        search for a simpler case that still fails
```

A finite passing run establishes the checks for the cases exercised,
not a proof of the universal claim.
A property can be too weak even with excellent generation;
a strong property can miss defects when its generator rarely reaches them.
Assess both separately.

## Choose how to search

Property-based testing and fuzzing can share the same semantic assertions.
A coverage-guided fuzzer can search for a violation of a postcondition,
round trip, or model comparison;
a target that only calls the operation checks a narrower failure condition.

Choose the engine from the useful input distribution and the execution budget.
Typed generators often make constrained values and operation histories easier
to construct and shrink during ordinary tests.
Fuzzing fits fast, repeatable checks that benefit from corpus mutation
and coverage feedback.
Structured adapters can combine both approaches;
compare their cost and rejection rate with generating valid values directly.
Neither engine supplies an independent oracle for you.

Check what the normal test command actually executes.
Replaying saved inputs is useful regression evidence,
but it does not establish that a run searched fresh inputs.
Make the generation or campaign command and its budget explicit.
Use the relevant development guidance for libraries, adapters, and commands.

## Derive relationships from the contract

Start with what the caller can observe and the domain where it is promised.
Useful families include:

| Family | What to check | What it can miss |
| --- | --- | --- |
| Postconditions and invariants | Results satisfy ordering, bounds, validity, or state constraints. | A valid result can still contain the wrong data. |
| Preservation | Content, multiplicity, totals, or meaning survive a transformation. | A set comparison loses duplicate counts; semantic equality may omit format promises. |
| Round trips | Applying an inverse recovers the supported value or meaning. | Both operations may share a format mistake. |
| Algebraic laws | A promised identity, idempotence, associativity, or commutativity holds. | A law alone may permit constant or unchanged output. |
| Metamorphic relations | A controlled input change implies a relationship between outputs. | The relationship may require conditions the generated inputs do not satisfy. |
| Reference comparison | Results agree with a simpler computation or independent implementation. | Shared assumptions can make both wrong together. |
| Stateful properties | Observations agree with the promised transitions across a history. | Isolated calls can miss interactions and identifier reuse. |

Derive the law rather than borrowing it from a familiar operation name.
For example, floating-point addition need not satisfy real-number associativity.
Adding a feasible choice cannot worsen a true optimum,
but a heuristic may not promise that relationship.
Use the contract's notion of equality:
a lossy conversion or canonical representation may preserve meaning
without preserving the original bytes.

## Build an oracle with different failure modes

Independence means reasoning from the contract through a different check,
not prohibiting all computation of expected results.
A direct predicate, an elementary exhaustive calculation over small inputs,
or a simple abstract model can be more trustworthy than a second fast algorithm.
Justify a reference's semantics and independence;
being older or located in another function is insufficient.
Avoid copying the production branches, private helpers, and assumptions
that the test is meant to challenge.

For example, `lower_bound(xs, value)` returns the first insertion position
in a nondecreasing integer list.
The following pseudocode checks its contract without reproducing binary search:

```text
for each generated nondecreasing integer list xs and integer value:
    position = lower_bound(xs, value)

    assert 0 <= position <= length(xs)
    assert every item in xs[0:position] is less than value
    assert every item in xs[position:length(xs)] is at least value
```

Empty lists, repeated values, and targets below, within, and above the list
exercise different parts of that claim.
Repeated values distinguish the first valid position from a later match.

Ask which wrong implementation could satisfy the proposed property.
`normalize(normalize(x)) == normalize(x)` also accepts a constant function.
Pair stability with independently checked preservation or specified examples
when the contract promises them.
`decode(encode(value)) == value` detects loss,
but matching encoder and decoder errors can still violate a published format.
Retain independent format examples or another justified compatibility check.
An observer that uses the same faulty production parser is not independent
merely because the assertion calls it by another name.

## Generate inputs that exercise the relationship

Distinguish the supported domain from the size and execution budgets of a run.
Construct valid constrained data directly when filtering arbitrary data
would reject most attempts or leave mostly trivial cases.
Generate invalid inputs separately when their rejection is part of the contract.
An assumption restricts the claim; justify it from the domain.
Do not exclude a supported counterexample to make the property pass.

Include relationships as well as individual values:
empty and singleton structures, duplicates, shared identifiers,
boundary values and their neighbors, nested structures,
and combinations that cross branches of the contract.
Independent random identifiers almost never revisit an earlier object.
Choose from existing identifiers when the promise concerns reuse or mutation.

Inspect which meaningful categories actually execute.
Case counts and line coverage do not establish that the test attempted
an overwrite, crossed a boundary, or compared different outputs.
Check whether rejection, skipped assertions, or an empty collection
makes the property vacuously pass.
Keep important boundary cases deterministic as explicit examples
or required inputs to the property.

## Check histories with a small model

For stateful behavior, generate sequences of actions
and compare public observations with a simple description of the promised state.
Start each sequence with fresh system and model state.
The model should omit storage layout, caches, scheduling,
and other machinery that callers do not observe.
For a key-value store, a plain mapping can describe the promised associations:

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

This example assumes reads are observational and removing an absent key is valid.
The generator must revisit keys, overwrite with different values,
and interleave operations on different keys.
Otherwise a store that discards writes could appear correct.
The model's map is useful because it expresses public associations simply;
copying a production storage algorithm would lose that advantage.

Derive action preconditions from the contract.
Include rejected actions when failure behavior is specified,
and check that failure preserves the promised state.
During shrinking, replay each candidate history from fresh state
and recompute expectations; removed actions can change later outcomes.
Preserve validity and useful shared-identifier relationships.
An operation need not retain an earlier setup action
when the contract permits it on absent state.
Sequential histories establish no claim about concurrent interleavings.

## Validate the detector and preserve failures

Name a credible defect, the generated input that exposes it,
and the assertion that fails.
Consider lost duplicates, empty output, unchanged state,
incorrect boundaries, and errors shared with the oracle where relevant.
Use a small deliberate mutation when it resolves uncertainty about detection;
a separate mutation-testing framework is not required.

Control relevant state, time, randomness, and external effects for replay.
Record the actual failing values or action trace
and the framework's replay information.
Shrinking seeks a simpler failure, not necessarily a globally smallest one.
Custom generators and shrinkers are test code and can be wrong.

A failing assertion identifies a disagreement to investigate.
Check the property, generated input, oracle, and implementation
against the governing contract before assigning fault.
Retain important discovered cases in explicit regressions or a durable corpus;
a seed or local cache alone may not survive generator or framework changes.

Keep the domain, operation, and promised relationship visible in the test body.
Make the counterexample readable enough to explain which promise failed.

## Further reading

- [Hughes, How to Specify It!](https://research.chalmers.se/publication/517894/file/517894_Fulltext.pdf)
  compares property families and what their counterexamples reveal.
- [Claessen and Hughes, QuickCheck](https://www.cs.tufts.edu/~nr/cs257/archive/john-hughes/quick.pdf)
  explains generated checks, input distributions, and constrained generation.
- [MacIver, Testing as a Complete Specification](https://hypothesis.works/articles/tests-as-complete-specifications/)
  separates the strength of a specification from the search for counterexamples.
- [MacIver, Testing performance optimizations](https://hypothesis.works/articles/testing-performance-optimizations/)
  illustrates comparison with an independently simpler computation.

These sources supply concepts; library APIs and language integration
belong in the relevant development guidance.
