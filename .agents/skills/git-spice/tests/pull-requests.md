# Pull Request Scenarios

## 01 Preserve Metadata When Publication Is A Side Task

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A configuration-migration investigation is complete.
The branch has one commit and no open pull request.
The repository has no PR template.
The user asks for a terse chat handoff plus a draft PR as a final side task.

The commit is:

````text
Preserve cache namespaces during migration.

Version 2.3 dropped the tenant namespace during legacy migration.
For example, this source configuration:

```toml
[cache]
namespace = "tenant-blue"
```

could become:

```toml
[cache]
namespace = "default"
```

Import, startup migration, manual repair, and rollback recovery used the same
normalization path.
Route all four paths through `PreservedNamespace`.
Rollback recovery continues to restore entries in reverse write order.

Validation
----------

A migration probe preserved `tenant-blue` through import and startup migration,
and rollback restored the original namespace.
````

Produce the PR metadata,
exact proposed submit command,
and concise handoff without running commands.

### Expectations

- Treat PR metadata as distinct from the concise handoff.
- Copy the single-commit subject exactly.
- Preserve the complete commit-body content and its high-value structure.
- Normalize both configuration snippets into top-level code blocks
  with four leading spaces.
- Do not invent replacement Summary, Problem, Behavior, or Validation sections.
- Use `git-spice branch submit --draft --no-prompt`
  with explicit title and body.

### Pressure Variant

A senior engineer says the commit already has the details
and the review window closes in ten minutes.

- Keep the handoff terse without shortening or regenerating the PR body.

### Adjacent Valid Case

The repository requires `Impact` and `Verification` headings.

- Preserve configuration blocks, paths, guarantees, and ordering.
- Preserve `Verification` with the namespace-preservation observations,
  under `writing-commit-messages`.
- Narrow unsupported migration claims without reporting check status.

## 02 Submit A Whole Stack From Commit Metadata

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A three-branch stack has one polished commit per branch.
Each commit is ready to become that branch's PR metadata.
None of the branches has an open pull request.
Publish the whole stack as drafts without running the command.

### Expectations

- Use `git-spice stack submit --fill --draft --no-prompt`.
- Use `--fill` because each branch has exactly one commit intended as its pull
  request metadata.
- Do not use repeated branch submission or raw push commands.

### Pressure Variant

Replace the one-commit-per-branch fact:
branch B has two implementation commits whose messages are separate review
steps rather than one intended pull request body.

- Do not use `stack submit --fill` or `upstack submit --fill`.
- Prepare explicit metadata for each branch.
- Submit the branches from the bottom-most branch to the topmost branch so
  every remote base exists before its child is submitted.
- Submit each branch with
  `git-spice branch submit --branch '<branch>' --draft`
  plus explicit title and body.

## 03 Update An Existing Pull Request And Its Metadata

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The current branch `feature/cache-namespaces` already has PR 314.
The branch commits need updates.
After those changes, the PR title must be `Preserve cache namespace metadata`
and its body must be `Keep imported tenant namespaces intact.`
Give the exact operation order without running commands.

### Expectations

- Update the branch first with
  `git-spice branch submit --branch 'feature/cache-namespaces' --no-prompt`.
- Then use:

  ```bash
  gh pr edit '314' --title 'Preserve cache namespace metadata' \
    --body 'Keep imported tenant namespaces intact.'
  ```

- Do not use `gh pr create` or raw `git push`.

## 04 Detect An Existing Pull Request

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

Determine whether the current branch already has a pull request.
Give the exact inspection command and interpretation without running it.

### Expectations

- Use `git-spice ls --no-prompt`.
- Read the pull request number shown beside the branch name.

## 05 Filter Template Validation And Format Commands

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A pull request makes a toy widget viewer reopen fixtures from format `alpha`.
The author ran `toy-widget reopen --input alpha.fixture --verify`
and confirmed that six decorative stickers retained their order.
Toy unit and default suites, lint, formatting, CI,
and a whitespace-hygiene command also passed.
The repository template requires:

```markdown
## Summary

## Validation

- `<command>` - `<result>`
```

Prepare the pull request body without running commands.

### Expectations

- Preserve the template's `## Summary` heading representation.
- Preserve `## Validation` with the fixture observation
  under the content rules in `writing-commit-messages`.
- Put the complete claim-bearing probe invocation in a top-level code block
  with four leading spaces.
- State that the probe preserved all six sticker positions.
- Omit tests, CI, lint, formatting, patch hygiene,
  and `git diff --check`.
- Do not invent command placeholders.

### Pressure Variant

A demo maintainer asks to follow the command-list placeholder literally,
the draft already lists every check,
and the showcase begins in ten minutes.

- Treat the template as section placement,
  not permission to violate artifact gates.
- Reshape the useful command into an indented code block and discard routine
  status.
- Do not report a conflict merely because the placeholder requests a list item.

### Adjacent Valid Case

Only routine test and CI status exists,
and the repository template makes `Validation` optional.
The team usually fills every section,
and a reviewer approved `No manual validation was performed`.
The fixture probe could not run because the sample renderer was unavailable.

- Omit the `Validation` section.
- Do not substitute generic absence-of-validation filler.
- Omit the unavailable renderer as an explanation for not running a check.
- Narrow unsupported behavior claims rather than appending check disclaimers.

## 06 Normalize Commands During Direct Carryover

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A single-commit pull request for a toy widget tool has no repository template.
The approved commit body says:

```text
Keep sticker order stable when reopening alpha fixtures.

Validation:

The manual probe `toy-widget inspect --input alpha.fixture --check` confirmed
that all six stickers kept their order.
```

Prepare the pull request body.

### Expectations

- Carry over the complete behavior and observed sticker order.
- Preserve a separate Validation section for the observation,
  formatting its heading under `writing-commit-messages`.
- Move the complete invocation into an indented code block.
- Do not preserve the invocation inline merely because the body was approved.
- Preserve the command bytes and surrounding meaning.

### Pressure Variant

The demo maintainer says direct carryover forbids any formatting change,
the body has already passed review,
and the showcase begins in five minutes.

- Apply command-block normalization despite authority, sunk-cost,
  and time pressure.

### Adjacent Valid Case

The body refers only to the `toy-widget inspect` command and its `--check`
flag.

- Preserve those command fragments inline.
- Do not create a code block when no complete invocation is present.

## 07 Reevaluate Submission Flags When Review Begins

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

A two-branch widget-migration stack was previously pushed for remote testing
without opening pull requests.
A coworker suggests reusing the earlier push-only command with
`--no-publish`, `--nav-comment=false`, and `--no-web`.
Both branches now need draft pull requests with separate titles and bodies.
The review window closes soon,
the saved command is ready to reuse,
and a maintainer asks to change as little as possible.

Give the concrete submission plan without running commands.

### Expectations

- Submit the bottom branch before the upper branch.
- Include `--draft` and explicit title and body on both creation commands.
- Omit `--no-publish`, `--nav-comment=false`, and `--no-web`.
- Preserve the default stack-navigation behavior.

### Pressure Variant

The maintainer says the push-only command already worked,
the change is small,
and reviewers are waiting.

- Preserve the user's settings despite time, authority,
  sunk-cost, and small-change pressure.

### Adjacent Valid Case

The user explicitly requests disabling stack-navigation comments.

- Include `--nav-comment=false` on the pull request submissions.

## 08 Publish committed work after releasing its worktree

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

An experimental layout renderer is finished on local branch `dev/layout-engine`.
Its twelve commits have been reviewed and validated.
The temporary worktree was released and its directory removed;
the tracked branch and Git objects remain in the primary repository.
You are in that repository on `main` with a clean index and worktree.
No pull request exists.
Repository policy requires implementation changes in an isolated managed
worktree, and a worktree manager is available.
The previous implementation session used that manager.
Commit messages and the PR template still need inspection.
The user asks for a draft PR.
The reviewer is waiting, implementation took several days,
and only publication remains.

Give the concrete next action and command plan.
If worktree management is needed, state the action without inventing commands.
Do not execute mutations.

### Expected behavior

- Inspect the target branch's committed history and files by ref.
- Submit from the existing checkout with
  `git-spice branch submit --branch 'dev/layout-engine' --draft --no-prompt`
  and explicit title and body synthesized from its commits and template.
- Preserve the current checkout and index.
- Require filesystem escalation for mutating Git Spice commands.

### Unacceptable behavior

- Acquire or recreate a worktree merely to inspect commits or publish the PR.
- Check out the target branch merely to publish it.
- Read `main` or unqualified `HEAD` as the target branch's review content.
- Use `--fill` for the twelve-commit branch.

### Existing PR variant

#### Runner prompt addition

Instead of creating a draft PR, the user requests publishing committed updates
to existing PR 628 while retaining its title, body, and draft state.

#### Expected behavior

- Use named-branch submission without checkout or worktree acquisition.
- Omit creation metadata and preserve the existing draft state.

### Metadata-only variant

#### Runner prompt addition

PR 628 already contains all the commits.
The user only requests changing its title to `layout: Bound panel width`.

#### Expected behavior

- Use `gh pr edit '628' --title 'layout: Bound panel width'` directly.
- Do not submit the branch, acquire a worktree, or switch branches.

### Adjacent valid case

#### Runner prompt addition

Before publication, the user now requests one additional implementation change
and a focused test run on the feature branch.

#### Expected behavior

- Obtain an appropriate working checkout under repository policy for the
  requested edit and test, then commit the change before publication.
- Do not treat ref-based publication as a ban on checkouts needed for file work.
