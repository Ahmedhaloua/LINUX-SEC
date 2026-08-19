#!/usr/bin/env bash
# Grimshield — main entrypoint
# One tool. Step by step. Asks before it touches anything.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- load core ---
source "$SCRIPT_DIR/assets/banner.sh"
source "$SCRIPT_DIR/core/detect.sh"
source "$SCRIPT_DIR/core/prompt.sh"
source "$SCRIPT_DIR/core/report.sh"

# --- banner (every run) ---
show_banner

# --- detect system ---
detect_system
check_support_level

echo -e "\033[1mDetected:\033[0m ${DISTRO_NAME} | package manager: ${PKG_MANAGER} | init: ${INIT_SYSTEM}"

if [ "$SUPPORT_LEVEL" = "none" ]; then
    echo -e "\033[0;31mNo supported package manager found. Grimshield cannot continue safely.\033[0m"
    exit 1
elif [ "$SUPPORT_LEVEL" = "partial" ]; then
    echo -e "\033[1;33mWarning: ${PKG_MANAGER} has partial support. Some steps may be skipped.\033[0m"
fi

# --- load the right backend ---
case "$PKG_MANAGER" in
    apt) source "$SCRIPT_DIR/core/backend/apt.sh" ;;
    dnf) source "$SCRIPT_DIR/core/backend/dnf.sh" ;;
    *)
        echo -e "\033[1;33mNo dedicated backend for ${PKG_MANAGER} yet — package-based steps will be skipped.\033[0m"
        pkg_install() { info "Skipped (${PKG_MANAGER} backend not implemented): $1"; return 1; }
        pkg_is_installed() { return 1; }
        pkg_update_index() { :; }
        pkg_enable_auto_updates() { info "Skipped (${PKG_MANAGER} backend not implemented)"; }
        ;;
esac

# --- load modules ---
source "$SCRIPT_DIR/modules/updates.sh"
source "$SCRIPT_DIR/modules/firewall.sh"
source "$SCRIPT_DIR/modules/ssh.sh"
source "$SCRIPT_DIR/modules/fail2ban.sh"
source "$SCRIPT_DIR/modules/users_audit.sh"
source "$SCRIPT_DIR/modules/sysctl.sh"

# --- run modules, step by step ---
run_updates_module
run_firewall_module
run_ssh_module
run_fail2ban_module
run_users_audit_module
run_sysctl_module

# --- final report ---
echo -e "\n\033[1mAll steps complete.\033[0m"
write_report

echo -e "\033[0;31mIt will be watching. Run grimshield again anytime.\033[0m"
