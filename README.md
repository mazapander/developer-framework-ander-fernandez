# Developer Framework — Ander Fernández

> A practical software development operating system for building faster with AI agents, reusable architecture, clear issues, controlled context, and small verifiable pull requests.

This repository documents how I work as a technical product/data/AI builder: from rough ideas to GitHub issues, from issues to agent-executed branches, from branches to reviewed pull requests, and from experiments to reusable software foundations.

It is not a theoretical framework. It is the result of iterating on real projects: analytics platforms, OCR pipelines, transcription tools, SaaS prototypes, internal automation, authenticated dashboards, and self-hosted services.

---

## Why this exists

I found myself starting several software projects with the same repeated needs:

- Authentication.
- Users.
- Roles and permissions.
- Admin panel.
- PostgreSQL.
- API layer.
- Docker.
- Reusable frontend layout.
- Clear development process.
- AI-assisted coding without losing control of the repository.

The problem was not only technical. The problem was operational.

AI coding tools are powerful, but without a system they tend to assume too much, over-engineer simple tasks, touch unrelated files, burn context and tokens, generate large diffs, and forget architectural decisions from one session to the next.

This repo is my answer to that.

---

## The core idea

```text
Rough idea
   ↓
Structured issue
   ↓
Small scoped task
   ↓
Agent reads AGENTS.md / CODEX.md
   ↓
Branch
   ↓
Minimal implementation
   ↓
Tests / verification
   ↓
Pull request
   ↓
Human review
   ↓
Merge
```

> Turn AI coding from a chaotic chat loop into a repeatable development workflow.

---

## My development principles

This framework is aligned with practical LLM coding guidelines: think before coding, keep solutions simple, make surgical changes, and define success criteria before implementation.

### 1. Think before coding

Before implementing anything non-trivial, the agent must explain:

- Objective understood.
- Assumptions.
- Ambiguities.
- Risks.
- Files it expects to touch.
- Criteria of acceptance.

No hidden guessing.

### 2. Simplicity first

The best solution is usually the smallest one that works.

Avoid premature abstractions, generic frameworks for one use case, unnecessary configuration, refactors mixed with features, and overbuilt APIs.

### 3. Surgical changes

Every changed line should map back to the issue.

Do not reformat unrelated files, improve adjacent code, rename things casually, delete old code unless the issue asks for it, or touch authentication/database/deployment unless required.

### 4. Goal-driven execution

Agents work better when they are given verifiable outcomes instead of vague commands.

Bad:

```text
Add validation.
```

Better:

```text
Add validation so that invalid invoice dates return 422.
Add tests for missing date, invalid format and future date.
```

---

## My default stack

### Backend

- Python.
- FastAPI.
- SQLAlchemy 2.x.
- Alembic.
- PostgreSQL.
- Pydantic Settings.
- Authlib / PyJWT for OIDC.
- Uvicorn.
- Pytest.

### Frontend

- React.
- Vite.
- TypeScript.
- React Router.
- TanStack Query.
- Tailwind CSS.
- shadcn/ui.
- React Hook Form.
- Zod.

### Auth

- OIDC-first.
- Azure Entra ID / Azure AD.
- Google.
- Keycloak.
- External OIDC providers.
- Internal user table separated from external identity.

### Admin

- SQLAdmin first.
- React Admin only when a richer backoffice is justified.

### Database

- PostgreSQL by default.
- SQLite only for local prototypes or analytical pipelines where it makes sense.
- Alembic from day one.
- Idempotent seeds.

### Infra

- Docker Compose.
- VPS deployments.
- Cloudflare / reverse proxy where useful.
- `.env.example` always updated.
- No secrets committed.

### AI workflow

- GitHub Issues as work units.
- Codex / Cursor / Claude Code / ChatGPT as execution assistants.
- Repomix / Gitingest for context optimization.
- AGENTS.md as the repo-level instruction layer.

---

## The reusable app starter

Most new apps I build need the same foundation:

```text
FastAPI
SQLAlchemy
PostgreSQL
Alembic
React
OIDC auth
Internal users
Roles and permissions
SQLAdmin
Audit log
Feature flags
Docker Compose
```

The starter architecture includes:

- `User`
- `ExternalIdentity`
- `Organization`
- `Membership`
- `Role`
- `Permission`
- `RolePermission`
- `UserRole`
- `AppProject`
- `AppSetting`
- `FeatureFlag`
- `AuditLog`

This means I do not need to re-explain the same base architecture every time I start a new product.

---

## How I use AI agents

AI agents should not be treated as magical senior engineers with infinite context. They should be treated as fast executors with strong guardrails.

The agent must always know:

- What the goal is.
- What not to touch.
- What files are relevant.
- What success means.
- How to verify the result.

Before coding, the agent should return:

```md
## Analysis before implementation

### Objective understood

### Assumptions

### Risks

### Minimal plan

### Files to touch

### Acceptance criteria
```

After coding, the agent should return:

```md
## Verification

- [ ] Backend tests
- [ ] Frontend build
- [ ] Migrations applied
- [ ] Docker compose checked
- [ ] Manual test
- [ ] Secrets reviewed
- [ ] Risks documented
```

---

## Token and context optimization

One of the biggest improvements in my workflow is not giving the full repo to the model unless necessary.

```text
Level 0: Issue + exact files
Level 1: Repo tree + relevant files
Level 2: Full module
Level 3: Compressed repo
Level 4: Full repo
```

Most tasks should happen at levels 0–2.

### Repomix

```bash
npx repomix@latest --compress
npx repomix@latest --token-count-tree 100
npx repomix@latest --include-diffs
npx repomix@latest --include "backend/app/**/*.py,frontend/src/**/*.tsx"
```

### Gitingest

```bash
pipx install gitingest
gitingest /path/to/repo
gitingest https://github.com/user/repo
```

---

## Repository structure

```text
.
├── README.md
├── AGENTS.md
├── CODEX.md
├── repomix.config.json
├── docs/
├── agents/
├── skills/
├── templates/
└── .github/
```

---

## My learning process

This methodology comes from learning by building, not from reading a single playbook.

### 1. Build small things manually

I started by building small tools and prototypes directly: React apps, Flask/FastAPI backends, scripts, scrapers, dashboards and Docker Compose stacks.

### 2. Repeat the same foundations too many times

Authentication, users, admin screens, database setup, deployments and environment variables kept appearing again and again. That repetition showed that the bottleneck was not coding. The bottleneck was lack of reusable structure.

### 3. Move from “asking for code” to “designing issues”

The biggest shift was realizing that AI tools work better when the task is shaped properly.

Instead of asking:

```text
Build this feature.
```

I moved toward:

```text
Here is the objective, context, constraints, files, acceptance criteria and verification checklist.
```

### 4. Create reusable agent instructions

`AGENTS.md`, `CODEX.md`, `CLAUDE.md` and Cursor rules became a way to avoid re-explaining how I want software to be built.

### 5. Optimize context

Repomix, Gitingest, diffs, file selection and token counting make the workflow more controlled.

### 6. Productize the workflow

The final step is turning the methodology itself into a reusable asset: for my own projects, for collaborators, for public visibility, and for explaining how I build software with AI.

---

## Recommended workflow

```text
Idea in rough notes
   ↓
Convert to GitHub issue
   ↓
Define acceptance criteria
   ↓
Assign agent / skill
   ↓
Implement in branch
   ↓
Open PR
```

---

## Status

This is a living framework. It will evolve as I keep building real software projects and refining the way I work with AI-assisted development.

---

## Author

**Ander Fernández**  
Technical Product / Data / AI / Software Builder

GitHub: `@mazapander`
