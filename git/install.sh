#!/usr/bin/env bash
# install.sh — installer for gp

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="/usr/bin/gp"
SOURCE="$SCRIPT_DIR/gpush.sh"
ALIASES_FILE="$HOME/.bash_aliases"
ALIAS_LINE="alias gp='source $SOURCE'"

# --- check if gp already exists in /usr/bin ---
if [[ -x "$TARGET" ]]; then
    echo "✅ $TARGET already exists. Skipping symlink."
else
    # --- verify gpush.sh is present ---
    if [[ ! -f "$SOURCE" ]]; then
        echo "❌ $SOURCE not found."
        exit 1
    fi

    echo "🔧 Installing gp..."
    sudo chmod +x "$SOURCE"

    # remove any stale file/link
    if [[ -L "$TARGET" || -e "$TARGET" ]]; then
        sudo rm -f "$TARGET"
    fi

    # create symlink
    sudo ln -s "$SOURCE" "$TARGET"
    echo "✅ Installed gp as symlink to $SOURCE"
fi

# --- ensure alias exists in ~/.bash_aliases ---
if [[ ! -f "$ALIASES_FILE" ]]; then
    touch "$ALIASES_FILE"
fi

if ! grep -Fxq "$ALIAS_LINE" "$ALIASES_FILE"; then
    echo "$ALIAS_LINE" >> "$ALIASES_FILE"
    echo "✅ Added alias to $ALIASES_FILE"
else
    echo "✅ Alias already present in $ALIASES_FILE"
fi

echo "ℹ️ Run: source $ALIASES_FILE   # or restart your shell to load the alias"
