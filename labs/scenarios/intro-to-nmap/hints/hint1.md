# Hint 1

Start with basic host discovery to see what's alive on the network.

Try using Nmap's ping scan feature:
```bash
nmap -sn 10.0.100.0/24
```

This will show you all active hosts without scanning their ports.
