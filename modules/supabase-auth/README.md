# Module: Supabase Auth

Use this module when a React/Vite application needs the standard email-and-password login backed by Supabase Auth.

## Standard user experience

Every project should start from the same normalized flow unless the product explicitly requires another design:

- `/login`: email, password, remember email, forgot-password link and generic authentication errors.
- `/forgot-password`: email field and enumeration-safe confirmation message.
- `/reset-password`: new password, confirmation and recovery-session update.
- Session persistence is delegated to Supabase.
- The checkbox remembers only the normalized email address. Passwords are never stored by the application.
- Components use the existing router, design system and aliases when present; templates are a behavioral baseline, not permission to duplicate UI foundations.

## Current conventions

- Use `@supabase/supabase-js`.
- Browser configuration uses `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY`.
- Never expose a secret key or service-role key in frontend code.
- Keep one client in `src/lib/supabase.ts` instead of creating clients inside components.
- Normalize email with `trim().toLowerCase()` before submitting.
- Use `signInWithPassword`, `resetPasswordForEmail` and `updateUser`.
- Treat authentication and authorization separately: Supabase Auth establishes identity; Row Level Security and application roles enforce access.
- Backend authorization must validate the JWT and its issuer/signature rather than trusting frontend state.
- Configure redirect URLs and email templates explicitly for local, staging and production environments.

## Application sequence

1. Detect package manager, router, frontend root, styling and existing auth.
2. Refuse automatic replacement when another auth provider already exists.
3. Install `@supabase/supabase-js` using the existing package manager.
4. Merge environment variable names into `.env.example` without values.
5. Add or reuse the singleton client.
6. Adapt the three standard screens to the existing component system.
7. Register `/login`, `/forgot-password` and `/reset-password`.
8. Add a session provider and protected-route boundary when authenticated routes exist.
9. Validate JWTs independently in FastAPI when the backend protects endpoints.
10. Add RLS policies for tables accessed directly from the browser.
11. Test login, logout, remembered email, recovery, expired session, unauthorized access and redirects.

## Definition of done

- Password is never persisted outside the browser password manager/Supabase session mechanisms.
- Recovery gives the same visible response for known and unknown email addresses.
- Loading, disabled, success and error states exist.
- Inputs include correct `autocomplete` values.
- Redirect URLs are documented per environment.
- Frontend build and authentication tests pass.

## Do not automate blindly

- Creating a Supabase project.
- Changing production redirect URLs.
- Adding service-role credentials.
- Replacing an existing auth provider.
- Generating permissive RLS policies.

These require explicit project decisions.
