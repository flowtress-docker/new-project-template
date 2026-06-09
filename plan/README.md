# Plan Index

Agent-actionable implementation plan for the `scaffold` CLI tool.

Load order: topology → execution → verification → conventions.

| File | Purpose | Load |
|------|---------|------|
| [topology.toml](./topology.toml) | 31 branches: orphans, fork chains, null branch, naming | 1st |
| [execution.toml](./execution.toml) | Script logic: create-all-upfront order, preflight, seed per branch type | 2nd |
| [verification.toml](./verification.toml) | 28 checks: fork integrity, orphan isolation, branch count, seed content | 3rd |
| [conventions.toml](./conventions.toml) | Naming rules, tool preferences, anti-patterns, script safety | Throughout |
