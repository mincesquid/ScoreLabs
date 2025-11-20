# Introduction to Nmap - Solution Walkthrough

⚠️ **Spoiler Warning**: This document contains complete solutions to the lab. Only refer to this after attempting the lab yourself or if you're completely stuck.

---

## Task 1: Host Discovery (100 points)

**Objective**: Identify all live hosts on the 10.0.100.0/24 network

### Solution

```bash
nmap -sn 10.0.100.0/24
```

### Expected Output

```
Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for 10.0.100.1
Host is up (0.00012s latency).
Nmap scan report for 10.0.100.10
Host is up (0.00015s latency).
Nmap scan report for 10.0.100.11
Host is up (0.00018s latency).
Nmap scan report for 10.0.100.12
Host is up (0.00014s latency).
Nmap done: 256 IP addresses (4 hosts up) scanned in 2.54 seconds
```

### Explanation

The `-sn` flag tells Nmap to perform a "ping scan" which discovers hosts without scanning ports. This is useful for initial network reconnaissance.

**Flag**: `flag{4}`

---

## Task 2: Web Server Analysis (150 points)

**Objective**: Identify web server software and version on 10.0.100.10

### Solution

```bash
nmap -sV -p 80,443 10.0.100.10
```

### Expected Output

```
Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for 10.0.100.10
Host is up (0.00012s latency).

PORT    STATE SERVICE VERSION
80/tcp  open  http    nginx 1.18.0
443/tcp open  https   nginx 1.18.0

Service detection performed. Please report any incorrect results.
Nmap done: 1 IP address (1 host up) scanned in 8.23 seconds
```

### Explanation

The `-sV` flag enables version detection, which probes open ports to determine what service and version is running. This is crucial for identifying potential vulnerabilities.

**Flag**: `flag{nginx/1.18.0}`

---

## Task 3: Hidden Service Discovery (200 points)

**Objective**: Find hidden service on high port (>10000) on 10.0.100.11

### Solution

```bash
nmap -p 10000-65535 10.0.100.11
```

Or scan all ports:

```bash
nmap -p- 10.0.100.11
```

### Expected Output

```
Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for 10.0.100.11
Host is up (0.00015s latency).

PORT      STATE SERVICE
12345/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 42.34 seconds
```

To identify the service:

```bash
nmap -sV -p 12345 10.0.100.11
```

```
PORT      STATE SERVICE VERSION
12345/tcp open  mongodb MongoDB 4.4.0
```

### Explanation

Not all services run on their default ports. Attackers often run services on non-standard ports to avoid detection. Always scan the full port range when doing thorough reconnaissance.

**Flag**: `flag{12345:mongodb}`

---

## Task 4: Operating System Detection (150 points)

**Objective**: Identify OS of file server (10.0.100.12)

### Solution

```bash
sudo nmap -O 10.0.100.12
```

### Expected Output

```
Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for 10.0.100.12
Host is up (0.00014s latency).
Not shown: 995 closed tcp ports (reset)

PORT    STATE SERVICE
21/tcp  open  ftp
22/tcp  open  ssh
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds

Device type: general purpose
Running: Linux 4.X|5.X
OS CPE: cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:5
OS details: Linux 4.15 - 5.6, Ubuntu 18.04
Network Distance: 0 hops

OS detection performed. Please report any incorrect results.
Nmap done: 1 IP address (1 host up) scanned in 5.43 seconds
```

### Explanation

OS detection (`-O`) uses TCP/IP stack fingerprinting to guess the operating system. It requires root privileges and open/closed ports to be accurate. Nmap compares the target's responses to a database of known OS signatures.

**Flag**: `flag{Ubuntu_18.04}`

---

## Task 5: Stealth Scanning (200 points)

**Objective**: Perform a SYN stealth scan

### Solution

```bash
sudo nmap -sS 10.0.100.10
```

### Expected Output

```
Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for 10.0.100.10
Host is up (0.00011s latency).
Not shown: 997 closed tcp ports (reset)

PORT    STATE SERVICE
22/tcp  open  ssh
80/tcp  open  http
443/tcp open  https

Nmap done: 1 IP address (1 host up) scanned in 0.24 seconds
```

### Explanation

A SYN scan (also called "half-open" scan) sends a SYN packet and waits for a SYN-ACK response, but never completes the three-way handshake by sending the final ACK. This makes it:

1. **Stealthier**: Doesn't complete connections, so may not be logged
2. **Faster**: Doesn't need to complete handshakes
3. **Requires root**: Needs raw socket access to craft SYN packets

The scan determines port state:
- **Open**: Receives SYN-ACK (sends RST to close)
- **Closed**: Receives RST
- **Filtered**: No response or ICMP unreachable

**Flag**: `flag{SYN_stealth}`

---

## Additional Learning

### Complete Scan Example

For comprehensive reconnaissance, combine multiple techniques:

```bash
sudo nmap -sS -sV -O -A -p- -T4 -oA complete-scan 10.0.100.0/24
```

Breakdown:
- `-sS`: SYN stealth scan
- `-sV`: Version detection
- `-O`: OS detection
- `-A`: Aggressive scan (includes scripts, traceroute, etc.)
- `-p-`: All ports
- `-T4`: Aggressive timing
- `-oA`: Output to all formats (normal, XML, grepable)

### Nmap Scripting Engine (NSE)

Nmap includes powerful scripts for vulnerability detection:

```bash
# Run default scripts
nmap --script=default 10.0.100.10

# Check for specific vulnerabilities
nmap --script=vuln 10.0.100.10

# HTTP enumeration
nmap --script=http-enum 10.0.100.10

# SMB enumeration
nmap --script=smb-enum-shares 10.0.100.12
```

### Scan Timing Comparison

```bash
# Paranoid (very slow, IDS evasion)
nmap -T0 10.0.100.10

# Sneaky (slow, IDS evasion)
nmap -T1 10.0.100.10

# Polite (slow, less bandwidth)
nmap -T2 10.0.100.10

# Normal (default)
nmap -T3 10.0.100.10

# Aggressive (fast, assumes fast network)
nmap -T4 10.0.100.10

# Insane (very fast, may miss results)
nmap -T5 10.0.100.10
```

### Evasion Techniques

```bash
# Fragment packets
nmap -f 10.0.100.10

# Use decoys
nmap -D RND:10 10.0.100.10

# Spoof source IP
nmap -S <spoofed-ip> 10.0.100.10

# Randomize scan order
nmap --randomize-hosts 10.0.100.0/24
```

---

## Common Mistakes

1. **Not using sudo for advanced scans**: OS detection and SYN scans require root
2. **Scanning too aggressively**: Can crash services or trigger alarms
3. **Not saving output**: Always use `-oA` to save results
4. **Ignoring filtered ports**: May indicate firewall rules
5. **Trusting version detection completely**: Not always 100% accurate

---

## Key Takeaways

✅ Host discovery is the first step in network reconnaissance
✅ Service version detection helps identify vulnerabilities
✅ Not all services run on standard ports
✅ OS detection provides valuable target information
✅ SYN scans are stealthier than full connects
✅ Timing and evasion techniques are important for real-world scenarios
✅ Always have proper authorization before scanning

---

## Next Steps

Now that you've mastered basic Nmap usage, consider:

1. **Advanced Nmap Lab**: NSE scripts, advanced evasion, custom scans
2. **Network Vulnerability Scanning**: Tools like Nessus, OpenVAS, Nikto
3. **Wireless Network Scanning**: Aircrack-ng, Kismet
4. **Web Application Scanning**: Burp Suite, OWASP ZAP
5. **Exploitation**: Metasploit, manual exploitation techniques

---

**Congratulations on completing the lab!** 🎉

You've taken your first steps into network reconnaissance. Remember: with great power comes great responsibility. Always scan ethically and legally.
