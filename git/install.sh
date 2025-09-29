#!/usr/bin/env bash
# install.sh — installer for gpush

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="/usr/bin/gpush"
SOURCE="$SCRIPT_DIR/gpush.sh"

# --- check if gpush already exists ---
if [[ -x "$TARGET" ]]; then
    echo "✅ $TARGET already exists. Nothing to do."
    exit 0
fi

# --- verify gpush.sh is present ---
if [[ ! -f "$SOURCE" ]]; then
    echo "❌ $SOURCE not found."
    exit 1
fi

# --- install ---
echo "🔧 Installing gpush..."
sudo chmod +x "$SOURCE"

# remove any stale file/link
if [[ -L "$TARGET" || -e "$TARGET" ]]; then
    sudo rm -f "$TARGET"
fi

# create symlink
sudo ln -s "$SOURCE" "$TARGET"

echo "✅ Installed gpush as symlink to $SOURCE"
