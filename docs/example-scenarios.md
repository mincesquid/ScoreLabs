# Example Scenarios — Step-by-step walkthroughs

This page contains full walkthroughs for common tasks in ScoreLabs.

## Scenario 1: Build the ScoreLabs ISO using Docker (macOS)

1. Clone repository and change directory

```bash
git clone https://github.com/yourusername/scorelabs.git
cd scorelabs
```

1. Prepare Docker

```bash
# Make sure Docker Desktop is installed and running
docker --version
```

1. Build inside Docker (this runs pacman and archiso inside an Arch container)

```bash
# runs the build environment and compiles the ISO
docker-compose up --build scorelabs-build
```

1. Find the artifact

```bash
ls -lh build/output/*.iso
```

1. Optional: test with qemu

```bash
./scripts/test-vm.sh --run-vm
```

Troubleshooting tips

- Permission denied for docker socket: ensure you have permission or run with `sudo` on Linux.
- Use `docker-compose logs scorelabs-build` for logs when build fails.

---

## Scenario 2: Start a lab (Docker + masscan discovery)

1. Start the lab environment

```bash
# Start the lab environment using scorelabs-cli
./scripts/scorelabs-cli lab start intro-to-nmap
```

1. Get the lab target IP address

```bash
scorelabs-cli lab info intro-to-nmap
```

1. Quick masscan to find open ports (fast & cautious rate)

```bash
cd labs/scenarios/intro-to-nmap/tools
sudo ./masscan-scan.sh 10.0.100.11 --rate 250 --out quickscan
```

1. Fingerprint discovered ports

- The `masscan-scan.sh` helper runs `nmap -sV` on discovered ports and outputs a `.nmap` file with the results.

1. Post-scan

- Give hints through the lab or run `scorelabs-cli lab hint intro-to-nmap` for directional hints.
- Submit flags with `scorelabs-cli lab submit intro-to-nmap "flag{...}"`

Troubleshooting tips

- Masscan returned no ports: try a lower `--rate` or ensure the target is reachable (check `scorelabs-cli lab info`)
- masscan requires `sudo`: prefix with `sudo` and ensure you are allowed to run masscan on your network.
