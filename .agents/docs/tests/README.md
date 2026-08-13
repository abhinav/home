# Documentation Guidance Behavioral Tests

Run each scenario with a fresh subagent that has an empty context window.
For application tests, give the subagent the relevant guidance path and scenario prompt.
For routing tests, give the subagent the task and guide catalog
without identifying the guide it should select.
Give the subagent only the text under the scenario's `### Prompt` heading.
Do not provide the scenario title,
quality bar, expectations, pressure variants, adjacent cases,
or intended answer.
When a pressure variant or adjacent case uses explicit subheadings,
give a fresh subagent the base `### Prompt`
plus only that variant's `#### Prompt addition`.
Keep the variant's `#### Expected behavior` hidden with the other expectations.
For older sections without those subheadings,
all content before the first evaluator bullet list is the prompt addition
and the bullets remain evaluator-only.
Keep tests read-only or confined to a task-local temporary directory
outside the target repository.

Capture the raw response or artifact
and compare it with the quality bar and expectations afterward.
For a substantial written artifact, give a separate fresh judge the artifact,
source input, quality bar, and applicable guidance.
Require a verdict supported by the source and artifact.
A scenario passes only when it meets the quality bar, every expectation holds,
and no contrary behavior appears.

For repair-loop scenarios, first run the relevant scenario against the current guidance.
After the edit, rerun that exact scenario.
Also run each applicable pressure variant and adjacent valid case.
Repeat important or borderline scenarios two or three times
and record the observed pass rate.
Rerun previously passing scenarios
when the change can affect their protected behavior.

Reusable scenarios are grouped by the behavior they primarily protect:

- [Prose formatting](scenarios/prose-formatting.md):
  source representation, semantic line breaks, and line width.
- [Prose writing](scenarios/prose-writing.md):
  causal explanation, prerequisites, evidence, and explanatory scale.
- [Code comments](scenarios/code-comments.md):
  documentation comments, implementation comments, and teaching structure.
- [Code readability](scenarios/code-readability.md):
  abstraction depth, change locality, and physical organization.
- [Code design](scenarios/code-design.md):
  ownership, contracts, representations, compatibility, and evolution.
- [Code testing](scenarios/code-testing.md):
  marginal evidence, change-detector avoidance, and detector ownership.
- [Guidance routing](scenarios/guidance-routing.md):
  selecting the guides required by the artifact and task.

A scenario may exercise several guides.
Keep it with the owner of the behavior it primarily protects
rather than duplicating its test contract across files.
