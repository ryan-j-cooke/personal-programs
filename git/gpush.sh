#!/usr/bin/env bash
# gp.sh — quick add/commit/push with optional exit

set -Eeuo pipefail

# --- args ---
MESSAGE="${1:-}"
KILL_SESSION="${2:-false}"   # accepts: true/false/1/0/yes/no (case-insensitive)

if [[ -z "$MESSAGE" ]]; then
    echo "Usage: $(basename "$0") \"commit message\" [killSession=true|false]"
    exit 1
fi

# --- verify git repo ---
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: not inside a Git repository."
    exit 1
fi

# --- add/commit/push ---
# Mirrors your sequence; using -m is clearer, but keeping close to your request.
git add . && git commit -am "$MESSAGE" || {
    # If commit failed (likely no changes), tell the user but still try pushing
    echo "Nothing to commit (working tree clean or no tracked changes)."
}
# Push current branch explicitly
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git push origin "$CURRENT_BRANCH"

# --- optional exit ---
shopt -s nocasematch
if [[ "$KILL_SESSION" == "true" || "$KILL_SESSION" == "1" || "$KILL_SESSION" == "yes" ]]; then
    echo "killSession=true: exiting…"
    # Note: this exits the script. To close your current shell session,
    # source the script ('. ./gp.sh \"msg\" true') or make it a shell function.
    exit 0
fi
