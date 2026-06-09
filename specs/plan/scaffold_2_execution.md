# Execution — scaffold_2

scaffold_2 creates 31 branches upfront. Explicit paths throughout.

## Phase 0 — Preflight

Validate name, check dir, verify git, init bare.

## Phase 1 — Utility

null (orphan, empty) + main (orphan, README).

## Phase 2 — Planning

01_rough-plan, 02_context, 02_plan — all orphans.

## Phase 3 — Standards

ui/impeccable — orphan.

## Phase 4 — Specs

9 spec/* orphans. Each gets README.md + spec/ dir.

## Phase 5 — Testing

8 testing/* branches. Each forks from corresponding spec/*.

## Phase 6 — Implementation

- impl/front-end_tech-stack — orphan
- impl/front-end_app-shell — orphan (merge target)
- 6 impl/* forks of app-shell
- impl/back-end_tech-stack — orphan

## Phase 7 — QA

staging/v1 (fork of app-shell) + bug-fixes + deployment/v1 + v2.

## Key Rule

All worktree paths use explicit `<project-name>_root/` prefix. No implicit cwd.