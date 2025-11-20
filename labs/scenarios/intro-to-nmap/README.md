# Introduction to Network Scanning Lab

## Overview

This lab introduces you to network scanning fundamentals using Nmap, one of the most popular network discovery and security auditing tools. You'll learn how to discover hosts, identify open ports, detect services, and fingerprint operating systems.

## Learning Objectives

By the end of this lab, you will be able to:
- Perform host discovery on a network
- Scan for open ports using various techniques
- Detect service versions running on open ports
- Identify operating systems through fingerprinting
- Understand the difference between various scan types
- Apply stealth techniques to avoid detection

## Lab Environment

You have access to a simulated network (10.0.100.0/24) with several systems:
- Web Server (10.0.100.10)
- Database Server (10.0.100.11)
- File Server (10.0.100.12)
- Router (10.0.100.1)

## Prerequisites

- Basic understanding of TCP/IP networking
- Familiarity with Linux command line
- Understanding of common network ports and services

## Tasks

### Task 1: Host Discovery (100 points)

**Objective**: Identify all live hosts on the network

The first step in any network assessment is discovering which hosts are active. Use Nmap's ping scan to identify all live systems on the 10.0.100.0/24 network.

**Command hint**: `nmap -sn <network>`

**Question**: How many live hosts are on the network?

**Flag format**: `flag{number}`

---

### Task 2: Web Server Analysis (150 points)

**Objective**: Identify the web server software and version

Once you know which hosts are alive, the next step is to identify what services they're running. Focus on the web server at 10.0.100.10 and determine what web server software and version it's using.

**Command hint**: `nmap -sV -p 80,443 <target>`

**Question**: What web server software and version is running?

**Flag format**: `flag{server/version}`

---

### Task 3: Hidden Service Discovery (200 points)

**Objective**: Find a hidden service on a high port

Not all services run on standard ports. The database server (10.0.100.11) is running a hidden service on a port above 10000. Your job is to find it.

**Command hint**: `nmap -p 10000-65535 <target>`

**Question**: What port and service did you find?

**Flag format**: `flag{port:service}`

---

### Task 4: Operating System Detection (150 points)

**Objective**: Identify the OS of the file server

Operating system detection can provide valuable information about a target. Use Nmap's OS detection to identify the operating system running on the file server (10.0.100.12).

**Command hint**: `sudo nmap -O <target>`

**Note**: OS detection requires root/sudo privileges.

**Question**: What operating system is the file server running?

**Flag format**: `flag{OS_Version}`

---

### Task 5: Stealth Scanning (200 points)

**Objective**: Perform a SYN stealth scan

Different scan types have different characteristics. A SYN scan (half-open scan) doesn't complete the TCP handshake, making it stealthier than a full connect scan.

**Command hint**: `sudo nmap -sS <target>`

**Question**: What scan technique did you use?

**Flag format**: `flag{scan_technique}`

---

## Nmap Quick Reference

### Common Scan Types
```bash
-sn              # Ping scan (no port scan)
-sS              # SYN scan (stealth)
-sT              # TCP connect scan
-sU              # UDP scan
-sV              # Service version detection
-O               # OS detection
-A               # Aggressive scan (OS, version, scripts)
```

### Port Specification
```bash
-p 22            # Scan specific port
-p 22,80,443     # Scan multiple ports
-p 1-1000        # Scan port range
-p-              # Scan all 65535 ports
--top-ports 100  # Scan top 100 most common ports
```

### Timing and Performance
```bash
-T0              # Paranoid (slowest)
-T1              # Sneaky
-T2              # Polite
-T3              # Normal (default)
-T4              # Aggressive
-T5              # Insane (fastest)
```

### Output Options
```bash
-oN file.txt     # Normal output
-oX file.xml     # XML output
-oG file.txt     # Grepable output
-oA basename     # All formats
-v               # Verbose
-vv              # Very verbose
```

## Tips and Best Practices

1. **Start Broad, Then Focus**: Begin with host discovery, then narrow down to specific ports and services

2. **Use Appropriate Timing**: Don't always use `-T5`. Slower scans are often more accurate and less likely to be detected

3. **Read the Output Carefully**: Nmap provides a lot of information. Take time to understand what it's telling you

4. **Combine Flags**: Many scans benefit from combining multiple options, e.g., `nmap -sV -O -A target`

5. **Use Verbose Mode**: The `-v` flag provides real-time feedback during long scans

6. **Save Your Output**: Always save scan results with `-oA` for later analysis

## Common Pitfalls

- **Forgetting sudo**: OS detection and some scan types require root privileges
- **Scanning too fast**: Aggressive scans can miss results or trigger IDS
- **Not scanning all ports**: The `-p-` flag ensures you don't miss high-numbered ports
- **Ignoring documentation**: Use `man nmap` or `nmap --help` when unsure

## Verification Commands

```bash
# Verify your scan results
nmap -sn 10.0.100.0/24                    # Task 1
nmap -sV -p 80,443 10.0.100.10           # Task 2
nmap -p- 10.0.100.11                     # Task 3
sudo nmap -O 10.0.100.12                 # Task 4
sudo nmap -sS 10.0.100.10                # Task 5
```

## Submission

Submit each flag as you complete the tasks:

```bash
scorelabs-cli lab submit intro-to-nmap "flag{your_answer}"
```

Check your progress:

```bash
scorelabs-cli lab progress intro-to-nmap
```

## Need Help?

If you're stuck, you can request hints:

```bash
scorelabs-cli lab hint intro-to-nmap
```

Hints are provided progressively and won't give away the entire solution.

## Completion

Once you've completed all tasks and submitted all flags, you'll receive a completion certificate and can move on to more advanced network scanning labs.

## Next Steps

After completing this lab, consider:
- **Advanced Nmap**: Learn about NSE scripts, advanced scan techniques
- **Network Vulnerability Scanning**: Use tools like Nessus or OpenVAS
- **Network Mapping**: Create comprehensive network diagrams
- **IDS/IPS Evasion**: Learn techniques to avoid detection

---

**Legal Notice**: This lab environment is for educational purposes only. Only scan networks and systems you have explicit permission to test. Unauthorized scanning is illegal.

**Time Estimate**: 30-45 minutes

**Difficulty**: Beginner

**Points**: 800 total

Good luck! 🎯
