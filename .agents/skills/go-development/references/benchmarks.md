# Benchmarks

Use `for b.Loop() { ... }` for benchmark iterations.
It keeps call arguments and results in the measured body alive,
so the compiler cannot eliminate the operation being measured.
Put reusable setup before the loop and cleanup after it.
