# Domain representations

## Express identity and lifecycle

When identity must survive changes to attributes, model that identity explicitly.
An entity is recognized as the same thing through those changes.
A value object is meaningful through its contents;
equal contents represent the same value within its domain.
Use replacement and immutability for values when that keeps their meaning stable.
Read-only fields do not protect mutable contents or aliases by themselves.
Choose equality from domain meaning, not from a database key added for storage.

## Establish validity through supported construction

A successfully constructed object carries its invariants to its consumers.
Identify the supported ways callers create and change it.
Constructors, factories, parsers, and supported decoding paths establish the
same guarantees; supported mutations preserve them.
Reject invalid inputs before returning the object,
resolve defaults and derived values there,
and retain the representation downstream operations need.
Consumers can then rely on those guarantees.

Provide a validation method only when the API supports callers constructing
or editing a representation with invalid inputs,
such as an unchecked configuration record or an incomplete draft.
State which supported path admits that state and what validation establishes.
When construction is controlled, put the checks in that construction boundary
and omit validation methods that recheck the resulting object's invariants.
A caller's need for early error reporting is served by fallible construction.

Language mechanisms that can manufacture an instance do not by themselves
establish a supported construction path.
Use the public contract and supported callers to decide whether literals,
zero values, defaults, or decoding belong to that contract.
If the contract is unclear, identify that uncertainty before choosing validation
behavior; do not silently expand the supported states.

Object validity covers the invariants construction can establish and preserve.
Changing external facts, such as file availability or current authorization,
remain checks of the operation that depends on them.

An incomplete draft can be valid for editing;
its transition to submission establishes the stronger guarantees of that state.

```text
draft = drafts.save(Draft(address=None))  # valid incomplete state
submit(draft)                           # rejects; draft remains editable
```

Construction and transitions establish downstream guarantees;
client feedback cannot replace those checks for clients or workers.

Keep assembly rules inside the constructor or factory.
Return enough information for the caller to understand a rejection;
collect independent input errors when that serves correction better than
reporting only the first one.
Represent a recurring condition as a named predicate or specification
when its shared meaning earns that abstraction.
Neither a factory hierarchy nor a specification framework follows automatically.

## Carry established guarantees forward

Return the validated representation instead of discarding the proof
and passing unchecked input onward.

```text
parse_routes(raw: List<RouteInput>) -> ValidRoutes
build_router(routes: ValidRoutes) -> Router
```

`ValidRoutes` carries the established structure and invariants.
Retain raw input only when diagnostics, audit, or round-tripping requires it.

Establish an invariant at the first boundary
where every downstream path requires it.
When only one selected path needs a stronger representation,
parse after selection;
otherwise the shared boundary would claim a constraint
the other paths do not have.

Choose data shapes that express domain meaning
and make invalid or ambiguous states difficult to construct.
Primitive values and generic containers are useful at external edges,
but repeated checks and conventions around them
usually reveal a missing domain concept.

Choose from meaning, not blanket bans on primitives or containers.

```text
has_children: Bool                 # stable binary fact
path_style: "relative" | "rooted"    # named finite choice, not an opaque callback
registrations: List<Registration>   # retains repeated emails
```

Place a choice where it varies; reserve behavior injection for open-ended choices.

For collections of domain records, expose named records and keep lookup indexes
inside the owner.
Uniqueness is a validation rule; it does not require callers to supply a map.
Building a map before validation can silently discard duplicate input,
and repeating an identifier in both key and record creates two sources of truth.

```text
Label { name: LabelName, color: Color }
set_labels(labels: List<Label>)     # reject duplicate names; any index stays private

expand(template, bindings: Map<VariableName, Text>)
expand("Hello, $recipient", {"recipient": "Sam"})
```

A map fits when callers work with the keyed associations themselves,
as with variable bindings.
Choose it from those operations and semantics, not from an internal lookup need.

Introduce a cohesive request, result, or configuration concept
when it is meaningful to callers,
when several values change together,
or when demonstrated evolution at a stable boundary
would otherwise force mechanical changes across callers.
The configuration boundary owns omission, defaults, and invalid combinations.
Parsing rejects unsupported or conflicting choices.
Construction extracts the values and binds the behavior the client will own:

```text
new_client(raw_options):
    options = parse_options(raw_options, defaults=established_defaults)
    return Client(
        endpoint=options.endpoint,
        timeout=options.timeout,
        retry_policy=make_retry_policy(options.retry_mode, options.retry_limit),
    )
```

Normalize at construction or the nearest API boundary,
so downstream code does not reinterpret surface states.
When adding an optional choice to a stable boundary,
preserve established behavior when that choice is omitted,
defaulted, or zero-valued where applicable,
unless the contract deliberately changes.
Do not wrap a small internal signature in a vague object
only to reserve space for imagined growth.

Language-specific API mechanisms and conventions govern concrete public API
shapes.
Apply them after the domain contract is clear.
