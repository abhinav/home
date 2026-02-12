# Code design

Apply these principles when designing new code or refactoring.

- [Centralize configuration](#centralize-configuration)
- [Avoid super-configs](#avoid-super-configs)
- [Group cohesive operations](#group-cohesive-operations)
- [Evaluate static conditions early](#evaluate-static-conditions-early)

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

## Adding new rules

To extend this document with additional rules:

1. Add the rule to the bullet list at the top.
2. Create a new section following the pattern:
   - Short rule title with anchor
   - Principle statement
   - **Why** explanation
   - Bad example heading + code
   - Good example heading + code
