# How to Download ScoreLabs

ScoreLabs is a custom Arch Linux distribution for cybersecurity. You can download the source code and build your own ISO, or use pre-built images if available.

## Option 1: Download Source Code (Recommended)

### Prerequisites
- Git
- Docker (for easy building on any OS)
- Or Arch Linux system

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mincesquid/ScoreLabs.git
   cd ScoreLabs
   ```

2. **Build the ISO:**
   ```bash
   # On Linux/macOS with Docker
   ./scripts/build-in-container.sh

   # Or on Arch Linux directly
   ./build.sh
   ```

3. **Find your ISO:**
   ```bash
   ls -lh build/output/*.iso
   ```

## Option 2: Pre-built ISO (if available)

Check the [Releases](https://github.com/mincesquid/ScoreLabs/releases) page for pre-built ISO files.

Download the latest `.iso` file and follow the installation instructions.

## What You'll Get

- **Source Code**: Complete build system for customizing ScoreLabs
- **ISO Image**: Bootable USB image with KDE Plasma desktop
- **Documentation**: Guides for installation, usage, and development

## System Requirements

- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 20GB free space for building
- **USB Drive**: 8GB+ for bootable USB

## Quick Commands Reference

```bash
# Clone repo
git clone https://github.com/mincesquid/ScoreLabs.git

# Build with Docker
cd ScoreLabs
./scripts/build-in-container.sh

# Create bootable USB (replace /dev/sdX with your USB device)
sudo dd bs=4M if=build/output/scorelabs-*.iso of=/dev/sdX status=progress
```

## Need Help?

- Read the full [README.md](README.md)
- Check [Installation Guide](docs/installation.md)
- Join discussions on GitHub Issues