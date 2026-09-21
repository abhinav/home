---
name: performing-code-review
description: >
  Use when the agent is responsible for performing a code review of a diff,
  commit, pull request, or code change and producing findings about behavior,
  design, readability, documentation, or reviewability. Do not use when
  responding to feedback on the agent's own changes or helping the user conduct
  their own review.
---

# Performing code review

## Choose the review questions

A review should answer named engineering questions.
Do not treat one undifferentiated pass as proof of correctness,
maintainability, clarity, and reviewability.
Choose the lenses that match the change's risks and the requested outcome:

- **Behavior:** Does the change preserve its established external contracts?
- **Design:** Do abstractions, ownership, and policy flow coherently?
- **Readability:** Can a maintainer form and use the system's mental model?
- **Documentation:** Does the code teach the contracts and context readers need?
- **Reviewability:** Do the diff and commit message explain the change alone?

Load the governing skill for each selected lens that has one:

- load `code-design` for the design lens;
- load `code-readability` for the readability lens; and
- load `code-comments` for the documentation lens
  when the change includes comments or other in-code documentation.

Before beginning the review,
verify that every selected lens with a route above
has its governing skill loaded.

The lenses are peers, not a required execution topology or sequence of gates.
One reviewer may apply several lenses.
Use independent reviewers when independent judgment is useful
or a lens requires an isolated evidence boundary.
Do not assign one agent per lens by default.

Reviewability has a constraint on evidence order, not higher priority.
When it applies, run it before the reviewer sees anything beyond the diff
and commit message.
If the reviewer has already seen other context,
give those two artifacts to a fresh isolated reviewer.

State which lenses were applied.
Keep their questions distinct so success under one lens
does not substitute for another.
When delegating a lens,
send a self-contained prompt that names its question,
evidence boundary, and reporting shape.

## Behavior lens

Establish the relevant external contract before judging the change against it.
Use evidence appropriate to the risk,
such as an authoritative specification, established behavior,
repository and operational history, or a focused probe at the real boundary.
Tests, validators, implementation source, and mocks are evidence about behavior;
they are not automatically the contract.

Try to falsify the contract with awkward but valid inputs, partial state,
process failures, cancellation, timing changes,
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
An imaginable failure is not a defect without evidence
that the relevant contract permits the scenario and the change mishandles it.

## Design lens

Apply the governing design principles to the changed workflows
rather than restating them.

Trace abstractions and their flow through representative workflows.
For each caller and boundary, ask:

- what the caller must know to complete the operation;
- where extension, ordering, retry, compatibility, and other policy live;
- which component owns the operation, state, resources, and transitions;
- whether the abstraction replaces caller knowledge
  or merely moves calls behind another name;
- whether dependency direction and lifetime match their owner;
- whether infrastructure details remain at system boundaries; and
- what the resulting flow teaches the next contributor about the design.

Repeated boundary crossings,
callers coordinating another module's internal sequence,
generic runners, super-configurations, god objects,
and forwarding-only layers are signals to investigate, not findings.
Report a design concern when the change creates real coordination cost,
requires callers to carry another component's policy,
obscures extension or ownership, or couples policy to infrastructure.

## Readability lens

Review as an intelligent maintainer encountering the changed code cold.

Focus on readability at the macro level:

- whether the source is organized around coherent responsibilities;
- whether the system's major stages and ownership boundaries are visible;
- how many conditions, states, branches, and handoffs must be tracked together;
- how much purpose, context, and invariant knowledge must be reconstructed;
- how far the reader must navigate to understand a coherent change; and
- whether related concepts and the behavior that gives them meaning stay close.

Also check whether a file contains unrelated services
or a command coordinates many abstractions by hand.
Formatting, local naming, and small expressions still matter
and should be fixed when found,
but they are not the organizing objective of this lens.
Do not let a hunt for local style issues displace fragmented flow,
scattered ownership, or excessive orchestration.

## Documentation lens

The objective is well-documented code.
Act as the advocate for a capable reader
who lacks the authoring conversation, implementation history,
and unstated local folklore.
At each package, symbol, command, and operational boundary,
identify what the reader already knows
and what they must learn to use or change the system safely.

Check whether names, types, structure, and documentation together communicate:

- ownership and resource lifetime;
- ordering, state transitions, and invariants;
- zero values, defaults, units, sources, and valid values;
- failure behavior, partial state, and recovery obligations;
- compatibility requirements and external process behavior; and
- rationale for surprising constraints or design choices.

Verify documentation claims against actual behavior.
Inaccurate documentation is harmful and should be fixed when found,
but chasing isolated minor inaccuracies is not the goal of this lens.
Judge whether the code is documented well enough as a system.

Do not reward documentation volume.
Do not request comments that repeat the implementation,
explain self-evident statements,
or compensate for a poorly named or misplaced concept.

## Reviewability lens

Assess whether a capable reviewer can understand the change
from only its diff and commit message.
Do not run commands, inspect source or repository state,
or use issue, CI, conversation, or other external context.

Determine whether the two artifacts communicate:

- the intended outcome and why it is needed;
- the scope of the change and relevant unchanged boundaries;
- the behavior or contract that changes;
- the abstractions involved and how control or data flows among them;
- ownership, lifecycle, ordering, and failure semantics that matter; and
- the relationship between the stated purpose and the visible diff.

This lens judges understandability and ambiguity, not correctness.
Treat missing context as a reviewability gap.
Report what the artifacts communicate,
what remains ambiguous,
and what information the message or diff needs
to make the change understandable on its own.

Do not resolve those gaps from outside evidence.
Do not convert suspicious code, an unexplained behavior change,
or an unanswered question into a correctness finding.

## Report and close the review

For each finding,
give the evidence and affected contract or reader need.
Separate observed facts from inferences and recommendations.
Classify the result as a confirmed defect,
supported risk or design concern,
reviewability gap,
or optional improvement or test idea.

A finding may involve several lenses.
Report it once with the relevant relationships
rather than duplicating it under each lens.
Do not present an optional idea or ambiguity as a defect
merely to make the review look productive.

After actionable findings are fixed,
rerun the relevant lenses and affected validation.
A review pass is not complete merely because it produced a list of findings.
