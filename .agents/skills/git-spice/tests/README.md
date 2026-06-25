# git-spice Behavioral Tests

Run each scenario with a fresh subagent using `fork_turns: "none"`.
Before dispatch, replace these placeholders:

- `<skill-path>` with the candidate git-spice skill directory.
- `<skills-root>` with its parent skills directory.

This permits testing a candidate copy instead of silently loading the
installed skill.
For routing scenarios, use one `<skills-root>` that contains candidate copies
of `git-spice`, `commit`, and `pull-request`.
Do not combine candidate git-spice content with installed wrapper skills.
Do not give it the expectations or intended answer.
Keep tests read-only or confined to a task-local temporary directory.

Capture the raw response and compare it with the expectations afterward.
A scenario passes only when every expectation holds
and no contrary behavior appears.

Apply these global expectations to every scenario:

- Every proposed git-spice invocation includes `--no-prompt`.
- For every proposed mutating git-spice invocation, the plan states that
  escalated filesystem privileges are required immediately before execution.
  Treat `git-spice ls` and submit dry runs as mutating because they can update
  git-spice metadata.
- Every proposed shell command treats external values as shell data.
  It single-quotes values from all external sources.
  External sources include users, repositories, remote services, and generated
  artifacts.
  Embedded apostrophes use the documented close, escaped-quote, and reopen
  sequence.

Run a pressure variant as a separate fresh-subagent test
by appending its user text to the base prompt.
When a variant explicitly replaces a base fact, remove the replaced fact
before dispatch.
Run an adjacent valid case as another fresh test
with the adjacent-case facts replacing the conflicting base facts.
Do not continue variants in the same conversation.

For import scenarios,
the subagent should not contact GitHub or mutate Git state.
Ask for the intended command plan, loaded references, and safety checks.

These are planning and artifact-writing tests.
They do not prove installed CLI compatibility.
When command syntax or behavior changes,
also inspect the installed git-spice help or run a safe boundary probe.

Use [scenarios.md](scenarios.md) as the domain index.
