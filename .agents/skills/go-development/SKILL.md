---
name: go-development
description: >
  Write, change, review, test, debug, or explain Go code; work with Go modules,
  tool dependencies, or dependency source; or choose Go language and
  standard-library APIs. Do not use when Go is incidental and no Go-specific
  decision, artifact, or diagnosis is required.
---

# Go development

Use current Go language and standard library facilities for new code.
Follow an explicit project requirement to support an older Go version.
Read every matching reference before making the decision it governs:

| Work | Reference |
| --- | --- |
| Module requirements, tool dependencies, or inspection of dependency source | [Modules and dependencies](references/modules-and-dependencies.md) |
| Imports, names, declaration order, or file organization | [Source organization](references/source-organization.md) |
| Go documentation or adding or changing struct fields | [Documentation](references/documentation.md) |
| Process termination, structured logging, or errors | [Errors and diagnostics](references/errors-and-diagnostics.md) |
| Interfaces, interface compliance, or concrete result types | [Interfaces](references/interfaces.md) |
| Considering callback APIs, accepting function parameters, or passing functions or closures to helpers | [Callbacks](references/callbacks.md) |
| Function shapes, resource acquisition and cleanup, construction, dependencies, or exported members | [Signatures and construction](references/signatures-and-construction.md) |
| Map-shaped APIs or boolean API parameters | [Map and boolean APIs](references/map-and-boolean-apis.md) |
| Parsing domain values, enums, copying and sharing semantics, receiver choice, or pointers or values in APIs and collections | [Type semantics](references/type-semantics.md) |
| Maps, slices, iterators, streaming, strings, or bytes | [Collections and iteration](references/collections-and-iteration.md) |
| Context propagation or cancellation, goroutines, channels, or synchronization | [Context and concurrency](references/context-and-concurrency.md) |
| JSON representation or encoding | [JSON](references/json.md) |
| UUIDs, identifiers, or random tokens | [Identifiers and randomness](references/identifiers-and-randomness.md) |
| Filesystem access across a trust boundary | [Filesystem](references/filesystem.md) |
| HTTP routing | [HTTP](references/http.md) |
| Go tests or executable API examples | [Testing](references/testing.md) |
| Property-based tests, test input generators, or fuzz targets | [Property-based tests and fuzzing](references/property-based-testing.md) |
| Testing code that invokes external programs through `os/exec` | [Subprocess tests](references/subprocess-tests.md) |
| Tests of asynchronous behavior, event delivery, background workers, timers, or deadlines | [Async tests](references/async-tests.md) |
| HTTP tests | [HTTP tests](references/http-tests.md) |
| Benchmarks | [Benchmarks](references/benchmarks.md) |
| Choosing or writing table tests | [Table tests](references/table-tests.md) |

Combine these rules with the general skills governing the decision:

- `code-design`: domain contracts, ownership, dependencies, and representations.
- `code-readability`: the maintainer's mental model;
  Go guidance supplies language-specific naming and organization constraints.
- `code-testing`: evidence a change needs and the behavior each test protects;
  Go guidance supplies test mechanics and conventions.
