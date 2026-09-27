# Property-based tests and fuzzing

Use `code-testing` to choose the missing evidence, domain, and independent oracle.
Keep a suitable existing integration; adding a property does not require
migrating the project's other tests.
For a new integration, match the input model and run mode:

- [Proptest](https://docs.rs/proptest/latest/proptest/)
  supplies composable strategies, shrinking, and persisted regressions
  in ordinary `cargo test` runs on stable Rust.
  It is a compact choice for structured values and operation histories.
- [Hegel](https://docs.rs/hegeltest/latest/hegel/)
  also generates and shrinks cases during ordinary tests,
  using the Hegel engine shared across language bindings.
  Consider it when that engine or an existing Hegel convention is useful.
- [cargo-fuzz](https://rust-fuzz.github.io/book/cargo-fuzz.html)
  runs coverage-guided libFuzzer campaigns separately from `cargo test`.
  It can check semantic properties as well as crashes and sanitizer failures.

Use releases compatible with the crate's supported toolchain.
The examples are alternatives for `lower_bound(xs: &[i32], key: i32) -> usize`,
which accepts sorted input and returns the first index with value at least key,
or the slice length.
Counting smaller values checks the contract independently of binary search.
Small value ranges encourage duplicates; length caps bound test work.
Keep fixed examples for important boundaries and wider integer limits.

## Proptest

Add `proptest` as a dev dependency, for example with `cargo add --dev proptest`.
In the existing test module, import `super::lower_bound` and
`proptest::{collection, prop_assert_eq, proptest}`:

```rust
proptest! {
    /// Checks the boundary against a count independent of binary search.
    #[test]
    fn lower_bound_proptest(
        mut xs in collection::vec(-20i32..=20, 0..101),
        key in -21i32..=21,
    ) {
        xs.sort_unstable();
        let want = xs.iter().filter(|&&x| x < key).count();
        prop_assert_eq!(lower_bound(&xs, key), want);
    }
}
```

Run with `cargo test`.
Use strategy composition to build valid values;
heavy rejection with `prop_assume!` wastes the search budget.
Keep important generated failures in durable regressions,
including Proptest's regression files when its persistence is enabled.
See the [Proptest guide](https://proptest-rs.github.io/proptest/proptest/getting-started.html)
for strategy and replay details.

## Hegel

Add the dev dependency with `cargo add --dev hegeltest`;
the package name is `hegeltest`, while the Rust import is `hegel`.
The current binding builds a native engine and loads it in the test process;
`cargo test` locates it automatically.
Check the selected release's [engine setup](https://docs.rs/hegeltest/latest/hegel/#the-engine-library)
and [compatibility](https://hegel.dev/compatibility)
for local and CI test environments, particularly offline builds.
Hegel is currently in beta, so verify APIs against the selected release.

In the test module, import `super::lower_bound` and
`hegel::{TestCase, generators}`:

```rust
/// Checks the boundary against a count independent of binary search.
#[hegel::test]
fn lower_bound_hegel(tc: TestCase) {
    let values = generators::integers::<i32>().min_value(-20).max_value(20);
    let mut xs = tc.draw(generators::vecs(values).max_size(100));
    let key = tc.draw(generators::integers::<i32>().min_value(-21).max_value(21));
    xs.sort_unstable();
    let want = xs.iter().filter(|&&x| x < key).count();
    assert_eq!(lower_bound(&xs, key), want, "xs={xs:?} key={key}");
}
```

Run with `cargo test`.
The attribute owns generation, shrinking, and replay around ordinary assertions.

## cargo-fuzz

A target in `fuzz/fuzz_targets/lower_bound.rs` can use typed input through
[`arbitrary`](https://rust-fuzz.github.io/book/cargo-fuzz/structure-aware-fuzzing.html).
It need not accept only raw bytes.
For a library crate named `search` with the contract above:

```rust
#![no_main]

use libfuzzer_sys::fuzz_target;

fuzz_target!(|input: (Vec<i32>, i32)| {
    let (mut xs, key) = input;
    xs.truncate(100);
    xs.sort_unstable();
    let want = xs.iter().filter(|&&x| x < key).count();
    assert_eq!(search::lower_bound(&xs, key), want, "xs={xs:?} key={key}");
});
```

Use the project's fuzz package, or `cargo fuzz init` and `cargo fuzz add lower_bound`
when adding that infrastructure is warranted.
Confirm the [cargo-fuzz prerequisites](https://rust-fuzz.github.io/book/cargo-fuzz/setup.html):
a supported platform, nightly toolchain, and required compiler support.
Select nightly for the invocation without changing the project's default:

```sh
cargo +nightly fuzz run lower_bound -- -max_total_time=10
```

Ordinary `cargo test` does not run this campaign or automatically replay its corpus.
Retain important failures as unit regressions or arrange explicit corpus replay.
The adapter bounds vector length but preserves integer values;
more constrained domains may need custom `Arbitrary` generation or mutation.
Prefer a property runner when those constraints are clearer as strategies
and the checks should generate cases on every ordinary test run.
