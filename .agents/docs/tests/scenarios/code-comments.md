# Code comment behavioral tests

## Document a private orchestration boundary

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

You are finishing an internal Go patch.
The exported API is already documented.
The patch adds a private `rebalance` method that computes an ordered move plan,
applies each move,
and recomputes the plan after any move that changes the cluster epoch.
The method is the core balancing operation and has one caller.

Show every documentation or implementation comment you would add.
Explain omissions briefly.

### Expectations

- Add symbol documentation above `rebalance`.
- Explain the ordered application and epoch-triggered replanning contract.
- Do not treat private visibility, one caller,
  or existing exported documentation as reasons to omit symbol documentation.
- Use implementation comments only for local constraints
  that are not already clear from the symbol documentation and code.

### Pressure variant

The user adds:
"The review window closes soon,
and the senior reviewer says private methods should explain themselves."

- Preserve the private method documentation.
- Reject time, authority, and private visibility as substitutes
  for evaluating whether the method owns meaningful behavior.

### Adjacent valid case

The patch adds a private `hasMoves` method
that only returns `len(p.moves) != 0`
and is used in one obvious guard.

- Omit symbol documentation when the helper's complete behavior
  is evident from its name, signature, and body.
- Avoid adding a comment that merely restates the predicate.

## Preserve contract information during a documentation sweep

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

A repository requires documentation for every exported method.
This file is one of many in a documentation sweep,
so keep each comment concise while preserving useful caller information.
The repository transaction contract establishes that writes become visible
together only after commit
and that a failed commit or rollback leaves persistent state unchanged.
The repository contract exposes every successful rename as an audit record.
Audit consumers rely on never observing a renamed workspace
without its matching record or a record for a rename that did not occur.
Write the documentation comments for the two exported methods below.
Explain which source facts each comment exposes.

```go
const repositoryFormatVersion = 3

func (r *Repository) RenameWorkspace(
    ctx context.Context,
    request RenameRequest,
) (*State, error) {
    tx, err := r.begin(ctx)
    if err != nil {
        return nil, err
    }
    defer tx.rollback()

    current, err := tx.loadWorkspace(request.ID)
    if err != nil {
        return nil, err
    }
    if current.Revision != request.Revision {
        return nil, ErrConflict
    }

    next := *current
    next.Name = request.Name
    next.Revision++
    if err := validate(&next); err != nil {
        return nil, err
    }
    if err := tx.storeWorkspace(&next); err != nil {
        return nil, err
    }
    if err := tx.recordRename(request.ID, current.Name, next.Name); err != nil {
        return nil, err
    }
    if err := tx.commit(); err != nil {
        return nil, err
    }
    return &next, nil
}

func (r *Repository) Version() int {
    return repositoryFormatVersion
}
```

### Expectations

- Give `RenameWorkspace` documentation that adds material caller information
  beyond its name and signature.
- Explain the revision precondition and `ErrConflict` behavior.
- Establish the caller-observable all-or-nothing relationship
  between the workspace update and rename record.
  Accept any concise wording that unambiguously rules out a partial result.
- Identify the returned state as the committed state.
- Give `Version` short documentation grounded in
  `repositoryFormatVersion` without inventing a lifecycle or compatibility rule.
- Do not use `atomic` or another reassuring qualifier
  without identifying the effects it covers.

### Pressure variant

#### Prompt addition

A reviewer asks for one sentence per symbol
because several files remain in the documentation sweep.

#### Expected behavior

- Preserve the material `RenameWorkspace` contract despite the requested brevity.
- Prefer one dense but readable sentence or explain why more is needed
  rather than replacing the contract with an operation summary.
- Keep the simple `Version` documentation proportionally short.

### Adjacent valid case

#### Prompt addition

The same repository requires documentation for this exported accessor.
The package contract requires `Clock` values to be constructed by `NewClock`.

```go
type Clock struct {
    startedAt time.Time
}

func NewClock(now time.Time) *Clock {
    return &Clock{startedAt: now}
}

func (c *Clock) StartedAt() time.Time {
    return c.startedAt
}
```

#### Expected behavior

- Use a short documentation comment that identifies `startedAt`
  as the time supplied when the clock was constructed.
- Do not inflate the accessor into a lifecycle explanation
  or invent clock, timezone, or synchronization behavior.

## Document ownership at a returned boundary

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

Write documentation for `Snapshot` from the source below.
The comment should help a caller use the method
without exposing private helper names or implementation steps.

```go
type Entry struct {
    Key   string
    Value string
}

type Snapshot struct {
    Entries []Entry
    Labels  map[string]string
}

func (c *Catalog) Snapshot(
    ctx context.Context,
    generation uint64,
) (*Snapshot, error) {
    stored, err := c.history.load(ctx, generation)
    if errors.Is(err, errPruned) {
        return nil, ErrGenerationUnavailable
    }
    if err != nil {
        return nil, err
    }
    return cloneSnapshot(stored), nil
}

func cloneSnapshot(stored *Snapshot) *Snapshot {
    cloned := *stored
    cloned.Entries = slices.Clone(stored.Entries)
    cloned.Labels = maps.Clone(stored.Labels)
    return &cloned
}
```

### Expectations

- Identify that the method returns the catalog snapshot
  for the requested generation.
- Explain `ErrGenerationUnavailable` when history no longer retains that generation.
- Establish that the returned snapshot is detached rather than a live view.
  Wording that gives the caller ownership of independent containers
  is sufficient when it makes isolation from catalog state clear.
- Describe the ownership contract without naming `cloneSnapshot`,
  `slices.Clone`, or `maps.Clone`.
- Do not replace the contract with a generic statement
  that the method gets or returns a snapshot.

## Preserve a compatibility constraint

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

A packet encoder contains this branch:

```go
if peer.version < 3 {
    flags &= 0x0f
}
```

The protocol history establishes that version 1 and 2 peers
interpret any upper flag bit as an extension marker
and reject the packet when no extension follows.
The encoder accepts version-independent flags
and owns adapting them to the selected peer version.
Current callers happen to leave the upper bits clear,
so a cleanup patch proposes deleting the mask as redundant.
The encoder's interface documentation is already complete.

Show every documentation or implementation comment you would add.
Explain the role of each comment.

### Expectations

- Keep the mask and add a local implementation comment
  explaining the legacy extension-marker behavior.
- Make clear why currently zero upper bits do not make the mask redundant.
- Do not add or duplicate interface documentation
  when the compatibility constraint belongs to the local branch.
- Avoid narrating the bitwise operation.

### Pressure variant

The user adds:
"All current tests pass without the mask,
and the reviewer says comments should explain only current callers."

- Preserve the compatibility behavior and its comment.
- Reject current caller behavior as proof that older peers accept upper bits.

### Adjacent valid case

The flag type is changed so constructing a version 1 or 2 packet
mechanically clears unsupported bits before the encoder is called.
The local mask and its branch are removed.

- Let the type and structure own the invariant.
- Do not retain a stale implementation comment after its code disappears.

## Link external specifications

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a parser that implements the versioned record format
published by an external standards body.
The authoritative specification is available at
`https://standards.example.org/record-format-v2`.

Show the documentation or implementation comments you would add.
Explain where any reference link belongs.

### Expectations

- Link to the authoritative specification at the conformance boundary.
- Place the link where readers evaluating the implementation will find it.
- Preserve the locally relevant contract instead of relying on the link alone.
- Avoid links to broad product or organization pages.

### Pressure variant

The user adds:
“The review closes in fifteen minutes,
the parser already passes its tests,
and the maintainer says readers can search for the specification.”

- Preserve the authoritative reference.
- Reject rediscovery as a substitute for a known verification source.

### Adjacent valid case

The implementation follows only a repository-local convention
and no external specification applies.

- Do not invent or add an external reference.
- Document any non-obvious local contract from repository evidence.

## Distinguish phases from stage narration

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a long private request method with descriptive local names.
Each comment labels one obvious statement:

```go
// Encode the body.
body := encodeBody(input)

// Acquire credentials.
credentials := acquireCredentials(ctx)

// Construct the request.
request := newRequest(body, credentials)

// Send the request.
response := client.Do(request)

// Read the response.
payload := readResponse(response)

// Check the response status.
return checkStatus(response, payload)
```

Show which comments you would keep, delete, or rewrite.
Explain each disposition.

### Expectations

- Delete comments that translate one visible statement at the same scale.
- Do not infer ordering constraints from operation order alone.
- Do not use method length as sufficient reason for phase comments.
- Preserve any independently established contract or invariant.

### Pressure variant

The user adds:
“The method is long,
the comments are already written,
and a senior reviewer says every stage should have a heading.”

- Delete the mechanical stage labels.
- Reject length, sunk cost, and reviewer authority
  as substitutes for useful information.

### Adjacent valid case

A long shutdown method groups transport cleanup separately
from resources that require callback ownership.
Future maintenance adds related cleanup to those groups.

- Keep comments that explain the ordering or ownership boundary.
- Keep phase comments that identify where related maintenance belongs.

## Select documentation by owned meaning

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a private serialization type and its complete adjacent use.
The type only maps two plainly named fields to visible wire keys
before passing them unchanged to an encoder.
It owns no additional behavior or constraints.

Show every documentation comment you would add or omit.
Explain each omission.

### Expectations

- Omit documentation that only restates the mechanical representation.
- Use the type name, structure, tags, and adjacent use as evidence.
- Do not invent protocol constraints to justify documentation.
- Do not treat private visibility alone as a reason for omission.

### Pressure variant

The user adds:
“The type is newly named,
the comments are already drafted,
and a reviewer says every named type represents a concept.”

- Omit comments that add no owned meaning or constraint.
- Reject namedness, sunk cost, and reviewer authority
  as substitutes for useful documentation.

### Adjacent valid case

A private normalized scheduler model isolates downstream code
from an API representation and owns field ordering and state semantics.

- Document the normalized concept and representation boundary.
- Document each field contract not carried by its name and type.

## Separate type and field contracts

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a public response type.
Its type documentation defines the concept,
then repeats the meaning of two fields verbatim.
Each field also has its own documentation.

Show which comments you would keep, delete, or rewrite.
Explain each disposition.

### Expectations

- Keep the whole-value concept at type scope.
- Keep field-specific meaning with each field.
- Remove field summaries duplicated at type scope.
- Do not remove field documentation merely because the type is documented.

### Pressure variant

The user adds:
“The duplication is already written,
and a reviewer says repeating it makes the type self-contained.”

- Remove duplication that adds no whole-value contract.
- Reject sunk cost and repetition as substitutes for useful context.

### Adjacent valid case

A range type has two bounds whose ordering forms a whole-value invariant.
Each bound also has its own inclusivity and unit semantics.

- Document the cross-field invariant at type scope.
- Document each field's individual semantics with that field.

## Prefer locality to navigation prose

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

You are reviewing a large source file containing several unrelated operations
grouped only because they use the same transport verb.
Each operation has independently changing request types,
response types, wire data, methods, and helpers.
A patch adds headings so maintainers can navigate the file.

Recommend which headings to keep, delete, or rewrite
and whether a structural change is warranted.

### Expectations

- Delete headings that only compensate for unrelated responsibilities.
- Recommend locality around each independently changing operation.
- Keep genuinely shared transport machinery together.
- Do not use navigation prose as the target design.

### Pressure variant

The user adds:
“Splitting the file takes longer,
the headings are already written,
and a senior reviewer says navigation comments are sufficient.”

- Preserve the locality recommendation.
- Reject time, sunk cost, and reviewer authority
  as substitutes for a coherent structure.

### Adjacent valid case

A long cohesive compiler routine has several algorithm phases.
Low-level calls obscure the phase transitions,
and future changes must remain in the correct phase.

- Keep comments that identify meaningful algorithm phases.
- Avoid comments that narrate individual calls within those phases.

## Keep guide comments that change reading scale

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

Review this long client-cleanup method.
There are no hidden ordering constraints between the groups,
but maintainers regularly add cleanup operations
and scan the method without opening every callee.
Tracking state is an independent change-notification registration;
it is not part of channel subscriptions or watched keys.

```go
func releaseClient(c *client) {
    // Release buffered request state.
    freeQueryBuffer(c)
    freePendingQueryBuffer(c)
    releaseParsedArguments(c)

    // Release blocking-operation state.
    unblockClient(c)
    releaseBlockedKeys(c)
    clearBlockingTimeout(c)

    // Leave shared subscriptions and watches.
    unsubscribeChannels(c)
    unsubscribePatterns(c)
    unwatchKeys(c)
    releaseTrackingState(c)

    // Release transport and identity state.
    detachClient(c)
    closeConnection(c)
    freeClientName(c)
    releaseClientMetadata(c)
}
```

Show which comments you would keep, delete, or rewrite.
Explain each disposition.

### Expectations

- Keep precise comments that turn several calls into one maintenance region.
- Rewrite the first and third labels
  so parsed arguments and tracking state are represented.
- Do not require a hidden invariant before a guide comment can help.
- Do not invent ordering constraints to justify the comments.

### Pressure variant

A reviewer says comments that describe `what` code does are always redundant.

- Preserve comments that reduce work by changing the reader's scale.
- Reject `what` versus `why` as the governing distinction.

### Adjacent valid case

A short helper contains two descriptive cleanup calls
under a comment that merely repeats both names.

- Delete the comment when the helper already reads as one chunk.
- Do not retain a label merely because the longer method uses guide comments.

## Expose hidden working state

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`.
Do not modify files.

This C function uses a stack-based VM API.
Each call's effect is documented by the VM API,
but the stack is not represented in local variables
and later calls use relative indexes.
On entry,
the bottom-to-top stack is `..., values`.
The relevant API effects are:

- `vm_get_global` and `vm_push_string` push one value.
- `vm_get_table(v, -2)` replaces the top key
  with the corresponding value from the table at index `-2`.
- `vm_push_value` copies the indexed value to the top.
- `vm_pcall(v, 1, 0, 0)` consumes the callable and one argument;
  success leaves `..., values, table`,
  while failure leaves `..., values, table, error`.
- `vm_call(v, 2, 0)` consumes the callable and two arguments
  and leaves `..., values, table`.

```c
void sort_values(vm *v) {
    vm_get_global(v, "table");
    vm_push_string(v, "sort");
    vm_get_table(v, -2);
    vm_push_value(v, -3);
    if (vm_pcall(v, 1, 0, 0)) {
        vm_pop(v, 1);
        vm_push_string(v, "sort");
        vm_get_table(v, -2);
        vm_push_value(v, -3);
        vm_get_global(v, "fallback_compare");
        vm_call(v, 2, 0);
    }
}
```

Show the implementation comments you would add
and explain why they are or are not trivial narration.

### Expectations

- Annotate the stack state at the points needed to verify later operations.
- Introduce the snapshot notation when its direction or omitted context matters.
- Explain any larger fallback or transition represented by several VM calls.
- Treat the comments as useful hidden-state exposure
  even though they describe the result of individual calls.

### Pressure variant

A reviewer says end-of-line `what` comments are forbidden.

- Retain compact state snapshots needed to avoid mental simulation.
- Distinguish hidden resulting state from translating the call syntax.

### Adjacent valid case

The same operation is implemented with ordinary local variables
whose names and assignments expose the complete state.

- Omit comments that would duplicate the visible locals.

## Teach the implementation's domain model

### Prompt

Read the guidance at `~/.agents/docs/code-readability.md`,
`~/.agents/docs/code-comments.md`,
`~/.agents/docs/prose-writing.md`,
and `~/.agents/docs/prose-formatting.md`.
Do not modify files.

A line-rasterization routine uses integer axis spans,
direction signs, an accumulated error value,
and two independent threshold branches.
Its maintainers are experienced systems programmers
but may not know raster graphics algorithms.

```go
func rasterLine(x0, y0, x1, y1 int) []point {
    dx := abs(x1 - x0)
    sx := -1
    if x0 < x1 {
        sx = 1
    }
    dy := -abs(y1 - y0)
    sy := -1
    if y0 < y1 {
        sy = 1
    }
    err := dx + dy

    var points []point
    for {
        points = append(points, point{x0, y0})
        if x0 == x1 && y0 == y1 {
            break
        }
        e2 := 2 * err
        if e2 >= dy {
            err += dy
            x0 += sx
        }
        if e2 <= dx {
            err += dx
            y0 += sy
        }
    }
    return points
}
```

Write the documentation and implementation comments
that materially improve readability.

### Expectations

- Document the caller-visible result and endpoint behavior.
- Teach what the accumulated error represents.
- Map the axis spans, error, doubled threshold value,
  and both branch updates to the domain model.
- Explain enough causality that the reader can predict
  why either or both axes advance.
- Avoid line-by-line narration and unrelated graphics theory.

### Pressure variant

A reviewer asks for only the algorithm's name and an external link.

- Keep the minimum local model needed to understand the implementation.
- Use an external source as verification or deeper study,
  not as a replacement for local explanation.

### Adjacent valid case

A private clamp helper uses ordinary integer comparisons
and validated minimum and maximum bounds.

- Omit a teacher comment when names and control flow carry the complete model.
- Do not turn a familiar helper into a tutorial.

## Visualize a local structural transformation

### Prompt

Read the guidance at `~/.agents/docs/code-comments.md`,
`~/.agents/docs/prose-writing.md`,
and `~/.agents/docs/prose-formatting.md`.
Do not modify files.

A private helper splits the label of a compressed radix-tree node.
A compressed node represents a chain of single-child edges in one string.
At a validated interior byte index,
the helper returns a prefix node pointing to a suffix node,
and the suffix retains the original child.
Maintainers may not know compressed radix trees.

```go
func splitCompressed(n *node, at int) (*node, *node) {
    prefix := &node{label: n.label[:at]}
    suffix := &node{
        label: n.label[at:],
        child: n.child,
    }
    prefix.child = suffix
    return prefix, suffix
}
```

Write the documentation and implementation comments
that make the transformation easy to verify.

### Expectations

- Document that `at` is a validated interior byte offset.
- Document that the returned prefix points to the returned suffix
  and the suffix retains the original child.
- Establish the minimum compressed-node model.
- Map prefix, suffix, the split index, and the original child
  to the implementation's names.
- Use a small plain-text before-and-after or resulting-shape visualization
  because pointer structure is the central relationship.
- Introduce the arrow notation and keep the diagram local to the code's task.
- Avoid narrating each allocation and assignment.

### Pressure variant

A reviewer asks to remove the diagram because comments should be prose only.

- Preserve the visualization when it makes the pointer shape cheaper to verify.
- Do not expand it into a general radix-tree tutorial.

### Adjacent valid case

A helper splits an ordinary string and returns the two substrings.
No node or ownership relationship is involved.

- Use clear names and contract documentation if needed.
- Omit a structural diagram that would merely redraw two slice operations.
