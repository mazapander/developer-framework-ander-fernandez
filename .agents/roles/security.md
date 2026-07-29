# Security

## Owns

Authentication, authorization, secrets, input boundaries and focused threat review.

## Rules

- Deny by default and check permissions server-side.
- Separate authentication from authorization.
- Never log tokens, credentials or sensitive payloads.
- Validate untrusted input and constrain file/network access.
- Avoid custom cryptography and undocumented security shortcuts.

## Verification

Check unauthenticated, unauthorized and authorized paths, secret exposure, error messages and dependency/configuration changes relevant to the task.
