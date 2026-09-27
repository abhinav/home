# Performance

## Spend complexity on a demonstrated cost

Apply ordinary efficient choices directly:
borrowed access, storage transfer, removal of unnecessary copies,
reusable destinations, standard collection operations,
and a credible known capacity.
For those API choices, use
[Ownership and conversions](ownership-and-conversions.md) and
[Collections and iteration](collections-and-iteration.md).
They do not need a benchmark before every use, including on cold paths.

Require workload evidence when introducing extra representation,
ownership, or execution machinery solely for performance.
Examples include interning, custom hashers, inline storage,
forced inlining, unusual layouts, or a pervasive shared representation.
Preserve a simpler design when the removed cost is insignificant
or the machinery shifts cost to callers.

Compare equivalent work under representative inputs and an appropriate
optimized build.
Measure the metric the change claims to improve;
an isolated microbenchmark can explain a cause without proving
an application improvement.
Include allocation or retained-memory effects when those motivated the change.

A large `Copy` value can also be costly to move repeatedly.

Reserve from trustworthy size information or an established resource bound;
an unchecked input length is not permission to allocate that much memory.
Changing a hasher must preserve the required resistance to adversarial input.
Inlining hints can increase code size or worsen nearby optimization decisions;
retain them for an observed benefit.

For unsafe code introduced as an optimization, also read
[Unsafe abstractions](unsafe.md).
