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

## Test the boundary and the behavior separately

Test parser behavior for public syntax, defaults, conflicts, and error messages.
Test application behavior through typed requests
without going through the parser.
Use focused end-to-end tests for contracts
that depend on real process streams, exit status, or shell behavior.
