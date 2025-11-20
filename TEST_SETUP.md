# Testing ScoreLabs on macOS

## Summary

ScoreLabs is built on Arch Linux, but you can build and test it on macOS using Docker containers.

## Quick Setup

### 1. Install Prerequisites

```bash
# Install Docker Desktop
brew install --cask docker

# (Optional) Install QEMU for testing
brew install qemu
```

### 2. Build the ISO

```bash
./scripts/build-in-container.sh
```

This will:
- Spin up an Arch Linux container
- Install `archiso` build tools
- Build the ScoreLabs ISO
- Output to `build/output/`

### 3. Test the ISO

```bash
./scripts/test-in-vm.sh
```

This launches QEMU with the built ISO.

## What Was Added

### New Files

1. **[Dockerfile.archiso](Dockerfile.archiso)** - Arch Linux container for building
2. **[docker-compose.archiso.yml](docker-compose.archiso.yml)** - Container orchestration
3. **[scripts/build-in-container.sh](scripts/build-in-container.sh)** - Automated build script
4. **[scripts/test-in-vm.sh](scripts/test-in-vm.sh)** - QEMU test launcher
5. **[docs/development/building-on-macos.md](docs/development/building-on-macos.md)** - Detailed guide

### Updated Files

- **[README.md](README.md)** - Added macOS quick start
- **[QUICKSTART.md](QUICKSTART.md)** - Updated Docker instructions

## Manual Build (Advanced)

If you want more control:

```bash
# Build container
docker-compose -f docker-compose.archiso.yml build

# Interactive session
docker-compose -f docker-compose.archiso.yml run --rm archiso-builder

# Inside container
./build.sh              # Full build
./build.sh --test       # Dry run
./build.sh --clean      # Clean artifacts
```

## Testing Methods

### Method 1: QEMU (Fastest)

```bash
brew install qemu
./scripts/test-in-vm.sh
```

### Method 2: VirtualBox

```bash
brew install --cask virtualbox

# Create new VM
# - Type: Linux
# - Version: Arch Linux (64-bit)
# - Mount: build/output/scorelabs-*.iso
```

### Method 3: UTM (Apple Silicon Optimized)

```bash
brew install --cask utm

# Create new VM in UTM
# - Architecture: x86_64
# - Boot ISO: build/output/scorelabs-*.iso
```

## Troubleshooting

### Docker Won't Build

```bash
# Clean everything
docker-compose -f docker-compose.archiso.yml down
docker system prune -a

# Rebuild from scratch
docker-compose -f docker-compose.archiso.yml build --no-cache
```

### No Space Left

```bash
# Clean Docker
docker system prune -a

# Clean build artifacts
./build.sh --clean
```

### Permission Denied

The container needs privileged mode for `mkarchiso`. This is already configured in `docker-compose.archiso.yml`:

```yaml
privileged: true
```

### QEMU Won't Start

```bash
# Check if QEMU is installed
qemu-system-x86_64 --version

# Install if missing
brew install qemu
```

## Architecture

```
macOS Host
    |
    ├─> Docker Container (Arch Linux)
    |       |
    |       ├─> archiso (build tools)
    |       ├─> ./build.sh
    |       └─> Output: scorelabs-*.iso
    |
    └─> QEMU VM
            |
            └─> Boot: scorelabs-*.iso
```

## Next Steps

1. **Customize the build**:
   - Edit [config/packages.x86_64](config/packages.x86_64) - Add packages
   - Edit [config/system-config.sh](config/system-config.sh) - System tweaks

2. **Create labs**:
   - See [labs/scenarios/intro-to-nmap/](labs/scenarios/intro-to-nmap/)
   - Copy and modify for new scenarios

3. **Test thoroughly**:
   - Boot the ISO in a VM
   - Verify all tools work
   - Test lab scenarios

## Documentation

- [Building on macOS](docs/development/building-on-macos.md) - Detailed guide
- [QUICKSTART.md](QUICKSTART.md) - Development quickstart
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Project organization
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

## Support

If you encounter issues:
1. Check [docs/development/building-on-macos.md](docs/development/building-on-macos.md)
2. Review [build.sh](build.sh) for build process
3. Check Docker logs: `docker-compose -f docker-compose.archiso.yml logs`

---

**You're all set!** Run `./scripts/build-in-container.sh` to start building.
