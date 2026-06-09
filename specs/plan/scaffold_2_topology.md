# Topology — scaffold_2

scaffold_2 creates 31 branches: 20 orphans, 11 forks.

## Branch Phases

| Phase | Name | Branches |
|-------|------|---------|
| 0 | Utility | null, main |
| 1 | Planning | 01_rough-plan, 02_context, 02_plan |
| 2 | Standards | ui/impeccable |
| 3 | Specs | 9 spec/* orphans |
| 4 | Testing | 8 testing/* forks (of spec) |
| 5 | Implementation | 3 orphans + 6 forks + 1 orphan (app-shell) |
| 6 | QA | staging/v1, bug-fixes, deployment/v1, v2 |

## Orphan Branches (20)

null, main, 01_rough-plan, 02_context, 02_plan, ui/impeccable, spec/* (9), impl/front-end_tech-stack, impl/front-end_app-shell, impl/back-end_tech-stack, deployment/v1, deployment/v2.

## Fork Branches (11)

testing/* (8): each forks from corresponding spec/*.

impl/front-end_typography, impl/front-end_color-scheme, impl/front-end_navbar, impl/front-end_footer, impl/front-end_hero, impl/front-end_homepage (6): each forks from impl/front-end_app-shell.

staging/v1: forks from impl/front-end_app-shell.

bug-fixes/front-end_navbar-nav-fix: forks from impl/front-end_navbar.

## Core Flow (per feature)

```
spec/<feature> ──fork──→ testing/<feature> ──merge──→ impl/<feature>
impl/<feature> is a fork of impl/front-end_app-shell
impl/<feature> ──merge──→ staging/v1
```

## App-Shell Special Case

impl/front-end_app-shell is orphan. impl/front-end_navbar and impl/front-end_footer merge into it. staging/v1 forks from it. Most impl/* branches fork from it.

## Back-End

impl/back-end_tech-stack is orphan. testing/back-end_tech-stack forks from spec/back-end_tech-stack. impl/back-end_tech-stack merges to staging/v1 for integration.

## Key Rule

Most impl/* branches fork from impl/front-end_app-shell. tech-stack branches (front-end and back-end) and app-shell itself are orphans.