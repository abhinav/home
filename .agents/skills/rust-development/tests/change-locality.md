# Change locality application scenarios

These invented scenarios exercise the placement of meaning, state, and effects
in Rust interfaces.
Use the runner and independent-grading procedure in [README.md](README.md).
Only the Prompt sections are runner-visible.
Expected behavior is evaluator-only; accept equivalent designs that preserve
all stated contracts.
The grouped cases can also be run individually with their common prompt preamble.

## Operation inputs, shared decisions, and persisted work

### Prompt

Use the Rust skill at {GUIDANCE_PATH} and the references relevant to each decision.
This is an invented Rust service; give a concise design recommendation for each
case with the smallest useful Rust interface sketch. Do not modify shared files
or inspect behavioral tests or other agents' results.
You may read only the supplied skill and the references it routes to.
Explain required remaining changes and preserve the stated contracts.

A. A process retains Dispatcher<Context, Store>. Context has async tenant(),
which reads the tenant of the current request. Each authenticated entry point
already resolves and authorizes its caller. A new command source must be added.
The dispatcher needs the tenant for attribution; the store is used during the
operation. Some later network calls also need the originating credentials.
How should the service and invocation boundary evolve?

B. Interactive and scheduled invoice importers each load a selected exchange
rate revision, verify its currency and publication date, then calculate the
same invoice totals. Their claiming, retry, and delivery policies differ.
A new rule for the selected rate must apply to both. Suggest the organization.
A nearby forecast calculator happens to use similar arithmetic but intentionally
uses today's estimated rate, not the selected revision.

C. A generated protocol adds optional repeated separators to a cursor record.
Existing callers use its legacy separator field. The protocol forbids setting
both; empty repeated separators preserve legacy interpretation. The generated
record already implements Default. Existing literals supply every old field.
How should these callers construct it? Separately, a domain command adds a
required recipient; no recipient is meaningful as a default.

D. A preview builder clones a delivery request, sets deliver=false and
validation_mode=Relaxed, invokes the full delivery planner, then deletes its
notification actions. The preview and delivery need the same address formatting;
the preview must not authorize delivery or arrange side effects. Show the useful
reuse boundary, including where the workflows' different validation belongs.

E. A media library can list saved track titles immediately, but loads transcripts
only when requested. A transcript may be absent because it has not been loaded,
or loaded and contain no words. Browsing titles currently waits for every
transcript. Recommend the data and operation boundaries. A later feature must
also display loading progress and distinguish a failed load from one not started.
Does the initial representation remain sufficient?

F. Persisted render jobs hash a tool executable version into artifact identity
and can only be claimed by workers with that version. Workers currently all
implement the same format contract. That contract permits several valid byte
encodings, and the first committed artifact is reused by subsequent readers.
A tool upgrade implements the same format. Recommend the identity and claim
contract for the upgrade and for a future incompatible format. Separately,
a reproducible-build product promises byte-identical output for a pinned toolchain.
Does your recommendation apply unchanged there?

### Expected behavior

Judgment evaluation; accept equivalent concise representations.
A: resolve authorized invocation identity to input; retain Store behavior;
preserve credential propagation and fresh authorization obligations. Do not
merely propagate Context to more outer types or treat tenant ID as a credential.
B: one operation owns selected-rate load/validate/calculate; distinct workflows
retain claim/retry/delivery; forecast retains different policy.
C: protocol defaults or an equivalent owned constructor contain optional field
growth; required domain recipient remains an explicit new caller choice.
D: direct formatting transformation with real inputs, separate workflow validation;
no fabricated relaxed delivery request, new generic workflow engine, or effects.
E: browsing titles does not depend on transcripts; absent differs from loaded
empty; transcript operations require loaded data. A simple presence/absence
representation is valid initially, but later observable loading/failure states
need distinct representation. Do not introduce unrelated coordination machinery.
F: explicit format compatibility owns durable identity and eligibility, preserve
accepted identifiers, intentional incompatible migration/support, no false byte
reproducibility promise. Pinned toolchain case retains required identity inputs.

For each case cite output/source evidence and classify pass/fail. Record weak or
missing detail separately from a material contract violation. Do not require a
particular type name or a complete compilable program for these interface sketches.

## Identities, lifecycle, batches, errors, and review boundaries

### Prompt

Use the Rust skill at {GUIDANCE_PATH} and references relevant to each decision.
These are invented APIs. Recommend a concrete design for each case and show
small Rust interface shapes where useful. Preserve the stated contracts.
Do not modify shared files or inspect tests, other reports, or other guidance
versions. You may read only the supplied skill and its routed references.

G. A hosted library catalogue uses a mutable public alias, a stable internal
CatalogId, and an external provider's bucket key. All three happen to contain
"books" in the initial fixture, but aliases can be renamed and providers can
move buckets. CatalogId keys all retained annotations. A fallback provider is
being added. Where should each value travel and where should resolution happen?
A nearby application uses one canonical externally assigned identifier whose
meaning and lifetime are shared by its domain and protocol; does it need wrapping?

H. Receipt preparation has optional resolved tax evidence and a bool named
queued. Historically no evidence meant legacy data with unknown tax policy.
For new receipts queued=true records the accepted deferred tax policy, and
remains true after calculation completes. A calculated result can itself have
been obtained by the same tax algorithm. Suggest an in-memory representation
and explain storage interpretation when another policy is introduced. Calculation
readiness changes independently; persisted older rows must remain readable.

I. An image converter already implements render_one. A worker renders up to
100 images from the same read-only source archive and repeatedly starts a codec
process. It must yield images in input order, enforce one byte limit for the
batch, retain successful earlier outputs after a later failure, and shut down
remaining process work before deleting its temporary directory. A pull may be
cancelled mid-frame. Some backends only support render_one. Propose the operation
and ownership contract. Separately, an atomic multi-account transfer is proposed
with a default method that loops over single-account writes; assess that fallback.

J. A lookup consumer exhaustively translates a large public MutationError enum
although it only needs absent, invalid request, and unavailable outcomes. The
mutation owner is adding a more informative invalid-format diagnostic, with no
new recovery behavior. Its lower-level unavailable error also has a useful source
that the current unit variant discards. Propose evolution of these boundaries.
A new conflict outcome really will require callers to reload before retrying.
How does that case differ?

K. A storage change strengthens settlement so balances and its receipt commit
together. The same patch moves validation into a shared operation, renames
records, and normalizes persisted layout. The old and new layouts can coexist
with a supported decoder; changing settlement behavior alone in either layout
is supported. Plan the review units and their evidence. A second version cannot
support any intermediate schema/behavior combination. What changes in that plan?

### Expected behavior

Judgment; accept equivalent shapes.
G: distinct meanings despite equal fixture strings; stable retained identity;
resolver/adapter owns aliases/provider routing; no compulsory wrapper for shared
canonical semantics; a value lookup does not permanently authorize use.
H: recorded evidence, accepted deferred policy, and legacy absence are distinct;
readiness remains independent, accepted policy does not flip on completion;
recorded evidence may come from same algorithm; decoding/version constraints
remain explicit; enum does not remove migration obligations.
I: retained resource owner or borrowed session, incremental fallible outputs,
ordered results and aggregate budget, real sequential fallback allowed for prefix
semantics, cancellation resume-versus-discard decision explicit, resource lifetime
covers surviving child work, loop cannot implement atomic transfer.
J: narrow operation contract or stable category/private detail; cause preserved;
new actionable conflict remains explicit instead of blanket wildcard/string errors.
K: separate behavior-preserving review units when intermediate states are supported;
parent-relative evidence and coordinated atomic effects; combined unit legitimate
when intermediate states cannot be supported. No callbacks/eventual-consistency
substitution merely to reduce diff size.
