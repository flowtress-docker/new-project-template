# Branch Topology — scaffold_2

```mermaid
git-branchDiagram
    direction TB

    %% Phase 0 — Utility
    group Phase_0__Utility[Phase 0 — Utility]
        main[main]
        null[null]
    end group

    %% Phase 1 — Planning
    group Phase_1__Planning[Phase 1 — Planning]
        p01_rough[01_rough-plan]
        p02_context[02_context]
        p02_plan[02_plan]
    end group

    %% Phase 2 — Standards
    group Phase_2__Standards[Phase 2 — Standards]
        ui_impeccable[ui/impeccable]
    end group

    %% Phase 3 — Specs
    group Phase_3__Specs[Phase 3 — Specs (orphan)]
        s_fe_tech[spec/front-end_tech-stack]
        s_be_tech[spec/back-end_tech-stack]
        s_fe_typ[spec/front-end_typography]
        s_fe_color[spec/front-end_color-scheme]
        s_fe_nav[spec/front-end_navbar]
        s_fe_foot[spec/front-end_footer]
        s_fe_shell[spec/front-end_app-shell]
        s_fe_hero[spec/front-end_hero]
        s_fe_home[spec/front-end_homepage]
    end group

    %% Phase 4 — Testing
    group Phase_4__Testing[Phase 4 — Testing (fork of spec)]
        t_fe_typ{{"testing/front-end_typography<br/><i>fork of spec/front-end_typography</i>"}}
        t_fe_color{{"testing/front-end_color-scheme<br/><i>fork of spec/front-end_color-scheme</i>"}}
        t_fe_nav{{"testing/front-end_navbar<br/><i>fork of spec/front-end_navbar</i>"}}
        t_fe_foot{{"testing/front-end_footer<br/><i>fork of spec/front-end_footer</i>"}}
        t_fe_shell{{"testing/front-end_app-shell<br/><i>fork of spec/front-end_app-shell</i>"}}
        t_fe_hero{{"testing/front-end_hero<br/><i>fork of spec/front-end_hero</i>"}}
        t_fe_home{{"testing/front-end_homepage<br/><i>fork of spec/front-end_homepage</i>"}}
        t_be_tech{{"testing/back-end_tech-stack<br/><i>fork of spec/back-end_tech-stack</i>"}}
    end group

    %% Phase 5 — Implementation
    group Phase_5__Impl[Phase 5 — Implementation]
        i_fe_tech[impl/front-end_tech-stack]
        i_be_tech[impl/back-end_tech-stack]
        i_fe_shell[impl/front-end_app-shell]
        i_fe_typ{{"impl/front-end_typography<br/><i>fork of impl/front-end_app-shell</i>"}}
        i_fe_color{{"impl/front-end_color-scheme<br/><i>fork of impl/front-end_app-shell</i>"}}
        i_fe_nav{{"impl/front-end_navbar<br/><i>fork of impl/front-end_app-shell</i>"}}
        i_fe_foot{{"impl/front-end_footer<br/><i>fork of impl/front-end_app-shell</i>"}}
        i_fe_hero{{"impl/front-end_hero<br/><i>fork of impl/front-end_app-shell</i>"}}
        i_fe_home{{"impl/front-end_homepage<br/><i>fork of impl/front-end_app-shell</i>"}}
    end group

    %% Phase 7 — QA
    group Phase_7__QA[Phase 7 — QA]
        stg_v1{{"staging/v1<br/><i>fork of impl/front-end_app-shell</i>"}}
        bf_nav{{"bug-fixes/front-end_navbar-nav-fix<br/><i>fork of impl/front-end_navbar</i>"}}
        dep_v1[deployment/v1]
        dep_v2[deployment/v2]
    end group

    %% Fork relationships (solid — git inheritance)
    s_fe_typ --> t_fe_typ
    s_fe_color --> t_fe_color
    s_fe_nav --> t_fe_nav
    s_fe_foot --> t_fe_foot
    s_fe_shell --> t_fe_shell
    s_fe_hero --> t_fe_hero
    s_fe_home --> t_fe_home
    s_be_tech --> t_be_tech

    i_fe_shell --> i_fe_typ
    i_fe_shell --> i_fe_color
    i_fe_shell --> i_fe_nav
    i_fe_shell --> i_fe_foot
    i_fe_shell --> i_fe_hero
    i_fe_shell --> i_fe_home

    i_fe_shell --> stg_v1
    i_fe_nav --> bf_nav

    %% Quasi-dependencies (dashed — informational flow)
    p01_rough -.-> p02_context
    p02_context -.-> p02_plan
    p02_plan -.-> s_fe_tech
    p02_plan -.-> s_be_tech
    p02_plan -.-> s_fe_typ
    p02_plan -.-> s_fe_color
    p02_plan -.-> s_fe_nav
    p02_plan -.-> s_fe_foot
    p02_plan -.-> s_fe_shell
    p02_plan -.-> s_fe_hero
    p02_plan -.-> s_fe_home

    ui_impeccable -.-> i_fe_tech
    ui_impeccable -.-> i_fe_typ
    ui_impeccable -.-> i_fe_color
    ui_impeccable -.-> i_fe_nav
    ui_impeccable -.-> i_fe_foot
    ui_impeccable -.-> i_fe_shell
    ui_impeccable -.-> i_fe_hero
    ui_impeccable -.-> i_fe_home

    stg_v1 -.-> dep_v1

    %% Legend
    legend
        shape branch(1,plain)[orphan branch]
        shape fork(1,stroke:#8B0000,stroke-width:2px)[fork branch]
        direction LR
        _:phantom[___phantom___]
        ====:solid line[fork parent → child]
        -.-:dashed line[quasi-dependency info flow]
    end legend
```

## Branch Counts

| Phase | Count | Type |
|-------|-------|------|
| Phase 0 — Utility | 2 | orphan |
| Phase 1 — Planning | 3 | orphan |
| Phase 2 — Standards | 1 | orphan |
| Phase 3 — Specs | 9 | orphan |
| Phase 4 — Testing | 8 | fork |
| Phase 5 — Implementation | 9 | 3 orphan + 6 fork |
| Phase 7 — QA | 4 | 2 orphan + 2 fork |
| **Total** | **36** | |

## Notes

- **Orphan branches** (rectangle): created from `null` or no parent — stand alone.
- **Fork branches** (rounded rectangle with red border): inherit from a parent branch via `git fork` or equivalent.
- **Solid arrows**: actual git fork relationships (parent → child).
- **Dashed arrows**: quasi-dependencies (informational flow only, not git inheritance).