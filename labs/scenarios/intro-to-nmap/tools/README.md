Masscan helper
===============

This folder contains `masscan-scan.sh`, a small helper script to perform a fast masscan scan and then run `nmap` on discovered ports for service/version detection.

Usage
-----

```bash
# Basic usage (requires sudo for masscan):
chmod +x masscan-scan.sh
./masscan-scan.sh 10.0.100.11

# Configure packet rate and ports:
./masscan-scan.sh 10.0.100.11 --rate 1000 --ports 1-65535 --out myscan

# Run nmap with additional options:
./masscan-scan.sh 10.0.100.11 --nmap-opts "-sC -A"
```

Safety & Recommendations
------------------------
- `masscan` is very fast and can be disruptive; only scan hosts you own or have written permission to test.
- Use the `--rate` option to keep traffic within acceptable levels on your network.
- On macOS, install `masscan` with `brew install masscan` and `nmap` with `brew install nmap`.

Outputs
-------
- `*.gnmap`: masscan grepable results
- `*.nmap`: `nmap` service detection results

If you'd like a version that uses JSON output from masscan and coordinates results across multiple targets, let me know — I can extend the helper to support batches and output parsing.
