# Help-me-review behavioral tests

Run each applicable scenario with a fresh subagent that has an empty context
window.
Replace `{GUIDANCE_PATH}` with the path to the candidate under test.

For application tests,
give the runner only the scenario's `Prompt` section.
Keep `Expected behavior` and `Unacceptable behavior` evaluator-only.
For catalog-selection tests,
give the runner the available skill catalog and request,
but withhold the target skill path and body.

Keep trials read-only or confine generated artifacts to a task-local directory
outside the skill and the repository being reviewed.
Capture the raw response, source evidence, and relevant navigation tool results,
then compare it with the held-out expectations.
A scenario passes only when every expected behavior holds
and no unacceptable behavior appears.

Grade the result as a guide for the user's review,
not as an independent code-review verdict.
A passing result must:

- leave the approval decision with the user;
- establish the relevant prior behavior, changed behavior, and scope;
- trace the smallest coherent semantic path through the change;
- provide a guided conversation linked to relevant diff or source ranges,
  using the host's source pane when available and desired;
- use faithful code shapes or a smaller useful visual structure
  when they materially improve understanding;
- copy retained source lines verbatim,
  using only visible `...` elisions inside code or diff shapes;
- keep labels and explanatory prose outside quoted code and diff shapes;
- compress only changes whose semantic equivalence was established;
- preserve meaningful outliers and uncertainty; and
- disclose a material defect or concern encountered while building the guide
  without reorganizing the response around finding production.

For source scenarios, replace `{FIXTURE_DIR}` with this folder's `fixtures`
directory and `{TRIAL_DIR}` with an isolated directory for that run.
Give only the runner prompt to an application agent.
Grade a substantial guide with a separate fresh judge given the input,
artifact, governing guidance, and held-out expectations.
Require the judge to cite source and artifact evidence for its verdict.
Verify that source links use the correct coordinates and that native navigation
requests use the supported tool schema.
When testing actual opening, retain the tool result;
distinguish a queued request from visible file or local Git review navigation.

For pointer-reach tests, give upstream guidance and the realistic task but
withhold the expected route.
Use an independent tool-access trace to establish which references were read;
without that trace, report only application evidence.

For a behavior-changing repair,
first run the relevant scenario against the current guidance.
Rerun the same scenario after the smallest green candidate.
Then integrate the candidate,
remove provisional or duplicated text,
and rerun the scenario and relevant regressions against the final form.
Repeat important or borderline scenarios two or three times
and record the observed pass rate.

Scenario 08 tests the boundary against acquiring or changing a repository
when the available review evidence is incomplete.
Run it when changing evidence collection or completeness guidance.
Scenario 10 tests workflow selection with general review guidance,
standing tracking, a prior checkpoint, pending checks, and a material concern.
Run it when changing investigation or completion guidance;
also run its explicit-assessment variant to check the adjacent valid request.
Its external actions are proposals, so it cannot establish live UI or CI behavior.
Scenario 11 checks web and saved-file PR navigation alongside local branch review.
Scenario 12 checks behavioral pseudocode for consequential runtime flows,
performance accounting, and immutable head-source links.
Run scenarios 02 and 07 with it to preserve faithful source shapes
and the evidence boundary for an excerpt without repository metadata.

Use [scenarios.md](scenarios.md) for the reusable gamut.
