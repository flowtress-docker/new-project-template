# Branch Lifecycle

How branches are born, live, and die in the scaffolding workflow.

## Phase 0 — Utility

### null
- **Purpose**: Empty branch. When developer wants to upload to a fresh branch, they DUPLICATE (not fork) null.
- **Created**: First, by `scaffold`. Always exists.
- **Contains**: Nothing. Completely empty commit.
- **Deleted**: Never. It's a utility.

### main
- **Purpose**: Development root. Lists all branches, links to docs, contains scaffold CLI scripts.
- **Created**: During `scaffold`. Base branch for the repo.
- **Contains**: README.md (placeholder), scaffold scripts (once built).
- **Deleted**: Never. It's the root.

---

## Phase 1 — Planning

### 01_rough-plan
- **Purpose**: Brainstorming space. Developer and agent chat about rough idea, MVP scope, future releases.
- **Created**: During `scaffold`. Starts empty.
- **Feeds**: 02_context (informational — not git fork).
- **Deleted**: Can be archived once context is finalized.

### 02_context
- **Purpose**: Precise scope setting. Uses resources from `flowtress-docker/context` for interviews, Q&A, skill gathering.
- **Created**: During `scaffold`. Starts empty.
- **Consumes**: 01_rough-plan content (manual transport).
- **Feeds**: 02_plan (informational).
- **Deleted**: Can be archived once plan is finalized.

### 02_plan
- **Purpose**: Detailed MVP plan. Demarcated into subfolders with `.md` + `.toml` + other agent-optimized formats.
- **Created**: During `scaffold`. Starts empty.
- **Consumes**: 02_context content (manual transport).
- **Feeds**: spec/* branches (manual transport — relevant bits only).
- **Deleted**: Can be archived once implementation begins.

---

## Phase 2 — Standards

### ui/impeccable
- **Purpose**: Local copy of UI standards from `pbakaus/impeccable`. Avoids webfetch/GH API calls during development.
- **Created**: During `scaffold`.
- **Source**: https://github.com/pbakaus/impeccable
- **Used by**: All impl/front-end_* branches (typography, color-scheme, components).
- **Deleted**: Never. It's a reference.

---

## Phase 3 — Specifications (all orphans)

### spec/* branches
- **Purpose**: Feature specifications. Define code behavior, branding, UX copy, anti-patterns. Visualize if needed for approval.
- **Created**: During `scaffold`. Starts empty (specs written later by agent).
- **Consumes**: Only relevant bits from 02_plan (manual transport).
- **Feeds**: impl/* branches (manual transport — spec informs implementation).
- **Key rule**: No implementation code on spec branches. Pure specification.

---

## Phase 4 — Implementation

### impl/front-end_tech-stack (orphan)
- **Purpose**: Confirm all npm packages and dependencies work together. Boilerplate that runs on localhost.
- **Created**: During `scaffold`. Minimal boilerplate seeded.
- **Feeds**: impl/front-end_typography (git fork).
- **Rule**: Agents should not customize this branch. It's a dependency-conflict resolution point.

### impl/front-end cascading fork chain
- **typography** ← fork of tech-stack. Strips boilerplate. Shows typography on localhost.
- **color-scheme** ← fork of typography. Strips boilerplate. Shows colors on localhost.
- **navbar** ← fork of color-scheme. Replaces content with navbar code.
- **footer** ← fork of navbar. Replaces content with footer code.
- **app-shell** ← fork of footer. Combines navbar+footer. This is the parent for most pages.
- **hero** ← fork of app-shell. Hero section.
- **homepage** ← fork of app-shell. Homepage.
- **Rule**: Each fork strips previous boilerplate and adds its own concern. ui/impeccable influences all.

### impl/back-end_* branches (all orphans)
- **tech-stack**: Confirm runtime and dependencies work.
- **api**: Back-end API. Standalone.
- **db**: Back-end database. Standalone.
- **Rule**: Back-end branches are independent orphans. No fork chain.

---

## Phase 5 — QA (examples, deletable)

### testing/*
- **Purpose**: Tests for a specific feature.
- **Created**: As needed. Example: `testing/front-end_navbar` (fork of impl/front-end_navbar).
- **Deleted**: After tests pass and are merged.

### staging/*
- **Purpose**: Integration staging. Merges multiple impl/ branches together.
- **Created**: As needed. Example: `staging/v1` (orphan).
- **Deleted**: After deployment.

### bug-fixes/*
- **Purpose**: Bug fixes for a specific feature.
- **Created**: As needed. Example: `bug-fixes/front-end_navbar-nav-fix` (fork of impl/front-end_navbar).
- **Deleted**: After fix is merged back.

### deployment/*
- **Purpose**: Production-ready code. Merges commits from bug-fixes/ + staging/.
- **Created**: During `scaffold`. Examples: `deployment/v1`, `deployment/v2` (orphans).
- **Deleted**: Never. Each version is a deployment artifact.

---

## Quasi-Dependencies

Some orphan branches have informational dependencies (not git parent-child):

```
01_rough-plan ──info──→ 02_context ──info──→ 02_plan ──info──→ spec/* ──info──→ impl/*
```

These are enforced by developer/agent discipline, not by git. The `scaffold` script creates all branches upfront so the developer can see the full topology and work in any order.
