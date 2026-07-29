# Codex adapter

This folder provides Codex-specific entry points without duplicating the repository rules.

Codex should always read `AGENTS.md` first. Then it may load `.agents/project.yaml`, one role and one workflow according to the task.

## Recommended invocation

```text
Read AGENTS.md.
Read .agents/project.yaml.
Use the backend role from .agents/roles/backend.md.
Follow .agents/workflows/feature.md.
Implement issue #123 with surgical changes and show verification evidence.
```

## Important

- `.codex/` is an adapter, not the source of truth.
- Do not assume every Codex client automatically loads files in this directory.
- Keep reusable logic in `.agents/`; keep only Codex-oriented prompts and examples here.
