# .agents

Reusable, tool-agnostic operating layer for AI-assisted development.

`AGENTS.md` remains the repository contract and source of truth. This directory contains the role definitions, workflows and project defaults that agents can load for a specific task.

## Structure

```text
.agents/
├── registry.yaml          # discoverable catalogue
├── project.yaml           # defaults copied and adapted per project
├── roles/                 # specialist operating profiles
└── workflows/             # repeatable multi-step procedures
```

## Loading order

1. Read the nearest `AGENTS.md` from repository root to the working directory.
2. Read `.agents/project.yaml` for project-specific defaults.
3. Select one primary role from `.agents/registry.yaml`.
4. Load one workflow only when the task requires it.
5. Read the minimum relevant source files and tests.

## Design rules

- Roles define responsibility and decision boundaries, not fictional personalities.
- Workflows define repeatable procedures and verification gates.
- Project-specific facts belong in `project.yaml`, not in reusable role files.
- Tool-specific adapters such as `.codex/` must reference this layer rather than duplicate it.
- An agent may consult other roles, but one role owns the final implementation.
