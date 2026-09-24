---
name: subagent-quorum
description: >
  Use when the user requests a subagent quorum, independent design proposals,
  panel-based synthesis, or a multi-agent tie-break between defined
  alternatives. Do not use for ordinary delegation, parallel fact gathering,
  implementation splitting, or a choice that depends on a missing user
  preference.
---

# Subagent quorum

Use independent subagents to improve a proposal or adjudicate a defined
decision.
The parent agent remains responsible for the recommendation.
A vote is evidence about judgment under shared criteria;
it does not establish facts, supply missing requirements,
or excuse the parent from comparing the alternatives.

## Establish the decision contract

Before spawning subagents, state:

- the proposal or decision the user needs;
- the requirements, constraints, and non-goals;
- the evidence available and the evidence subagents may gather;
- the criteria that distinguish a better result;
- the output the parent must deliver.

Keep the work within the user's authority.
A request for a proposal or decision does not authorize implementation,
repository mutation, publication, or other external effects.
Give each subagent only the context and permissions needed for its role.

Classify each material unknown before deciding whether a quorum can resolve it:

- Inspect sources or run a supported probe for a factual question.
- Ask the user when the result depends on a missing material preference.
- Use a proposal panel to explore materially different directions.
- Use a decision quorum for a tradeoff among defined alternatives
  under established criteria.

## Run a proposal panel

When exploring materially different directions,
read [Proposal panel](references/proposal-panel.md)
before assigning proposal authors.

## Run a decision quorum

When adjudicating defined alternatives under established criteria,
read [Decision quorum](references/decision-quorum.md)
before assigning adjudicators.

## Produce the recommendation

The parent compares every proposal against the decision contract,
then synthesizes compatible strengths into the recommendation.
Do not adopt a proposal wholesale merely because it received the most support.
Do not add a decision quorum merely because the panel produced alternatives.
Use adjudication only when the user requests it
or the parent's comparison leaves a material judgment unresolved.

The parent rejects any alternative that fails a requirement,
regardless of its vote count.
Reconcile disagreements caused by different facts, assumptions,
or workload models before treating them as judgment differences.

Lead with the recommendation or proposal.
Then report:

- how it satisfies the requirements;
- which elements were synthesized from the proposal panel;
- why the material alternatives were rejected;
- the quorum result and material dissent, when adjudication occurred;
- remaining assumptions, evidence gaps, and conditions that would change the
  recommendation.

Summarize the reasoning rather than returning raw subagent transcripts unless
the user asks for them.
