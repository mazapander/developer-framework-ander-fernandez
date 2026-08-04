# Backend Supabase JWT module

Validates Supabase access tokens in FastAPI and exposes reusable authentication and authorization dependencies.

## Current verification strategy

1. Prefer local verification through the project's JWKS endpoint when Supabase uses asymmetric signing keys.
2. Validate signature, `iss`, `exp`, `sub` and the allowed algorithm; select the key by `kid`.
3. Cache public keys for a bounded period and refresh once when an unknown `kid` appears.
4. For legacy/shared-secret projects, use the Supabase Auth `/user` endpoint instead of embedding the legacy JWT secret in application code.
5. Authentication returns `401`; authenticated users lacking permission receive `403`.

## Generated structure

```text
app/
├── core/supabase_jwt.py
├── dependencies/auth.py
└── schemas/auth.py
```

## Rules

- Never trust claims decoded without signature verification.
- Never expose a Supabase secret/service-role key to React.
- Treat `role` and custom claims as inputs to authorization, not as unconditional database permissions.
- Make the authenticated principal a typed object.
- Keep user synchronization with the local database optional and separate from token verification.
- Add unit tests using dependency overrides and one integration test against a controlled Supabase project when appropriate.