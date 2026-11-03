---
name: performing-code-review
description: >
  Use when the agent is responsible for reviewing a diff, commit, pull request,
  or code change and producing behavior, design, readability, documentation,
  or reviewability findings. Excludes responding to feedback on its own changes
  and helping the user conduct their own review.
---

# Performing code review

## Choose the review questions

Choose named engineering questions matching the change's risks and requested outcome.
One undifferentiated pass does not establish correctness, maintainability,
clarity, and reviewability.

| Lens | Question | Governing skill to load |
| --- | --- | --- |
| Behavior | Does the change preserve established external contracts? | — |
| Design | Do abstractions, ownership, and policy flow coherently? | `code-design` |
| Readability | Can a maintainer form and use the system's mental model? | `code-readability` |
| Documentation | Does code teach the contracts and context readers need? | `code-comments` when the change includes comments or other in-code documentation |
| Reviewability | Do the diff and commit message explain the change alone? | — |

Before reviewing, verify that each selected lens's applicable governing skill is loaded.
State the lenses applied and keep their questions distinct;
success under one does not cover another.
Lenses are peers, not a required execution topology or gate sequence.
One reviewer may apply several; use independent reviewers when independent judgment is useful
or an evidence boundary requires isolation, not one agent per lens by default.
For delegation, name the question, evidence boundary, and reporting shape
in a self-contained prompt.

Reviewability imposes evidence order, not priority.
Run it before the reviewer sees anything beyond the diff and commit message;
if other context was already seen, give those artifacts to a fresh isolated reviewer.

## Behavior

Establish the relevant external contract before judging conformance.
Use evidence proportionate to risk, such as authoritative specifications, established behavior,
repository and operational history, or a focused probe at the real boundary.
Tests, validators, implementation source, and mocks are behavioral evidence,
not automatically the contract.

Try to falsify conformance with awkward but valid inputs, partial state, process failures,
cancellation, timing changes, unexpected but valid file names, and realistic boundary behavior.
Check failure reporting, ordering, state transitions, cleanup, and partial success.
Scrutinize happy-path tests, mocks, or assertions shaped around implementation
when they replace the real boundary.

- **Confirmed defect:** established contract plus evidence of implementation violation.
- **Supported risk:** evidenced premises and the contract at risk,
  naming the unverified boundary or behavior.
- **Optional test idea:** a plausible case without claiming it currently fails.

Be skeptical without inventing facts.
An imaginable failure is not a defect without evidence that the contract permits
the scenario and the change mishandles it.

## Design

Apply governing principles through representative changed workflows, rather than restating them.
For each caller and boundary, ask:

- What must callers know, and where do extension, ordering, retry, compatibility,
  and other policy live?
- Who owns operations, state, resources, and transitions?
  Do dependency direction and lifetime match that owner?
- Does abstraction replace caller knowledge or merely move calls behind another name?
  Do infrastructure details remain at system boundaries?
- What does the resulting flow teach the next contributor about the design?

Repeated boundary crossings, callers coordinating another module's internal sequence,
generic runners, super-configurations, god objects, and forwarding-only layers
are investigation signals, not findings.
Report concerns when the change creates real coordination cost,
makes callers carry another component's policy, obscures extension or ownership,
or couples policy to infrastructure.

## Readability

Read as an intelligent maintainer encountering the code cold.
Prioritize:

- source organized around coherent responsibilities;
- visible major stages and ownership boundaries;
- how many conditions, states, branches, and handoffs must be tracked together;
- purpose, context, and invariants the reader must reconstruct;
- how far readers navigate to understand a coherent change; and
- proximity of related concepts and the behavior giving them meaning.

Also check files containing unrelated services and commands manually coordinating many abstractions.
Formatting, local naming, and small expressions should be fixed when found,
but do not let hunting for them displace review of fragmented flow,
scattered ownership, or excessive orchestration.

## Documentation

Judge whether the code is well documented as a system.
Advocate for a capable reader lacking the authoring conversation, implementation history,
and unstated folklore.
At each package, symbol, command, and operational boundary,
identify what readers know and must learn to use or change the system safely.
Do names, types, structure, and documentation together communicate:

- ownership, resource lifetime, ordering, transitions, and invariants;
- zero values, defaults, units, sources, and valid values;
- failure behavior, partial state, and recovery obligations;
- compatibility and external process behavior; and
- rationale for surprising constraints or design choices?

Verify documentation against behavior; inaccuracies should be fixed when found,
but isolated minor corrections are not the lens's goal.
Do not reward volume or request comments repeating implementation,
explaining self-evident statements, or compensating for poor naming or misplaced concepts.

## Reviewability

Assess whether a capable reviewer can understand the change from only its diff and commit message.
Do not run commands, inspect source or repository state,
or use issues, CI, conversation, or other external context.
Do the two artifacts communicate:

- intended outcome and why it is needed;
- scope and relevant unchanged boundaries;
- changed behavior or contracts;
- abstractions and their control or data flow;
- consequential ownership, lifecycle, ordering, and failure semantics; and
- how the stated purpose relates to the visible diff?

Judge understandability and ambiguity, not correctness.
Report what is communicated, what remains ambiguous, and what the diff or message
needs to make the change understandable alone.
Missing context is a reviewability gap; do not resolve it from outside evidence
or turn suspicious code, unexplained behavior, or unanswered questions into correctness findings.

## Report and close

For each finding, give evidence and the affected contract or reader need.
Separate observed facts, inferences, and recommendations.
Classify as confirmed defect, supported risk or design concern, reviewability gap,
or optional improvement or test idea.
Report a finding spanning lenses once, with the relevant relationships.
Do not label optional ideas or ambiguity as defects to make the review look productive.

After actionable findings are fixed, rerun relevant lenses and affected validation.
A review pass is not complete merely because it produced a list of findings.
