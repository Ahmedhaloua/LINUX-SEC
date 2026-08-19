#!/usr/bin/env bash
# Grimshield — main entrypoint
# One tool. Step by step. Asks before it touches anything.
#
# Usage:
#   ./grimshield.sh              full interactive run
#   ./grimshield.sh --scan-only  report findings only, no changes made

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCAN_ONLY=0
if [ "${1:-}" = "--scan-only" ]; then
    SCAN_ONLY=1
fi
export SCAN_ONLY

# --- load core ---
source "$SCRIPT_DIR/assets/banner.sh"
source "$SCRIPT_DIR/core/detect.sh"
source "$SCRIPT_DIR/core/prompt.sh"
source "$SCRIPT_DIR/core/report.sh"

# --- banner (every run) ---
show_banner

if [ "$SCAN_ONLY" -eq 1 ]; then
    echo -e "\033[1;33mScan-only mode: no changes will be made, only findings will be reported.\033[0m\n"
fi

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
    apt)    source "$SCRIPT_DIR/core/backend/apt.sh" ;;
    dnf)    source "$SCRIPT_DIR/core/backend/dnf.sh" ;;
    pacman) source "$SCRIPT_DIR/core/backend/pacman.sh" ;;
    zypper) source "$SCRIPT_DIR/core/backend/zypper.sh" ;;
    *)
        echo -e "\033[1;33mNo dedicated backend for ${PKG_MANAGER} yet — package-based steps will be skipped.\033[0m"
        pkg_install() { info "Skipped (${PKG_MANAGER} backend not implemented): $1"; return 1; }
        pkg_is_installed() { return 1; }
        pkg_update_index() { :; }
        pkg_enable_auto_updates() { info "Skipped (${PKG_MANAGER} backend not implemented)"; }
        ;;
esac

# --- scan-only mode: override ask_yes_no to always say no (report only) ---
if [ "$SCAN_ONLY" -eq 1 ]; then
    ask_yes_no() {
        local question="$1"
        local reason="$2"
        echo -e "\033[1;33m?\033[0m ${question}"
        [ -n "$reason" ] && echo -e "  \033[0;90m${reason}\033[0m"
        echo -e "  \033[0;90m[scan-only: not applied]\033[0m"
        return 1
    }
fi

# --- load modules ---
source "$SCRIPT_DIR/modules/updates.sh"
source "$SCRIPT_DIR/modules/firewall.sh"
source "$SCRIPT_DIR/modules/ssh.sh"
source "$SCRIPT_DIR/modules/fail2ban.sh"
source "$SCRIPT_DIR/modules/users_audit.sh"
source "$SCRIPT_DIR/modules/sysctl.sh"
source "$SCRIPT_DIR/modules/rootkit.sh"
source "$SCRIPT_DIR/modules/file_integrity.sh"
source "$SCRIPT_DIR/modules/audit_logging.sh"
source "$SCRIPT_DIR/modules/mac.sh"

# --- run modules, step by step ---
run_updates_module
run_firewall_module
run_ssh_module
run_fail2ban_module
run_users_audit_module
run_sysctl_module
run_rootkit_module
run_file_integrity_module
run_audit_logging_module
run_mac_module

# --- final report ---
echo -e "\n\033[1mAll steps complete.\033[0m"
write_report

echo -e "\033[0;31mIt will be watching. Run grimshield again anytime.\033[0m"
