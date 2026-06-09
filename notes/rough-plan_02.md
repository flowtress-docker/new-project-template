# Rough Plan 02 — Subagent Orchestration Patterns (Refined)

## 1. Procedure Standard (User-Invoked, Not Scaffolded)

Three reusable templates the user copies verbatim per session. No scaffolding needed.

### plan/
```
1. /cavecrew investigators fan out (parallel) → site list
2. M3 plans delegation (read-only, sees all sites)
3. Send sub-agent swarms with /cavecrew and /review skills to execute
   on task and report using /herdr multiplexing for this WORKSPACE
4. Be the orchestrator
5. If a sub-agent needs thinking, do NOT provide thinking models like M3
6. Do not do any non-executive tasks — make sub-agents work for you
7. Review
8. Report
```

### implement/
```
1. Send sub-agent swarms with /cavecrew and /review skills to execute
   on task and report using /herdr multiplexing for this WORKSPACE
2. Be the orchestrator
3. Do not implement anything — make sub-agents work for you
4. Review
5. Report
```

### debug/
```
1. Send sub-agent swarms with /cavecrew, /review, and /systematic-debugging
   skills to execute on task and report using /herdr multiplexing for
   this WORKSPACE
2. Be the orchestrator
3. Do not implement anything — make sub-agents work for you
4. Review
5. Report
```

## 2. Agent Modes (Refined)

| Mode | Allowed In | Tools |
|------|-----------|-------|
| `plan` | M3 only | read, glob, grep, list, webfetch |
| `delegate` | M3 sub-orchestrator | read, glob, grep, list, webfetch, +delegate_to_worker |
| `build` | M2.x workers | full read+write+bash+edit |

M3 has **both** `plan` and `delegate` modes — no `build` (architect pattern from Aider).

## 3. M3 as Commit Gatekeeper

```
Worker M2.x → writes files → reports diff → M3 reviews → M3 commits
```

- Workers never commit
- M3 sees every diff before it lands in history
- Matches Aider ArchitectCoder → EditCoder handoff

## 4. A2A Context Passing (Adopted from Aider ArchitectCoder)

Aider's ArchitectCoder sends only relevant code snippets to the edit coder — full context is not transmitted. M3 mirrors this:

- **Worker context per task** = spec file + relevant file:line snippets + the worker's prior output (if iterating)
- **Full repo context** = stays with M3 orchestrator only
- **Spec files in `spec/*` branches** = the contract between M3 and worker (read by both)

## 5. Model Tier Routing (Refined from Plan 01)

| Worker Model | Mode | Use |
|--------------|------|-----|
| MiniMax-M3 | `plan` + `delegate` only | All orchestration, never writes |
| MiniMax-M2.7 | `build` | Default code generation |
| MiniMax-M2.5 | `build` | Complex refactor (5+ files) |
| MiniMax-M2.1 | `build` | Surgical edit (≤2 files) |
| MiniMax-M2 | `build` | Lightweight, function-calling heavy |

**Anti-rule:** Workers that need deep reasoning → M2.5 (not M3). M3 is reserved for orchestrators only.

## 6. Tool Stack Per Task

| Task | Tools Used |
|------|-----------|
| Investigation | `/cavecrew-investigator` (1-3 in parallel) |
| Edit | `/cavecrew-builder` (≤2 files) |
| Review | `/cavecrew-reviewer` |
| Debug | + `/systematic-debugging` |
| Multiplexing | `/herdr` (tab orchestration) |

## 7. Branch Topology Usage (No Auto-Trigger)

- `01_rough-plan/` — M3 intake (plan mode)
- `02_context/` — M3 delegation planning
- `02_plan/` — M3 final plan (committed by M3)
- `spec/*` — Worker task contracts (M3 writes spec, M2.x reads spec)
- `impl/*` — Worker execution (manual M3 decision per branch)
- `testing/staging/bug-fixes/deployment` — M3 verification

## 8. What Was Re-invented (Avoided)

✓ Two-mode read/write split (Aider ArchitectCoder)
✓ Plan/Act separation (Cline)
✓ Worker contracts via spec branches (Cline Task)
✓ Subagent mode + permission enforcement (OpenCode)
✓ Cavecrew output compression (OpenCode skill catalog)
✓ /herdr multiplexing (herdr skill)

## 9. MiniMax-Specific Additions (New)

✦ M3 = plan + delegate (no build) mode
✦ M3 commits, workers write only
✦ A2A context: M3 sends snippets, not full context
✦ Anti-thinking-model rule: workers get M2.x, not M3

## 10. Research Sources

- MiniMax Models: https://platform.minimax.io/docs/guides/models-intro.md
- M2 Agent Generalization: https://platform.minimax.io/docs/guides/text-m2-agent-generalization.md
- M3 Function Call: https://platform.minimax.io/docs/guides/text-m3-function-call.md
- M3 for Coding Tools: https://platform.minimax.io/docs/guides/text-ai-coding-tools.md

## 11. Open Items (Needs Correction)

1. Tool names — are they `/cavecrew` (category) or specific presets?
2. Mode terminology — is `orchestrator` agent type with `plan`/`delegate` modes correct?
3. Procedure storage — should be `.opencode/skills/` (SKILL.md) or manual templates?
4. Commit flow — workers auto-commit + M3 reviews after, or workers report diff → M3 reviews → M3 commits?
5. A2A protocol — correct concept or needs structured message passing?

## Notes

- Awaiting corrections from user on above items
- Errors identified by user: tool names, mode terminology, procedure storage, commit flow, A2A protocol