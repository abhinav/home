# Behavioral evidence

Keep evidence at the fidelity needed to carry its meaning.
Preserve compact motivating input or output verbatim
when its wording, structure, threshold, or search terms matter.
When raw evidence is long, noisy, or sensitive,
retain the smallest safe, self-contained excerpt that carries the claim.
Paraphrase when the original form adds nothing.

For a bug fix, preserve a regression test's demonstrated failure against
the old implementation and its corrected result against the fix.
Name the existing contract, triggering input, and expected versus actual
behavior so the reader can assess what the comparison proves.
A regression test can itself reveal the violation of an existing contract;
a separate production incident is not required.
A test written to define new behavior does not by itself establish
that the old implementation violated an existing contract.
Without a pre-change observation, make no reproduction claim.

For manual verification, preserve the exercised behavior and observed result.
Identify the relevant revision and environment when they establish what
was verified, and retain supporting output or a captured-result link.
A staging deployment followed by a successful behavioral probe qualifies;
deployment completion alone does not demonstrate the changed behavior.
A local build run with a new option qualifies when the invocation and observed
outcome demonstrate that option's behavior; build success alone does not.

Measurements earn space when they substantiate the behavioral claim.
Keep the workload, comparison, and limits needed to interpret them.
For example, a reduction in peak memory under a stated workload can substantiate
a memory claim; a successful benchmark run cannot.

Preserve uncertainty when it explains a design choice, compatibility limit,
or decision the reader must make about the system.
State the affected behavior and consequence, not the unavailable check
or the writer's inability to run it.
For example, an unconfirmed appliance format can explain retaining a legacy
reader; an unavailable local test environment does not explain that design.
Narrow an unsupported claim instead of appending a testing disclaimer.
