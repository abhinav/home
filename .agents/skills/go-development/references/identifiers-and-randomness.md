# Identifiers and randomness

Use standard `uuid` for UUID generation and parsing:
`uuid.New()` chooses a suitable default; use `uuid.NewV4()` or `uuid.NewV7()`
when version is contractual, and `uuid.Parse` to validate incoming strings.
An established API may still require a third-party UUID type.

Use `crypto/rand.Text()` for an opaque secret string or token when its base32 alphabet
and variable length fit; it supplies at least 128 bits of randomness.
Do not substitute it for UUIDs or tokens with a required format.
