#!/usr/bin/env bash
# Grimshield — system detection
# Sets: DISTRO_ID, DISTRO_NAME, PKG_MANAGER, INIT_SYSTEM

detect_system() {
    DISTRO_ID="unknown"
    DISTRO_NAME="Unknown Linux"
    PKG_MANAGER="none"
    INIT_SYSTEM="none"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="${ID:-unknown}"
        DISTRO_NAME="${NAME:-Unknown Linux}"
    fi

    if command -v apt-get >/dev/null 2>&1; then
        PKG_MANAGER="apt"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MANAGER="dnf"
    elif command -v yum >/dev/null 2>&1; then
        PKG_MANAGER="yum"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MANAGER="pacman"
    elif command -v zypper >/dev/null 2>&1; then
        PKG_MANAGER="zypper"
    fi

    if command -v systemctl >/dev/null 2>&1; then
        INIT_SYSTEM="systemd"
    elif command -v rc-service >/dev/null 2>&1; then
        INIT_SYSTEM="openrc"
    else
        INIT_SYSTEM="unknown"
    fi

    export DISTRO_ID DISTRO_NAME PKG_MANAGER INIT_SYSTEM
}

# Warn (not crash) if the package manager isn't one we officially support yet.
check_support_level() {
    case "$PKG_MANAGER" in
        apt|dnf)
            SUPPORT_LEVEL="full"
            ;;
        yum|zypper|pacman)
            SUPPORT_LEVEL="partial"
            ;;
        *)
            SUPPORT_LEVEL="none"
            ;;
    esac
    export SUPPORT_LEVEL
}
