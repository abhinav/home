---
name: rust-development
description: >
  Use when writing, changing, reviewing, testing, debugging, or explaining Rust
  code; designing Rust APIs and representations; or choosing Rust language and
  library idioms. Do not use when Rust is incidental context and no
  Rust-specific decision, artifact, or diagnosis is required.
---

# Rust development

Assume current stable Rust and edition 2024 or newer.
This skill supplies implementation preferences for agents that already know Rust.
Apply the project's supported contracts when changing existing code.

Prefer borrowing or moving existing data over duplicating payloads.
Treat each added clone or owned conversion as an ownership decision,
including inside a change whose primary purpose is unrelated to ownership.

Read every reference whose condition matches the work before making the
corresponding decision:

- For module and file organization, shared operations, changes spanning callers,
  item naming, imports, visibility, dependency types in APIs,
  or the ways callers can extend or depend on an API,
  read [API surface and evolution](references/api-surface-and-evolution.md).
- For invocation data, retained dependencies, required parameters, optional
  settings, constructors, builders, or staging substantial caller changes,
  read [Construction](references/construction.md).
- For ownership in signatures or local data flow, borrow-checker fixes,
  cloning or owned conversions, buffer reuse, accessor names,
  or owned types with borrowed counterparts,
  read [Ownership and conversions](references/ownership-and-conversions.md).
- For domain identities, provider address translation, parsing into domain types,
  preserving invariants during mutation, invalid states, standard trait
  implementations, numeric conversions, or exhaustive enum handling,
  read [Types and standard traits](references/types-and-traits.md).
- For generics, trait objects, trait bounds, extension traits, or callbacks,
  read [Polymorphism and bounds](references/polymorphism.md).
- For sequence APIs, collections, iterators, streaming, or adapter chains,
  read [Collections and iteration](references/collections-and-iteration.md).
- For errors, panics, logging, or process termination,
  read [Errors and diagnostics](references/errors-and-diagnostics.md).
- For serialization, generated protocol records, independently available data,
  persisted compatibility, schema validation, or dynamic payloads,
  read [Data representation](references/data-representation.md).
- For paths, OS strings, or filesystem access across a trust boundary,
  read [Filesystem and native representations](references/filesystem.md).
- For RAII, resources shared across a batch, temporary resources, child processes,
  cleanup, fallible completion, or extracting a wrapped resource,
  read [Resources and completion](references/resources-and-completion.md).
- For async execution, task spawning or cancellation, blocking work on async
  workers, or synchronization,
  read [Async execution and synchronization](references/async-and-synchronization.md).
- For performance changes,
  read [Performance](references/performance.md).
- For unsafe code, FFI wrappers, pinning, or partial initialization,
  read [Unsafe abstractions](references/unsafe.md).
- When authoring, changing, or reviewing named Rust items, comments,
  or API examples,
  read [Documentation](references/documentation.md).
- For Rust tests, including file layout, fixtures, subprocesses, and async behavior,
  read [Testing](references/testing.md).
- For property-based tests, test input generators, or fuzz targets,
  read [Property-based tests and fuzzing](references/property-based-testing.md).
