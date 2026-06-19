# Code review

A review should name the engineering question it is trying to answer.
Do not treat one undifferentiated review pass as proof of correctness,
maintainability,
and clarity.
Choose the lenses that match the risk of the change.

## Behavioral review

Check whether the implementation satisfies its external contract,
including failure behavior,
ordering,
state transitions,
and interactions with real boundaries.
Look for cases where mocks,
happy-path tests,
or implementation assumptions could conceal a user-visible failure.

An antagonistic behavioral review should actively construct inputs,
timing,
and environmental conditions that could invalidate the implementation's
assumptions.
Distinguish observed failures from plausible risks that still need evidence.

## Architecture review

Trace representative workflows through modules and abstraction layers.
Check that each important decision has a clear owner,
dependency direction remains intentional,
and infrastructure details stay at system boundaries.

Repeated boundary crossings,
callers coordinating several internal steps,
and abstractions that only forward data are signs that a boundary may be wide
and shallow.
Evaluate whether each abstraction reduces what its callers need to know.

## Readability review

Judge readability by the cognitive load required to understand and change a
coherent section of code.
Inspect:

- how many conditions and states must be tracked at once
- how far a reader must navigate to understand dependencies or invariants
- whether related concepts are physically near one another
- whether names expose the domain operation rather than the mechanism
- whether control flow converges or requires reconstructing several branches
- whether comments supply missing context instead of narrating statements

Formatting and naming matter,
but they do not compensate for scattered ownership or excessive orchestration.

## Documentation review

Review documentation from the intended reader's starting point.
Confirm that public contracts,
named concepts,
invariants,
ownership,
and non-obvious failure behavior are explained where readers need them.
Do not assume access to implementation history,
review discussion,
or neighboring modules.

Read and apply `~/.agents/docs/code-comments.md`
when the review covers in-code documentation or implementation comments.

## Close the review loop

Report findings with the evidence and affected contract needed to evaluate them.
Separate confirmed defects,
supported design concerns,
and optional improvements.

Fix actionable findings,
then rerun the relevant review lens and affected validation.
A review pass is not complete merely because it produced a list of findings.
