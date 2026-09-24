# Evidence and validation

Keep evidence at the fidelity needed to carry its meaning.
Preserve compact motivating input or output verbatim
when its original wording, structure, threshold, or search terms matter.
When raw evidence is long, noisy, or sensitive,
retain the smallest safe, self-contained excerpt that carries the claim.
Paraphrase when the original form adds nothing.

A test written to drive new behavior records development process,
even when its author observes the expected red result before implementation.
That result shows that the purpose-built test distinguishes unimplemented
behavior; it does not establish an independently existing failure.
Do not preserve that TDD red/green chronology as commit-message evidence.
A regression test supplies causal evidence only when it reproduces a failure
established independently of the test's introduction,
such as an observed product failure or supported-boundary reproduction,
and the post-change result materially establishes the repair.

Measurements, real-boundary probes, and material validation gaps
earn space under the same standard.
A gap is material when an unresolved claim and its consequence
change how the reader should evaluate, use, or continue the change.
State that claim boundary and consequence;
do not turn unavailable evidence into an activity report.
Without a pre-change result, make no reproduction claim.

## Structure validation evidence

A `Validation` section is optional.
Use it only when it carries claim-bearing evidence
or a material validation gap.
Map every retained result or gap to the claim it supports.
If no useful validation content remains, omit the heading and section entirely.
Do not place purpose-built TDD red/green results,
other test-first chronology, routine pass status,
or a command inventory under `Validation`.
Evidence can instead remain near its claim when a separate section
would make the relationship less clear.
