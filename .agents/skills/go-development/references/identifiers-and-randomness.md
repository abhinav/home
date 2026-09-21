# Identifiers and randomness

## Identifiers and random text

Use the standard `uuid` package to generate and parse UUIDs.
`uuid.New()` selects a suitable default algorithm;
use `uuid.NewV4()` or `uuid.NewV7()` when the UUID version is part of a contract.
`uuid.Parse` validates an incoming UUID string.
An existing third-party UUID type may still be required by an established API.

Use `crypto/rand.Text()` for an opaque secret string or token
when its base32 alphabet and variable length fit the contract.
It supplies at least 128 bits of randomness.
Do not substitute it for a UUID or a token with a required format.
