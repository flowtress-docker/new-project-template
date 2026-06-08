# Prompt Index

Agent-optimized prompt for implementing a **Recurring Dev Repo Branch Topology Template**.

Uses the **Adversarial Agent Pattern** (Executor + Verifier) from `flowtress-docker/context`.

## Files

| File | Purpose | Load First? |
|------|---------|-------------|
| [adversarial.toml](./adversarial.toml) | **Orchestrator prompt**: spawns two adversarial agents (Implementer + Reviewer) with iteration protocol. | **Yes** |
| [task.toml](./task.toml) | Core task definition, classification, scope, goal | Yes |
| [topology.toml](./topology.toml) | Full branch topology spec: fork graph, naming conventions, directory scaffold per branch type | Yes |
| [execution.toml](./execution.toml) | Ordered execution phases (A→D) with individual step details and dependencies | After context |
| [context.toml](./context.toml) | Preflight context acquisition: what to search/read/verify before starting | First action |
| [checkpoints.toml](./checkpoints.toml) | Checkpoint markers with expected output format for each phase | During execution |
| [verification.toml](./verification.toml) | Test commands, expected outputs, and acceptance criteria | Before completion |
| [conventions.toml](./conventions.toml) | Tool preferences, anti-patterns, branch naming rules, commit style | Throughout |

## Execution Order

```
# 1. Orchestrator reads adversarial.toml
#    → Spawns Implementer + Reviewer as parallel agents

# 2. Both agents load shared context
context.toml → run preflight ops in PARALLEL

# 3. Both agents load the spec
task.toml + topology.toml → understand what to build

# 4. Adversarial iteration begins
Implementer → Phase A work → Reviewer audits → feedback loop → approve
Implementer → Phase B work → Reviewer audits → feedback loop → approve
Implementer → Phase C work → Reviewer audits → feedback loop → approve
Implementer → Phase D work → Reviewer audits → feedback loop → approve

# 5. Final verification
verification.toml → all V.1–V.10 checks pass → Reviewer issues final approval
```

## Adversarial Pattern

```
┌──────────────┐         ┌──────────────┐
│  Implementer  │ ──draft─→│   Reviewer   │
│  (Executor)   │←─review──│  (Verifier)  │
└──────────────┘         └──────────────┘
                              │
                         Iterate until
                         all issues resolved
                              │
                              ▼
                         APPROVED
```

- **Max rounds**: 3 per phase
- **Severity levels**: CRITICAL (blocking), MAJOR (must fix), MINOR (optional)
- **Completion**: Reviewer must approve before declaring done

## Quick Summary

**What**: GitHub template repo with a bootstrap script that creates a recurring branch topology.

**Branch Chain**: `main → context → /plan/* → /spec/* → impl/*`

**Pattern**: Adversarial (Executor + Verifier) — Implementer builds, Reviewer challenges.

**Success**: Reviewer approves. All V.1–V.10 checks pass. `./scripts/verify-topology.sh` exits 0.

**Format**: All config files are TOML for agent parsimony.
