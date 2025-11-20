# Building ScoreLabs on macOS

Since ScoreLabs is built on Arch Linux, building it natively on macOS requires some workarounds. This guide covers the recommended approaches.

## Prerequisites

### Required
- **Docker Desktop** for Mac - [Download here](https://www.docker.com/products/docker-desktop)
- At least 20GB free disk space
- 8GB+ RAM recommended

### Optional (for testing)
- **QEMU** - For VM testing: `brew install qemu`
- **VirtualBox** or **UTM** - Alternative VM options

## Quick Start

### 1. Build ISO in Container

```bash
# Build the ISO using Docker
./scripts/build-in-container.sh
```

This script will:
1. Build an Arch Linux container with `archiso` tools
2. Run the ScoreLabs build script inside the container
3. Output the ISO to `build/output/`

### 2. Test the ISO

```bash
# Test in QEMU VM
./scripts/test-in-vm.sh
```

Or manually with:
```bash
qemu-system-x86_64 \
    -m 4G \
    -smp 2 \
    -cdrom build/output/scorelabs-*.iso \
    -boot d \
    -accel hvf
```

## Alternative: Manual Docker Build

If you prefer manual control:

```bash
# Build the container
docker-compose -f docker-compose.archiso.yml build

# Start interactive session
docker-compose -f docker-compose.archiso.yml run --rm archiso-builder

# Inside container - run build
./build.sh

# Or run test mode
./build.sh --test
```

## Alternative: UTM on Apple Silicon

For M1/M2/M3 Macs, UTM provides better performance:

1. Install UTM: `brew install --cask utm`
2. Create new VM:
   - Type: Linux
   - Architecture: x86_64 (or ARM64 if available)
   - Memory: 4GB+
   - Boot from ScoreLabs ISO

## Alternative: Remote Build Server

Set up an Arch Linux build server (VPS or local VM):

```bash
# On Arch Linux system
git clone <your-repo>
cd ScoreLabs
./build.sh
```

Then sync the ISO back:
```bash
# On macOS
scp buildserver:~/ScoreLabs/build/output/*.iso ./
```

## Troubleshooting

### Docker Build Fails
```bash
# Clean and rebuild
docker-compose -f docker-compose.archiso.yml down
docker-compose -f docker-compose.archiso.yml build --no-cache
```

### Permission Issues
The container needs privileged mode for `mkarchiso`. This is configured in the docker-compose file.

### Out of Disk Space
```bash
# Clean Docker resources
docker system prune -a

# Clean build artifacts
./build.sh --clean
```

### QEMU Won't Start
```bash
# Install QEMU if missing
brew install qemu

# Or use VirtualBox instead
brew install --cask virtualbox
```

## Performance Tips

1. **Increase Docker Resources**: Docker Desktop → Preferences → Resources
   - RAM: 6-8GB recommended
   - Disk: 40GB+

2. **Use Docker Volumes**: Already configured in `docker-compose.archiso.yml`

3. **Multi-stage Builds**: Cache layers for faster rebuilds

## CI/CD Integration

For automated builds, see:
- [.github/workflows/](.github/workflows/) - GitHub Actions examples
- Can build in Linux runners without Docker overhead

## See Also

- [Project Structure](../PROJECT_STRUCTURE.md)
- [Contributing Guide](../../CONTRIBUTING.md)
- [Build Script Reference](../../build.sh)
