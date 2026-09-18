# Go guidance behavioral tests

## Keep behavioral objects pointer-oriented

### Prompt

Read the guidance at `{GUIDANCE_PATH}` and apply it to the task below.
Do not modify files or external state.

Sketch the public and internal Go API for a package that dispatches messages.
The package needs a `MessageDispatcher` configured with a `Sender`
and an `Encoder`.
It has a `Preview(Message) ([]byte, error)` operation
and a `Dispatch(context.Context, Message) error` operation.
`Dispatch` encodes and sends the message;
`Preview` only returns the encoded bytes.
The type does not need to reassign its configuration after construction.

Show the type, construction API, method signatures,
one representative function that accepts a dispatcher,
and one representative collection of dispatchers.
Omit method bodies.
Briefly explain material API choices.

### Expectations

- Treat `MessageDispatcher` as a pointer-oriented object
  because it owns collaborators and exposes operations through them.
- Use pointer receivers and carry that model through construction,
  concrete parameters, and collection elements.
- Do not infer value semantics from the struct's size,
  stable fields, or mechanically cheap copies of interface values.
- Apply the constructor guidance independently;
  direct initialization remains valid when construction only assigns fields.

### Adjacent valid case

Instead, sketch the API for an `Interval` with `Start` and `End` times.
Callers compare intervals by their contents,
freely copy them,
and expect `Shift(time.Duration) Interval`
to leave the original unchanged.
Also include `Contains(time.Time) bool`,
one function that accepts an interval,
and one collection of intervals.

- Use value receivers, value parameters, value results,
  and value collection elements.
- Preserve value semantics even though the type exposes several methods.
- Do not generalize the pointer default into a ban on rich value types.

## Name declarations for their scope

### Prompt

Read the guidance at `{GUIDANCE_PATH}` and apply it to the task below.
Do not modify files or external state.

Sketch declarations for additions to an established `catalog` package
with more than twenty package-level types.
The additions need:

- an unexported type holding transient state while decoding a supplier feed;
- an unexported type representing the comparison
  between incoming and stored records;
- an unexported type recording why one catalog update failed;
- an unexported worker object that owns a `Store` and `Clock`;
- a package-level metric counter for failed catalog updates; and
- a narrow helper whose locals represent its state and result.

Show representative declarations and signatures,
not complete method bodies.
Name every declaration idiomatically and explain the naming choices briefly.

### Expectations

- Give package-level types enough domain and role context
  to distinguish them from the package's other declarations.
- Give the package-level metric a name that identifies
  the counted event and the metric role.
- Keep narrow local names such as `state` and `result` concise.
- Do not justify a generic package-level name
  merely because its type or surrounding file supplies context.
- Do not add empty qualifiers such as `global`, `private`, or `internal`.

### Adjacent valid case

Instead, sketch a small `scanner` package
with one unexported cursor type and one narrow scanning helper.
The package has four package-level declarations.

- Permit a compact package-level name such as `cursor`
  when it denotes the package's one unambiguous cursor role.
- Permit a small role qualifier such as `scanCursor`
  when it leaves `cursor` available as a natural parameter name.
- Do not require a redundant package-name prefix such as `scannerCursor`.
- Keep narrow locals such as `r` and `result` concise.
