# ScoreLabs Troubleshooting & FAQ

This file lists common problems, error messages, and solutions to help users get up and running.

## Podman / Docker: "podman: command not found"

- Problem: A script tries to run `podman` but it isn't installed.
- Solution: Install Podman or Docker on macOS (prefer Docker desktop). We provide a helper `scripts/detect-networks.sh` that can fallback to Docker if Podman is not present.

## masscan: requires sudo / "Permission denied"

- Problem: `masscan` performs raw packet injection and requires elevated privileges.
- Solution: Run masscan with sudo, or configure CAP_NET_RAW capabilities. Example:

```bash
sudo masscan -p1-65535 --rate 1000 10.0.100.11 -oG masscan.gnmap
```

## Nmap "hangs" or scans are slow

- Problem: full port scans can take a long time due to timeouts, net filters, or slow script probes.
- Quick fixes:
  - Use `-T4` or `--min-rate` for more aggressive timing
  - Disable DNS with `-n`
  - Use `nmap -sS` for faster SYN scans (requires root)
  - Use `-Pn` if host discovery is blocked
  - Use `masscan` to seed ports for `nmap` as suggested in the `intro-to-nmap` tools

## QEMU/KVM VM does not start

- Problem: `qemu-system-x86_64` fails with `could not set KVM` or `unable to open /dev/kvm`.
- Solution: Ensure KVM is available and enabled (Linux host), or use Docker / macOS VM. On macOS, use Hypervisor.framework alternatives like UTM.

## pacman / archiso build errors while running on non-Arch distro

- Problem: `build.sh` expects `pacman` and archiso tools, causing errors on non-Arch hosts.
- Solution: Use Docker on macOS as described in `docs/installation.md` or run the build on an actual Arch Linux environment.

## Sandbox `systemd-nspawn` or `qemu` problems

- Problem: sandbox start may fail because of missing host capabilities, misconfigured network or insufficient permissions.
- Solution: Ensure systemd is present and you have required permissions; check logs in `/var/log` and container logs from `machinectl` or QEMU monitor.

## General troubleshooting tips

- Use `-v` or `-vv` on nmap for verbose progress and `--packet-trace` to debug network probes
- Check system logs and journalctl for sandbox/service failures
- Ensure required tools (nmap, masscan, docker/podman) are installed and on PATH
- If in a corporate environment, proxy/firewall may block ICMP/TCP probes; try a different network

If you encounter an issue not listed here, open a GitHub issue with logs and steps to reproduce so the team can triage it.
