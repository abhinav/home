---
name: cli-design
description: >
  Design or change command-line interfaces: commands, flags, output streams,
  structured output, exit status, and the boundary between command adapters
  and application behavior. Do not use merely to invoke an existing command.
---

# Command-line interface design

## Keep commands at the boundary

Commands adapt syntax to application behavior:
parse input into a typed request, invoke an application or domain operation,
and translate its result into the output contract.
Keep policy, state transitions, and reusable workflows in those operations,
not in commands, parser callbacks, or framework hooks.
These operations should be testable without argument parsing.

Organize command implementation files around user-facing operations
or cohesive operation families.
Keep each command's request, validation, dispatch, and output translation
near one another.
Avoid declaration-kind files collecting every command, command type, or command service.
For shared behavior, extract an application operation or focused adapter component,
not a large command utility layer.

## Preserve output contracts

Reserve stdout for the requested result, especially pipe/file/machine data.
Send diagnostics, progress, and logs to stderr;
structured output must contain no incidental status or logs.
Render at the command boundary so operations need not know whether output is
text, JSON, or another representation.

Return enough to determine what happened, what changed, and available next actions.
Choose content for that decision, not an unbounded internal transcript.
Useful result behavior includes:

- Quiet success when the requested result establishes completion.
- A bounded, stable structure for machine consumption.
- The violated invariant and affected target on failure, with known recovery
  when it exists.
- Inspection or dry run before consequential effects;
  a receipt or postcondition query after a state-changing operation.

Keep output suppression at the command boundary; run the complete operation.
Preserve full output and true exit status, return what the next decision needs,
and provide a stable route to omitted evidence.
Do not require callers to pipe through `head` or `tail` for manageable output:
early closure can terminate execution, discarded output can lose context,
and pipelines can hide the command's status.

## Test boundary and behavior separately

- Parser tests cover public syntax, defaults, conflicts, and error messages.
- Application tests exercise typed requests without the parser.
- Focused end-to-end tests cover contracts depending on real process streams,
  exit status, or shell behavior.

For intentionally bounded output, test complete execution, preservation of the
original exit status, and retrieval of omitted evidence.
For consequential operations, test the preview, receipt, or postcondition behavior
promised by the command.
