#!/usr/bin/env bash
set -euo pipefail

# detect-networks.sh: Returns networks in format NAME|DRIVER
# This script chooses Podman if available, otherwise Docker.

if command -v podman >/dev/null 2>&1; then
    podman network ls --format '{{.Name}}|{{.Driver}}'
elif command -v docker >/dev/null 2>&1; then
    docker network ls --format '{{.Name}}|{{.Driver}}'
else
    echo "Error: neither podman nor docker is installed or available in PATH" >&2
    exit 1
fi
