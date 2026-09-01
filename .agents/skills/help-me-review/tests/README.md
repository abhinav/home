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

Keep trials read-only.
Capture the raw response,
then compare it with the held-out expectations.
A scenario passes only when every expected behavior holds
and no unacceptable behavior appears.

Grade the result as a guide for the user's review,
not as an independent code-review verdict.
A passing result must:

- leave the approval decision with the user;
- establish the relevant prior behavior, changed behavior, and scope;
- trace the smallest coherent semantic path through the change;
- use faithful code shapes or a smaller useful visual structure
  when they materially improve understanding;
- copy retained source lines verbatim,
  using only visible `...` elisions inside code or diff shapes;
- keep labels and explanatory prose outside quoted code and diff shapes;
- compress only changes whose semantic equivalence was established;
- preserve meaningful outliers and uncertainty; and
- disclose a material defect or concern encountered while building the guide
  without reorganizing the response around finding production.

For a behavior-changing repair,
first run the relevant scenario against the current guidance.
Rerun that exact scenario after the smallest green candidate.
Then integrate the candidate,
remove provisional or duplicated text,
and rerun the scenario and relevant regressions against the final form.
Repeat important or borderline scenarios two or three times
and record the observed pass rate.

Use [scenarios.md](scenarios.md) for the reusable gamut.
