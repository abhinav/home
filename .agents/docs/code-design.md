# Code design

Apply these principles when designing new code or refactoring.

- [Data, dependency, and control flow](#data-dependency-and-control-flow)
  - [Centralize configuration](#centralize-configuration)
  - [Avoid super-configs](#avoid-super-configs)
  - [Place values by scope](#place-values-by-scope)
  - [Evaluate static conditions early](#evaluate-static-conditions-early)
  - [Converge shared control flow](#converge-shared-control-flow)
- [Abstraction shape](#abstraction-shape)
  - [Group cohesive operations](#group-cohesive-operations)
  - [Prefer narrow, deep business packages](#prefer-narrow-deep-business-packages)
  - [Plan function expansion with objects](#plan-function-expansion-with-objects)
  - [Model choices as concepts, not booleans](#model-choices-as-concepts-not-booleans)
- [Boundaries and data modeling](#boundaries-and-data-modeling)
  - [Keep domain boundaries clean](#keep-domain-boundaries-clean)
  - [Parse at abstraction boundaries](#parse-at-abstraction-boundaries)
  - [Keep maps inside abstraction boundaries](#keep-maps-inside-abstraction-boundaries)
- [Adding new rules](#adding-new-rules)

---

## Data, dependency, and control flow

Use these rules to decide where configuration,
dependencies,
values,
and shared work should enter or live in the system.

### Centralize configuration

Access to environment variables, configuration files, and other external state
should be centralized at the entry point (e.g., `main()`),
not scattered throughout the codebase.

**Why**: Scattered access makes code harder to test,
harder to reason about, and creates hidden dependencies.

#### Bad: Scattered access

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

#### Good: Centralized access

```go
func main() {
    // All environment access happens here.
    dbHost := os.Getenv("DB_HOST")
    dbPort, _ := strconv.Atoi(os.Getenv("DB_PORT"))
    logLevel := os.Getenv("LOG_LEVEL")

    db := NewDatabase(dbHost, dbPort)
    logger := NewLogger(logLevel)
    runServer(db, logger)
}
```

### Avoid super-configs

Do not bundle unrelated configuration into a single object
that gets passed everywhere.
Each component should receive only the parameters it needs.

**Why**: God objects create tight coupling, make testing harder,
and obscure what each function actually depends on.

#### Bad: Super-config passed everywhere

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

#### Good: Pass only what is needed

```go
func handleRequest(db *Database, logger *Logger, req *Request) { ... }
func validateToken(auth *AuthProvider, token string) { ... }
func logEvent(logger *Logger, event *Event) { ... }
```

### Place values by scope

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

#### Bad: Repeated large-scope parameter

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

#### Good: Large-scope values live on the object

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

### Evaluate static conditions early

When a condition depends on static configuration
(environment variables, flags, config files)
that will not change during execution,
evaluate it once at initialization and select the appropriate implementation.
Do not re-check static conditions repeatedly at runtime.

**Why**: Repeated conditional checks add noise, obscure intent,
and scatter policy decisions throughout the codebase.
Evaluating once makes the code cleaner and the decision point explicit.

#### Bad: Static condition checked repeatedly

```go
type Notifier struct {
    Channel string // never changes after construction
}

func (n *Notifier) Send(msg string) error {
    // Checked on every call.
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

#### Good: Condition evaluated once, implementation selected

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

// Condition evaluated once at construction.
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

### Converge shared control flow

When conditional branches choose an input, mode, representation,
or intermediate value for the same later operation,
make the branches produce or refine a common value,
then run the shared operation once after the conditional.

Use early returns for failures, invalid states,
or outcomes where the function should not continue.

**Why**: Duplicating the same downstream operation across branches
makes the function harder to scan
and creates room for the branches to drift apart.
Converging after the decision keeps branches focused on selection
and keeps shared work in one place.

#### Bad: Shared operation duplicated across branches

```go
value := defaultValue

loaded, err := load()
if err != nil {
    if errors.Is(err, os.ErrNotExist) {
        return use(value)
    }
    return fmt.Errorf("load: %w", err)
}

value = loaded
return use(value)
```

#### Good: Branches decide, then converge

```go
value := defaultValue

loaded, err := load()
if err != nil {
    if !errors.Is(err, os.ErrNotExist) {
        return fmt.Errorf("load: %w", err)
    }
} else {
    value = loaded
}

return use(value)
```

Early returns are still preferred
when the function cannot continue.
The convergence point is for work
that all successful paths share.

---

## Abstraction shape

Use these rules to decide when a set of functions,
parameters,
or modes should become a named abstraction.

### Group cohesive operations

Group related operations into a class or struct
when they share state or form a cohesive unit of functionality.

**Why**: Encapsulation provides clear boundaries,
hides implementation details, and makes testing easier.

#### Bad: Scattered functions sharing implicit state

```go
func createSession(store *Store, userID string) (*Session, error) { ... }
func getSession(store *Store, sessionID string) (*Session, error) { ... }
func refreshSession(store *Store, sessionID string) error { ... }
func invalidateSession(store *Store, sessionID string) error { ... }
func cleanupExpiredSessions(store *Store, maxAge time.Duration) error { ... }
```

#### Good: Cohesive struct

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
func (m *SessionManager) CleanupExpired(maxAge time.Duration) (int, error) {
    ...
}
```

### Prefer narrow, deep business packages

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

#### Bad: Wide helper package

```go
func LoadInvoice(client *Client, id string) (*Invoice, error) { ... }
func PriceInvoice(client *Client, inv *Invoice) (*Price, error) { ... }
func SendInvoice(client *Client, inv *Invoice, price *Price) error { ... }
```

#### Good: Named business abstraction

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

### Plan function expansion with objects

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

#### Parameter objects

```go
type SearchRequest struct {
    Query string
    Limit int
}

func Search(req SearchRequest) (*SearchResult, error) { ... }
```

#### Result objects

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

### Model choices as concepts, not booleans

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

#### Bad: Narrow boolean option

```go
func FormatReport(report *Report, compact bool) string { ... }
```

The call site does not explain what the boolean means.
It also leaves little room for a third formatting mode
without adding another option
or changing the function shape again.

#### Good: Named behavior mode

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

## Boundaries and data modeling

Use these rules when data crosses a package,
service,
domain,
or infrastructure boundary.

### Keep domain boundaries clean

Business packages should depend on business concepts,
not transport, persistence, framework, or vendor abstractions.

Translate external shapes at the adapter boundary.
HTTP handlers, CLI commands, database repositories,
queue consumers, and SDK clients should convert their inputs
into domain request and result types before calling domain logic.

**Why**: When infrastructure types leak into business logic,
the domain becomes coupled to incidental delivery mechanisms.
Policy changes then require plumbing through HTTP structs,
database rows, generated clients, or framework lifecycles.
Keeping the boundary clean makes domain behavior easier to test,
reuse, and change.

#### Bad: Infrastructure leaks into the domain

```go
func (s *BillingService) CreateInvoice(
    ctx context.Context,
    req *http.Request,
    row *InvoiceRow,
) error {
    customerID := req.URL.Query().Get("customer_id")
    ...
}
```

#### Good: Adapter translates into domain concepts

```go
type CreateInvoiceRequest struct {
    CustomerID CustomerID
    Lines      []InvoiceLine
}

func (s *BillingService) CreateInvoice(
    ctx context.Context,
    req CreateInvoiceRequest,
) error {
    ...
}
```

Adapters may know about both sides of the boundary.
Domain abstractions should not.

Avoid passing through generic bags like `map[string]any`,
transport DTOs, database rows, or generated API structs
unless they are the actual domain model.

### Parse at abstraction boundaries

Parse less-structured input into precise data shapes
as close to the boundary as practical.

Do not validate a value,
discard the knowledge gained,
and keep passing the original string,
integer, slice, map, or external DTO through the system.
Return a representation that carries the invariant forward.

**Why**: Validation that leaves data in its original primitive form
forces the rest of the program to trust that a prior check happened.
That creates repeated checks,
`impossible` branches,
and fragile coupling between callers and callees.
Parsing preserves what was learned
by turning raw input into a type the rest of the system can rely on.

Prefer types that make valid structure explicit:
URLs should become parsed URL values,
timestamps should become time values,
identifiers should become identifier types,
non-empty inputs should become non-empty shapes,
deduplicated data should become a structure that enforces uniqueness,
and templates or expressions should become parsed syntax trees.

#### Bad: Validate, then keep raw data

```go
func validateRoutes(routes []RouteInput) error {
    seen := map[string]struct{}{}

    for _, route := range routes {
        if route.Service == "" {
            return errors.New("service is required")
        }
        if _, ok := seen[route.Service]; ok {
            return fmt.Errorf("duplicate service %q", route.Service)
        }
        seen[route.Service] = struct{}{}
    }

    return nil
}

func ConfigureAlerts(routes []RouteInput) error {
    if err := validateRoutes(routes); err != nil {
        return err
    }

    return applyRoutes(routes)
}
```

The validation result carries no information.
A later caller can skip it,
or a later callee can accidentally reintroduce the invalid case.

#### Good: Parse into the shape the domain needs

```go
type AlertRoutes struct {
    byService map[string]AlertRoute
}

func ParseAlertRoutes(inputs []RouteInput) (AlertRoutes, error) {
    routes := AlertRoutes{byService: map[string]AlertRoute{}}

    for _, input := range inputs {
        route, err := ParseAlertRoute(input)
        if err != nil {
            return AlertRoutes{}, err
        }
        if _, ok := routes.byService[route.Service]; ok {
            return AlertRoutes{}, fmt.Errorf(
                "duplicate service %q",
                route.Service,
            )
        }
        routes.byService[route.Service] = route
    }

    return routes, nil
}

func ConfigureAlerts(routes AlertRoutes) error {
    return applyRoutes(routes)
}
```

After parsing,
the parsed type should become the system of record.
Keep the original raw value only when needed for diagnostics,
audit output,
or round-tripping.

Push the burden of proof upward as far as useful,
but no farther.
If only one selected branch needs a stronger representation,
parse into that representation when the branch is selected,
before acting on the data.

### Keep maps inside abstraction boundaries

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

#### Bad: Map-shaped boundary

```go
func ConfigureAlerts(routes map[string]string) error { ... }
```

The signature does not explain what each string means.
It also suggests one route per key,
even if that may become a policy decision instead of a data-shape rule.

#### Good: Structured boundary

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

## Adding new rules

To extend this document with additional rules:

1. Add the rule to the relevant group at the top.
2. Create a new section following the pattern:
   - short rule title with anchor
   - principle statement
   - **Why** explanation
   - bad example heading and code
   - good example heading and code
