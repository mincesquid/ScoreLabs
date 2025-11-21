# ScoreLabs

> A next-generation security Linux distribution built on Arch Linux

ScoreLabs is a streamlined, high-performance security distribution designed for professionals, students, and curious technologists who want to learn, explore, and push the boundaries of what's possible in cybersecurity.

## 🎯 Overview

ScoreLabs delivers a powerful environment packed with tools for:
- System analysis and forensics
- Secure operations and hardening
- Penetration testing and security research
- Hands-on experimentation in controlled environments

At its core, ScoreLabs introduces a **unique sandboxing and simulation system** that enables users to dive into real-world investigative scenarios, explore compromised environments, study unusual system behaviors, and experiment with legacy operating systems and early-era malware in safe, controlled labs.

## ✨ Key Features

- **Arch Linux Foundation**: Rolling release model with cutting-edge packages and performance
- **KDE Plasma Desktop**: Custom "Glitch Security" theme with professional cyberpunk aesthetic
- **Comprehensive Security Toolkit**: Pre-configured tools for analysis, testing, and defense
- **Advanced Sandboxing**: Isolated environments for safe experimentation
- **Lab Scenarios**: Real-world simulation exercises for skill development
- **Flexible Deployment**: Live USB, VM, or bare-metal installation options
- **Professional-Grade**: Designed for both learning and serious security work

## 🚀 Quick Start

### Setup Git Configuration

**Important**: Before working with the repository, configure git properly:

```bash
./scripts/setup-git.sh
```

This ensures you can fetch and merge all branches, including OS assets and feature branches.

### Download & Build

See [HOWTODOWNLOAD.md](HOWTODOWNLOAD.md) for detailed download and build instructions.

### On Arch Linux

```bash
# Build the ISO
./build.sh
```

### On macOS

```bash
# Build using Docker
./scripts/build-in-container.sh

# Test in VM
./scripts/test-in-vm.sh
```

See [Building on macOS](docs/development/building-on-macos.md) for detailed instructions.

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Architecture Overview](docs/architecture.md)
- [Tool Reference](docs/tools.md)
- [Lab Scenarios](docs/labs/README.md)
- [Contributing](CONTRIBUTING.md)

## 🛠️ Project Structure

```
ScoreLabs/
├── build/              # Build scripts and configurations
├── config/             # System configurations and presets
├── docs/               # Documentation
├── labs/               # Sandbox scenarios and exercises
├── packages/           # Custom packages and tool integrations
├── scripts/            # Utility and deployment scripts
└── sandbox/            # Sandboxing and simulation framework
```

## 🧪 Sandboxing System

ScoreLabs includes a sophisticated sandboxing framework that allows you to:
- Create isolated analysis environments
- Simulate compromised systems
- Run legacy OS instances safely
- Study malware behavior in containment
- Practice incident response scenarios

See [Sandbox Documentation](docs/sandbox.md) for detailed usage.

## 🎓 Target Audience

- Security professionals and penetration testers
- Digital forensics investigators
- Security researchers and students
- System administrators learning hardening techniques
- Anyone interested in hands-on cybersecurity

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- Code standards
- Lab scenario creation
- Tool integration
- Documentation improvements

## 📜 License

See [LICENSE](LICENSE) for details.

## ⚠️ Legal Notice

ScoreLabs is designed for educational purposes and authorized security testing only. Users are responsible for ensuring compliance with all applicable laws and regulations. Unauthorized access to computer systems is illegal.

---

**Built with security in mind. Powered by Arch Linux. Designed for exploration.**
