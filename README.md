# Grimshield

A step-by-step Linux security hardening tool. One command to install, then it walks you through hardening your machine — explaining each change and asking before it touches anything.

> Note: project files currently live in `grimshield/` — this will be flattened to the repo root soon.

## Install

```bash
git clone https://github.com/Ahmedhaloua/LINUX-SEC.git
cd LINUX-SEC/grimshield
./install.sh
```

## Run

```bash
./grimshield.sh
```

Every run shows the Grimshield banner, detects your distro, and walks through each hardening module one at a time. Nothing is changed without your explicit yes.

## What it does (v1)

1. **System updates** — enable automatic security updates
2. **Firewall** — ufw/firewalld with default-deny inbound, SSH preserved
3. **SSH hardening** — disable root login, disable password auth (key-only)
4. **Fail2ban** — brute-force protection for SSH
5. **User & permission audit** — UID 0 accounts, empty passwords, world-writable files
6. **Kernel/sysctl hardening** — network and kernel security parameters

## Supported systems (v1)

| Distro | Package manager | Support level |
|---|---|---|
| Ubuntu, Kali | apt | Full |
| CentOS, RHEL, Fedora | dnf | Full |
| Arch, openSUSE, others | pacman/zypper | Partial |

## Report

After every run, Grimshield writes a `grimshield-report-<timestamp>.txt` summarizing exactly what was checked, found, and changed.

## Disclaimer

This tool makes real changes to system configuration. Review each prompt before confirming. Test in a non-production environment first.
