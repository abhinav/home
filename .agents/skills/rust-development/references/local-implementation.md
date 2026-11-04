# Local implementation

## Expose useful type information

Add a local type annotation when understanding an expression otherwise requires
tracing later uses or another declaration, especially for `parse`, `into`,
and the result of a complex iterator chain.
Prefer annotating the binding when it identifies the value for the reader:

```rust
let limit: usize = raw_limit.parse()?;
```

Use a turbofish when the operation itself needs the type argument
or there is no useful binding to annotate.
Keep inference when the initializer or nearby context already makes the
relevant type clear; do not spell out unwieldy iterator or closure types.

## Keep ordinary operations in ordinary Rust

Prefer functions, types, traits, and modules when they express the needed contract.
Introduce a custom macro or code generation when required syntax or repeated
structure justifies the cost of understanding expansion and generated behavior.
Account for effects and control flow hidden from the call site,
and the ability to navigate and debug the implementation.
Use a declarative macro when it meets the need without procedural machinery.
Established derives and standard macros remain appropriate for their usual jobs.
