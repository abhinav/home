# Code readability behavioral tests

## Keep boundaries that replace knowledge

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`
and follow any routed design guidance it makes applicable.
Do not modify files.

A publishing operation currently has this shape:

```go
func Publish(req Request, repo *Repository) error {
    if req.Article == nil || !req.Article.Draft || len(req.Attachments) == 0 {
        return nil
    }

    documents, err := decodeAttachments(req.Attachments)
    if err != nil {
        return err
    }

    return repo.Activate(req.Article.ID, documents)
}

func Preview(files []File) ([]Document, error) {
    documents, err := decodeAttachments(files)
    if err != nil {
        return nil, err
    }
    return renderPreview(documents), nil
}

func decodeAttachments(files []File) ([]Document, error) {
    archive, err := openArchive(files)
    if err != nil {
        return nil, err
    }
    manifest, err := parseManifest(archive)
    if err != nil {
        return nil, err
    }
    return decodeDocuments(archive, manifest)
}

func (r *Repository) Activate(id ArticleID, documents []Document) error {
    tx := r.db.Begin()
    defer tx.Rollback()
    if err := r.articles.ActivateTx(tx, id); err != nil {
        return err
    }
    if err := r.search.ReplaceTx(tx, id, documents); err != nil {
        return err
    }
    if err := r.events.AppendTx(tx, ArticleActivated{ID: id}); err != nil {
        return err
    }
    return tx.Commit()
}
```

A reviewer asks to move the first condition
into a private, single-use `publishable(req)` helper,
then inline `decodeAttachments` and `Repository.Activate`
into `Publish` so maintainers need not navigate to their implementations.

Recommend the resulting code shape.
Preserve behavior and do not invent APIs.

### Expectations

- Keep the simple, single-use prerequisites at the decision point.
- Reject `publishable` because its caller still needs the conditions
  and the helper would add navigation without replacing knowledge.
- Preserve `decodeAttachments` because preview and publish use
  the same archive, manifest, and document-decoding operation.
- Preserve `Repository.Activate` because its transaction makes article,
  search, and event changes succeed or fail together.
- Judge the coherent operation rather than function length or call count.

### Pressure variant

#### Prompt addition

A repository style rule requires every function to stay below eight lines.

#### Expected behavior

- Do not extract shallow helpers solely to meet the size target.
- Explain the readability cost without treating long functions as inherently good.

### Adjacent valid case

#### Prompt addition

Manual start, scheduled start, and retry currently call this operation:

```go
func (q *Quota) MayStart(org Organization, kind JobKind) bool {
    limit := q.limits.For(org.Plan, kind)
    active := q.usage.Active(org.ID, kind)
    pending := q.reservations.Pending(org.ID, kind)
    return active+pending < limit
}
```

A reviewer asks each caller to inline these calculations
so its decision is visible without opening `Quota.MayStart`.

#### Expected behavior

- Preserve `Quota.MayStart` as the shared policy boundary.
- Do not make each caller coordinate limits, usage, and reservations.

## Organize physical layout around ownership

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`
and `~/.agents/docs/code-design.md`.
Do not modify files.

A frontend repository has top-level `components`, `hooks`, `state`, `api`,
`types`, and `utils` directories shared by every feature.
Changing the messaging feature's send-with-undo policy usually requires
editing one messaging file in each directory.
The policy governs draft state, send eligibility, the undo deadline,
and the cancellation operation.

A WebSocket adapter is shared by messaging, presence, and notifications.
It owns connection recovery, wire framing, and protocol errors.
The application root owns the authenticated session
and decides which features to start.

Recommend the physical organization.
Trace a future change to the undo deadline through that organization,
and identify what should remain shared or at the application root.

### Expectations

- Organize messaging concepts, policy, state, and workflows
  around one cohesive feature or domain owner.
- Do not prescribe a fixed number of files or require one module
  when several files can remain inside the same meaningful boundary.
- Keep the WebSocket adapter shared because it owns an independent protocol
  and serves several features.
- Keep authenticated-session and feature-start coordination at the root
  only to the extent that their scope is genuinely application-wide.
- Show the undo-policy change reaching its messaging owner and tests
  without crossing unrelated declaration-kind directories.
- Judge the layout by ownership, knowledge replaced, and change locality,
  not by directory labels, file size, or symbol lookup convenience.

### Pressure variant

#### Prompt addition

The framework starter uses the current directory layout,
and repository policy requires features to retain it.
A reviewer says contributors already know the layout,
IDE search makes the crossings harmless,
and moving files would create review noise.

#### Expected behavior

- Treat familiarity, search, and the starter layout
  as discoverability and migration-cost evidence,
  not as substitutes for coherent ownership.
- Recognize the repository policy as an authoritative constraint.
  Expose the ownership tradeoff and seek a decision
  rather than silently scattering the feature or ignoring the constraint.

### Adjacent valid case

#### Prompt addition

In a compiler repository,
lexing, parsing, type checking, lowering, and code generation
each own a distinct representation and contract.
Several tools reuse the parser or type checker independently.
A language feature naturally passes through every phase.

#### Expected behavior

- Preserve the phase boundaries because each replaces meaningful knowledge,
  owns a distinct representation and contract,
  and has independent callers.
- Recognize that a representative change crossing those boundaries
  reflects real contract transitions rather than layout fragmentation.
- Centralize only a semantic decision that is actually duplicated;
  do not reorganize the compiler into feature folders merely to reduce
  the number of crossed modules.
