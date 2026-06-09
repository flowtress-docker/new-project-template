#!/usr/bin/env bash
# =============================================================================
# scaffold_2 verification tests
# =============================================================================
# Runs verification checks against a live scaffold_2 run.
# Uses set -euo pipefail. Exits non-zero on any failure.
# Eager cleanup: removes temp dir on exit.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCAFFOLD_BIN="${SCAFFOLD_BIN:-scaffold_2}"

# -----------------------------------------------------------------------------
# Cleanup
# -----------------------------------------------------------------------------
TEST_DIR=""
cleanup() {
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}
trap cleanup EXIT

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
run_test() {
    local name="$1"
    local cmd="$2"
    echo "  [$name]"
    if eval "$cmd" >/dev/null 2>&1; then
        echo "    PASS"
        return 0
    else
        echo "    FAIL: $cmd"
        return 1
    fi
}

fail() {
    echo "FAIL: $1" >&2
    exit 1
}

# -----------------------------------------------------------------------------
# Main test runner
# -----------------------------------------------------------------------------
main() {
    local test_project="scaffold-2-test-$$"
    TEST_DIR="$(mktemp -d)"
    local failed=0

    echo "=== scaffold_2 verification tests ==="
    echo ""

    # T1: no args
    echo "[T1] scaffold_2 with no arguments exits 1"
    if scaffold_2 >/dev/null 2>&1; then
        echo "  FAIL: should exit 1"
        failed=1
    else
        echo "  PASS"
    fi

    # T2: empty string
    echo "[T2] scaffold_2 '' exits 1"
    if scaffold_2 '' >/dev/null 2>&1; then
        echo "  FAIL: should exit 1"
        failed=1
    else
        echo "  PASS"
    fi

    # T3: space in name
    echo "[T3] scaffold_2 'my project' exits 1"
    if scaffold_2 'my project' >/dev/null 2>&1; then
        echo "  FAIL: should exit 1"
        failed=1
    else
        echo "  PASS"
    fi

    # T4: valid name creates directory
    echo "[T4] scaffold_2 my-app creates <name>_root/"
    (cd "$TEST_DIR" && scaffold_2 my-app >/dev/null 2>&1) || fail "scaffold_2 my-app failed"
    if [[ -d "$TEST_DIR/my-app_root" ]]; then
        echo "  PASS"
    else
        echo "  FAIL: my-app_root not created"
        failed=1
    fi

    # T5: .bare is bare repo
    echo "[T5] .bare is a bare repo"
    if git -C "$TEST_DIR/my-app_root/.bare" config core.bare >/dev/null 2>&1; then
        echo "  PASS"
    else
        echo "  FAIL: .bare is not a bare repo"
        failed=1
    fi

    # T6: 31 branches exist
    echo "[T6] 31 branches exist"
    local count
    count=$(git --git-dir="$TEST_DIR/my-app_root/.bare" branch -a | wc -l)
    if [[ "$count" -ge 31 ]]; then
        echo "  PASS ($count branches)"
    else
        echo "  FAIL: only $count branches (expected 31)"
        failed=1
    fi

    # T7: null branch empty
    echo "[T7] null branch: 1 commit, 0 tracked files"
    local commits files
    commits=$(git -C "$TEST_DIR/my-app_root/null" rev-list --count HEAD)
    files=$(git -C "$TEST_DIR/my-app_root/null" ls-files | wc -l)
    if [[ "$commits" -eq 1 && "$files" -eq 0 ]]; then
        echo "  PASS"
    else
        echo "  FAIL: commits=$commits files=$files"
        failed=1
    fi

    # T8: main exists with README
    echo "[T8] main exists with README.md"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" show-ref --verify refs/heads/main >/dev/null 2>&1 && \
       git --git-dir="$TEST_DIR/my-app_root/.bare" show main:README.md >/dev/null 2>&1; then
        echo "  PASS"
    else
        echo "  FAIL"
        failed=1
    fi

    # T9: orphan branches have no merge-base with main (excludes null and main)
    echo "[T9] All 20 orphan branches have no merge-base with main"
    local orphan_list=(
        "01_rough-plan" "02_context" "02_plan" "ui/impeccable"
        "spec/front-end_tech-stack" "spec/back-end_tech-stack"
        "spec/front-end_typography" "spec/front-end_color-scheme"
        "spec/front-end_navbar" "spec/front-end_footer"
        "spec/front-end_app-shell" "spec/front-end_hero" "spec/front-end_homepage"
        "impl/front-end_tech-stack" "impl/front-end_app-shell"
        "impl/back-end_tech-stack"
        "deployment/v1" "deployment/v2"
    )
    local orphan_ok=1
    for orphan in "${orphan_list[@]}"; do
        if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base "refs/heads/$orphan" refs/heads/main >/dev/null 2>&1; then
            echo "  FAIL: $orphan shares history with main"
            orphan_ok=0
        fi
    done
    if [[ "$orphan_ok" -eq 1 ]]; then
        echo "  PASS"
    else
        failed=1
    fi

    # T10: impl/front-end_typography is child of impl/front-end_app-shell
    echo "[T10] impl/front-end_typography is child of impl/front-end_app-shell"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor impl/front-end_app-shell impl/front-end_typography 2>/dev/null; then
        echo "  PASS"
    else
        echo "  FAIL"
        failed=1
    fi

    # T11: each impl fork is child of app-shell
    echo "[T11] All 6 impl/* branches are children of impl/front-end_app-shell"
    local impl_forks=(
        "impl/front-end_typography"
        "impl/front-end_color-scheme"
        "impl/front-end_navbar"
        "impl/front-end_footer"
        "impl/front-end_hero"
        "impl/front-end_homepage"
    )
    local fork_ok=1
    for branch in "${impl_forks[@]}"; do
        if ! git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor impl/front-end_app-shell "$branch" 2>/dev/null; then
            echo "  FAIL: $branch is not child of app-shell"
            fork_ok=0
        fi
    done
    if [[ "$fork_ok" -eq 1 ]]; then
        echo "  PASS"
    else
        failed=1
    fi

    # T12: hero and homepage are siblings (both from app-shell)
    echo "[T12] impl/front-end_hero and impl/front-end_homepage are siblings"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor impl/front-end_app-shell impl/front-end_hero 2>/dev/null && \
       git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor impl/front-end_app-shell impl/front-end_homepage 2>/dev/null; then
        echo "  PASS"
    else
        echo "  FAIL"
        failed=1
    fi

    # T13: testing/front-end_navbar is child of spec/front-end_navbar
    echo "[T13] testing/front-end_navbar is child of spec/front-end_navbar"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor spec/front-end_navbar testing/front-end_navbar 2>/dev/null; then
        echo "  PASS"
    else
        echo "  FAIL"
        failed=1
    fi

    # T14: staging/v1 is child of impl/front-end_app-shell
    echo "[T14] staging/v1 is child of impl/front-end_app-shell"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor impl/front-end_app-shell staging/v1 2>/dev/null; then
        echo "  PASS"
    else
        echo "  FAIL"
        failed=1
    fi

    # T15: bug-fixes is child of impl/front-end_navbar
    echo "[T15] bug-fixes/front-end_navbar-nav-fix is child of impl/front-end_navbar"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base --is-ancestor impl/front-end_navbar bug-fixes/front-end_navbar-nav-fix 2>/dev/null; then
        echo "  PASS"
    else
        echo "  FAIL"
        failed=1
    fi

    # T16: all non-null branches have README.md
    echo "[T16] All non-null branches have README.md"
    local all_branches=(
        "main" "01_rough-plan" "02_context" "02_plan" "ui/impeccable"
        "spec/front-end_tech-stack" "spec/back-end_tech-stack"
        "spec/front-end_typography" "spec/front-end_color-scheme"
        "spec/front-end_navbar" "spec/front-end_footer"
        "spec/front-end_app-shell" "spec/front-end_hero" "spec/front-end_homepage"
        "testing/front-end_typography" "testing/front-end_color-scheme"
        "testing/front-end_navbar" "testing/front-end_footer"
        "testing/front-end_app-shell" "testing/front-end_hero"
        "testing/front-end_homepage" "testing/back-end_tech-stack"
        "impl/front-end_tech-stack" "impl/front-end_app-shell"
        "impl/front-end_typography" "impl/front-end_color-scheme"
        "impl/front-end_navbar" "impl/front-end_footer"
        "impl/front-end_hero" "impl/front-end_homepage"
        "impl/back-end_tech-stack"
        "staging/v1" "bug-fixes/front-end_navbar-nav-fix"
        "deployment/v1" "deployment/v2"
    )
    local readme_ok=1
    for branch in "${all_branches[@]}"; do
        if ! git --git-dir="$TEST_DIR/my-app_root/.bare" show "$branch:README.md" >/dev/null 2>&1; then
            echo "  FAIL: $branch missing README.md"
            readme_ok=0
        fi
    done
    if [[ "$readme_ok" -eq 1 ]]; then
        echo "  PASS"
    else
        failed=1
    fi

    # T17: re-running scaffold_2 on same dir exits 1
    echo "[T17] Re-running scaffold_2 on same dir exits 1"
    if (cd "$TEST_DIR" && scaffold_2 my-app >/dev/null 2>&1); then
        echo "  FAIL: should exit 1"
        failed=1
    else
        echo "  PASS"
    fi

    # T18: impl/back-end_tech-stack is orphan (not fork of app-shell)
    echo "[T18] impl/back-end_tech-stack is orphan"
    if git --git-dir="$TEST_DIR/my-app_root/.bare" merge-base impl/back-end_tech-stack impl/front-end_app-shell >/dev/null 2>&1; then
        echo "  FAIL: back-end_tech-stack shares history with app-shell"
        failed=1
    else
        echo "  PASS"
    fi

    echo ""
    if [[ "$failed" -eq 0 ]]; then
        echo "All tests passed."
        exit 0
    else
        echo "Some tests failed."
        exit 1
    fi
}

main "$@"