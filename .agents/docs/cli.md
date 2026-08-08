# Command-line interface design

Apply these principles when designing or changing a command-line program.

## Keep commands at the boundary

A command is an adapter between command-line syntax and application behavior.
It should parse input and produce a typed request,
then invoke an application or domain operation
and translate the result into the command's output contract.

Do not make command implementations a second business-logic layer.
Policy, state transitions, and reusable workflows belong
in application or domain abstractions.
Those abstractions should be testable
without parsing command-line arguments.
Parser callbacks and framework hooks should not become hidden homes for that
behavior.

## Organize commands by responsibility

Organize command implementation files around user-facing operations
or cohesive operation families.
Keep a command's request shape, validation, dispatch, and output translation
near one another.

Avoid collecting every command, command type, or command service
into declaration-kind files.
When several commands share behavior,
extract an application operation or a focused adapter component
rather than a large command utility layer.

## Preserve output contracts

Treat standard output and standard error as separate interfaces.
Reserve standard output for the result the user requested,
especially data intended for pipes, files, or machine consumption.
Write diagnostics, progress, and logs to standard error.

Structured output modes must not be contaminated
by logs or incidental status messages.
Keep rendering decisions at the command boundary
so application operations do not need to know
whether a result will be printed as text, JSON, or another representation.

## Make outcomes interpretable

A command result should let the caller determine what happened,
what changed, and which action is available next.
Design output for the decision it supports,
not as an unbounded transcript of the command's internal work.

Useful result behavior includes:

- quiet success when the requested result already establishes completion
- a bounded, stable structure for results consumed mechanically
- the violated invariant and affected target when an operation fails
- a known recovery action when one exists
- a stable retrieval path for details omitted from the primary result
- an inspection or dry-run mode before consequential effects
- a receipt or postcondition query after a state-changing operation

Output suppression belongs at the command boundary.
The command should run the complete operation,
preserve the full output and true exit status,
return the information needed for the next decision,
and provide a stable route to any omitted evidence.

Do not require callers to truncate a command with `head` or `tail`
to obtain a manageable result.
Early-closing consumers can terminate the command before completion,
discarded output can remove necessary context,
and pipelines can hide the command's exit status.

## Test the boundary and the behavior separately

Test parser behavior for public syntax, defaults, conflicts, and error messages.
Test application behavior through typed requests
without going through the parser.
Use focused end-to-end tests for contracts
that depend on real process streams, exit status, or shell behavior.
When output is intentionally bounded,
test that the complete operation still runs,
the original exit status is preserved,
and omitted evidence remains retrievable.
For consequential operations,
test the preview, receipt, or postcondition behavior promised by the command.
