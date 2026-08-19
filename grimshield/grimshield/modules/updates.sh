#!/usr/bin/env bash
# Grimshield module: system updates

run_updates_module() {
    echo -e "\n\033[1m[1] System Updates\033[0m"

    if ask_yes_no "Enable automatic security updates?" \
        "Keeps the OS patched against known vulnerabilities without manual intervention."; then
        pkg_update_index
        pkg_enable_auto_updates
        ok "Automatic security updates enabled"
        log_report "Updates" "Automatic security updates" "applied" "Configured via ${PKG_MANAGER}"
    else
        skip "Automatic security updates"
        log_report "Updates" "Automatic security updates" "skipped" "User declined"
    fi
}
