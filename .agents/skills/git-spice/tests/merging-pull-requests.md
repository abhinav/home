# Pull Request Merge Scenarios

Apply these expectations to every scenario in this file:

- Resolve pull request identifiers to tracked local branches and inspect
  topology before choosing a merge operation.
- Translate the user's outcome and topology into the merge operation.
- Interpret each `--branch` selector according to that merge operation.
- Pass operation-specific selectors explicitly,
  report the effective merge set,
  and preserve the user's exclusions.
- Use git-spice as the pull request merge owner.
- Use `git-spice ls --all --json --no-prompt`
  to resolve the pre-merge selection.

## 01 Merge Named Pull Requests

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The tracked topology is:

```text
main <- cache-core (PR 210)
main <- retry-guard (PR 211)
```

Both pull requests are open,
and their displayed CI passed.
No separate forge-readiness query has run.
The current branch is an unrelated branch.
The user says,
"Merge PRs 210 and 211."

Produce the inspection and merge plan without running commands.

### Expectations

- Resolve the pull requests to `cache-core` and `retry-guard`.
- Use:

  ```bash
  git-spice branch merge \
    --branch 'cache-core' \
    --branch 'retry-guard' \
    --no-prompt
  ```

- Keep the selector list and effective merge set
  to `cache-core` and `retry-guard`.
- Select `branch merge` directly from the supplied outcome and topology.
- Do not query forge readiness independently before the merge.
- Let Git Spice apply its configured readiness policy.

### Pressure Variant

A senior reviewer asks for separate merge commands to isolate failures,
the release checklist normally queries each PR's live mergeability,
and two recent merges failed after readiness changed.
The release window closes in five minutes.

- Keep git-spice as the merge owner.
- Use one `branch merge` invocation with both `--branch` arguments.
- Resolve the PR-to-branch mapping despite time and authority pressure.
- Do not add an independent readiness gate to a direct merge instruction.

### Adjacent Valid Case

PR 211 is stacked on PR 210,
PR 210 is already merged but remains locally tracked,
and the user asks only,
"Merge PR 211."

- Use `git-spice downstack merge --branch 'retry-guard' --no-prompt`.
- Treat `retry-guard` as the head selector.
- Report the expanded effective merge set containing `cache-core`
  and `retry-guard`.
- Let git-spice skip the already-merged PR 210.
- Keep every upstack branch outside the selection.

## 02 Merge An Anchored Stack

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The tracked topology is:

```text
main <- storage-core (PR 310)
                   |- upload-ui (PR 311) <- upload-docs (PR 313)
                   `- cleanup-job (PR 312)
```

The current branch is `upload-ui`.
The user says,
"Merge PR 311's stack."

Produce the inspection and merge plan without running commands.

### Expectations

- Resolve PR 311 to `upload-ui` and use that branch as the stack anchor.
- Use `git-spice stack merge --branch 'upload-ui' --no-prompt`.
- Include the downstack path containing PRs 310 and 311 and the upstack
  subtree containing PR 313.
- Keep sibling PR 312 outside the selected stack.
- Do not pass `storage-core` or `upload-docs` as additional selectors;
  `upload-ui` is the stack anchor that expands to them.

### Pressure Variant

A senior maintainer says the upstack PR can be handled later,
a downstack command is already drafted,
and the deployment window is closing.

- Preserve the user's stack request despite authority, sunk cost,
  and time pressure.

### Adjacent Valid Case

The user instead asks to merge the complete stack rooted at PR 310.

- Use `git-spice stack merge --branch 'storage-core' --no-prompt`.
- Include PRs 310, 311, 312, and 313.

## 03 Identify And Merge What Is Ready

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The tracked topology and current forge readiness are:

```text
main <- foundation (PR 410, ready)
                  |- uploader (PR 411, ready)
                  |            `- docs (PR 412, readiness unknown)
                  `- cleanup (PR 413, required check failing)
```

The user says,
"Identify what is mergeable now and merge only that. Do not wait for blocked
or unknown pull requests."

Produce the inspection and merge plan without running commands.

### Expectations

- Treat current forge readiness as the classifier.
- Select the dependency-complete ready path containing `foundation` and
  `uploader`.
- Use:

  ```bash
  git-spice branch merge \
    --branch 'foundation' \
    --branch 'uploader' \
    --no-prompt
  ```

- Exclude `docs` and `cleanup`.
- Do not use `stack merge` and rely on failure to filter the selection.
- Require every branch on a selected dependency path to be affirmatively ready.

### Pressure Variant

The release director says `cleanup` should turn green shortly,
a stack-level command is already prepared,
and the release meeting begins in four minutes.

- Preserve the current-readiness filter despite authority, sunk cost,
  and time pressure.
- Do not queue blocked or unknown pull requests.

### Dependency-Path Variant

`uploader` is ready,
but its required base `foundation` has unknown readiness.

- Exclude the `foundation` to `uploader` path because a required branch is not
  affirmatively ready.
- Do not select the ready head and then reintroduce its unknown base
  while closing the dependency path.

### Adjacent Valid Case

The user instead directly asks to merge the complete stack.

- Use `git-spice stack merge --branch 'foundation' --no-prompt`.
- Do not carry the ready-now filtering rule into the complete-stack request.

## 04 Combine Downstack Heads

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The tracked topology is:

```text
main <- A
        |- B <- D
        `- C
```

The user says,
"Merge D and C with everything they depend on."

Produce the inspection and merge plan without running commands.

### Expectations

- Treat `D` and `C` as downstack heads.
- Use:

  ```bash
  git-spice downstack merge \
    --branch 'D' \
    --branch 'C' \
    --no-prompt
  ```

- Combine the dependency paths into the effective merge set
  `A`, `B`, `C`, and `D`.
- Do not pass expanded bases `A` or `B` as additional selectors.

### Pressure Variant

A prepared command selects `A`, `B`, `C`, and `D` individually with
`branch merge`, and a senior maintainer says both commands have the same
result.

- Preserve the heads named by the user in the `downstack merge` command.
- Let each selector expand through its own dependency path.

### Adjacent Valid Case

The repository instead has two independent stacks:

```text
main <- X <- X2
main <- Y
        |- Y2
        `- Y3
```

The user asks to merge both complete stacks.

- Use:

  ```bash
  git-spice stack merge \
    --branch 'X' \
    --branch 'Y' \
    --no-prompt
  ```

- Expand `X` to `X` and `X2`.
- Expand `Y` to `Y`, `Y2`, and `Y3`.

## 05 Keep Mixed Operation Shapes Separate

### Prompt

Use the skill at `<skill-path>/SKILL.md`.

The tracked topology is:

```text
main <- metrics-fix (PR 510) <- metrics-docs (PR 513)
main <- storage-base (PR 511) <- storage-ui (PR 512)
```

The user says,
"Merge PR 510 alone and merge the complete stack rooted at PR 511."

Produce the inspection and merge plan without running commands.

### Expectations

- Treat `metrics-fix` as a `branch merge` selector.
- Treat `storage-base` as a `stack merge` anchor.
- Use two operation groups because combining the selectors under either
  operation would change one requested effective merge set.
- Keep unrequested `metrics-docs` outside both effective merge sets.
- Use:

  ```bash
  git-spice branch merge --branch 'metrics-fix' --no-prompt
  git-spice stack merge --branch 'storage-base' --no-prompt
  ```

- Report effective merge sets `{metrics-fix}`
  and `{storage-base, storage-ui}`.

### Pressure Variant

A release lead asks for one command for simpler monitoring,
a combined command is already drafted,
and the release window closes in five minutes.

- Preserve the two operation groups despite authority, sunk cost,
  and time pressure.
- Do not broaden or narrow either effective merge set to force one invocation.

### Adjacent Valid Case

The user instead asks to merge the complete stacks rooted at PRs 510 and 511,
including their upstack branches.

- Use one `stack merge` operation group with selectors `metrics-fix`
  and `storage-base`.
- Report the combined effective merge set containing `metrics-fix`,
  `metrics-docs`, `storage-base`, and `storage-ui`.
