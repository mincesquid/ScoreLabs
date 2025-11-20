#!/bin/bash
# Test ScoreLabs ISO in a VM using QEMU

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${PROJECT_ROOT}/build/output"

# Find the most recent ISO
ISO_FILE=$(find "$BUILD_DIR" -name "*.iso" -type f -print0 2>/dev/null | xargs -0 ls -t | head -n 1)

if [ -z "$ISO_FILE" ]; then
    echo "❌ No ISO file found in ${BUILD_DIR}"
    echo "💡 Build one first with: ./scripts/build-in-container.sh"
    exit 1
fi

echo "🚀 Testing ScoreLabs ISO: $(basename "$ISO_FILE")"

# Check for QEMU
if ! command -v qemu-system-x86_64 &> /dev/null; then
    echo "❌ QEMU not found"
    echo "💡 Install with: brew install qemu"
    exit 1
fi

# VM Settings
MEMORY="4G"
CPUS="2"

echo "⚙️  VM Configuration:"
echo "   Memory: $MEMORY"
echo "   CPUs: $CPUS"
echo "   ISO: $(basename "$ISO_FILE")"
echo ""
echo "🖥️  Starting virtual machine..."

qemu-system-x86_64 \
    -m "$MEMORY" \
    -smp "$CPUS" \
    -cdrom "$ISO_FILE" \
    -boot d \
    -enable-kvm 2>/dev/null || \
    -accel hvf 2>/dev/null || \
    echo "⚠️  Running without hardware acceleration"
