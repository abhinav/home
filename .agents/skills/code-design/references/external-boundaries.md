# External boundaries

Domain code should speak in domain concepts.
Adapters may know both an external representation and the domain,
but transport requests, database rows, vendor clients,
generic command runners, and framework lifecycles
should not spread through business logic.
Translate at the boundary that owns the external mechanism.

Model an external system in terms of the capability the domain needs.
An adapter for an external process should own command syntax,
working directory, environment, output parsing,
exit status, and tool-specific failures.
The domain should request the operation,
not reconstruct the external protocol.
Do not create a service boundary for a small local probe
whose result and mechanism have no domain policy;
the boundary must remove real knowledge, not anticipate hypothetical reuse.

Establish cohesive ownership before introducing a process or network boundary.
Distribution does not create a meaningful domain boundary;
it adds latency, partial failure, versioning, observability,
deployment, and operational ownership.
Introduce it only when demonstrated needs such as independent lifecycle,
scaling, security, or failure isolation justify those costs.

Translate across a boundary when ownership, representation,
or contract actually changes.
Do not create duplicate types merely to make every package look isolated.
A canonical generated or shared type can be the domain type
when the domain truly owns its meaning and compatibility.
