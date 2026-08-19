# Grimshield

A step-by-step Linux security hardening tool. One command to install, then it walks you through hardening your machine — explaining each change and asking before it touches anything.

## Install

```bash
git clone https://github.com/<your-username>/grimshield.git
cd grimshield
./install.sh
```

## Run

```bash
./grimshield.sh
```

Every run shows the Grimshield banner, detects your distro, and walks through each hardening module one at a time. Nothing is changed without your explicit yes.

## Supported systems (v1)

| Distro           | Package manager | Support level |
|-------------------|------------------|----------------|
| Ubuntu             | apt              | Full           |
| Kali Linux          | apt              | Full           |
| CentOS / RHEL / Fedora | dnf          | Full           |
| Arch, openSUSE, others | pacman/zypper | Partial (detected, package steps skipped until backend is added) |

Grimshield auto-detects your system and adapts. Unsupported package managers are reported clearly rather than causing silent failures — contributions adding new backends are welcome.

## What it does (v1)

1. **System updates** — enable automatic security updates
2. **Firewall** — ufw/firewalld with default-deny inbound, SSH preserved
3. **SSH hardening** — disable root login, disable password auth (key-only)
4. **Fail2ban** — brute-force protection for SSH
5. **User & permission audit** — UID 0 accounts, empty passwords, world-writable files in `/etc`
6. **Kernel/sysctl hardening** — network and kernel security parameters

Each step is optional. Say no to anything you don't want.

## Report

After every run, Grimshield writes a `grimshield-report-<timestamp>.txt` file summarizing exactly what was checked, what was found, and what was changed — useful for audits or just keeping a record.

## Project structure

```
grimshield/
├── grimshield.sh          # main entrypoint
├── install.sh             # one-time setup (chmod, optional PATH symlink)
├── core/
│   ├── detect.sh           # distro/package-manager/init detection
│   ├── prompt.sh            # shared yes/no prompt helpers
│   ├── report.sh            # report logging + .txt generation
│   └── backend/
│       ├── apt.sh
│       └── dnf.sh
├── modules/                # one file per hardening category
├── assets/
│   └── banner.sh
└── README.md
```

## Contributing

New modules and package-manager backends (pacman, zypper, apk) are welcome. Each module should:
- Explain what it does and why before prompting
- Never make a change without `ask_yes_no` confirmation
- Log every check/action via `log_report`

## Disclaimer

This tool makes real changes to system configuration (SSH, firewall, kernel parameters). Review each prompt before confirming. Test in a non-production environment first. Not affiliated with any distro vendor.
