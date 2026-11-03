---
name: help-me-review
description: >
  Use when the user wants to understand a code change and focus their own
  review of a pull request, commit, or diff.
---

# Help me review

## Serve the reviewer

The user remains the reviewer.
Deliver a guided reading directly in conversation so they can understand the change,
follow consequential behavior, and judge important choices.
Use other review guidance to substantiate the explanation; guided reading remains the deliverable.
Standing review tracking can stay open for the user's disposition after delivery.
Approval recommendations and readiness assessments are separate deliverables
when explicitly requested.

Explain supplied excerpts in chat using them as anchors.
For existing files or review views, open source beside chat when supported
and link explanations to evidence.
Semantic subjects may span files.
Chat carries explanation and follow-up; source views carry full code.
For chat-only requests or hosts without source panes, use links and small faithful excerpts.

Start from good code by capable agents: unless evidence says otherwise,
assume it builds, tests pass, and routine implementation details are handled competently.
Help the user judge consequential choices, not establish basic implementation competence.
Do not start with a line-by-line hunt for small bugs.
Routine defensive mistakes,
style issues, and speculative edge cases are not organizing questions;
obvious material defects still matter when encountered.
Spend attention on changed contracts and behavior, data flow, control flow and state transitions,
load-bearing assumptions, and consequences for callers and the system.

## Establish the evidence

Preserve the original diff and supporting source used.
Use supplied files in place; save fetched or mutable evidence when needed to recover
the reviewed version in a follow-up.
A raw diff plus optional supporting source suffices; no local repository or refs are required.
Use only evidence and read-only source surfaces already available to the task.
Never clone, fetch, pull, check out, switch branches, create a worktree,
or otherwise acquire or change a repository for the review.
Read existing checkouts without changing Git state;
available provider or API access may retrieve specific diffs or supporting files.
If context remains unavailable, deliver the guide from existing evidence
and state uncertainty where it affects judgment.
Identify the repository or supplied input and known revisions;
when revisions are unavailable, identify the input and its scope.
Get further source from the same revision, or identify its different revision and relevance.

For follow-ups, recover the subject's original source and version first.
Distinguish later changes and use preserved evidence if native views have advanced.
Before collecting more evidence, opening source, or writing source links,
read [Evidence and navigation](references/evidence.md)
for commands, tool arguments, versions, and coordinates.

## Build the change model

Before presenting, trace the smallest coherent semantic path:

1. Relevant prior behavior and the change's problem or purpose.
2. Changed definition, contract, operation, or ownership boundary.
3. Applicability conditions and important transformations, decisions, or state transitions.
4. Observable effects and affected callers or systems;
   nearby unchanged paths when they clarify scope.
5. Changed tests as specifications of scenarios, stimuli, and outcomes:
   do they establish the intended contract or merely agree with implementation?

Reason across definitions, callers, tests, and configuration, not isolated lines.
Let a question drive each further investigation:
what would a caller, contract, test, or runtime check establish,
and how would the answer change the explanation or user's judgment?
Refresh changing status when it affects the explanation
or the user requests a current readiness assessment.
Treat plausible failures as questions, not defect evidence.
If governing contracts or runtime evidence are unavailable, retain uncertainty
and explain what the answer would change.

Keep and examine anchors exposing new contracts, conditions, transformations,
ownership boundaries, lifecycle edges, external effects, compatibility constraints,
or consequential algorithms or architecture choices.
Compress repeated setup, generated output, call-site migrations, or cases only after checking
equivalence in caller contracts, inputs, timing, ownership, failure behavior,
lifecycle, and effects.
Distinct contexts are distinct subjects: a repeated call during shutdown,
under another lock or task lifetime, or across another compatibility boundary may not be mechanical.
Language changes expression, not importance.
If importance is uncertain, retain the code in the model and inspect the uncertainty;
compression targets and finding counts do not replace judgment.

## Guide the user's reading

Account for every changed file and meaningful group,
organized by semantic path rather than file order.
Lead with purpose, then contrast relevant prior and changed behavior.
For multiple subjects, give a short map in reading order with one sentence on why each matters.
Introduce definitions, actors, ownership boundaries, and prerequisites before relying on them.

Show the smallest faithful code shape when syntax exposes a relationship to judge.
Use behavioral pseudocode when implementation obscures consequential runtime flow
or conceptual comparison is requested.
Use a visualization when several actors, states, branches, or ownership boundaries
are harder to understand in linear prose or code.
Before choosing or constructing these forms,
read [Presentation forms](references/presentation-forms.md) for fidelity and flow rules.

Lead each subject with clickable Markdown links to available source ranges
or identify its supplied excerpt; do not use plain or code file references when links are available.
Explain prior behavior, changed behavior, and what the user should judge.
For compressed groups, name the anchor's coverage and direct the user separately
to each meaningful exception.
Keep representative and grouped source reachable through available links,
with material uncertainties beside affected subjects.

Deliver the coherent guide in the initial response, not one user turn per subject or hunk.
Ordinary replies can follow callers, compare cases, or revisit subjects.
Surface material defects, supported risks or design concerns,
and missing contract or runtime evidence where they affect judgment.
Distinguish facts, supported inferences, and unresolved questions.
Do not hunt for findings or manufacture small issues.

Finish when the user can follow the consequential change, locate every meaningful group's evidence,
understand what was compressed and why, and identify their remaining decisions or questions.
Unresolved questions belong with evidence and consequence;
resolving every question or waiting for pending checks is not required to deliver the guide.
Before returning, compare every code and diff shape with source,
move inserted annotations or explanations outside it,
and verify each source link's file, version, and range.
Report navigation limitations affecting evidence inspection.
