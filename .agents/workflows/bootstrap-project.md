# Bootstrap project workflow

1. Copy `AGENTS.md`, `.agents/`, `.codex/`, issue templates and PR template.
2. Replace placeholders in `.agents/project.yaml`.
3. Record real install, test, lint, build, migration and run commands.
4. Remove roles or workflows that do not apply.
5. Add project-specific boundaries and protected paths.
6. Validate the framework with `scripts/validate-agent-framework.sh`.
7. Commit the bootstrap separately from product changes.

The copied framework must describe the target repository as it exists, not the desired future architecture.
