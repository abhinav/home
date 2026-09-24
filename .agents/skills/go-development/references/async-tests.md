# Async tests

When testing asynchronous behavior,
prefer deterministic synchronization,
explicit signals,
or direct state assertions over unconditional waiting.
Avoid assertions such as `require.Never`
when their main effect is to make the test sleep.

This applies to concurrency tests,
event-delivery tests,
absence-of-event tests,
and background-worker tests.
Use a real-time check only when no deterministic signal
or virtual-time test is practical.

For behavior driven by timers or deadlines,
`testing/synctest.Test` provides a bubble with virtual time.
Create the timers and goroutines inside the bubble;
`synctest.Wait` lets their activity settle before an assertion.
`synctest.Sleep(d)` advances virtual time by `d`
and then waits for activity at that time to settle.
This is suitable for boundary assertions without real sleeping:

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

The bubble cannot make external I/O or unrelated goroutines deterministic.
Use explicit signals for those boundaries.
