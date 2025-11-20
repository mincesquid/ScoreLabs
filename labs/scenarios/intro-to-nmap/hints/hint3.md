# Hint 3

Services don't always run on their default ports. To find hidden services on high ports, you need to scan beyond the standard port range.

Use the `-p` flag to specify a port range:

```bash
nmap -p 10000-65535 10.0.100.11
```

Or scan all 65,535 ports with:

```bash
nmap -p- 10.0.100.11
```

Be patient - full port scans take time. Once you find the open port, use `-sV` to identify the service.

## Faster scan tips and troubleshooting

If a full port scan seems to hang, or if you need results quickly, try these techniques:

### Scan the top ports first (fast)

```bash
nmap -T4 -F -n --open 10.0.100.11
```

- `-F` limits to the top 100 ports so it runs quickly.
- `-T4` speeds up timing; `-T5` is more aggressive and can be noisy.
- `-n` disables DNS resolution to avoid delays.

### Aggressive full-port scans with timing and rate limits

```bash
sudo nmap -p- -T4 --min-rate 500 -n --open 10.0.100.11
```

- `--min-rate 500` forces at least 500 packets per second (tune to your network). Use a lower rate if you see packet loss.
- `--open` shows only open ports so output is easier to parse.

### Reduce retransmissions and timeouts

```bash
nmap -p- -T4 --max-retries 2 --host-timeout 3m 10.0.100.11
```

- If the host blocks ping/ICMP, treat it as up to skip host discovery delays:

```bash
nmap -Pn -p- -T4 10.0.100.11
```

- Use `-sS` (SYN) scan for speed and stealth (requires root); `-sT` (connect) is slower but works when you don't have privileges.

Massive scans: If you need extreme speed, `masscan` can scan millions of ports per second. Use it carefully and only on targets you own or are authorized to test:

```bash
sudo masscan -p1-65535 --rate 1000 10.0.100.11 -oG masscan.gnmap
# Then run nmap only on the discovered ports for service detection:
nmap -p <comma-separated-ports> -sV 10.0.100.11

Tip: This repository includes a helper script at `labs/scenarios/intro-to-nmap/tools/masscan-scan.sh` that runs a masscan scan, extracts the open ports, and then runs `nmap -sV` against them.

Example usage:

```bash
cd labs/scenarios/intro-to-nmap/tools
chmod +x masscan-scan.sh
sudo ./masscan-scan.sh 10.0.100.11 --rate 1000 --out quickscan
```

### Why does nmap hang?

### How to diagnose hanging

- Use `--packet-trace` or `-d` to see timestamps and where probes are waiting
- Try `--reason` to show why nmap considers a port open/closed/filtered

Workflow example (fast-to-slow):

1. Quick check of top ports:

```bash
nmap -T4 -F -n --open 10.0.100.11
```

1. Aggressive full-range scan only if needed:

```bash
sudo nmap -p- -T4 --min-rate 500 -n --open 10.0.100.11
```

1. Service fingerprint open ports:

```bash
nmap -p <ports_from_step_2> -sV --version-light -T4 10.0.100.11
```

These steps let you find hidden services efficiently without waiting for a full slow scan upfront.
