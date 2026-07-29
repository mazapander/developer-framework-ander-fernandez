# Module: Supabase Auth

Use this module when a React/Vite application needs Supabase authentication.

## Current conventions

- Use `@supabase/supabase-js`.
- Browser configuration uses `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY`.
- Never expose a secret key or service-role key in frontend code.
- Keep one client in `src/lib/supabase.ts` instead of creating clients inside components.
- Treat authentication and authorization separately: Supabase Auth establishes identity; Row Level Security and application roles enforce access.
- Prefer `getClaims()` or verified session claims for local UI state. Backend authorization must validate the JWT and its issuer/signature rather than trusting frontend state.
- Configure redirect URLs and email templates explicitly for local, staging and production environments.

## Application sequence

1. Detect package manager and frontend root.
2. Install `@supabase/supabase-js` using the existing package manager.
3. Merge the environment variable names into `.env.example` without adding values.
4. Add the singleton client.
5. Add the requested login method only: password, magic link/OTP, OAuth or SSO.
6. Add a session provider only when several routes/components need auth state.
7. Protect backend endpoints independently.
8. Add RLS policies for tables accessed directly from the browser.
9. Test login, logout, expired session, unauthorized access and redirect behavior.

## Do not automate blindly

- Creating a Supabase project.
- Changing production redirect URLs.
- Adding service-role credentials.
- Replacing an existing auth provider.
- Generating permissive RLS policies.

These require explicit project decisions.