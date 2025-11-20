# ScoreLabs Lab Scenarios

Lab scenarios provide structured, hands-on learning experiences in safe, isolated environments. Each lab focuses on specific security concepts, tools, or techniques.

## Available Labs

### Beginner Labs

#### 1. Introduction to Network Scanning
**Objective**: Learn basic network reconnaissance with Nmap
**Duration**: 30 minutes
**Skills**: Network discovery, port scanning, service detection

```bash
scorelabs-cli lab start intro-to-nmap
```

#### 2. Web Application Basics
**Objective**: Understand common web vulnerabilities (OWASP Top 10)
**Duration**: 45 minutes
**Skills**: SQL injection, XSS, authentication bypass

```bash
scorelabs-cli lab start web-app-basics
```

#### 3. Password Cracking 101
**Objective**: Learn password hashing and cracking techniques
**Duration**: 30 minutes
**Skills**: Hash identification, John the Ripper, wordlists

```bash
scorelabs-cli lab start password-cracking-101
```

### Intermediate Labs

#### 4. Digital Forensics Investigation
**Objective**: Analyze a compromised system image
**Duration**: 2 hours
**Skills**: Timeline analysis, artifact recovery, log analysis

```bash
scorelabs-cli lab start forensics-investigation
```

#### 5. Wireless Network Attacks
**Objective**: Audit wireless network security
**Duration**: 1 hour
**Skills**: WiFi packet capture, WPA cracking, rogue AP detection

```bash
scorelabs-cli lab start wireless-attacks
```

#### 6. Exploit Development Basics
**Objective**: Create a basic buffer overflow exploit
**Duration**: 2 hours
**Skills**: Assembly, debuggers, shellcode, exploit writing

```bash
scorelabs-cli lab start exploit-dev-basics
```

### Advanced Labs

#### 7. Advanced Persistent Threat (APT) Simulation
**Objective**: Detect and respond to a simulated APT
**Duration**: 4 hours
**Skills**: Threat hunting, lateral movement detection, incident response

```bash
scorelabs-cli lab start apt-simulation
```

#### 8. Malware Analysis Deep Dive
**Objective**: Reverse engineer and analyze malware samples
**Duration**: 3 hours
**Skills**: Static/dynamic analysis, unpacking, behavior analysis

```bash
scorelabs-cli lab start malware-analysis-101
```

#### 9. Red Team Exercise
**Objective**: Complete a full penetration test simulation
**Duration**: 4 hours
**Skills**: OSCP-style challenge, privilege escalation, post-exploitation

```bash
scorelabs-cli lab start red-team-exercise
```

## Lab Structure

Each lab contains:

```
labs/scenarios/lab-name/
├── README.md              # Lab description and objectives
├── scenario.yml           # Configuration and metadata
├── setup.sh              # Environment setup script
├── resources/            # Files, scripts, disk images
│   ├── vulnerable-app/
│   ├── network-captures/
│   └── evidence/
├── hints/                # Progressive hints
│   ├── hint1.md
│   ├── hint2.md
│   └── hint3.md
└── solution/             # Complete solution
    ├── walkthrough.md
    ├── scripts/
    └── screenshots/
```

## Using Labs

### Starting a Lab

```bash
# List all available labs
scorelabs-cli lab list

# Start a specific lab
scorelabs-cli lab start lab-name

# Start with hints disabled
scorelabs-cli lab start lab-name --no-hints
```

### Accessing Lab Environment

```bash
# Get lab connection info
scorelabs-cli lab info lab-name

# Connect to lab
scorelabs-cli lab connect lab-name

# Or manually SSH (info from lab info command)
ssh student@lab-ip
```

### Getting Hints

```bash
# Get next hint
scorelabs-cli lab hint lab-name

# View all hints
scorelabs-cli lab hints lab-name --all
```

### Submitting Flags

```bash
# Submit flag (for CTF-style labs)
scorelabs-cli lab submit lab-name "flag{...}"

# Check progress
scorelabs-cli lab progress lab-name
```

### Resetting a Lab

```bash
# Reset to initial state
scorelabs-cli lab reset lab-name

# Stop lab
scorelabs-cli lab stop lab-name
```

## Detailed Lab Examples

### Lab: Introduction to Nmap

**File**: `labs/scenarios/intro-to-nmap/README.md`

#### Objectives
- Understand network scanning fundamentals
- Learn Nmap syntax and options
- Identify services and versions
- Understand scan timing and stealth

#### Environment
- Target network: 10.0.0.0/24
- Multiple hosts with various services
- Firewall present on some hosts

#### Tasks

1. **Discovery**: Find all live hosts
   ```bash
   nmap -sn 10.0.0.0/24
   ```

2. **Port Scanning**: Identify open ports on target
   ```bash
   nmap -p- target-ip
   ```

3. **Service Detection**: Determine service versions
   ```bash
   nmap -sV target-ip
   ```

4. **OS Detection**: Identify operating system
   ```bash
   nmap -O target-ip
   ```

5. **Stealth Scan**: Perform a SYN scan
   ```bash
   nmap -sS target-ip
   ```

#### Flags
- Flag 1: Banner from web server on port 8080
- Flag 2: SSH version on port 22
- Flag 3: Hidden service on high port

#### Solution
See `solution/walkthrough.md` for complete solution.

---

### Lab: Malware Analysis 101

**File**: `labs/scenarios/malware-analysis-101/README.md`

#### Objectives
- Set up a safe malware analysis environment
- Perform static analysis
- Conduct dynamic analysis
- Document findings

#### Environment
- Windows 10 VM (isolated)
- Analysis tools pre-installed
- Sample malware (safe, educational)

#### Tasks

1. **Static Analysis**
   - Check file hashes
   - Examine strings
   - Inspect PE headers
   - Identify packers

2. **Dynamic Analysis**
   - Monitor system calls
   - Capture network traffic
   - Track file system changes
   - Analyze registry modifications

3. **Behavioral Analysis**
   - Identify persistence mechanisms
   - Document C2 communications
   - Map MITRE ATT&CK techniques

#### Tools Used
- PEStudio
- Strings
- Process Monitor
- Process Hacker
- Wireshark
- Volatility

#### Deliverables
- Complete malware analysis report
- IOCs (Indicators of Compromise)
- YARA rule for detection

---

### Lab: Web Application Exploitation

**File**: `labs/scenarios/web-app-basics/README.md`

#### Objectives
- Identify common web vulnerabilities
- Exploit SQL injection
- Perform XSS attacks
- Bypass authentication

#### Environment
- Vulnerable web application
- Multiple vulnerability types
- Progressive difficulty

#### Vulnerabilities

1. **SQL Injection**
   - Location: Login form
   - Type: Authentication bypass
   - Goal: Admin access

2. **Cross-Site Scripting (XSS)**
   - Location: Comment section
   - Type: Stored XSS
   - Goal: Cookie theft

3. **Insecure Direct Object Reference**
   - Location: User profiles
   - Goal: Access other users' data

4. **Command Injection**
   - Location: Ping utility
   - Goal: Remote code execution

#### Tools
- Burp Suite
- SQLMap
- Browser developer tools

#### Flags
- Flag 1: Database version
- Flag 2: Admin password hash
- Flag 3: Contents of /etc/passwd
- Final Flag: Root shell on server

## Lab Development

Want to create your own labs? See [Creating Labs Guide](creating-labs.md)

### Quick Lab Template

```yaml
# scenario.yml
name: "My Custom Lab"
version: "1.0"
difficulty: intermediate
duration: 60
categories:
  - web
  - exploitation
description: |
  Learn advanced web exploitation techniques

objectives:
  - Identify vulnerability
  - Exploit the flaw
  - Capture the flag

environment:
  type: docker-compose
  services:
    - webapp
    - database

flags:
  - name: "First Flag"
    points: 100
    hint: "Check the source code"
  - name: "Final Flag"
    points: 500
    hint: "Think about database access"
```

## Lab Series & Learning Paths

### Web Application Security Path
1. Web App Basics → 2. Advanced SQLi → 3. Web API Security → 4. Full Web Pentest

### Forensics Path
1. File System Forensics → 2. Memory Forensics → 3. Network Forensics → 4. Incident Response

### Malware Analysis Path
1. Static Analysis → 2. Dynamic Analysis → 3. Advanced Unpacking → 4. Rootkit Analysis

### Network Security Path
1. Network Scanning → 2. MITM Attacks → 3. Wireless Security → 4. Advanced Network Exploitation

## Leaderboards & Progress

```bash
# View your progress
scorelabs-cli lab progress

# View leaderboard (if enabled)
scorelabs-cli lab leaderboard

# Export certificates
scorelabs-cli lab certificate lab-name
```

## Community Labs

Submit your own labs to the community:

1. Create lab following the template
2. Test thoroughly
3. Submit pull request
4. Community review
5. Published to ScoreLabs repository

## Support

- **Stuck?**: Use `scorelabs-cli lab hint <lab-name>`
- **Bugs?**: Report issues on GitHub
- **Questions?**: Join community chat
- **Solutions?**: Available after completing or in `solution/` directory

Happy hacking! 🔒
