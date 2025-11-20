# ScoreLabs Sandbox System

## Overview

The ScoreLabs sandbox system provides isolated, controlled environments for safe security research, malware analysis, and hands-on experimentation. Sandboxes can be used to test tools, analyze suspicious files, or simulate compromised systems without risk to your host.

## Sandbox Types

### Container Sandboxes (systemd-nspawn)

**Best for:**
- Quick tool testing
- Isolated command-line environments
- Network service testing
- Lightweight isolation

**Features:**
- Fast startup (seconds)
- Shared kernel with host
- Minimal resource overhead
- Easy snapshot/restore

**Limitations:**
- Kernel-level vulnerabilities affect host
- Limited GUI support
- Same architecture as host

### VM Sandboxes (QEMU/KVM)

**Best for:**
- Malware analysis
- Full OS simulation
- Legacy system testing
- Complete isolation

**Features:**
- Full virtualization
- Run different OS/architectures
- Hardware emulation
- Complete network isolation

**Limitations:**
- Higher resource usage
- Slower startup
- More complex setup

## Quick Start

### Create a Sandbox

```bash
# Container sandbox (default)
scorelabs-cli sandbox create my-test-env

# VM sandbox
scorelabs-cli sandbox create malware-lab --type vm --os ubuntu-20.04

# With specific resources
scorelabs-cli sandbox create forensics-lab --ram 4096 --cpu 2 --disk 20G
```

### List Sandboxes

```bash
scorelabs-cli sandbox list
```

### Start a Sandbox

```bash
scorelabs-cli sandbox start my-test-env
```

### Access a Sandbox

```bash
# Container
scorelabs-cli sandbox shell my-test-env

# VM (SSH)
scorelabs-cli sandbox ssh malware-lab
```

### Stop a Sandbox

```bash
scorelabs-cli sandbox stop my-test-env
```

### Delete a Sandbox

```bash
scorelabs-cli sandbox delete my-test-env
```

## Advanced Usage

### Network Isolation

Sandboxes support various network modes:

```bash
# Completely isolated (no network)
scorelabs-cli sandbox create isolated-env --network none

# NAT (outbound only, default)
scorelabs-cli sandbox create nat-env --network nat

# Bridged (full network access)
scorelabs-cli sandbox create bridge-env --network bridge

# Internal network (sandboxes can communicate)
scorelabs-cli sandbox create net1 --network internal:testnet
scorelabs-cli sandbox create net2 --network internal:testnet
```

### Snapshots

Save and restore sandbox states:

```bash
# Create snapshot
scorelabs-cli sandbox snapshot my-test-env snap1

# List snapshots
scorelabs-cli sandbox snapshots my-test-env

# Restore snapshot
scorelabs-cli sandbox restore my-test-env snap1

# Delete snapshot
scorelabs-cli sandbox snapshot-delete my-test-env snap1
```

### File Sharing

Share files between host and sandbox:

```bash
# Mount host directory in sandbox
scorelabs-cli sandbox mount my-test-env /path/on/host /path/in/sandbox

# Copy files
scorelabs-cli sandbox copy myfile.txt my-test-env:/root/

# Copy from sandbox
scorelabs-cli sandbox copy my-test-env:/var/log/app.log ./
```

### Resource Limits

Control sandbox resource usage:

```bash
# Set CPU limit (percentage)
scorelabs-cli sandbox config my-test-env --cpu-limit 50

# Set memory limit
scorelabs-cli sandbox config my-test-env --memory 2048M

# Set disk quota
scorelabs-cli sandbox config my-test-env --disk-quota 10G

# Set network bandwidth
scorelabs-cli sandbox config my-test-env --bandwidth 1mbit
```

## Malware Analysis Sandbox

Special precautions for malware analysis:

### Creating a Malware Analysis Environment

```bash
# Create isolated Windows VM
scorelabs-cli sandbox create malware-win --type vm \
  --os windows-10 \
  --network none \
  --snapshot auto

# Install analysis tools
scorelabs-cli sandbox exec malware-win -- install-tools
```

### Safety Features

1. **Network Isolation**: No external connectivity by default
2. **Snapshots**: Automatic snapshots before execution
3. **Time Limits**: Automatic shutdown after analysis period
4. **Monitoring**: Capture all system calls and network attempts
5. **Cleanup**: Secure deletion of malware after analysis

### Example Malware Analysis Workflow

```bash
# 1. Create snapshot
scorelabs-cli sandbox snapshot malware-win clean-state

# 2. Copy malware to sandbox
scorelabs-cli sandbox copy suspicious.exe malware-win:/analysis/

# 3. Start monitoring
scorelabs-cli sandbox monitor malware-win --output analysis.log

# 4. Execute malware
scorelabs-cli sandbox exec malware-win -- /analysis/suspicious.exe

# 5. Analyze results
scorelabs-cli sandbox export malware-win /analysis/results/ ./results/

# 6. Restore clean state
scorelabs-cli sandbox restore malware-win clean-state
```

## Predefined Sandbox Templates

### Forensics Sandbox

```bash
scorelabs-cli sandbox create forensics --template forensics
```

Includes:
- Autopsy, Sleuthkit
- Volatility3
- Various forensics tools
- Mounted evidence directory

### Web Testing Sandbox

```bash
scorelabs-cli sandbox create webtest --template web-testing
```

Includes:
- Burp Suite, OWASP ZAP
- SQLMap, Nikto
- Preconfigured proxy settings
- Vulnerable web apps for testing

### Network Analysis Sandbox

```bash
scorelabs-cli sandbox create netmon --template network
```

Includes:
- Wireshark, tcpdump
- nmap, masscan
- Network taps configured
- Sample PCAPs

## Container Sandbox Details

### Implementation (systemd-nspawn)

ScoreLabs uses systemd-nspawn for container sandboxes:

```bash
# Manual creation (advanced)
sudo systemd-nspawn -D /var/lib/scorelabs/sandbox/my-env \
  --boot \
  --network-veth \
  --bind=/tmp/shared:/shared
```

### Container Configuration

Located at `/var/lib/scorelabs/sandbox/NAME/config`:

```ini
[Container]
Boot=yes
NetworkVeth=yes
PrivateUsers=yes

[Network]
Zone=sandbox

[Files]
BindReadOnly=/etc/resolv.conf
```

## VM Sandbox Details

### Implementation (QEMU/KVM)

ScoreLabs uses QEMU with KVM acceleration:

```bash
# Manual VM start (advanced)
qemu-system-x86_64 \
  -enable-kvm \
  -m 2048 \
  -smp 2 \
  -drive file=/var/lib/scorelabs/sandbox/vm.qcow2,format=qcow2 \
  -net nic -net user,restrict=on \
  -display none \
  -daemonize
```

### VM Configuration

Located at `/var/lib/scorelabs/sandbox/NAME/vm.conf`:

```yaml
name: malware-lab
type: vm
os: windows-10
resources:
  memory: 4096
  cpu: 2
  disk: 20G
network:
  mode: none
  interfaces:
    - type: isolated
snapshots:
  auto: true
  on_shutdown: true
```

## Security Considerations

### Container Isolation Limits

⚠️ **Warning**: Containers share the kernel with the host

- Kernel exploits can escape container
- Not suitable for untrusted code execution
- Use VM sandboxes for malware analysis

### VM Isolation

✅ **Strong isolation** for malware analysis

- Separate kernel
- Hardware virtualization
- Network can be completely isolated
- Snapshots provide clean rollback

### Best Practices

1. **Never Trust Sandboxes Completely**: Defense in depth
2. **Use Snapshots**: Before risky operations
3. **Network Isolation**: Default to no network for malware
4. **Monitor Resources**: Prevent DoS attacks
5. **Regular Updates**: Keep sandbox images updated
6. **Audit Logs**: Review sandbox activity
7. **Secure Deletion**: Properly delete malware after analysis

## Troubleshooting

### Sandbox Won't Start

```bash
# Check logs
journalctl -u scorelabs-sandbox@NAME

# Verify resources
scorelabs-cli sandbox status NAME

# Reset sandbox
scorelabs-cli sandbox reset NAME
```

### Network Issues

```bash
# Check network configuration
scorelabs-cli sandbox network NAME

# Restart network
scorelabs-cli sandbox exec NAME -- systemctl restart NetworkManager
```

### Performance Issues

```bash
# Check resource usage
scorelabs-cli sandbox stats NAME

# Increase resources
scorelabs-cli sandbox config NAME --memory 4096 --cpu 2
```

## API and Scripting

### Python API

```python
from scorelabs.sandbox import Sandbox

# Create sandbox
sb = Sandbox.create("my-env", type="container")
sb.start()

# Execute command
result = sb.exec(["nmap", "-sV", "target.com"])

# Snapshot
sb.snapshot("before-test")

# Cleanup
sb.restore("before-test")
sb.stop()
```

### Bash Scripting

```bash
#!/bin/bash

# Automated testing in sandbox
sandbox_name="test-$(date +%s)"

scorelabs-cli sandbox create "$sandbox_name"
scorelabs-cli sandbox start "$sandbox_name"

# Run tests
scorelabs-cli sandbox exec "$sandbox_name" -- ./run-tests.sh

# Collect results
scorelabs-cli sandbox copy "$sandbox_name:/results/" ./results/

# Cleanup
scorelabs-cli sandbox delete "$sandbox_name"
```

## Additional Resources

- [Lab Scenarios](labs/README.md) - Pre-built sandbox exercises
- [Tool Reference](tools.md) - Tools available in sandboxes
- [API Documentation](api/sandbox.md) - Full API reference

## Support

For issues with the sandbox system:
- Check logs: `/var/log/scorelabs/sandbox.log`
- Report bugs: GitHub Issues
- Community: Join our chat
