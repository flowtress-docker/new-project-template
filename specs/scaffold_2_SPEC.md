# SPEC — scaffold_2

` scaffold_2 <project-name> `

Creates `<project-name>_root/` with bare git repo + 31 branch worktrees.

## Exit Codes

0 = success. 1 = error.

## Edge Cases

- Dir exists: exit 1
- Invalid name: exit 1
- No git: exit 1
- Re-run: exit 1

## Output

Progress per branch. Summary. Next hint.

## Prerequisites

git 2.27+, bash 4.0+. Offline. No GH CLI.