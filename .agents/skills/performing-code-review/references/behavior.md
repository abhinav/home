# Behavior review

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
