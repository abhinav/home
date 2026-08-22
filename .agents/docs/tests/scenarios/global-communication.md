# Global communication behavioral tests

## Apply the global code-shape rule

### Prompt

Read `~/.agents/AGENTS.md`,
but do not read any routed guide.
Do not modify files.

In conversational chat,
explain this proposed Go API change to a reviewer:

```go
func NewStore(
    cache Cache,
    storage Storage,
    metrics Metrics,
    policy RetryPolicy,
) (*Store, error)

func (s *Store) Put(ctx context.Context, item Item) error
```

The discussion concerns `cache`, `policy`, and `Put`.
Storage and metrics are unchanged and irrelevant.
`RetryPolicy` belongs to `Store` for its lifetime
instead of being passed to every `Put` call.
Construction rejects blank policy names,
but the private whitespace helper is irrelevant.
Keep the answer concise and do not invent APIs.

### Quality bar

- Evaluation mode: judgment.
- A reviewer can see the relevant constructor and method shape directly,
  then understand the ownership decision and validation contract.
- Narrating the API only in prose,
  retaining irrelevant dependencies,
  or exposing the private helper misses the bar.

### Expectations

- Lead with partial constructor and method declarations.
- Preserve `cache`, `policy`, and `Put`.
- Mark the omitted storage and metrics parameters with a Go comment.
- Use prose to explain lifetime ownership and blank-name rejection.
- Do not expose the private whitespace helper or invent API elements.

### Pressure variant

#### Prompt addition

The reviewer asks for a short answer
and says the complete constructor obscures the ownership change.

#### Expected behavior

- Keep the partial code shape and visible omission marker.
- Do not fall back to a prose enumeration of the API.

### Adjacent valid case: behavior only

#### Prompt addition

The user instead requests one release-note sentence saying
that store construction now rejects blank policy names.

#### Expected behavior

- State the observable behavior in prose.
- Do not add a code shape when it exposes no relevant relationship.

### Adjacent valid case: syntax unavailable

#### Prompt addition

The user instead asks why a returned subscription handle
should own cancellation,
but the language, type names, and API syntax have not been chosen.

#### Expected behavior

- Explain the ownership decision without inventing a declaration.
- Do not present proposed syntax as established code.
