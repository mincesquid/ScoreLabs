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
