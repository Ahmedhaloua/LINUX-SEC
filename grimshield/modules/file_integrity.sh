#!/usr/bin/env bash
# Grimshield module: file integrity monitoring (AIDE)

run_file_integrity_module() {
    echo -e "\n\033[1m[8] File Integrity Monitoring\033[0m"

    if ask_yes_no "Install AIDE and create a baseline snapshot of critical files?" \
        "Lets you detect later if system files were changed — a classic sign of a break-in."; then

        pkg_install aide

        info "Initializing AIDE database (this can take a few minutes)..."
        if [ -x /usr/sbin/aideinit ]; then
            sudo aideinit -y -f >/dev/null 2>&1
        else
            sudo aide --init >/dev/null 2>&1
            if [ -f /var/lib/aide/aide.db.new ]; then
                sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
            fi
        fi

        ok "AIDE baseline created"
        info "Run 'sudo aide --check' anytime to see what's changed since this baseline"
        log_report "File Integrity" "Initialize AIDE baseline" "applied" "Baseline stored in /var/lib/aide/"
    else
        skip "File integrity monitoring"
        log_report "File Integrity" "Initialize AIDE baseline" "skipped" "User declined"
    fi
}
