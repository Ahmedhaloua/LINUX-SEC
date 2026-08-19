#!/usr/bin/env bash
# Grimshield module: rootkit / malware scan

run_rootkit_module() {
    echo -e "\n\033[1m[7] Rootkit & Malware Scan\033[0m"

    if ask_yes_no "Install rkhunter and run a rootkit/malware scan?" \
        "Checks whether this machine is ALREADY compromised, not just whether it's exposed."; then

        pkg_install rkhunter

        info "Updating rkhunter's signature database..."
        sudo rkhunter --update >/dev/null 2>&1

        info "Running scan (this can take a few minutes)..."
        local scan_output
        scan_output=$(sudo rkhunter --check --sk --report-warnings-only 2>/dev/null)

        if [ -z "$scan_output" ]; then
            ok "No warnings found"
            log_report "Rootkit" "rkhunter scan" "applied" "No warnings found"
        else
            echo "$scan_output" | sed 's/^/    /'
            ok "Scan complete — warnings found, review above"
            log_report "Rootkit" "rkhunter scan" "applied" "Warnings found, see terminal output above"
        fi
    else
        skip "Rootkit scan"
        log_report "Rootkit" "rkhunter scan" "skipped" "User declined"
    fi
}
