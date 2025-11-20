# ScoreLabs Development Quickstart

Welcome to ScoreLabs development! This guide will get you up and running quickly.

## Prerequisites

Since you're on macOS, you'll need to use Docker or a Linux VM to build the ISO.

### Option 1: Docker (Recommended for macOS)

```bash
# Make sure Docker is installed and running
docker --version

# Build using Docker
docker-compose up scorelabs-build
```

### Option 2: Linux VM

Use VirtualBox, VMware, or UTM with Arch Linux.

## Project Overview

ScoreLabs is structured as follows:

- **`build.sh`** - Main build script (needs Arch Linux)
- **`scripts/scorelabs-cli`** - CLI tool for managing the distribution
- **`config/`** - Configuration files and package lists
- **`docs/`** - Documentation
- **`labs/`** - Lab scenarios and exercises
- **`sandbox/`** - Sandbox management scripts

## Common Tasks

### Testing the CLI (Works on macOS)

```bash
# List available commands
./scripts/scorelabs-cli help

# Show available tool suites
./scripts/scorelabs-cli list

# Note: Some commands require Linux
```

## Quickly find your project on macOS

If you have trouble finding the project folder, use one of these quick options:

- Create a symlink on the Desktop: `ln -s $(pwd) ~/Desktop/ScoreLabs`
- Create a Finder alias (right-click the folder → Make Alias), or use `scripts/create_desktop_shortcut.sh --alias`
- Add the project to the Finder sidebar or the Dock for fast access

See `docs/desktop_shortcuts.md` for detailed steps and Automator/Alfred suggestions.

### Working on Documentation

All documentation is in Markdown under `docs/`:

```bash
# Edit installation guide
vim docs/installation.md

# Edit architecture docs
vim docs/architecture.md
```

### Creating a New Lab Scenario

```bash
# Copy the template
cp -r labs/scenarios/intro-to-nmap labs/scenarios/my-new-lab

# Edit the scenario
cd labs/scenarios/my-new-lab
vim scenario.yml
vim README.md
vim setup.sh
```

### Modifying Package List

```bash
# Edit the package list
vim config/packages.x86_64

# Packages are organized by category
# Just add package names (one per line)
```

### Testing on Arch Linux

If you have access to an Arch Linux system:

```bash
# Install dependencies
sudo pacman -S archiso squashfs-tools

# Run test build (dry run)
./build.sh --test

# Full build
./build.sh

# Test in QEMU
./scripts/test-vm.sh --run-vm
```

## Development Workflow

### 1. Make Changes

Edit files in your preferred editor (VS Code recommended):

```bash
# Open in VS Code (already opened)
# Edit files as needed
```

### 2. Test Locally

```bash
# For scripts
bash -n scripts/scorelabs-cli  # Syntax check

# For labs
cd labs/scenarios/intro-to-nmap
./setup.sh  # Test setup script
```

### 3. Build (on Linux)

```bash
./build.sh
```

### 4. Test ISO

```bash
# In QEMU
./scripts/test-vm.sh --run-vm

# Or in VirtualBox/VMware
# Point to build/output/*.iso
```

### 5. Commit Changes

```bash
git add .
git commit -m "Description of changes"
git push
```

## Key Files to Know

### Build System

- **`build.sh`** - Main build orchestrator
- **`config/packages.x86_64`** - Packages to include in ISO
- **`Dockerfile.build`** - Docker build environment

### CLI System

- **`scripts/scorelabs-cli`** - Main CLI (bash)
- **`config/scorelabs.yml`** - Configuration file

### Sandbox System

- **`sandbox/sandbox-manager.sh`** - Core sandbox logic
- **`docs/sandbox.md`** - Sandbox documentation

### Lab System

- **`labs/scenarios/*/scenario.yml`** - Lab configuration
- **`labs/scenarios/*/setup.sh`** - Lab environment setup
- **`docs/labs/README.md`** - Lab documentation

## Useful Commands

### Find Files

```bash
# Find all shell scripts
find . -name "*.sh"

# Find all YAML configs
find . -name "*.yml"

# Find all markdown docs
find . -name "*.md"
```

### Check Syntax

```bash
# Shell scripts
shellcheck scripts/*.sh

# YAML files
yamllint config/*.yml
```

### View Structure

```bash
# Tree view
tree -L 3

# Or simple list
find . -type d -maxdepth 2
```

## Tips

1. **Documentation First**: Update docs when changing features
2. **Test Early**: Test scripts before committing
3. **Small Commits**: Make focused, atomic commits
4. **Follow Conventions**: Match existing code style
5. **Ask Questions**: Use GitHub Issues or Discussions

## Next Steps

### For Security Researchers

- Add new lab scenarios in `labs/scenarios/`
- Improve documentation with real-world examples
- Test security tools and report issues

### For Developers

- Enhance the CLI with new commands
- Improve the sandbox system
- Add automated testing
- Create GUI management interface

### For System Builders

- Optimize the build process
- Add more package categories
- Improve ISO customization
- Create deployment scripts

## Getting Help

- **Documentation**: Check `docs/` directory
- **Examples**: Look at `labs/scenarios/intro-to-nmap/`
- **Issues**: GitHub Issues (when repository is set up)
- **Contributing**: See `CONTRIBUTING.md`

## Quick Reference

```bash
# Build (Linux only)
./build.sh

# Test build
./build.sh --test

# Clean build artifacts
./build.sh --clean

# CLI help
./scripts/scorelabs-cli help

# Test VM
./scripts/test-vm.sh --run-vm

# Run lab setup
cd labs/scenarios/intro-to-nmap && ./setup.sh
```

## Resources

- [Arch Linux Documentation](https://wiki.archlinux.org/)
- [Archiso Documentation](https://wiki.archlinux.org/title/Archiso)
- [Docker Documentation](https://docs.docker.com/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

---

Happy hacking! 🚀
