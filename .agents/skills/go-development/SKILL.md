---
name: go-development
description: >
  Use when writing, changing, reviewing, testing, debugging, or explaining Go
  code; working with Go modules, tool dependencies, or dependency source; or
  choosing Go language and standard-library APIs. Do not use when Go is only
  incidental context and no Go-specific decision, artifact, or diagnosis is
  required.
---

# Go development

Use current Go language and standard library facilities for new code.
Follow an explicit project requirement to support an older Go version.

Read every reference whose condition matches the work before making the
decision it governs:

- For module requirements, tool dependencies,
  or inspection of dependency source,
  read [Modules and dependencies](references/modules-and-dependencies.md).
- For imports, names, declaration order, or file organization,
  read [Source organization](references/source-organization.md).
- For process termination, structured logging, or errors,
  read [Errors and diagnostics](references/errors-and-diagnostics.md).
- For interfaces, function shapes, construction, dependencies,
  exported members, map-shaped APIs, or boolean API parameters,
  read [API design](references/api-design.md).
- For parsing domain values, enums, copying and sharing semantics,
  receiver choice,
  or whether APIs and collections carry pointers or values,
  read [Type semantics](references/type-semantics.md).
- For maps, slices, iterators, streaming, strings, or bytes,
  read [Collections and iteration](references/collections-and-iteration.md).
- For context propagation or goroutines,
  read [Context and concurrency](references/context-and-concurrency.md).
- For JSON representation or encoding,
  read [JSON](references/json.md).
- For UUIDs, identifiers, or random tokens,
  read [Identifiers and randomness](references/identifiers-and-randomness.md).
- For filesystem access across a trust boundary,
  read [Filesystem](references/filesystem.md).
- For HTTP routing,
  read [HTTP](references/http.md).
- For Go tests or benchmarks,
  read [Testing](references/testing.md).

Combine these language-specific rules with the general skills that govern the
decision:

- `code-design` owns domain contracts, ownership, dependencies,
  and representation decisions.
- `code-readability` owns the maintainer's mental model;
  Go guidance supplies language-specific naming and organization constraints.
- `code-testing` owns the evidence a change needs
  and the behavior each test protects;
  Go guidance supplies Go test mechanics and conventions.
- `code-comments` owns documentation judgment;
  Go guidance supplies Go-specific comment mechanics when present.
