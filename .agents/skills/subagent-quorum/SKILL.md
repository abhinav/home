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

Choose the number of proposal authors from the number of useful directions.
Three is a useful default, but proposal panels do not need an odd count.

Use seeded exploration when distinct directions are already visible.
Give each author one direction and the same decision contract.
Tell the author to test the direction rather than advocate for it,
and permit the author to reject an unworkable seed.

Use open exploration when the option space is uncertain.
Give each author the same decision contract and ask for an independent
direction.
Deduplicate overlapping directions before spending another round on depth.

Do not show proposal authors one another's work while they are developing their
proposals.
Require concrete behavior, tradeoffs, failure modes, assumptions,
evidence gaps, and validation.
Let authors inspect relevant sources or conduct research when the task permits
it.
Give authors equivalent access to the shared evidence,
and record any evidence that only one author could inspect.

The parent compares every proposal against the decision contract,
then synthesizes compatible strengths into the recommendation.
Do not adopt a proposal wholesale merely because it received the most support.
Do not add a decision quorum merely because the panel produced alternatives.
Use adjudication only when the user requests it
or the parent's comparison leaves a material judgment unresolved.

## Run a decision quorum

Use fresh subagents that did not author the proposals being adjudicated.
Give every adjudicator the same alternatives, decision contract,
and supporting evidence.
Do not include earlier votes, another adjudicator's reasoning,
or the parent's preferred outcome.

Use an odd number of adjudicators so a binary choice can produce a majority.
Use three by default and increase to another odd count only when the decision
warrants the additional cost.
Each adjudicator independently evaluates every alternative,
identifies disqualifying requirement failures,
states a choice or ranking, and explains the evidence that controls it.

For two alternatives, use the majority as one input to the parent's decision.
For three or more alternatives, have each adjudicator rank all alternatives
against the shared criteria.
Do not use an input-order knockout bracket.
If no stable winner emerges, give the tied finalists to a fresh odd quorum.
If preferences form a cycle, identify the conflicting criterion or missing
evidence instead of manufacturing consensus.

Proposal authors may critique every alternative,
but their rankings are author-review evidence rather than an independent
decision quorum.
When fresh adjudicators are unavailable, the parent must synthesize from the
decision contract and disclose that no independent quorum was completed.
When concurrency is limited, run fresh adjudicators sequentially rather than
reusing proposal authors or reducing a voting panel to an even count.

## Produce the recommendation

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
