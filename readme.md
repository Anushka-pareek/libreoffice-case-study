# oss-audit-ANUSHKA

**Student Name:** ANUSHKA PAREEK
**Roll Number:** 24BCY10398
**Course:** Open Source Software — NGMC Capstone
**Chosen Software:** Git (GPL v2)

---

## About This Project

This repository contains the shell scripts and supporting files for the Open Source Audit capstone project. The subject of the audit is **Git** — the distributed version control system created by Linus Torvalds in 2005 under the GNU General Public License v2.

---

## Repository Structure

```
oss-audit-hardware/
│
├── scripts/
│   ├── script1_system_identity.sh       # System welcome screen
│   ├── script2_package_inspector.sh     # FOSS package checker
│   ├── script3_disk_permission_auditor.sh  # Directory permissions audit
│   ├── script4_log_analyzer.sh          # Log file keyword analyzer
│   └── script5_manifesto_generator.sh   # Interactive manifesto generator
│
└── README.md
```

---

## Script Descriptions

| Script | Name | What It Does |
|--------|------|-------------|
| `script1_system_identity.sh` | System Identity Report | Displays OS, kernel, user, uptime, date, and OSS license info |
| `script2_package_inspector.sh` | FOSS Package Inspector | Checks if a package is installed; prints version, license, and philosophy note |
| `script3_disk_permission_auditor.sh` | Disk & Permission Auditor | Audits system directories and Git-specific paths for size and permissions |
| `script4_log_analyzer.sh` | Log File Analyzer | Reads a log file, counts keyword matches, shows last 5 hits and severity breakdown |
| `script5_manifesto_generator.sh` | Manifesto Generator | Interactively generates a personalised open-source philosophy statement |

---

## How to Run

### Prerequisites

- **macOS:** Bash (built-in), Git (Xcode CLT or Homebrew), optional: Homebrew
- **Linux:** Bash, `git`, `dpkg` or `rpm` depending on distro

### Make all scripts executable

```bash
cd scripts/
chmod +x *.sh
```

---

### Script 1 — System Identity Report

```bash
./script1_system_identity.sh
```

No arguments needed. Detects macOS or Linux automatically and prints a formatted system summary.

**Sample output:**
```
╔══════════════════════════════════════════════════════════╗
║           OPEN SOURCE AUDIT — SYSTEM IDENTITY           ║
╚══════════════════════════════════════════════════════════╝
  Student  : ANUSHKA (24BCY10398)
  OS       : macOS 14.4
  Kernel   : 23.4.0
  User     : jane
  Uptime   : 3 hours, 12 minutes
```

---

### Script 2 — FOSS Package Inspector

```bash
# Default: inspects 'git'
./script2_package_inspector.sh

# Inspect a specific package
./script2_package_inspector.sh git
./script2_package_inspector.sh python3
./script2_package_inspector.sh firefox
```

**Dependencies:** `brew` (macOS), `rpm` (Fedora/RHEL), or `dpkg` (Ubuntu/Debian)

---

### Script 3 — Disk and Permission Auditor

```bash
./script3_disk_permission_auditor.sh
```

No arguments needed. Audits `/etc`, `/var/log`, `/home`, `/usr/bin`, `/tmp`, and Git-specific paths. On macOS, also audits `/Users`.

---

### Script 4 — Log File Analyzer

```bash
# Auto-generates a sample Git activity log (good for demo)
./script4_log_analyzer.sh

# Analyze a real log file, search for 'error' (default keyword)
./script4_log_analyzer.sh /var/log/syslog

# Analyze with a custom keyword
./script4_log_analyzer.sh /var/log/syslog WARNING
./script4_log_analyzer.sh /tmp/git_activity_sample.log push
```

If no log file is specified or the file is missing/empty, the script auto-generates a sample Git activity log at `/tmp/git_activity_sample.log` and retries.

---

### Script 5 — Open Source Manifesto Generator

```bash
./script5_manifesto_generator.sh
```

Interactive — the script will ask you three questions. Your manifesto is saved as `manifesto_[username].txt` in the current directory.

**Optional alias** (add to `~/.zshrc` or `~/.bashrc`):
```bash
alias manifesto='bash ~/path/to/scripts/script5_manifesto_generator.sh'
```

---

## Running All Scripts at Once (Quick Demo)

```bash
cd scripts/
chmod +x *.sh
echo "=== Script 1 ===" && ./script1_system_identity.sh
echo "=== Script 2 ===" && ./script2_package_inspector.sh git
echo "=== Script 3 ===" && ./script3_disk_permission_auditor.sh
echo "=== Script 4 ===" && ./script4_log_analyzer.sh
# Script 5 is interactive — run it separately:
# ./script5_manifesto_generator.sh
```

---

## License

All shell scripts in this repository are written for educational purposes as part of the VITyarthi Open Source Software course. The subject of the audit, Git, is licensed under GNU GPL v2.

---

## References

- Pro Git Book (free): https://git-scm.com/book
- Git source code: https://github.com/git/git
- GNU GPL v2: https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
- Linux Command Line: https://linuxcommand.org/tlcl.php
