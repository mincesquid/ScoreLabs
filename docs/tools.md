# ScoreLabs Tool Reference

A comprehensive guide to security tools included in ScoreLabs.

## Tool Categories

### Network Discovery & Scanning
- **Nmap** - Network exploration and security auditing
- **Masscan** - Fast port scanner
- **Rustscan** - Modern port scanner
- **DNSenum** - DNS enumeration
- **Fierce** - DNS reconnaissance

### Web Application Testing
- **Burp Suite** - Web application security testing
- **OWASP ZAP** - Web app vulnerability scanner
- **SQLMap** - Automatic SQL injection
- **Nikto** - Web server scanner
- **Gobuster** - Directory/file brute-forcing
- **Ffuf** - Fast web fuzzer

### Password Attacks
- **Hashcat** - Advanced password recovery
- **John the Ripper** - Password cracker
- **Hydra** - Network login cracker
- **Medusa** - Parallel brute-forcer
- **Crunch** - Wordlist generator

### Wireless Security
- **Aircrack-ng** - WiFi security suite
- **Wifite** - Automated wireless auditing
- **Reaver** - WPS attack tool
- **Bully** - WPS brute-force

### Digital Forensics
- **Autopsy** - Digital forensics platform
- **Sleuthkit** - File system analysis
- **Volatility** - Memory forensics
- **Binwalk** - Firmware analysis
- **Foremost** - File carving
- **ExifTool** - Metadata extraction

### Reverse Engineering
- **Radare2** - Reverse engineering framework
- **Ghidra** - Software reverse engineering
- **GDB** - GNU debugger
- **Strace** - System call tracer

### Exploitation
- **Metasploit** - Penetration testing framework
- **ExploitDB** - Exploit database
- **Searchsploit** - Local exploit search

### Network Analysis
- **Wireshark** - Network protocol analyzer
- **tcpdump** - Packet analyzer
- **Ettercap** - Network interceptor
- **Bettercap** - Network attack toolkit

### System Analysis
- **Lynis** - Security auditing
- **Rkhunter** - Rootkit detection
- **ClamAV** - Antivirus
- **Chkrootkit** - Rootkit checker

## Quick Reference by Suite

### Forensics Suite
```bash
scorelabs-cli install --suite forensics
```
Includes: autopsy, sleuthkit, volatility3, binwalk, foremost, exiftool

### Pentesting Suite
```bash
scorelabs-cli install --suite pentesting
```
Includes: nmap, metasploit, burpsuite, sqlmap, nikto, gobuster

### Wireless Suite
```bash
scorelabs-cli install --suite wireless
```
Includes: aircrack-ng, wifite, reaver, bully

### Password Suite
```bash
scorelabs-cli install --suite password
```
Includes: hashcat, john, hydra, medusa, crunch

For detailed usage of each tool, see the individual tool documentation pages.
