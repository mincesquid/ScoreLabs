# PR summary

This PR contains updates that introduce a fast port discovery workflow for labs and improves developer tooling / docs.

- Key changes:

- Adds `masscan-scan.sh` helper for masscan -> nmap (fast discovery -> targeted fingerprinting).
- Adds `scripts/detect-networks.sh` to detect container networks (prefers podman, fallback Docker).
- Updates `docs/installation.md` and `lab` hints with macOS and scanning tips.
- Adds helper docs in `labs/scenarios/intro-to-nmap/tools/README.md`.

## Checklist

- [ ] Changes are tested locally (if applicable)
- [ ] New scripts include basic usage & help
- [ ] Documentation updated
- [ ] Shell scripts pass ShellCheck (see CI results)
- [ ] Markdown linting passes (see CI results)

## How to test

1. Run the `masscan-scan.sh` helper (requires masscan & nmap):

```bash
cd labs/scenarios/intro-to-nmap/tools
chmod +x masscan-scan.sh
sudo ./masscan-scan.sh 10.0.100.11 --rate 1000 --out quickscan
 
1. Check network detection helper:

```bash
chmod +x scripts/detect-networks.sh
./scripts/detect-networks.sh
```

1. Run shellcheck locally (optional):

```bash
./scripts/checks/run-shellcheck.sh
```

## Notes

- `masscan` is powerful and may generate high network load; only scan authorized targets.
- This PR adds CI to surface ShellCheck and lint warnings before merging.
- This PR adds CI to surface ShellCheck and lint warnings before merging.
