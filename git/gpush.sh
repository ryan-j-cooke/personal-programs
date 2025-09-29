#!/usr/bin/env bash
# gpush.sh — quick add/commit/push with optional exit

set -Eeuo pipefail

MESSAGE="${1:-}"
KILL_SESSION="${2:-true}"   # default true

# --- verify git repo ---
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not inside a Git repository."
    exit 1
fi

if [[ -z "$MESSAGE" ]]; then
    echo "❌ No commit message provided."
else
    git add . && git commit -am "$MESSAGE" || {
        echo "ℹ️ Nothing to commit (working tree clean)."
    }
    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git push origin "$CURRENT_BRANCH"
fi

# --- optional exit ---
shopt -s nocasematch
if [[ "$KILL_SESSION" == "true" || "$KILL_SESSION" == "1" || "$KILL_SESSION" == "yes" ]]; then
    echo "killSession=true: exiting…"
    exit
fi

exit