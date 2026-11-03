# Domain representations

## Express identity and lifecycle

Model identity explicitly when it must survive attribute changes.
An entity remains the same thing; a value object is identified by its contents
within the domain.
Use replacement and immutability when they preserve value meaning;
read-only fields alone do not protect mutable contents or aliases.
Choose equality from domain meaning, not a storage key.

## Establish validity through construction

Identify supported creation and mutation paths.
Constructors, factories, parsers, and supported decoding establish the same
invariants; supported mutations preserve them, so consumers can rely on them.
Reject invalid inputs, resolve defaults and derived values,
and retain the needed downstream representation before returning the object.

Provide validation methods only when the API supports constructing or editing
invalid representations, such as unchecked configuration or incomplete drafts.
State which supported path admits that state and what validation establishes.
With controlled construction, check there and omit methods
that recheck the resulting object's invariants.
Fallible construction also serves early error reporting.
Language mechanisms for manufacturing instances do not establish supported paths:
use the public contract and supported callers to decide whether literals,
zero values, defaults, or decoding qualify.
If unclear, identify that uncertainty before choosing validation behavior;
do not silently expand supported states.

Changing external facts, such as file availability or current authorization,
remain checks of the operation that depends on them.
A draft may be valid for editing while submission needs stronger guarantees.
Illustrative pseudocode:

```text
draft = drafts.save(Draft(address=None))  # valid incomplete state
submit(draft)                           # rejects; draft remains editable
```

Construction and transitions must establish downstream guarantees;
client feedback cannot replace those checks for clients or workers.
Keep assembly rules inside constructors or factories.
Return enough information for the caller to understand a rejection;
collect independent input errors when more useful for correction
than reporting only the first.
Use a named predicate or specification for a recurring condition
when its shared meaning earns the abstraction,
without assuming a factory hierarchy or specification framework.

## Carry guarantees forward

Return validated representations instead of passing unchecked input downstream.
Illustrative signatures:

```text
parse_routes(raw: List<RouteInput>) -> ValidRoutes
build_router(routes: ValidRoutes) -> Router
```

Retain raw input only when diagnostics, audit, or round-tripping requires it.
Establish an invariant at the first boundary where all downstream paths require it.
If only a selected path needs a stronger representation, parse after selection
rather than imposing its constraint on other paths.

Choose shapes expressing domain meaning and discouraging invalid or ambiguous states.
Primitives and generic containers are useful at external edges.
Repeated checks and conventions around them usually reveal a missing domain concept;
choose from meaning rather than banning either.
Illustrative shapes:

```text
has_children: Bool                 # stable binary fact
path_style: "relative" | "rooted"    # named finite choice, not an opaque callback
registrations: List<Registration>   # retains repeated emails
```

Place a choice where it varies; reserve behavior injection for open-ended choices.
For domain-record collections, expose named records and keep indexes inside the owner.
Uniqueness is validation, not a reason to require a map;
building one before validation can discard duplicates,
and repeating an identifier in key and record creates two sources of truth.
Maps suit callers operating on keyed associations themselves.
Illustrative signatures and call:

```text
Label { name: LabelName, color: Color }
set_labels(labels: List<Label>)     # reject duplicate names; any index stays private

expand(template, bindings: Map<VariableName, Text>)
expand("Hello, $recipient", {"recipient": "Sam"})
```

Introduce a cohesive request, result, or configuration concept when meaningful
to callers, when values change together, or when demonstrated evolution of a
stable boundary would otherwise require mechanical caller changes.
The configuration boundary owns omission, defaults, and invalid combinations;
parsing rejects unsupported or conflicting choices.
Construction extracts values and binds behavior the client owns.
Illustrative pseudocode:

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
For optional additions at stable boundaries, preserve behavior for omitted,
defaulted, or zero-valued choices where applicable unless deliberately changing
the contract.
Do not wrap small internal signatures in vague objects for imagined growth.
After establishing the domain contract,
apply language-specific mechanisms and conventions to concrete public API shapes.
