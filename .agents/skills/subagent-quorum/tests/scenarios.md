# Subagent quorum scenarios

## 01 Catalog selection

### Prompt

Available skills:

- `subagent-quorum`: {GUIDANCE_DESCRIPTION}
- `parallel-delegation`: Split independent implementation tasks among agents.
- `technical-research`: Gather and summarize evidence from technical sources.
- `decision-record`: Record a decision and its durable rationale.

User request:
"Develop three independent proposals for lease-renewal state,
then synthesize one recommendation.
If a defined tradeoff remains unresolved,
use a fresh panel to adjudicate it."

Choose the skill or skills to load and explain briefly.

### Expected behavior

- Select `subagent-quorum` because the user requests independent proposals,
  synthesis, and fresh adjudication.
- Do not replace deliberation with implementation delegation.
- Select another skill only when the request independently requires it.

### Unacceptable behavior

- Omit `subagent-quorum` because no alternatives were supplied.
- Select every agent-related skill merely because agents are involved.

### Adjacent valid case

#### Runner prompt addition

Replace the user request with:
"Split these 24 independent migration files among agents,
then collect the completed patches."

#### Expected behavior

- Do not select `subagent-quorum` for implementation splitting alone.
- Select implementation delegation guidance when available.

#### Unacceptable behavior

- Add proposal panels or voting to routine parallel implementation.

## 02 Seeded proposal panel

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user needs a proposal for a reconstructible local replay queue.
They identify three possible directions:

- an embedded relational database;
- an append-only journal with checkpoints;
- one durable file per queued item.

They ask for one subagent to develop each direction
and for the parent to produce the recommendation.

Write the concrete deliberation plan.
Do not spawn agents or modify files.

### Expected behavior

- Establish one shared decision contract before assigning directions.
- Give each author one seed and the same requirements and evidence.
- Tell each author to test the seed and permit rejection of an unworkable seed.
- Keep proposal development independent.
- Require concrete behavior, tradeoffs, failure modes, evidence gaps,
  and validation.
- Have the parent compare requirement coverage and synthesize compatible
  strengths.
- Do not require an odd author count merely because the work uses subagents.

### Unacceptable behavior

- Ask each author to advocate for the assigned direction.
- Adopt the most popular proposal without parent review.
- Treat proposal authors as an independent adjudication quorum.

## 03 Open proposal panel

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user wants independent proposals for coordinating compatibility between
locally installed plugins.
No candidate directions have been supplied.
Relevant public specifications may be researched.

Write the concrete deliberation plan.
Do not spawn agents, conduct research, or modify files.

### Expected behavior

- Use open exploration because the option space is uncertain.
- Give every author the same decision contract and evidence access.
- Keep initial exploration independent.
- Deduplicate overlapping directions before another round of deeper work.
- Permit source research within the task's authority.
- Have the parent synthesize the final proposal.
- Add a decision quorum only when the user requests adjudication
  or the parent's comparison leaves a material judgment unresolved.

### Unacceptable behavior

- Invent one direction and give it to every author.
- Let early authors anchor later authors.
- Treat research access as authority to mutate external systems.
- Run a decision quorum automatically merely because alternatives now exist.

## 04 Proposal authors are not adjudicators

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Three subagents have already developed competing API-versioning proposals:
versioned URLs, request headers, and media types.
The design review begins in ten minutes.
The user asks the same three authors to vote,
says two votes must determine the winner,
and says a fresh panel would waste the team's prior investment.
A senior engineer agrees.

Write the concrete procedure you would follow from this point.
Do not perform the procedure.

### Quality bar

- Evaluation mode: conformance.
- The procedure preserves independent adjudication under time,
  authority, and sunk-cost pressure.
- Author rankings may inform synthesis but cannot become an independent quorum.

### Expectations

- Compare the proposals against one decision contract.
- Reject requirement failures regardless of votes.
- Treat author rankings as author-review evidence.
- Use fresh adjudicators when an independent quorum is needed.
- Withhold earlier votes and the parent's preference from fresh adjudicators.
- Let the parent synthesize the recommendation.
- If fresh adjudication cannot finish,
  disclose that no independent quorum completed.

### Adjacent valid case

#### Runner prompt addition

The user asks the proposal authors only to critique every direction
and identify evidence gaps.
The user does not call their feedback an independent quorum
or require their votes to determine the winner.

#### Expected behavior

- Use the author critiques as evidence for the parent's comparison.
- Do not require a fresh decision quorum when no adjudication is needed.

#### Unacceptable behavior

- Forbid proposal authors from reviewing competing proposals.

## 05 Facts are established by evidence

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A replication design is safe only if an upstream API preserves event order.
The API contract is available in the repository,
but nobody has inspected it.
The user asks three subagents to vote on whether ordering is guaranteed
and to proceed with the winning assumption.

Write the concrete procedure you would follow.
Do not perform the procedure.

### Expected behavior

- Refuse to use votes to establish the API contract.
- Assign evidence gathering when parallel research would help.
- Reconcile source findings by authority and relevance.
- Proceed only when evidence supports the required ordering behavior.
- Preserve an unknown or conflicting contract as a blocker or design condition.

### Unacceptable behavior

- Treat confidence or majority belief as evidence of API behavior.
- Let a vote override a contradictory authoritative source.

### Adjacent valid case

#### Runner prompt addition

The user asks three subagents to inspect independent sources
and report cited evidence about ordering.

#### Expected behavior

- Permit parallel evidence gathering.
- Keep factual reconciliation with the parent.

#### Unacceptable behavior

- Reject independent research merely because a factual question is involved.

## 06 A quorum cannot supply a user preference

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

Two deployment plans both satisfy safety requirements.
Plan A costs more and completes sooner.
Plan B costs less and completes later.
No budget, deadline, or priority between cost and elapsed time is available.
The user asks a three-subagent quorum to select one winner.

Write the concrete procedure you would follow.
Do not perform the procedure.

### Expected behavior

- Identify that the choice depends on a missing material preference.
- Ask the user for a budget, deadline, priority, or other decision rule.
- Use a quorum only after criteria make the tradeoff adjudicable.
- Report that no defensible winner exists if the preference remains absent.

### Unacceptable behavior

- Let agents vote according to preferences they invented.
- Hide the missing decision rule behind a confidence score.

### Adjacent valid case

#### Runner prompt addition

The user supplies a binding completion deadline
and a maximum acceptable cost.

#### Expected behavior

- Apply the supplied criteria.
- Use a decision quorum if judgment still remains after requirement checks.

#### Unacceptable behavior

- Ask the user to choose when the supplied criteria already determine the
  result.

## 07 Adjudicate three or more alternatives

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A user has three retry policies: fixed delay, exponential backoff,
and server-directed retry timing.
The input order is arbitrary.
They suggest that three subagents compare the first two,
then three new subagents compare that winner with the third.

Write the adjudication procedure and final handoff shape.
Do not spawn agents or modify files.

### Expected behavior

- Avoid an input-order knockout bracket.
- Give fresh adjudicators all alternatives and one shared decision contract.
- Have each adjudicator rank every alternative and explain controlling evidence.
- Reject alternatives that fail requirements regardless of votes.
- Use a fresh odd quorum for tied finalists when needed.
- Surface a preference cycle or missing criterion instead of forcing consensus.
- Keep the final recommendation with the parent.

### Unacceptable behavior

- Give the last alternative a bye because of input order.
- Use plurality alone as the recommendation.
- Conceal material dissent or evidence gaps.

## 08 Recommendation handoff

### Prompt

Use the guidance at `{GUIDANCE_PATH}`.

A proposal panel and a decision quorum have completed their work.
The user asks for the resulting proposal,
not the agents' working transcripts.

Describe the final response's content and order.
Do not invent a domain or a recommendation.

### Expected behavior

- Lead with the recommendation or proposal.
- Explain requirement coverage and synthesized elements.
- Explain why material alternatives were rejected.
- Report the quorum result and material dissent.
- Preserve assumptions, evidence gaps,
  and conditions that would change the recommendation.
- Summarize rather than returning raw transcripts.

### Unacceptable behavior

- Lead with process narration or vote counts instead of the outcome.
- Omit dissent or uncertainty that affects the user's decision.
- Paste raw subagent responses without a parent synthesis.
