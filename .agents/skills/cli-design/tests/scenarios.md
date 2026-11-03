# CLI design scenarios

## Adapter ownership and structured output

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.
Review this proposed CLI design.
A `deploy` parser callback updates a process-global deployment registry,
enforces release policy, and prints `Starting deployment...` to stdout.
The command later invokes a service and prints JSON to stdout when `--json` is set.
Other clients also need to apply the release policy.
Explain the changes you recommend and the validation that would give confidence
in the public command.
Do not implement or execute it.

### Evaluation

- Mode: judgment.
- Put policy and reusable state transitions in an application or domain operation;
  the parser produces a typed request and the boundary renders its result.
- Keep JSON stdout clean and send progress and diagnostics to stderr.
- Distinguish parser and application tests from process-stream validation.
- Do not invent the release policy.

## Bounded consequential operation

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.
Design the result interface for `archive apply`.
Its backend can emit thousands of lines, write archive state before failing,
and exit nonzero.
Today callers run `archive apply | head -100` because full output is hard to consume.
The command already promises `--preview` without mutation
and a receipt identifier after an application attempt;
the user needs a compact primary result and access to diagnostic detail.
Explain the design and how to validate the promises.
Do not implement or execute it.

### Evaluation

- Mode: judgment.
- Run the backend to completion, preserve its true status and full evidence,
  and expose a bounded useful result with a stable route to omitted details.
- Preserve the promised nonmutating preview and receipt;
  do not assume a failure had no effects.
- Validate execution, status, retrieval, and the promised preview and receipt.
  Use real-process checks where streams, exit status, or shell behavior matter.
  Do not depend on an early-closing consumer.

## Catalog selection

### Prompt

Available skills:

- `cli-design`: `{GUIDANCE_DESCRIPTION}`
- `shell-execution`: Run existing command-line programs for an authorized task
  without designing their interfaces.
- `documentation-review`: Review ordinary prose for clarity and accuracy.

A user asks: “Design a CLI command's JSON output, diagnostics, and exit status
for a new archive operation.”
Choose the skill or skills to load and explain briefly.
Do not implement the request.

### Evaluation

- Mode: conformance.
- Select `cli-design` for the public output and exit-status design.

### Adjacent prompt

Instead, the user asks: “Run the existing `archive list --json` command once
and report its output; no CLI behavior or design is being changed.”

### Adjacent evaluation

- Do not select `cli-design` merely to invoke an existing command.
