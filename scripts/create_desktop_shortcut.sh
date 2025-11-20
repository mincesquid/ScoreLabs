#!/usr/bin/env bash
# create_desktop_shortcut.sh — create easy-to-find shortcuts on macOS
# Usage: ./scripts/create_desktop_shortcut.sh [--symlink] [--alias] [--vscode]

set -euo pipefail

# Defaults
DO_SYMLINK=true
DO_ALIAS=false
DO_VSCODE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --symlink) DO_SYMLINK=true; shift;;
    --no-symlink) DO_SYMLINK=false; shift;;
    --alias) DO_ALIAS=true; shift;;
    --vscode) DO_VSCODE=true; shift;;
    -h|--help)
      echo "Usage: $0 [--symlink] [--alias] [--vscode]"
      echo "  --symlink   Create a Finder-visible symlink on the Desktop (default)"
      echo "  --no-symlink  Disable symlink creation"
      echo "  --alias     Create a Finder Alias on the Desktop (macOS only)"
      echo "  --vscode    Write a ScoreLabs.code-workspace file in repository root"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1;;
  esac
done

REPO_DIR="$PWD"
DESKTOP="$HOME/Desktop"
LINK_NAME="ScoreLabs"

if [ "$DO_SYMLINK" = true ]; then
  TARGET_LINK="$DESKTOP/$LINK_NAME"
  if [ -e "$TARGET_LINK" ]; then
    echo "Symlink target '$TARGET_LINK' already exists — skipping"
  else
    ln -s "$REPO_DIR" "$TARGET_LINK"
    echo "Created symlink: $TARGET_LINK -> $REPO_DIR"
  fi
fi

# Create Finder alias via AppleScript
if [ "$DO_ALIAS" = true ]; then
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Finder alias only supported on macOS. Skipping alias creation."
  else
    osascript -e "tell application \"Finder\" to make alias file to POSIX file \"$REPO_DIR\" at POSIX file \"$DESKTOP\""
    echo "Created Finder alias on Desktop"
  fi
fi

# Create a minimal VS Code workspace so the user can double-click it to open the project
if [ "$DO_VSCODE" = true ]; then
  WORKSPACE_FILE="$REPO_DIR/ScoreLabs.code-workspace"
  if [ -e "$WORKSPACE_FILE" ]; then
    echo "VS Code workspace already exists at $WORKSPACE_FILE"
  else
    cat > "$WORKSPACE_FILE" <<EOF
{
  "folders": [
    { "path": "." }
  ],
  "settings": {}
}
EOF
    echo "Wrote VS Code workspace file: $WORKSPACE_FILE"
  fi
fi

# Summary
if [ "$DO_SYMLINK" = true ]; then
  echo "If you'd rather a Finder Alias (not a symlink) use: $0 --alias"
fi

echo "Done — try Spotlight (Command+Space) and type 'ScoreLabs' or look on your Desktop."
exit 0
