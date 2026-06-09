# Verification — scaffold_2

30 checks. All must pass.

## Branch Existence

V.1: 31 branches. V.2: null empty. V.3: main exists.

## Planning + Standards

V.4–V.7: planning and standards branches exist.

## Spec Branches

V.8: all 9 spec branches exist. V.9: no implementation files on spec branches.

## Testing Branches

V.10: all 8 testing branches exist. V.11: each testing branch is child of its spec parent.

## Orphan Integrity

V.12: 20 orphan branches (excl. null, main) have no merge-base with main.

## Impl Fork Chain

V.13–V.19: all 6 impl/* branches are children of impl/front-end_app-shell. Hero and homepage are siblings.

## Orphan Tech-Stack

V.20: impl/front-end_tech-stack is orphan. V.21: impl/back-end_tech-stack is orphan. V.22: impl/front-end_app-shell is orphan.

## Staging + QA

V.23: staging/v1 is child of app-shell. V.24: bug-fixes is child of impl/front-end_navbar. V.25–V.26: deployment branches exist.

## README

V.27: all non-null branches have README.md.

## Null + Bare

V.28: null has 0 tracked files. V.29: null has 1 commit. V.30: .bare is bare repo.