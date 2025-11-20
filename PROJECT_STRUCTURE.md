# ScoreLabs Project Structure

```
ScoreLabs/
├── README.md                    # Main project documentation
├── LICENSE                      # MIT License with legal notice
├── CONTRIBUTING.md              # Contribution guidelines
├── .gitignore                   # Git ignore rules
├── build.sh                     # Main ISO build script
├── docker-compose.yml           # Docker build environment
├── Dockerfile.build             # Docker build container
│
├── build/                       # Build directory (created during build)
│   ├── output/                  # ISO output directory
│   ├── work/                    # Build working directory
│   └── profile/                 # Customized archiso profile
│
├── config/                      # System and build configurations
│   ├── packages.x86_64          # Package list for ISO
│   ├── scorelabs.yml            # Main ScoreLabs configuration
│   ├── system-config.sh         # System configuration script
│   └── airootfs/                # Filesystem overlay (future)
│
├── docs/                        # Documentation
│   ├── installation.md          # Installation guide
│   ├── architecture.md          # System architecture
│   ├── sandbox.md               # Sandbox system guide
│   ├── tools.md                 # Tool reference
│   └── labs/                    # Lab documentation
│       └── README.md            # Lab scenarios overview
│
├── labs/                        # Lab scenarios
│   └── scenarios/
│       └── intro-to-nmap/       # Example: Nmap introduction lab
│           ├── README.md        # Lab instructions
│           ├── scenario.yml     # Lab configuration
│           ├── setup.sh         # Lab setup script
│           ├── hints/           # Progressive hints
│           │   ├── hint1.md
│           │   ├── hint2.md
│           │   └── hint3.md
│           └── solution/        # Complete solution
│               └── walkthrough.md
│
├── packages/                    # Custom packages (future)
│   └── scorelabs-cli/           # CLI package
│
├── sandbox/                     # Sandbox framework
│   └── sandbox-manager.sh       # Sandbox management script
│
└── scripts/                     # Utility scripts
    ├── scorelabs-cli            # Main CLI interface
    └── test-vm.sh               # VM testing script
```

## Quick Start

### Building the ISO

```bash
# On Arch Linux
./build.sh

# Using Docker
docker-compose up scorelabs-build
```

### Using the CLI

```bash
# Install tool suites
./scripts/scorelabs-cli install --suite forensics
./scripts/scorelabs-cli install --suite pentesting

# Manage sandboxes
./scripts/scorelabs-cli sandbox create my-test
./scripts/scorelabs-cli sandbox start my-test

# Run labs
./scripts/scorelabs-cli lab list
./scripts/scorelabs-cli lab start intro-to-nmap
```

### Testing

```bash
# Test the build
./build.sh --test

# Test in VM
./scripts/test-vm.sh --run-vm
```

## Key Features

✅ **Arch Linux Base** - Rolling release with latest tools
✅ **Comprehensive Security Tools** - Pre-configured tool suites
✅ **Sandbox System** - Safe isolated environments
✅ **Lab Scenarios** - Hands-on learning exercises
✅ **CLI Management** - Unified command interface
✅ **Flexible Deployment** - Live USB, VM, or bare metal

## Development Status

### Completed
- [x] Project structure
- [x] Build system (archiso-based)
- [x] Package definitions
- [x] CLI framework
- [x] Sandbox framework structure
- [x] Example lab scenario (intro-to-nmap)
- [x] Comprehensive documentation

### In Progress
- [ ] Custom package builds
- [ ] Desktop environment customization
- [ ] Additional lab scenarios
- [ ] Testing framework

### Planned
- [ ] GUI management interface
- [ ] Cloud deployment options
- [ ] Community lab repository
- [ ] Automated updates
- [ ] Plugin system

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Submitting bug reports
- Creating lab scenarios
- Adding security tools
- Improving documentation

## Resources

- **Installation**: [docs/installation.md](docs/installation.md)
- **Architecture**: [docs/architecture.md](docs/architecture.md)
- **Sandboxes**: [docs/sandbox.md](docs/sandbox.md)
- **Labs**: [docs/labs/README.md](docs/labs/README.md)
- **Tools**: [docs/tools.md](docs/tools.md)

## License

MIT License - See [LICENSE](LICENSE) for details

**Legal Notice**: ScoreLabs is for educational and authorized testing only. Users are responsible for ensuring legal compliance.

---

Built with ❤️ for the security community
