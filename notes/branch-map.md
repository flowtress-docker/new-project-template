# Branch Map — scaffold_2

## Core Flow (per feature)

```
spec/<feature> ──fork──→ testing/<feature> ──merge──→ impl/<feature>
impl/<feature> is a fork of impl/front-end_app-shell
impl/<feature> ──merge──→ staging/v1
```

**Minor feature path:** `impl/<feature>` → `staging/v1` directly. No testing branch.

## Branch Types

| Prefix | Type | Purpose |
|--------|------|---------|
| `01_rough-plan` | orphan | Brainstorming: rough idea, MVP scope, future releases |
| `02_context` | orphan | Precise scope setting using flowtress-docker/context |
| `02_plan` | orphan | Detailed MVP plan demarcated in subfolders with .md + .toml |
| `ui/impeccable` | orphan | UI standards and anti-patterns (pbakaus/impeccable) |
| `spec/*` | orphan | Feature specifications: behavior, branding, UX copy, anti-patterns |
| `impl/*` | fork or orphan | Minimal implementation of specs |
| `testing/*` | fork | Spec-driven TDD: fork of spec, merged into impl |
| `staging/*` | fork | Integration staging: fork of impl/app-shell, merges from impl/* |
| `bug-fixes/*` | fork | Bug fixes: fork of impl or staging |
| `deployment/*` | orphan | Production-ready: merges from staging + bug-fixes |

## Complete Topology

```mermaid
flowchart TB
    subgraph planning["PLANNING (orphans)"]
        rp["01_rough-plan"]
        ctx["02_context"]
        pl["02_plan"]
    end

    subgraph standards["STANDARDS (orphan)"]
        ui["ui/impeccable"]
    end

    subgraph specs["SPECS (orphans)"]
        sFEts["spec/front-end_tech-stack"]
        sFEty["spec/front-end_typography"]
        sFEcs["spec/front-end_color-scheme"]
        sFEnav["spec/front-end_navbar"]
        sFEfoot["spec/front-end_footer"]
        sFEapp["spec/front-end_app-shell"]
        sFEhero["spec/front-end_hero"]
        sFEhome["spec/front-end_homepage"]
        sBEts["spec/back-end_tech-stack"]
    end

    subgraph testing["TESTING (forks of spec)"]
        tFEty["testing/front-end_typography"]
        tFEcs["testing/front-end_color-scheme"]
        tFEnav["testing/front-end_navbar"]
        tFEfoot["testing/front-end_footer"]
        tFEapp["testing/front-end_app-shell"]
        tFEhero["testing/front-end_hero"]
        tFEhome["testing/front-end_homepage"]
        tBEts["testing/back-end_tech-stack"]
    end

    subgraph impl["IMPLEMENTATION"]
        iFEts["impl/front-end_tech-stack"]
        iFEty["impl/front-end_typography"]
        iFEcs["impl/front-end_color-scheme"]
        iFEnav["impl/front-end_navbar"]
        iFEfoot["impl/front-end_footer"]
        iFEapp["impl/front-end_app-shell"]
        iFEhero["impl/front-end_hero"]
        iFEhome["impl/front-end_homepage"]
        iBEts["impl/back-end_tech-stack"]
    end

    subgraph qa["QA"]
        stg["staging/v1"]
        bf["bug-fixes/front-end_navbar-nav-fix"]
        d1["deployment/v1"]
        d2["deployment/v2"]
    end

    %% Planning quasi-deps
    rp -->|"quasi-dep"| ctx
    ctx -->|"quasi-dep"| pl
    pl -->|"quasi-dep"| sFEts
    pl -->|"quasi-dep"| sFEty
    pl -->|"quasi-dep"| sFEcs
    pl -->|"quasi-dep"| sFEnav
    pl -->|"quasi-dep"| sFEfoot
    pl -->|"quasi-dep"| sFEapp
    pl -->|"quasi-dep"| sFEhero
    pl -->|"quasi-dep"| sFEhome
    pl -->|"quasi-dep"| sBEts

    %% UI influence on impl
    ui -.->|"influences"| iFEty
    ui -.->|"influences"| iFEcs
    ui -.->|"influences"| iFEnav
    ui -.->|"influences"| iFEfoot

    %% Spec → Testing
    sFEty -->|"fork"| tFEty
    sFEcs -->|"fork"| tFEcs
    sFEnav -->|"fork"| tFEnav
    sFEfoot -->|"fork"| tFEfoot
    sFEapp -->|"fork"| tFEapp
    sFEhero -->|"fork"| tFEhero
    sFEhome -->|"fork"| tFEhome
    sBEts -->|"fork"| tBEts

    %% Testing → Impl (testing loop)
    tFEty -->|"merge"| iFEty
    tFEcs -->|"merge"| iFEcs
    tFEnav -->|"merge"| iFEnav
    tFEfoot -->|"merge"| iFEfoot
    tFEapp -->|"merge"| iFEapp
    tFEhero -->|"merge"| iFEhero
    tFEhome -->|"merge"| iFEhome
    tBEts -->|"merge"| iBEts

    %% Most impl branches fork from app-shell
    iFEapp -->|"fork"| iFEty
    iFEapp -->|"fork"| iFEcs
    iFEapp -->|"fork"| iFEnav
    iFEapp -->|"fork"| iFEfoot
    iFEapp -->|"fork"| iFEhero
    iFEapp -->|"fork"| iFEhome

    %% Navbar + footer merge into app-shell
    iFEnav -->|"merge"| iFEapp
    iFEfoot -->|"merge"| iFEapp

    %% Staging from app-shell
    iFEapp -->|"fork"| stg

    %% Impl merges to staging
    iFEty -->|"merge"| stg
    iFEcs -->|"merge"| stg
    iFEhero -->|"merge"| stg
    iFEhome -->|"merge"| stg
    iBEts -->|"merge"| stg

    %% Bug-fixes and deployment
    stg -->|"fork"| bf
    iFEnav -->|"fork"| bf
    stg -->|"merge"| d1
    bf -->|"merge"| d1
```

## App-Shell Special Case

```
spec/front-end_app-shell ──fork──→ testing/front-end_app-shell
testing/front-end_app-shell ──merge──→ impl/front-end_app-shell
impl/front-end_navbar ──merge──→ impl/front-end_app-shell
impl/front-end_footer ──merge──→ impl/front-end_app-shell
impl/front-end_app-shell ──fork──→ impl/front-end_hero
impl/front-end_app-shell ──fork──→ impl/front-end_homepage
```

App-shell testing loop starts **after** navbar + footer are merged.

## Orphan Branches

| Branch | Reason |
|--------|--------|
| `01_rough-plan` | Planning |
| `02_context` | Planning |
| `02_plan` | Planning |
| `ui/impeccable` | Standards reference |
| `spec/*` (all 9) | Specifications |
| `impl/front-end_tech-stack` | Dependency resolution only, no fork parent |
| `impl/back-end_tech-stack` | Backend boilerplate, no fork parent |
| `impl/front-end_app-shell` | Merge target, no fork parent |
| `deployment/*` (all) | Deployment artifacts |

## Fork Relationships

| Branch | Parent | Reason |
|--------|--------|--------|
| `testing/*` | `spec/*` | Spec-driven TDD |
| `impl/front-end_typography` | `impl/front-end_app-shell` | Fork of app-shell |
| `impl/front-end_color-scheme` | `impl/front-end_app-shell` | Fork of app-shell |
| `impl/front-end_navbar` | `impl/front-end_app-shell` | Fork of app-shell |
| `impl/front-end_footer` | `impl/front-end_app-shell` | Fork of app-shell |
| `impl/front-end_hero` | `impl/front-end_app-shell` | Fork of app-shell |
| `impl/front-end_homepage` | `impl/front-end_app-shell` | Fork of app-shell |
| `staging/v1` | `impl/front-end_app-shell` | Integration staging base |
| `bug-fixes/*` | `impl/*` or `staging/*` | Bug fix isolation |

## Key Decisions (Context for scaffold_2 Logic)

These decisions guide scaffold_2 logic but are NOT functions in the code. They inform branch creation topology, not runtime behavior.

1. **Most impl branches fork from app-shell** — provides a clean ground for minimal implementations. Each impl branch inherits the app-shell base without inheriting other impl branch history.

2. **Testing forks from spec, merges into impl** — spec-driven TDD. Testing branch is the proving ground. When approved, it merges into the impl branch (which is a fork of app-shell).

3. **App-shell is the merge target for navbar + footer** — impl/front-end_navbar and impl/front-end_footer merge into impl/front-end_app-shell. App-shell is the composite result.

4. **App-shell testing loop starts after navbar + footer merge** — the app-shell spec is written first, but the testing loop for app-shell only begins once navbar and footer components are finalized and merged.

5. **Staging forks from app-shell** — staging/v1 is a fork of app-shell, not a merge result. This gives staging its own history to receive merges from other impl branches.

6. **Back-end merges into front-end staging** — `impl/back-end_tech-stack` merges into `staging/v1` to verify front-end + back-end integration.

7. **Minor features skip testing loop** — simple, non-error-prone features go impl → staging directly.

8. **Orphan/fork decisions are developer discretion** — scaffold_2 creates the branch topology. The developer decides at runtime which branches to fork, merge, or skip. This document captures the intended logic, not enforcement rules.