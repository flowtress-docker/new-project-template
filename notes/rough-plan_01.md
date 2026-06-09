# Orchestration Architecture — Rough Plan 01

## 1. Model Tier Specification

| Role | Model | Capability | Constraint |
|------|-------|-----------|-----------|
| **Orchestrator** | MiniMax-M3 | 1M context, multimodal, frontier coding | Read-only only |
| **Sub-Orchestrator** | MiniMax-M3 | Same as orchestrator | Read-only only |
| **Worker Tier A** | MiniMax-M2.7 | Professional office delivery, character-rich interaction | Read+Write |
| **Worker Tier B** | MiniMax-M2.5 | Peak performance, master the complex | Read+Write |
| **Worker Tier C** | MiniMax-M2.1 | Polyglot code mastery, precision refactoring | Read+Write |
| **Worker Tier D** | MiniMax-M2 | Agentic capabilities, function calling | Read+Write |

## 2. Hybrid Routing Logic

### Fixed Rules (Task Type → Model)
- Code generation/reasoning → M2.7 (default)
- Complex refactoring → M2.5
- Legacy/code cleanup → M2.1
- Multi-file orchestration → M3 (orchestrator only)

### Dynamic Analysis (Criteria-based)
- Context length estimate → use M3 if >200k tokens
- Complexity score (files touched × dependencies) → M2.5 if >threshold
- Speed requirement → use highspeed variants
- Cost sensitivity → use M2.1/M2 for simple tasks

## 3. Log Structure

```
<project_root>/
├── main
├── .bare
├── <branch_worktrees>
└── sub-agent_logs/
    ├── 01_orchestrator/
    │   ├── decisions.yaml      # What M3 decided and why
    │   └── delegations/     # Each delegation record
    ├── 02_sub_orchestrator/
    │   ├── decisions.yaml
    │   └── delegations/
    └── workers/
        ├── m2.7/
        ├── m2.5/
        ├── m2.1/
        └── m2/
```

## 4. Interleaved Thinking Flow

```
Human → M3 (analyze + decide) → M3:delegate(task) → Worker(execute) → Worker:report
                                                            ↓
Human ← M3 (review + approve) ← M3:feedback ← Worker:result
```

## 5. Branch Topology Mapping

| Branch Pattern | Orchestration Role |
|---------------|--------------------|
| `01_*/` | Task intake, initial analysis |
| `02_*/` | Context gathering, delegation planning |
| `spec/*` | Task specs for workers |
| `impl/*` | Worker execution (forked or orphan) |
| `testing/*` | Worker output verification |
| `staging/*` | Integration verification |
| `deployment/*` | Final delivery |

## 6. Reference

- MiniMax Models: https://platform.minimax.io/docs/guides/models-intro.md
- Tool Use & Interleaved Thinking: https://platform.minimax.io/docs/guides/text-m3-function-call.md
- M2 Agent Generalization: https://platform.minimax.io/docs/guides/text-m2-agent-generalization.md