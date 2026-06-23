# Multiwork Behavioral Tests

Run each scenario with a fresh subagent using `fork_turns: "none"`.
Give the subagent the skill path and scenario prompt.
Do not give it the expectations or intended answer.
Keep tests read-only or confined to a task-local temporary directory.

Capture the raw response and compare it with the expectations afterward.
A scenario passes only when every expectation holds
and no contrary behavior appears.

For fresh-context executability tests, use two phases.
Agent A creates the durable files.
Agent B receives only the project path and applicable repository instructions,
plus the relevant `plan.md` path.
Agent B must not receive the original prompt or conversation.
Agent B must not receive the workstream log or skill instructions
as substitute mission context.
Agent B must execute the first safe, concrete plan step and return its evidence.
The test passes only if Agent B acts without asking for the task to be restated
or reading another workstream's files.

For log self-containment tests,
give a fresh agent only the project path,
applicable repository instructions,
and the relevant `log.md` path.
Do not provide the plan, original prompt, conversation, or skill.
Ask the agent to explain the owned outcome,
record organization, material evidence, latest recovery checkpoint,
and unresolved uncertainty.
The agent should interpret the record,
not execute the mission or guess mutable state beyond the checkpoint.

## Scenario Families

Use the smallest family that covers the behavior under review:

| Family | Scenarios | File |
| --- | --- | --- |
| Core layout and lifecycle | 01, 02, 05, 06, 11, 17, 20, 23-25, 27, 35-36 | [core-layout.md](core-layout.md) |
| Plans and supporting records | 12, 14-16, 21-22, 38-39 | [plans-and-records.md](plans-and-records.md) |
| Delegation and completion | 03-04, 07, 09-10, 13, 26 | [delegation-and-completion.md](delegation-and-completion.md) |
| Evergreen workstreams | 18 | [evergreen.md](evergreen.md) |
| Workspaces and worktrees | 08, 19, 28-34, 37 | [workspaces.md](workspaces.md) |

Scenario IDs remain stable across these files.
For a behavioral repair,
first run the relevant scenario without the changed guidance.
After the edit, rerun that exact scenario.
Also rerun its pressure variant when one is defined.
