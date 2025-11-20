#!/bin/bash
# Test script for ScoreLabs build

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO_PATH="${SCRIPT_DIR}/../build/output/scorelabs-*.iso"

echo "ScoreLabs Test Suite"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Check if ISO exists
echo "[TEST] Checking for ISO file..."
if ls $ISO_PATH 1> /dev/null 2>&1; then
    echo "✓ ISO file found"
    ISO_FILE=$(ls $ISO_PATH | head -n 1)
    echo "  File: $ISO_FILE"
    echo "  Size: $(du -h "$ISO_FILE" | cut -f1)"
else
    echo "✗ ISO file not found"
    echo "  Run ./build.sh first"
    exit 1
fi

# Test 2: Check ISO integrity
echo ""
echo "[TEST] Checking ISO integrity..."
if command -v isoinfo &> /dev/null; then
    if isoinfo -d -i "$ISO_FILE" &> /dev/null; then
        echo "✓ ISO structure is valid"
    else
        echo "✗ ISO structure is invalid"
        exit 1
    fi
else
    echo "⚠ isoinfo not available, skipping integrity check"
fi

# Test 3: Launch QEMU test (optional)
if [ "$1" == "--run-vm" ]; then
    echo ""
    echo "[TEST] Launching test VM..."
    
    if command -v qemu-system-x86_64 &> /dev/null; then
        echo "Starting QEMU with ISO..."
        qemu-system-x86_64 \
            -cdrom "$ISO_FILE" \
            -m 2048 \
            -boot d \
            -enable-kvm \
            -display sdl
    else
        echo "✗ QEMU not installed"
        exit 1
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "All tests passed! ✓"
echo ""
echo "Next steps:"
echo "  - Test in VM: $0 --run-vm"
echo "  - Write to USB: sudo dd if=$ISO_FILE of=/dev/sdX bs=4M status=progress"
echo "  - Use Ventoy: Copy ISO to Ventoy USB drive"
