#!/bin/bash
# Build ScoreLabs ISO using Docker container

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "🏗️  Building ScoreLabs in Arch Linux container..."

# Build the container image
echo "📦 Building container image..."
docker-compose -f docker-compose.archiso.yml build

# Run the build
echo "🔨 Starting ISO build..."
docker-compose -f docker-compose.archiso.yml run --rm archiso-builder /bin/bash -c "./build.sh"

echo "✅ Build complete! Check build/output/ for your ISO"
