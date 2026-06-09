# Conventions — scaffold_2

## Tool Preferences

Write (create), Edit (modify), Grep (search), Glob (find), Read (read), Bash (git/script).

No cat/head/tail. No bash grep. No echo/heredoc for file creation.

## Anti-Patterns

- No project code in template
- No git worktree creation by agents
- No embedded secrets
- No interactive scripts
- Keep READMEs concise
- No over-engineering

## Branch Naming

- null: empty duplication source
- 01_rough-plan / 02_context / 02_plan: orphan planning phases
- ui/: orphan standards
- spec/: orphan specs
- testing/: fork of spec/*
- impl/: orphan (tech-stack, app-shell) or fork of app-shell
- staging/: fork of app-shell
- bug-fixes/: fork of impl/* or staging/*
- deployment/: orphan

## Script Conventions

- bash, set -euo pipefail
- Explicit paths: every worktree path prefixed with `<project-name>_root/`
- Idempotent: exit 1 if .bare exists
- Exit 0 success, 1 error

## Developer Discretion (NOT scaffold_2 functions)

- Orphan/fork decisions at runtime
- Testing loop is developer-driven
- App-shell merge order is developer choice
- Back-end merges to staging when developer decides