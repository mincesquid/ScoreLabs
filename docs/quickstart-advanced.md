# Quickstart — Advanced (Experienced Users)

This page is a single-page fast path for experienced users who already know Docker/QEMU and want to get ScoreLabs built and labs running quickly.

1. Clone and change directory

```bash
git clone https://github.com/yourusername/scorelabs.git
cd scorelabs
```

1. Build the project with Docker (recommended on macOS)

```bash
# Build using Docker Compose
docker-compose up --build scorelabs-build
```

1. Start a lab quickly

```bash
# List available labs
./scripts/scorelabs-cli lab list

# Start the 'intro-to-nmap' lab
./scripts/scorelabs-cli lab start intro-to-nmap
```

1. Quick scan tips (for labs that require discovery)

```bash
# Fast top ports
nmap -T4 -F -n --open <target-ip>

# aggressive full port scan, then service detection
sudo nmap -p- -T4 --min-rate 500 -n --open <target-ip>

# masscan helper included in the repo (seed ports for nmap):
cd labs/scenarios/intro-to-nmap/tools
sudo ./masscan-scan.sh <target-ip> --rate 1000 --out quickscan
```

1. Fast shellcheck and lint prior to commit

```bash
# Local shellcheck script
chmod +x scripts/checks/run-shellcheck.sh
./scripts/checks/run-shellcheck.sh

# Markdown lint via CI or local npm install
npm install -g markdownlint-cli
markdownlint "**/*.md"
```

1. Quick troubleshooting

- If Docker fails, check Docker Desktop logs, increase RAM/CPU assigned.
- If masscan requires root, prefix command with `sudo`.
- Use `scorelabs-cli lab info` for connection info.

1. Where to find more details

- Full installation: `docs/installation.md`
- Scenarios: `docs/labs/README.md` and individual `labs/scenarios/*/README.md`
- Troubleshooting FAQ: `docs/troubleshooting.md`
