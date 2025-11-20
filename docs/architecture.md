# ScoreLabs Architecture

## System Overview

ScoreLabs is built on Arch Linux, leveraging its rolling release model, extensive package repository, and minimalist philosophy to create a purpose-built security distribution.

### Architecture Stack

- **Distribution Core** – Customized Arch Linux base with curated kernel, systemd, core utilities, and networking stack configured for rolling security updates.
- **Desktop Layer (Optional)** – XFCE4 shipped as default lightweight environment while remaining headless-friendly for appliance or server deployments.
- **ScoreLabs CLI & Management** – `scorelabs-cli` orchestration plane handling tool-suite provisioning, sandbox lifecycle, lab deployment, and update workflows.
- **Security Tooling Pillars** – Modular bundles (Security Tools, Sandbox Framework, Lab Scenarios) installed incrementally to match training or research needs.
- **End-User Experiences** – Prebuilt scenarios and sandboxes provide repeatable, isolated environments for experimentation, training, and validation.

The stack ensures a minimal, auditable base, a predictable management interface, and composable layers that can be enabled or omitted depending on the operator’s requirements.
┌─────────────────────────────────────────────────────────────┐
│                     ScoreLabs Distribution                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Security   │  │   Sandbox    │  │     Lab      │      │
│  │     Tools    │  │   Framework  │  │  Scenarios   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
│  ┌────────────────────────────────────────────────────┐     │
│  │           ScoreLabs CLI & Management Layer         │     │
│  └────────────────────────────────────────────────────┘     │
│                                                               │
│  ┌────────────────────────────────────────────────────┐     │
│  │      Desktop Environment (XFCE4) - Optional        │     │
│  └────────────────────────────────────────────────────┘     │
│                                                               │
│  ┌────────────────────────────────────────────────────┐     │
│  │              Arch Linux Base System                 │     │
│  │  (Kernel, SystemD, Package Manager, Core Utils)    │     │
│  └────────────────────────────────────────────────────┘     │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. Base System (Arch Linux)

**Why Arch Linux?**
- **Rolling Release**: Always access to latest security tools and kernel features
- **Pacman Package Manager**: Fast, efficient, with extensive AUR support
- **Minimal Bloat**: Start with minimal base, add only what's needed
- **Documentation**: Excellent wiki and community support
- **Customization**: Complete control over every aspect

**Key Base Packages:**
- Linux kernel (latest stable)
- SystemD init system
- NetworkManager for connectivity
- Core utilities (GNU coreutils, util-linux)

### 2. Security Tool Suites

Tools are organized into functional suites for easy installation and management:

#### Forensics Suite
- **Autopsy**: Digital forensics platform
- **Sleuthkit**: File system analysis
- **Volatility**: Memory forensics
- **Binwalk**: Firmware analysis
- **Foremost**: File recovery
- **ExifTool**: Metadata extraction

#### Penetration Testing Suite
- **Nmap**: Network discovery
- **Metasploit**: Exploitation framework
- **Burp Suite**: Web application testing
- **SQLMap**: SQL injection
- **Nikto**: Web server scanner
- **Gobuster**: Directory/file brute-forcing

#### Wireless Suite
- **Aircrack-ng**: WiFi security
- **Wifite**: Automated wireless auditing
- **Reaver**: WPS attacks
- **Bully**: WPS brute-forcing

#### Password Suite
- **Hashcat**: GPU password cracking
- **John the Ripper**: Password cracking
- **Hydra**: Network login cracker
- **Medusa**: Parallel brute-forcer
- **Crunch**: Wordlist generator

#### Reverse Engineering Suite
- **Radare2**: Reverse engineering framework
- **Ghidra**: NSA's RE tool
- **GDB**: GNU debugger
- **Strace**: System call tracer

### 3. Sandbox Framework

The sandbox system provides isolated environments for safe experimentation:

```
┌─────────────────────────────────────────────────┐
│            Sandbox Framework                     │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────┐  ┌──────────────┐            │
│  │  Container   │  │  VM-based    │            │
│  │  Sandboxes   │  │  Sandboxes   │            │
│  │ (systemd-    │  │  (QEMU/KVM)  │            │
│  │  nspawn)     │  │              │            │
│  └──────────────┘  └──────────────┘            │
│                                                  │
│  ┌─────────────────────────────────────────┐   │
│  │     Isolation & Resource Management     │   │
│  │  - Network isolation                    │   │
│  │  - Filesystem isolation                 │   │
│  │  - Resource limits (CPU, RAM, Disk)     │   │
│  │  - Snapshot & restore capabilities      │   │
│  └─────────────────────────────────────────┘   │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Sandbox Types:**

1. **Container-based** (systemd-nspawn)
   - Lightweight isolation
   - Quick startup
   - Shared kernel
   - Good for tool testing

2. **VM-based** (QEMU/KVM)
   - Full virtualization
   - Complete OS isolation
   - Support for legacy systems
   - Malware analysis

### 4. Lab Scenario System

Structured learning environments with predefined challenges:

```
Lab Scenario Structure:
├── scenario.yml          # Configuration and metadata
├── setup.sh             # Environment setup script
├── README.md            # Description and objectives
├── resources/           # Files, images, network captures
├── hints/               # Progressive hints
└── solution/            # Solution guide
```

**Lab Categories:**
- Network reconnaissance
- Web application security
- Malware analysis
- Digital forensics
- Privilege escalation
- Wireless attacks
- Reverse engineering

### 5. Management Layer (scorelabs-cli)

Unified command-line interface for system management:

**Functions:**
- Tool suite installation
- Sandbox creation and management
- Lab scenario deployment
- System updates and maintenance
- Configuration management

## Directory Structure

```
/
├── etc/scorelabs/              # Configuration files
│   ├── config.yml              # Main configuration
│   ├── tools/                  # Tool configurations
│   └── labs/                   # Lab configurations
│
├── usr/
│   ├── bin/
│   │   └── scorelabs-cli       # Main CLI tool
│   ├── share/scorelabs/
│   │   ├── labs/               # Lab scenarios
│   │   ├── resources/          # Shared resources
│   │   └── templates/          # Sandbox templates
│   └── lib/scorelabs/          # Libraries and modules
│
└── var/
    └── lib/scorelabs/          # Runtime data
        ├── sandbox/            # Sandbox instances
        ├── labs/               # Active lab environments
        └── cache/              # Downloaded resources
```

## Build System

The build system uses **archiso** to create customized Live ISOs:

```
Build Process:
1. Profile Setup (archiso releng base)
2. Package Selection (packages.x86_64)
3. Custom Configuration (airootfs overlay)
4. Build ISO (mkarchiso)
5. Testing (QEMU/VirtualBox)
6. Release
```

**Key Build Components:**
- `build.sh`: Main build script
- `config/packages.x86_64`: Package list
- `config/airootfs/`: Filesystem overlay
- `config/profiledef.sh`: ISO configuration

## Security Considerations

### System Hardening
- Minimal attack surface (only essential services)
- SELinux/AppArmor support (optional)
- Firewall (iptables/nftables)
- Encrypted storage options

### Sandbox Isolation
- Network namespace isolation
- Filesystem permissions
- Resource quotas
- Mandatory Access Control (MAC)

### Safe Defaults
- Services disabled by default
- Minimal exposed network ports
- User-level execution (non-root when possible)
- Clear warnings for dangerous operations

## Integration Points

### Package Management
- **Pacman**: Core Arch packages
- **AUR**: Community packages
- **Custom repos**: ScoreLabs-specific packages

### Desktop Environment
- **XFCE4**: Lightweight, customizable
- **Alternatives**: i3, KDE, GNOME (user choice)
- **Terminal-only**: Headless server mode

### Networking
- **NetworkManager**: WiFi and wired
- **OpenVPN/WireGuard**: VPN support
- **Tor**: Anonymous connectivity (optional)

## Performance Optimization

- **Fast Boot**: Optimized systemd services
- **Minimal Background**: Only essential daemons
- **SSD Optimized**: TRIM, I/O schedulers
- **Memory Efficiency**: Lightweight tools prioritized

## Extensibility

Users can extend ScoreLabs:
- Custom tool suites
- Additional lab scenarios
- Plugin system for scorelabs-cli
- Community package repository

## Future Architecture Enhancements

- Container orchestration (Kubernetes/Docker Swarm)
- Distributed lab environments
- Cloud deployment options
- Automated update system
- Telemetry and analytics (opt-in)
- GUI management interface

## Related Documentation

- [Installation Guide](installation.md)
- [Tool Reference](tools.md)
- [Sandbox Guide](sandbox.md)
- [Lab Creation Guide](labs/creating-labs.md)
