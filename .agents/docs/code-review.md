# Code review

A review should name the engineering question it is trying to answer.
Do not treat one undifferentiated review pass as proof of correctness,
maintainability,
and clarity.
Choose the lenses that match the risk of the change.

Treat the sections below as review lenses,
not as a required execution topology.
One reviewer may apply several lenses,
or independent reviewers and workstreams may apply them separately
when the change and its risks justify that separation.
State which lenses were applied,
and keep their questions distinct enough that success under one lens
does not substitute for another.

## Behavioral review

Act as an antagonistic systems tester of the claimed external contract.
Establish the contract from evidence appropriate to the risk,
such as an authoritative specification,
documented or established behavior,
repository and operational history,
or a focused probe at the real boundary.
Tests, validators, implementation source,
and mocks are evidence about behavior;
they are not automatically the contract.

Try to falsify the contract with awkward but valid inputs,
partial state, process failures, cancellation, timing changes,
unexpected but valid file names, and realistic boundary behavior.
Check failure reporting, ordering, state transitions, cleanup,
and partial-success behavior.
Pay particular attention when happy-path tests, mocks,
or implementation-shaped assertions replace the real boundary.

Keep the claim no stronger than the evidence:

- A confirmed defect requires an established contract
  and evidence that the implementation violates it.
- A supported risk identifies evidenced premises and the contract at risk,
  while naming the boundary or behavior that remains unverified.
- An optional test idea explores a plausible case
  without claiming that the case currently fails.

Be skeptical without filling gaps in the available facts.
A possible failure is not a defect merely because an antagonistic scenario can
be imagined.

## Architecture review

Trace information flow through representative workflows
rather than grading declarations in isolation.
For each caller and boundary, ask:

- what the caller must know to complete the operation
- where ordering, retry, compatibility, and other policy decisions live
- which component owns the operation and its state transitions
- whether the abstraction makes callers simpler
  or merely moves calls behind another name
- whether dependency direction and lifetime match the component that owns them
- whether infrastructure details remain at system boundaries

Treat repeated boundary crossings,
callers coordinating another module's internal sequence, generic runners,
super-configurations, god objects,
and forwarding-only layers as warning signals.
These patterns are not findings by themselves.
Flag a boundary when the change creates real coordination cost,
requires callers to carry another component's policy,
or couples policy to infrastructure.

When a boundary should change,
prefer deep modules with narrow contracts, named domain operations,
interfaces defined by the consumer that needs substitution,
concrete returned data, and dependencies whose lifetime matches their owner.
Do not demand an abstraction for symmetry or future possibility alone.

## Readability review

Review as an intelligent maintainer encountering the changed code cold.
Do not grant the reader context from the authoring conversation
or assume familiarity with neighboring packages.
Judge readability by the cognitive load required to understand and change a
coherent section of code.
Account explicitly for:

- how many conditions and states must be tracked at once
- how much context outside the local scope a reader must reconstruct
  to understand the code's role, invariants, and effects
- how far a reader must navigate to understand dependencies or invariants
- whether related concepts are physically near one another
- whether names expose the domain operation rather than the mechanism
- whether control flow converges or requires reconstructing several branches
- whether comments supply missing context instead of narrating statements

Also check whether types are separated from the behavior that gives them
meaning, one file contains unrelated services,
or a command coordinates many abstractions by hand.

Formatting and naming matter,
but they do not compensate for scattered ownership,
branching that must be mentally replayed, or excessive orchestration.
Comments should supply missing purpose, constraints, and invariants.
They should not narrate syntax or excuse complexity that the code can remove.

## Documentation review

Act as the advocate for a capable reader who lacks the authoring conversation,
implementation history, and unstated local folklore.
Apply theory of mind at each package, symbol, command,
and operational boundary:
identify what the reader can already know there
and what the reader must learn to use or modify the system correctly.

Check whether the contract depends on context that names and types do not carry,
including:

- ownership and resource lifetime
- ordering and state transitions
- zero values, defaults, units, sources, and valid values
- failure behavior, partial state, and recovery obligations
- compatibility requirements and external process behavior

Require that context where the intended reader needs it,
and verify documentation claims against actual behavior.
Do not reward documentation volume.
Do not request comments that repeat the implementation,
explain self-evident statements,
or compensate for a poorly named or misplaced concept.

Read and apply `~/.agents/docs/code-comments.md`
when the review covers in-code documentation or implementation comments.

## Close the review loop

Report findings with the evidence and affected contract needed to evaluate them.
Separate observed facts from inferences and recommendations.
Classify confirmed defects,
supported risks or design concerns,
and optional improvements or test ideas distinctly.
Do not present an optional idea as a finding merely to make a review look
productive.

After actionable findings are fixed,
rerun the relevant review lens and affected validation.
A review pass is not complete merely because it produced a list of findings.
