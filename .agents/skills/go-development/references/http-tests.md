# HTTP tests

`httptest.NewTestServer(t, handler)` serves requests on an in-memory network
and registers server cleanup with the test.
Its `server.Client()` routes requests to that server without a TCP port,
including requests made inside a `synctest` bubble.
Call `Start` only when a real loopback listener is needed.
