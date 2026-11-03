# Async tests

For tests of concurrency, event delivery, event absence, or background workers,
prefer deterministic synchronization, explicit signals, or direct state assertions
over unconditional waiting.
Avoid `require.Never` when its main effect is sleep.
Use real-time checks only when neither deterministic signals nor virtual time is practical.

For behavior driven by timers or deadlines, create timers and goroutines
inside `testing/synctest.Test`'s bubble.
`synctest.Wait` settles activity before assertions;
`synctest.Sleep(d)` advances virtual time by `d` and settles activity at that time.
This supports boundary assertions without real sleeping:

```go
func TestReadyAfterDelay(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		var ready atomic.Bool
		time.AfterFunc(10*time.Second, func() { ready.Store(true) })

		synctest.Sleep(10*time.Second - time.Nanosecond)
		assert.False(t, ready.Load())
		synctest.Sleep(time.Nanosecond)
		assert.True(t, ready.Load())
	})
}
```

The bubble cannot make external I/O or unrelated goroutines deterministic;
use explicit signals for those boundaries.
