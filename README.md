# Prompt Index

Agent-optimized prompt for building the `scaffold` CLI tool — a globally-installable command that creates a project scaffolding with 31 branches in one shot.

Uses the **Adversarial Agent Pattern** (Executor + Verifier).

## Directory Structure

```
starting-prompt/
├── README.md                 # this file
├── adversarial.toml          # orchestrator: Implementer + Reviewer dual-agent prompt
├── plan/                     # HOW — agent-actionable implementation plan
│   ├── README.md
│   ├── topology.toml         # 31 branches: orphans, fork chains, naming
│   ├── execution.toml        # 6-phase creation order with 34 operations
│   ├── verification.toml     # 28 checks for branch integrity
│   └── conventions.toml      # naming rules, anti-patterns, script safety
├── docs/                     # WHY — human-readable documentation
│   ├── README.md
│   ├── workflow.toml         # full scaffolding workflow spec
│   └── branch-lifecycle.md   # what each branch type means and when to use it
└── spec/                     # WHAT — formal CLI tool specification
    ├── README.md
    ├── cli-interface.toml    # scaffold command contract
    ├── directory-scaffold.toml # folder/file output per branch type
    └── seed-templates.toml   # minimal starter file content
```

## Load Order for Agents

```
1. adversarial.toml          → understand the dual-agent pattern
2. spec/cli-interface.toml   → what scaffold must do
3. plan/topology.toml        → exact branch names and relationships
4. plan/execution.toml       → creation order and operations
5. spec/directory-scaffold.toml → what goes where
6. spec/seed-templates.toml  → file contents to seed
7. plan/verification.toml    → acceptance criteria
8. plan/conventions.toml     → rules throughout
```

## Quick Summary

**Command**: `scaffold <project-name>` (globally installed)

**Output**: `<project-name>_root/` with `.bare` + 31 branch worktrees

**Branches**: 1 null, 22 orphans, 8 forks across 6 phases

**Success**: Reviewer approves. All 28 verification checks pass. Script exits 0.
