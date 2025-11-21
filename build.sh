#!/bin/bash
# ScoreLabs Build Script
# Builds a custom Arch Linux ISO with security tools and configurations

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
OUTPUT_DIR="${BUILD_DIR}/output"
WORK_DIR="${BUILD_DIR}/work"
CONFIG_DIR="${SCRIPT_DIR}/config"
PROFILE_DIR="${BUILD_DIR}/profile"

ISO_NAME="scorelabs"
ISO_VERSION="$(date +%Y.%m.%d)"
ISO_LABEL="SCORELABS_${ISO_VERSION}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    local deps=("mkarchiso" "pacman" "mksquashfs")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install with: sudo pacman -S archiso squashfs-tools"
        exit 1
    fi
    
    log_info "All dependencies satisfied"
}

setup_build_environment() {
    log_info "Setting up build environment..."
    
    # Create directories
    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$WORK_DIR"
    mkdir -p "$PROFILE_DIR"
    
    # Copy archiso profile
    if [ -d /usr/share/archiso/configs/releng ]; then
        cp -r /usr/share/archiso/configs/releng/* "$PROFILE_DIR/"
    else
        log_error "archiso releng profile not found. Is archiso installed?"
        exit 1
    fi
    
    log_info "Build environment ready"
}

configure_profile() {
    log_info "Configuring ScoreLabs profile..."
    
    # Update package list
    if [ -f "${CONFIG_DIR}/packages.x86_64" ]; then
        cp "${CONFIG_DIR}/packages.x86_64" "${PROFILE_DIR}/packages.x86_64"
    fi
    
    # Copy custom configurations
    if [ -d "${CONFIG_DIR}/airootfs" ]; then
        cp -r "${CONFIG_DIR}/airootfs/"* "${PROFILE_DIR}/airootfs/" 2>/dev/null || true
    fi
    
    # Copy customize script
    if [ -f "${CONFIG_DIR}/customize_airootfs.sh" ]; then
        cp "${CONFIG_DIR}/customize_airootfs.sh" "${PROFILE_DIR}/"
        chmod +x "${PROFILE_DIR}/customize_airootfs.sh"
    fi
    
    # Update profile configuration
    sed -i "s/iso_name=.*/iso_name=\"${ISO_NAME}\"/" "${PROFILE_DIR}/profiledef.sh" 2>/dev/null || true
    sed -i "s/iso_label=.*/iso_label=\"${ISO_LABEL}\"/" "${PROFILE_DIR}/profiledef.sh" 2>/dev/null || true
    
    log_info "Profile configured"
}

build_iso() {
    log_info "Building ISO (this may take a while)..."
    
    cd "$BUILD_DIR"
    
    if command -v mkarchiso &> /dev/null; then
        sudo mkarchiso -v -w "$WORK_DIR" -o "$OUTPUT_DIR" "$PROFILE_DIR"
    else
        log_error "mkarchiso not found. Install archiso package."
        exit 1
    fi
    
    log_info "ISO build complete!"
}

cleanup() {
    if [ "$1" = "--clean" ]; then
        log_info "Cleaning build directories..."
        sudo rm -rf "$WORK_DIR"
        log_info "Cleanup complete"
    fi
}

show_results() {
    log_info "Build Summary:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "ISO Name:    ${ISO_NAME}-${ISO_VERSION}"
    echo "Output Dir:  ${OUTPUT_DIR}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if ls "${OUTPUT_DIR}"/*.iso 1> /dev/null 2>&1; then
        echo "Built ISOs:"
        ls -lh "${OUTPUT_DIR}"/*.iso
    fi
}

# Main execution
main() {
    log_info "ScoreLabs Build System v${ISO_VERSION}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Parse arguments
    if [ "$1" = "--clean" ]; then
        cleanup --clean
        exit 0
    fi
    
    if [ "$1" = "--test" ]; then
        log_info "Running in test mode (dry run)"
        check_dependencies
        setup_build_environment
        configure_profile
        log_info "Test complete - build environment ready"
        exit 0
    fi
    
    # Check if running on Arch-based system
    if [ ! -f /etc/arch-release ]; then
        log_warn "This script is designed for Arch Linux"
        log_warn "Building on other systems may not work properly"
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Build process
    check_dependencies
    setup_build_environment
    configure_profile
    build_iso
    show_results
    
    log_info "Done! ISO is ready in ${OUTPUT_DIR}"
}

# Run main function
main "$@"
