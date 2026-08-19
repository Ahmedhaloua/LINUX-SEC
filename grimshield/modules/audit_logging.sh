#!/usr/bin/env bash
# Grimshield module: audit logging (auditd)

run_audit_logging_module() {
    echo -e "\n\033[1m[9] Audit Logging\033[0m"

    if ask_yes_no "Install and enable auditd for system audit logging?" \
        "If something goes wrong, proper logs are what let you find out what happened."; then

        pkg_install auditd
        sudo systemctl enable --now auditd >/dev/null 2>&1

        ok "auditd installed and enabled"
        log_report "Audit Logging" "Install and enable auditd" "applied" ""
    else
        skip "Audit logging"
        log_report "Audit Logging" "Install and enable auditd" "skipped" "User declined"
    fi
}
