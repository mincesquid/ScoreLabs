#!/usr/bin/env bash
# run-shellcheck.sh - Run shellcheck locally on all repo shell scripts

set -euo pipefail

if ! command -v shellcheck >/dev/null 2>&1; then
  echo "ShellCheck is not installed. Install it with 'brew install shellcheck' (macOS) or 'apt install shellcheck' (Linux)."
  exit 2
fi

echo "Running shellcheck on all .sh files..."

FILES=$(git ls-files '*.sh' || true)
if [ -z "$FILES" ]; then
  echo "No .sh files to check"
  exit 0
fi

shellcheck -x $FILES

echo "ShellCheck complete"

exit 0
