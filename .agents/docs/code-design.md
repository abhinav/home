# Code design

Apply these principles when designing new code or refactoring.

- [Centralize configuration](#centralize-configuration)
- [Avoid super-configs](#avoid-super-configs)
- [Group cohesive operations](#group-cohesive-operations)
- [Evaluate static conditions early](#evaluate-static-conditions-early)
- [Plan function expansion with objects](#plan-function-expansion-with-objects)
- [Place values by scope](#place-values-by-scope)
- [Prefer narrow, deep business packages](#prefer-narrow-deep-business-packages)
- [Keep maps inside abstraction boundaries](#keep-maps-inside-abstraction-boundaries)
- [Parse at abstraction boundaries](#parse-at-abstraction-boundaries)
- [Model choices as concepts, not booleans](#model-choices-as-concepts-not-booleans)

---

## Centralize configuration

Access to environment variables, configuration files, and other external state
should be centralized at the entry point (e.g., `main()`),
not scattered throughout the codebase.

**Why**: Scattered access makes code harder to test,
harder to reason about, and creates hidden dependencies.

### Bad: Scattered access

```go
func connectToDatabase() *Database {
    host := os.Getenv("DB_HOST")
    port, _ := strconv.Atoi(os.Getenv("DB_PORT"))
    return NewDatabase(host, port)
}

func createLogger() *Logger {
    level := os.Getenv("LOG_LEVEL")
    return NewLogger(level)
}
```

### Good: Centralized access

```go
func main() {
    // All environment access happens here
    dbHost := os.Getenv("DB_HOST")
    dbPort, _ := strconv.Atoi(os.Getenv("DB_PORT"))
    logLevel := os.Getenv("LOG_LEVEL")

    db := NewDatabase(dbHost, dbPort)
    logger := NewLogger(logLevel)
    runServer(db, logger)
}
```

---

## Avoid super-configs

Don't bundle unrelated configuration into a single object
that gets passed everywhere.
Each component should receive only the parameters it needs.

**Why**: God objects create tight coupling, make testing harder,
and obscure what each function actually depends on.

### Bad: Super-config passed everywhere

```go
type AppContext struct {
    DB           *Database
    Logger       *Logger
    Metrics      *MetricsClient
    Auth         *AuthProvider
    FeatureFlags *FeatureFlags
}

func handleRequest(ctx *AppContext, req *Request) { ... }
func validateToken(ctx *AppContext, token string) { ... }
func logEvent(ctx *AppContext, event *Event) { ... }
```

### Good: Pass only what's needed

```go
func handleRequest(db *Database, logger *Logger, req *Request) { ... }
func validateToken(auth *AuthProvider, token string) { ... }
func logEvent(logger *Logger, event *Event) { ... }
```

---

## Group cohesive operations

Group related operations into a class or struct
when they share state or form a cohesive unit of functionality.

**Why**: Encapsulation provides clear boundaries,
hides implementation details, and makes testing easier.

### Bad: Scattered functions sharing implicit state

```go
func createSession(store *Store, userID string) (*Session, error) { ... }
func getSession(store *Store, sessionID string) (*Session, error) { ... }
func refreshSession(store *Store, sessionID string) error { ... }
func invalidateSession(store *Store, sessionID string) error { ... }
func cleanupExpiredSessions(store *Store, maxAge time.Duration) error { ... }
```

### Good: Cohesive struct

```go
type SessionManager struct {
    store *Store
}

func NewSessionManager(store *Store) *SessionManager {
    return &SessionManager{store: store}
}

func (m *SessionManager) Create(userID string) (*Session, error) { ... }
func (m *SessionManager) Get(sessionID string) (*Session, error) { ... }
func (m *SessionManager) Refresh(sessionID string) error { ... }
func (m *SessionManager) Invalidate(sessionID string) error { ... }
func (m *SessionManager) CleanupExpired(maxAge time.Duration) (int, error) { ... }
```

---

## Evaluate static conditions early

When a condition depends on static configuration
(environment variables, flags, config files)
that won't change during execution,
evaluate it once at initialization and select the appropriate implementation.
Don't re-check static conditions repeatedly at runtime.

**Why**: Repeated conditional checks add noise, obscure intent,
and scatter policy decisions throughout the codebase.
Evaluating once makes the code cleaner and the decision point explicit.

### Bad: Static condition checked repeatedly

```go
type Notifier struct {
    Channel string  // never changes after construction
}

func (n *Notifier) Send(msg string) error {
    // Checked on every call
    switch n.Channel {
    case "email":
        return sendEmail(msg)
    case "slack":
        return postToSlack(msg)
    case "sms":
        return sendSMS(msg)
    }
    return errors.New("unknown channel")
}
```

### Good: Condition evaluated once, implementation selected

```go
type Notifier interface {
    Send(msg string) error
}

type EmailNotifier struct{}
func (EmailNotifier) Send(msg string) error { return sendEmail(msg) }

type SlackNotifier struct{}
func (SlackNotifier) Send(msg string) error { return postToSlack(msg) }

type SMSNotifier struct{}
func (SMSNotifier) Send(msg string) error { return sendSMS(msg) }

// Condition evaluated once at construction
func NewNotifier(channel string) Notifier {
    switch channel {
    case "email":
        return EmailNotifier{}
    case "slack":
        return SlackNotifier{}
    case "sms":
        return SMSNotifier{}
    }
    panic("unknown channel")
}
```

---

## Plan function expansion with objects

When a function's inputs or outputs are likely to grow,
prefer a named parameter object or result object
over a long positional signature.

Parameter objects let callers pass named inputs
and let the API add optional inputs later
without changing every call site.
Result objects let the API add optional outputs later
without changing every caller's assignment shape.

Use this especially for functions that cross package,
service,
or domain boundaries.

### Parameter objects

```go
type SearchRequest struct {
    Query string
    Limit int
}

func Search(req SearchRequest) (*SearchResult, error) { ... }
```

### Result objects

```go
type SearchResult struct {
    Items    []Item
    NextPage string
}

func Search(req SearchRequest) (*SearchResult, error) { ... }
```

Do not hide required concepts inside vague option bags.
The object should still describe the operation clearly,
and its fields should be cohesive.

---

## Place values by scope

Put values where their lifetime and rate of change match the abstraction.

Values that stay the same for an object, session,
job, or application run usually belong in configuration
or struct fields.
Values that change on each operation usually belong in method
or function parameters.

**Why**: Mixing scopes makes APIs noisy
and causes repeated plumbing.
Large-scope values passed through every call
often indicate a missing object or configuration boundary.
Small-scope values stored on long-lived structs
can make behavior harder to reason about
and unsafe to reuse.

### Bad: Repeated large-scope parameter

```go
func FetchProfile(
    client *http.Client,
    org string,
    login string,
) (*Profile, error) {
    ...
}

func ListProfiles(
    client *http.Client,
    org string,
) ([]*Profile, error) {
    ...
}
```

### Good: Large-scope values live on the object

```go
type ProfileService struct {
    client *http.Client
    org    string
}

func (s *ProfileService) Fetch(login string) (*Profile, error) {
    ...
}

func (s *ProfileService) List() ([]*Profile, error) {
    ...
}
```

---

## Prefer narrow, deep business packages

Business packages should usually expose a small surface area
that hides a meaningful amount of behavior.

Be skeptical of packages made mostly of exported top-level helpers.
A wide helper-style package often means the real abstraction
has not been named yet.

Warning signs include exported functions that:

- share many of the same parameters
- call each other frequently
- pass one function's output into another function
- perform business logic plus IO or RPC
- read process globals or shared package state
- live in packages named `util`, `common`, or `helpers`

When these signs appear,
look for the domain concept that ties the operations together.
Give that concept a name,
move shared dependencies into it,
and expose fewer entry points that do more complete work.

### Bad: Wide helper package

```go
func LoadInvoice(client *Client, id string) (*Invoice, error) { ... }
func PriceInvoice(client *Client, inv *Invoice) (*Price, error) { ... }
func SendInvoice(client *Client, inv *Invoice, price *Price) error { ... }
```

### Good: Named business abstraction

```go
type BillingService struct {
    client *Client
}

func (s *BillingService) SendInvoice(id string) error {
    ...
}
```

Small helper functions are fine inside the package.
The concern is exporting shallow fragments
that force callers to orchestrate the package's internal workflow.

---

## Keep maps inside abstraction boundaries

Avoid accepting or returning maps across package, service,
or domain abstraction boundaries
when the map represents structured business data.

Prefer purpose-built request, result,
or record types at the boundary.
Use maps internally when they are the right implementation detail
for lookup, grouping, deduplication, or indexing.

**Why**: Map types often hide the meaning of their keys and values.
They also expose implementation choices and mutable business constraints,
such as uniqueness requirements,
as part of the public shape of the API.
That makes later policy changes more disruptive
than they need to be.

### Bad: Map-shaped boundary

```go
func ConfigureAlerts(routes map[string]string) error { ... }
```

The signature does not explain what each string means.
It also suggests one route per key,
even if that may become a policy decision instead of a data-shape rule.

### Good: Structured boundary

```go
type AlertRoute struct {
    Service string
    Target  string
}

func ConfigureAlerts(routes []AlertRoute) error {
    seen := map[string]struct{}{}

    for _, route := range routes {
        if _, ok := seen[route.Service]; ok {
            return fmt.Errorf("duplicate service %q", route.Service)
        }
        seen[route.Service] = struct{}{}
    }

    ...
}
```

The function accepts the domain concept directly.
Any uniqueness checks happen at the entry point,
where they can change without forcing callers
to adopt a different container type.

Scrutinize maps especially when they appear in exported APIs,
constructor arguments, request structs, return values,
or interfaces.
A map is often appropriate inside the implementation,
but a slice of named records is usually clearer at the boundary.

---

## Parse at abstraction boundaries

Do not repeatedly inspect strings, integers,
or other primitive values
when they represent structured domain data.

Parse unstructured input once,
as close to the boundary as practical,
and pass the parsed representation through the rest of the system.

**Why**: Validation that leaves data in its original primitive form
forces every caller to rediscover the same structure.
That duplicates parsing logic,
creates inconsistent edge-case handling,
and makes invalid states easier to reintroduce.

Prefer types that make valid structure explicit:
URLs should become parsed URL values,
timestamps should become time values,
identifiers should become identifier types,
and templates or expressions should become parsed syntax trees.

### Bad: Repeated primitive inspection

```go
func supportsRemote(ref string) bool {
    return strings.HasPrefix(ref, "git://") ||
        strings.HasPrefix(ref, "ssh://")
}

func fetch(ref string) error {
    if supportsRemote(ref) {
        return fetchRemote(ref)
    }
    return fetchLocal(ref)
}
```

### Good: Parse once, operate on structure

```go
type SourceRef struct {
    Scheme string
    Path   string
}

func ParseSourceRef(raw string) (SourceRef, error) { ... }

func fetch(raw string) error {
    ref, err := ParseSourceRef(raw)
    if err != nil {
        return err
    }

    switch ref.Scheme {
    case "git", "ssh":
        return fetchRemote(ref)
    case "file":
        return fetchLocal(ref)
    default:
        return fmt.Errorf("unsupported source scheme %q", ref.Scheme)
    }
}
```

After parsing,
avoid consulting the original raw value
unless it is needed for diagnostics or output.
The parsed type should become the system of record.

---

## Model choices as concepts, not booleans

Avoid adding narrow boolean options
to represent one-off behavior changes across abstraction boundaries.

A boolean often models the first exception,
not the underlying concept.
That makes APIs rigid:
the next mode becomes another boolean,
and combinations of booleans can create invalid or unclear states.

Prefer naming the broader choice directly.
Use an enum, strategy, or purpose-built option type
when behavior has multiple possible modes
or is likely to grow beyond a stable yes/no decision.

Put the option at the scope where it actually varies.
If behavior is chosen once per object, session, or job,
do not pass it on every operation.

When adding optional configuration,
choose a zero value that preserves existing behavior.
Validate unsupported modes or conflicting options
at construction or at the API boundary.

### Bad: Narrow boolean option

```go
func FormatReport(report *Report, compact bool) string { ... }
```

The call site does not explain what the boolean means.
It also leaves little room for a third formatting mode
without adding another option
or changing the function shape again.

### Good: Named behavior mode

```go
type ReportFormat int

const (
    ReportFormatFull ReportFormat = iota
    ReportFormatCompact
    ReportFormatSummary
)

type Formatter struct {
    Format ReportFormat
}

func (f *Formatter) FormatReport(report *Report) string { ... }
```

The API names the concept directly
and leaves room for future modes
without creating boolean combinations.

Booleans are still appropriate for genuinely binary,
stable facts:
predicates, local control flow,
or fields where true and false are the domain.

---

## Adding new rules

To extend this document with additional rules:

1. Add the rule to the bullet list at the top.
2. Create a new section following the pattern:
   - Short rule title with anchor
   - Principle statement
   - **Why** explanation
   - Bad example heading + code
   - Good example heading + code
